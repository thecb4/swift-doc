import SwiftSemantics
import SwiftDoc
import CommonMarkBuilder
import HypertextLiteral

public struct TypePage: Page {
    public let module: Module
    let symbol: Symbol
    public let baseURL: String

    public init(module: Module, symbol: Symbol, baseURL: String) {
        precondition(symbol.api is Type)
        self.module = module
        self.symbol = symbol
        self.baseURL = baseURL
    }

    // MARK: - Page

    public var title: String {
        return symbol.id.description
    }

    public var document: CommonMark.Document {
        return CommonMark.Document {
            Heading { symbol.id.description }

            Documentation(for: symbol, in: module, baseURL: baseURL)
            Relationships(of: symbol, in: module, baseURL: baseURL)
            Members(of: symbol, in: module, baseURL: baseURL)
            Requirements(of: symbol, in: module, baseURL: baseURL)
        }
    }

    public var html: HypertextLiteral.HTML {
        return #"""
        <h1>
            <small>\#(String(describing: type(of: symbol.api)))</small>
            <code class="name">\#(softbreak(symbol.id.description))</code>
        </h1>

        \#(Documentation(for: symbol, in: module, baseURL: baseURL).html)
        \#(Relationships(of: symbol, in: module, baseURL: baseURL).html)
        \#(Members(of: symbol, in: module, baseURL: baseURL).html)
        \#(Requirements(of: symbol, in: module, baseURL: baseURL).html)
        """#
    }
}
