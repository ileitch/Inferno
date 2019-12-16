import Foundation
import SwiftSyntax

class Parser: SyntaxVisitor {
    fileprivate var bindingNames: [String] = []

    static func parse(url: URL) throws -> [String] {
        let syntax = try SyntaxParser.parse(url)
        var parser = self.init()
        syntax.walk(&parser)
        return parser.bindingNames
    }

    required init() {}

    func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        for binding in node.bindings {
            guard binding.typeAnnotation == nil else { continue }

            var name = binding.pattern.description

            if binding.pattern.trailingTriviaLength.utf8Length > 0 {
                name = String(name.dropLast(binding.pattern.trailingTriviaLength.utf8Length))
            }

            bindingNames.append(name)
        }

        return .skipChildren
    }
}
