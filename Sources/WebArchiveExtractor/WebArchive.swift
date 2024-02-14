import Foundation

public struct WebArchive: Decodable {
	public let mainResource: WebResource
	public let subresources: [WebResource]

	enum CodingKeys: String, CodingKey {
		case mainResource = "WebMainResource"
		case subresources = "WebSubresources"
	}
	
	public func write(relativeTo baseUrl: URL, overwriteExisting: Bool) throws {
		var outputIsDirectory: ObjCBool = false
		let outputExists = FileManager.default.fileExists(atPath: baseUrl.path(), isDirectory: &outputIsDirectory)
		
		guard !outputExists || outputIsDirectory.boolValue else {
			print("Output already exists as a file, refusing to overwrite")
			return
		}
		
		if outputExists {
			guard overwriteExisting else {
				print("Output folder already exists and clear/overwrite parameters weren't set")
				return
			}
		}

		try mainResource.write(relativeTo: baseUrl, overwriteExisting: overwriteExisting)
		for subresource in subresources {
			try subresource.write(relativeTo: baseUrl, overwriteExisting: overwriteExisting)
		}
	}
}

public struct WebResource: Decodable {
	public let data: Data
	public let frameName: String?
	public let mimeType: String
	public let encoding: String?
	public let path: String
	
	func url() throws -> URL {
		guard let res = URL(string: path) else {
			throw WAError.urlParseFailed(path)
		}
		return res
	}
	
	enum CodingKeys: String, CodingKey {
		case data = "WebResourceData"
		case frameName = "WebResourceFrameName"
		case mimeType = "WebResourceMIMEType"
		case encoding = "WebResourceTextEncodingName"
		case path = "WebResourceURL"
	}

	func write(relativeTo baseUrl: URL, overwriteExisting: Bool) throws {
		let writeUrl = try fileUrl(relativeTo: baseUrl)
		if FileManager.default.fileExists(atPath: writeUrl.path()) {
			guard overwriteExisting else {
				throw WAError.fileExists(writeUrl.path())
			}
			try FileManager.default.removeItem(atPath: writeUrl.path())
		}
		try FileManager.default.createDirectory(at: writeUrl.deletingLastPathComponent(), withIntermediateDirectories: true)
		try write(to: writeUrl)
	}
	
	func fileUrl(relativeTo baseUrl: URL) throws -> URL {
		var writeUrl = baseUrl
		for component in try self.url().pathComponents {
			writeUrl = writeUrl.appending(path: component)
		}
		return writeUrl
	}
	
	func write(to url: URL) throws {
		try self.data.write(to: url)
	}
}
