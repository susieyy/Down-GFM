//
//  DownASTRenderable.swift
//  Down
//
//  Created by Rob Phillips on 5/31/16.
//  Copyright © 2016-2019 Down. All rights reserved.
//

import Foundation
import libcmark

public protocol DownASTRenderable: DownRenderable {
    func toAST(_ options: DownOptions) throws -> UnsafeMutablePointer<cmark_node>
}

extension DownASTRenderable {
    /// Generates an abstract syntax tree from the `markdownString` property
    ///
    /// - Parameter options: `DownOptions` to modify parsing or rendering, defaulting to `.default`
    /// - Returns: An abstract syntax tree representation of the Markdown input
    /// - Throws: `MarkdownToASTError` if conversion fails
    public func toAST(_ options: DownOptions = .default) throws -> UnsafeMutablePointer<cmark_node> {
        return try DownASTRenderer.stringToAST(markdownString, options: options)
    }
}

public struct DownASTRenderer {
    public static func parseDocument(_ string: String, options: DownOptions = .default) -> UnsafeMutablePointer<cmark_node>? {
        cmark_gfm_core_extensions_ensure_registered()

        let parser = cmark_parser_new(options.rawValue);

        if let strikethrough = cmark_find_syntax_extension("strikethrough") {
            cmark_parser_attach_syntax_extension(parser, strikethrough)
        }

        if let table = cmark_find_syntax_extension("table") {
            cmark_parser_attach_syntax_extension(parser, table)
        }

        if let tasklist = cmark_find_syntax_extension("tasklist") {
            cmark_parser_attach_syntax_extension(parser, tasklist)
        }

        if let autolink = cmark_find_syntax_extension("autolink") {
            cmark_parser_attach_syntax_extension(parser, autolink)
        }

        // wed don't need tagfilter
//        if let tagfilter = cmark_find_syntax_extension("tagfilter") {
//            cmark_parser_attach_syntax_extension(parser, tagfilter)
//        }

        string.withCString {
            cmark_parser_feed(parser, $0, strlen($0));
        }

        let document = cmark_parser_finish(parser);

        cmark_parser_free(parser);

        return document
    }

    /// Generates an abstract syntax tree from the given CommonMark Markdown string
    ///
    /// **Important:** It is the caller's responsibility to call `cmark_node_free(ast)` on the returned value
    ///
    /// - Parameters:
    ///   - string: A string containing CommonMark Markdown
    ///   - options: `DownOptions` to modify parsing or rendering, defaulting to `.default`
    /// - Returns: An abstract syntax tree representation of the Markdown input
    /// - Throws: `MarkdownToASTError` if conversion fails
    public static func stringToAST(_ string: String, options: DownOptions = .default) throws -> UnsafeMutablePointer<cmark_node> {
        guard let ast = parseDocument(string, options: options) else {
            throw DownErrors.markdownToASTError
        }
        return ast
    }
}
