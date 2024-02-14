import ArgumentParser
import Foundation
import WebArchiveExtractor

@main
struct ExtractToFolder: ParsableCommand {
	@Flag(help: "Overwrite conflicting files")
	var overwrite = false

	@Option(name: .shortAndLong, help: "Input file path")
	var input: String

	@Option(name: .shortAndLong, help: "Output directory path")
	var output: String

	mutating func run() throws {
		let sourceUrl = URL(filePath: input)
		let sourceData = try Data(contentsOf: sourceUrl)

		let decoder = PropertyListDecoder()

		let wa = try decoder.decode(WebArchive.self, from: sourceData)

		let outputDirectoryUrl = URL(filePath: output)

		try wa.write(relativeTo: outputDirectoryUrl, overwriteExisting: overwrite)
	}
}
