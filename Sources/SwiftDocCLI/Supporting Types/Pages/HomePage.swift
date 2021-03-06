import CommonMarkBuilder
import SwiftDoc
import SwiftSemantics
import HypertextLiteral

public struct HomePage: Page {
    public var module: Module
    public let baseURL: String

    var classes: [Symbol] = []
    var enumerations: [Symbol] = []
    var structures: [Symbol] = []
    var protocols: [Symbol] = []
    var operators: [Symbol] = []
    var globalTypealiases: [Symbol] = []
    var globalFunctions: [Symbol] = []
    var globalVariables: [Symbol] = []

    public init(module: Module, baseURL: String) {
        self.module = module
        self.baseURL = baseURL

        for symbol in module.interface.topLevelSymbols.filter({ $0.isPublic }) {
            switch symbol.api {
            case is Class:
                classes.append(symbol)
            case is Enumeration:
                enumerations.append(symbol)
            case is Structure:
                structures.append(symbol)
            case is Protocol:
                protocols.append(symbol)
            case is Typealias:
                globalTypealiases.append(symbol)
            case is Operator:
                operators.append(symbol)
            case let function as Function where function.isOperator:
                operators.append(symbol)
            case is Function:
                globalFunctions.append(symbol)
            case is Variable:
                globalVariables.append(symbol)
            default:
                continue
            }
        }
    }

    // MARK: - Page

    public var title: String {
        return module.name
    }

    public var document: CommonMark.Document {
        return Document {
            ForEach(in: [
                ("Types", classes + enumerations + structures),
                ("Protocols", protocols),
                ("Operators", operators),
                ("Global Typealiases", globalTypealiases),
                ("Global Functions", globalFunctions),
                ("Global Variables", globalVariables),
            ]) { (heading, symbols) in
                if (!symbols.isEmpty) {
                    Heading { heading }

                    List(of: symbols.sorted()) { symbol in
                        Abstract(for: symbol, baseURL: baseURL).fragment
                    }
                }
            }
        }
    }

    public var html: HypertextLiteral.HTML {
        return #"""
        \#([
            ("Classes", classes),
            ("Structures", structures),
            ("Enumerations", enumerations),
            ("Protocols", protocols),
            ("Typealiases", globalTypealiases),
            ("Functions", globalFunctions),
            ("Variables", globalVariables)
        ].compactMap { (heading, symbols) -> HypertextLiteral.HTML? in
            guard !symbols.isEmpty else { return nil }

            return #"""
            <section id=\#(heading.lowercased())>
                <h2>\#(heading)</h2>
                <dl>
                    \#(symbols.sorted().map { Abstract(for: $0, baseURL: baseURL).html })
                </dl>
            </section>
        """#
        })
        """#
    }
}
