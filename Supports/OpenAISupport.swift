//
//  OpenAISupport.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/11.
//

import OpenAI
import Foundation

let generationPrompt = """
根据我们的以上聊天内容，从对话中思考我想要学习什么，生成一条学习路线并格式化为如下 YAML 代码（注意：仅给我代码即可，不要有多余的解释或任何 markdown 标记）：

category: ""
title: ""
steps:
    - index: 1
      title: ""
      content: ""
    - index: 2
      title: ""
      content: ""

务必遵循以下要求:
1. title 提炼主题即可，不要以'学习路线'为结尾;
2. category 只能根据所生成的学习路线，从以下10个分类中挑选出最合适的一个：
"coding", "language", "health", "art", "technology", "biology", "philosophy", "business", "sport", "math".
切记不能使用其他的字符串，也不能为空，不然会导致程序的错误;
3. steps 数组中元素的数量最低为3个，不作上限，对于 steps 中的每一个元素，你需要设计每一步合适的学习路线来帮助用户实现他的需求，将生成的标题和内容并填入 title 和 content，其中的内容不宜是过于简单的概括，尽量给出比较具体详细的方案，比如建议阅读哪些著作、浏览哪些网站以获取更多信息;
"""

func sendAndReceive(with dialogues: [Dialogue]) async -> (String, Bool) {
    var currentReceivedMessage = ""
    UserDefaults.standard.set(currentReceivedMessage, forKey: "CurrentMessage")
    
    do {
        let(openAI, query) = setupOpenAI(with: dialogues, for: .chat)
        for try await result in openAI.chatsStream(query: query) {
            if !result.choices.isEmpty {
                currentReceivedMessage += result.choices.last!.delta.content ?? ""
                UserDefaults.standard.set(currentReceivedMessage, forKey: "CurrentMessage")
                if result.choices.last!.finishReason != nil {
                    return (currentReceivedMessage, true)
                }
            }
        }
        return("UNKNOWN ERROR", false)
    } catch {
        // 如果发生错误，则返回错误信息
        return (error.localizedDescription, false)
    }
}

func roadmapYam(_ dialogues: [Dialogue]) async -> (String, Bool) {
    do {
        let(openAI, query) = setupOpenAI(with: dialogues, for: .roadmap)
        let result = try await openAI.chats(query: query)
        let response = result.choices.first!.message.content
        
        if let response = response {
            if let formattedResponse = response.formattedYAML() {
                print(formattedResponse)
                return (formattedResponse, true)
            }
        }
        print(response ?? "")
        return (response ?? "", true)
    } catch {
        return (error.localizedDescription, false)
    }
}

func setupOpenAI(with dialogues: [Dialogue], for usage: OpenAIUsage) -> (OpenAI, ChatQuery) {
    var dialogueBuffer: [Dialogue] = []
    
    let contextCount: Int = UserDefaults.standard.integer(forKey: "ContextCount")
    
    var maxDialogueCount = 4
    switch usage {
    case .chat:
        maxDialogueCount = contextCount == 0 ? 4 : contextCount
    case .roadmap:
        maxDialogueCount = max(10, contextCount)
    }
    
    if dialogues.count < 2 || !dialogues[dialogues.count - 2].success {
        dialogueBuffer = [dialogues.last].compactMap { $0 }
    } else {
        let recentItems = dialogues.suffix(maxDialogueCount)
        dialogueBuffer = Array(recentItems)
    }
    
    var messages: [Chat] = []
    
    for dialogue in dialogueBuffer {
        messages.append(Chat(role: .user, content: dialogue.ask))
        if usage == .chat && dialogue != dialogueBuffer.last {
            messages.append(Chat(role: .assistant, content: String(dialogue.answer)))
        }
    }
    
    if usage == .roadmap {
        messages.append(Chat(role: .system, content: generationPrompt))
    }
    
    let aiModel: Model = UserDefaults.standard.string(forKey: "AIModel") ?? Model.gpt3_5Turbo
    let aiTemperature: Double = UserDefaults.standard.double(forKey: "AITemperature")
    let query = ChatQuery(model: aiModel, messages: messages, temperature: aiTemperature)
    let apiKey: String = UserDefaults.standard.string(forKey: "APIKey") ?? ""
    let apiHost: String = UserDefaults.standard.string(forKey: "APIHost") ?? "api.openai.com"
    let openAIConfig = apiHost == "" ? OpenAI.Configuration(token: apiKey) : OpenAI.Configuration(token: apiKey, host: apiHost)
    let openAI = OpenAI(configuration: openAIConfig)
    
    return (openAI, query)
}

public extension Model {
    static var allCases: [Model] {
        return [
            gpt3_5Turbo,
            gpt3_5Turbo0613,
            gpt4,
            gpt4_0613,
        ]
    }
}

extension Model: Identifiable {
    public var id: String { self }
}

extension String {
    func formattedYAML() -> String? {
        let str = self
        guard str.hasPrefix("```yaml") && str.hasSuffix("```") else {
            return nil
        }
        let startIndex = str.index(str.startIndex, offsetBy: 6)
        let endIndex = str.index(str.endIndex, offsetBy: -3)
        return String(str[startIndex..<endIndex])
    }
}

enum OpenAIUsage {
    case chat, roadmap
}
