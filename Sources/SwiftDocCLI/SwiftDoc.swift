import ArgumentParser
import Foundation
import Logging
import LoggingGitHubActions

let logger = Logger(label: "org.swiftdoc.swift-doc")

let fileManager = FileManager.default

var standardOutput = FileHandle.standardOutput
var standardError = FileHandle.standardError

public struct SwiftDoc: ParsableCommand {
    public static var configuration = CommandConfiguration(
        commandName: "swift doc",
        abstract: "A utility for generating documentation for Swift code.",
        version: "1.0.0-beta.5",
        subcommands: [Generate.self, Coverage.self, Diagram.self]
    )

  public init() {}
}