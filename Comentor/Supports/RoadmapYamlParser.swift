//
//  RoadmapYamlParser.swift
//  Comentor-Neue
//
//  Created by 徐嗣苗 on 2023/6/11.
//

import Foundation
import Yams

struct DecodedRoadmap: Codable {
    var category: String
    var title: String
    var steps: [DecodedStep]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.category = try container.decode(String.self, forKey: .category)
        self.title = try container.decode(String.self, forKey: .title)
        self.steps = try container.decode([DecodedStep].self, forKey: .steps)
    }
}

struct DecodedStep: Codable {
    var index: Int
    var title: String
    var content: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.index = try container.decode(Int.self, forKey: .index)
        self.title = try container.decode(String.self, forKey: .title)
        self.content = try container.decode(String.self, forKey: .content)
    }
}

func parsedRoadmap(from yamlString: String) -> (Roadmap, [Step])? {
    let decoder = YAMLDecoder()
    do {
        let decodedRoadmap = try decoder.decode(DecodedRoadmap.self, from: yamlString)
        let decodedSteps = decodedRoadmap.steps
        
        if let category = StudyCategory(rawValue: decodedRoadmap.category) {
            let newRoadmap = Roadmap(decodedRoadmap.title, category: category)
            
            var steps: [Step] = []
            for step in decodedSteps {
                let newStep = Step(index: step.index, title: step.title, content: step.content)
                steps.append(newStep)
            }
            print(newRoadmap)
            return (newRoadmap, steps)
        }
        return nil
        
    } catch {
        print("Error decoding YAML: \(error)")
        return nil
    }
}

