//
//  MdExtensions.swift
//  Comentor
//
//  Created by 徐嗣苗 on 2023/6/9.
//

#if !os(xrOS)
import SwiftUI
import MarkdownText

struct CustomHeading: HeadingMarkdownStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color.accentColor)
    }
}

extension HeadingMarkdownStyle where Self == CustomHeading {
    static var custom: Self { .init() }
}

struct Underline: StrikethroughMarkdownStyle {
    func makeBody(configuration: Configuration) -> Text {
        configuration.content.underline()
    }
}

extension StrikethroughMarkdownStyle where Self == Underline {
    static var custom: Self { .init() }
}

struct CustomInlineCode: InlineCodeMarkdownStyle {
    func makeBody(configuration: Configuration) -> Text {
        configuration.label
            .foregroundStyle(.pink)
    }
}

extension InlineCodeMarkdownStyle where Self == CustomInlineCode {
    static var custom: Self { .init() }
}

struct CustomQuote: QuoteMarkdownStyle {
    struct Content: View {
        @ScaledMetric(wrappedValue: 20) private var padding
        @ScaledMetric(wrappedValue: 3) private var thickness
        @Environment(\.markdownParagraphStyle) private var style
        
        let paragraph: ParagraphMarkdownConfiguration
        
        var body: some View {
            style
                .makeBody(configuration: paragraph)
                .font(.system(.callout, design: .rounded))
                .foregroundStyle(.secondary)
                .padding(.horizontal, padding)
                .overlay(
                    RoundedRectangle(cornerRadius: thickness)
                        .frame(width: thickness)
                    #if os(iOS)
                        .foregroundStyle(Color(.systemFill))
                    #endif
                        .offset(x: thickness),
                    alignment: .leading
                )
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        Content(paragraph: configuration.content)
    }
}

extension QuoteMarkdownStyle where Self == CustomQuote {
    static var custom: Self { .init() }
}

public struct CustomCode: CodeMarkdownStyle {
    struct Label: View {
        @ScaledMetric(wrappedValue: 15) private var padding
        
        let configuration: Configuration
        
        @State private var isCopied = false
        
        var body: some View {
            VStack(spacing: 6) {
                HStack {
                    configuration.language.flatMap { Text($0) }?
                        .padding(3)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.white)
                        .background(.gray)
                        .cornerRadius(4)
                    Spacer()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    configuration.label
                        .padding(padding)
                }
#if os(iOS)
                .background(Color(.quaternarySystemFill).cornerRadius(8))
#else
                .background(Color.secondary.cornerRadius(8).opacity(0.1))
                
#endif
                
                
                .overlay(alignment: .topTrailing) {
                    Button {
                        configuration.code.copyToClipBoard()
                        withAnimation {
                            self.isCopied = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                self.isCopied = false
                            }
                        }
                    } label: {
                        if isCopied {
                            HStack {
                                Image(systemName: "checkmark")
                                Text("Copied to clipboard")
                            }
                        } else {
                            Image(systemName: "doc.on.doc")
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(isCopied)
                    .padding(5)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)
                    .padding(8)
                }
            }
            
            .environment(\.layoutDirection, .leftToRight)
        }
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        Label(configuration: configuration)
    }
}

extension CodeMarkdownStyle where Self == CustomCode {
    static var custom: Self { .init() }
}

struct CustomUnorderedBullet: UnorderedListBulletMarkdownStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
#if os(iOS)
            .foregroundStyle(Color(UIColor.tertiaryLabel))
#endif
            .font(.footnote)
    }
}

extension UnorderedListBulletMarkdownStyle where Self == CustomUnorderedBullet {
    static var custom: Self { .init() }
}

struct CustomOrderedBullet: OrderedListBulletMarkdownStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.secondary)
    }
}

extension OrderedListBulletMarkdownStyle where Self == CustomOrderedBullet {
    static var custom: Self { .init() }
}

struct CustomImage: ImageMarkdownStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}

extension ImageMarkdownStyle where Self == CustomImage {
    static var custom: Self { .init() }
}

extension View {
    func comentorAnswerMarkdownStyle() -> some View {
        self.markdownHeadingStyle(.custom)
            .markdownQuoteStyle(.custom)
            .markdownCodeStyle(.custom)
            .markdownInlineCodeStyle(.custom)
            .markdownOrderedListBulletStyle(.custom)
            .markdownUnorderedListBulletStyle(.custom)
            .markdownImageStyle(.custom)
    }
}

#endif
