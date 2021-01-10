import SwiftSemantics
import SwiftDoc
import CommonMarkBuilder
import HypertextLiteral

public struct GlobalPage: Page {
    public let module: Module
    let name: String
    let symbols: [Symbol]
    public let baseURL: String

    public init(module: Module, name: String, symbols: [Symbol], baseURL: String) {
        self.module = module
        self.name = name
        self.symbols = symbols
        self.baseURL = baseURL
    }

    // MARK: - Page

    public var title: String {
        return name
    }
    
    public var document: CommonMark.Document {
        return Document {
            ForEach(in: symbols) { symbol in
                Heading { symbol.id.description }
                Documentation(for: symbol, in: module, baseURL: baseURL)
            }
        }
    }

    public var html: HypertextLiteral.HTML {
        let description: String

        let descriptions = Set(symbols.map { String(describing: type(of: $0.api)) })
        if descriptions.count == 1 {
            description = descriptions.first!
        } else {
            description = "Global"
        }

        return #"""
        <h1>
        <small>\#(description)</small>
        <span class="name">\#(softbreak(name))</span>
        </h1>

        \#(symbols.map { symbol in
        Documentation(for: symbol, in: module, baseURL: baseURL).html
        })
        """#
    }
}
