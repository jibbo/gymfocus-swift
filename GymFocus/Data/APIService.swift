import Foundation
import UIKit

actor APIService {
    static let shared = APIService()
    
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: configuration)
    }
}

extension APIService {
    enum APIError: Error, LocalizedError {
        case invalidURL
        case invalidResponse
        case noData
        case decodingError(Error)
        case networkError(Error)
        case serverError(Int)
        case missingAPIKey
        case imageProcessingError
        case uploadError(String)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .invalidResponse:
                return "Invalid response"
            case .noData:
                return "No data received"
            case .decodingError(let error):
                return "Decoding error: \(error.localizedDescription)"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            case .serverError(let code):
                return "Server error with code: \(code)"
            case .missingAPIKey:
                return "Missing API key"
            case .imageProcessingError:
                return "Image processing error"
            case .uploadError(let message):
                return "Upload error: \(message)"
            }
        }
    }
}

extension APIService {
    struct GeminiRequest: Codable {
        let contents: [Content]
        
        struct Content: Codable {
            let parts: [Part]
            
            struct Part: Codable {
                let text: String?
                let fileData: FileData?
                let inlineData: InlineData?
                
                enum CodingKeys: String, CodingKey {
                    case text
                    case fileData = "file_data"
                    case inlineData = "inline_data"
                }
                
                init(text: String) {
                    self.text = text
                    self.fileData = nil
                    self.inlineData = nil
                }
                
                init(fileData: FileData) {
                    self.text = nil
                    self.fileData = fileData
                    self.inlineData = nil
                }
                
                init(inlineData: InlineData) {
                    self.text = nil
                    self.fileData = nil
                    self.inlineData = inlineData
                }
            }
            
            struct FileData: Codable {
                let mimeType: String
                let fileUri: String
                
                enum CodingKeys: String, CodingKey {
                    case mimeType = "mime_type"
                    case fileUri = "file_uri"
                }
            }
            
            struct InlineData: Codable {
                let mimeType: String
                let data: String
                
                enum CodingKeys: String, CodingKey {
                    case mimeType = "mime_type"
                    case data
                }
            }
        }
    }
    
    struct GeminiResponse: Codable {
        let candidates: [Candidate]
        
        struct Candidate: Codable {
            let content: Content
            
            struct Content: Codable {
                let parts: [Part]
                
                struct Part: Codable {
                    let text: String
                }
            }
        }
    }
    
    struct FileUploadStartRequest: Codable {
        let file: FileMetadata
        
        struct FileMetadata: Codable {
            let displayName: String
            
            enum CodingKeys: String, CodingKey {
                case displayName = "display_name"
            }
        }
    }
    
    struct FileUploadResponse: Codable {
        let file: UploadedFile
        
        struct UploadedFile: Codable {
            let uri: String
            let name: String?
            let displayName: String?
            let mimeType: String?
            let sizeBytes: String?
            
            enum CodingKeys: String, CodingKey {
                case uri
                case name
                case displayName = "display_name"
                case mimeType = "mime_type"
                case sizeBytes = "size_bytes"
            }
        }
    }
}

extension APIService {
    private func uploadImage(_ image: UIImage, displayName: String, apiKey: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw APIError.imageProcessingError
        }
        
        let mimeType = "image/jpeg"
        let contentLength = imageData.count
        
        guard let startUrl = URL(string: "https://generativelanguage.googleapis.com/upload/v1beta/files") else {
            throw APIError.invalidURL
        }
        
        let startRequest = FileUploadStartRequest(
            file: FileUploadStartRequest.FileMetadata(displayName: displayName)
        )
        
        var request = URLRequest(url: startUrl)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "x-goog-api-key")
        request.setValue("resumable", forHTTPHeaderField: "X-Goog-Upload-Protocol")
        request.setValue("start", forHTTPHeaderField: "X-Goog-Upload-Command")
        request.setValue("\(contentLength)", forHTTPHeaderField: "X-Goog-Upload-Header-Content-Length")
        request.setValue(mimeType, forHTTPHeaderField: "X-Goog-Upload-Header-Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(startRequest)
        } catch {
            throw APIError.decodingError(error)
        }
        
        let (_, startResponse) = try await session.data(for: request)
        
        guard let httpResponse = startResponse as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode,
              let uploadUrl = httpResponse.value(forHTTPHeaderField: "x-goog-upload-url") else {
            throw APIError.uploadError("Failed to get upload URL")
        }
        
        guard let url = URL(string: uploadUrl) else {
            throw APIError.invalidURL
        }
        
        var uploadRequest = URLRequest(url: url)
        uploadRequest.httpMethod = "POST"
        uploadRequest.setValue("\(contentLength)", forHTTPHeaderField: "Content-Length")
        uploadRequest.setValue("0", forHTTPHeaderField: "X-Goog-Upload-Offset")
        uploadRequest.setValue("upload, finalize", forHTTPHeaderField: "X-Goog-Upload-Command")
        uploadRequest.httpBody = imageData
        
        let (uploadData, uploadResponse) = try await session.data(for: uploadRequest)
        
        guard let uploadHttpResponse = uploadResponse as? HTTPURLResponse,
              200...299 ~= uploadHttpResponse.statusCode else {
            throw APIError.uploadError("Failed to upload image")
        }
        
        let fileResponse = try JSONDecoder().decode(FileUploadResponse.self, from: uploadData)
        return fileResponse.file.uri
    }
    
    private func imageToBase64(_ image: UIImage) throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw APIError.imageProcessingError
        }
        return imageData.base64EncodedString()
    }
    
    func generateContent(text: String, images: [UIImage] = [], useInlineImages: Bool = true, apiKey: String) async throws -> String {
        guard !apiKey.isEmpty else {
            throw APIError.missingAPIKey
        }
        
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent") else {
            throw APIError.invalidURL
        }
        
        var parts: [GeminiRequest.Content.Part] = [GeminiRequest.Content.Part(text: text)]
        
        for (index, image) in images.enumerated() {
            if useInlineImages {
                let base64Data = try imageToBase64(image)
                let inlineData = GeminiRequest.Content.InlineData(
                    mimeType: "image/jpeg",
                    data: base64Data
                )
                parts.append(GeminiRequest.Content.Part(inlineData: inlineData))
            } else {
                let fileUri = try await uploadImage(image, displayName: "image_\(index + 1)", apiKey: apiKey)
                let fileData = GeminiRequest.Content.FileData(
                    mimeType: "image/jpeg",
                    fileUri: fileUri
                )
                parts.append(GeminiRequest.Content.Part(fileData: fileData))
            }
        }
        
        let requestBody = GeminiRequest(
            contents: [
                GeminiRequest.Content(parts: parts)
            ]
        )
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-goog-api-key")
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
            print("request sent: ")
            print(text)
        } catch {
            throw APIError.decodingError(error)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
        
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw APIError.serverError(httpResponse.statusCode)
            }
            
            guard !data.isEmpty else {
                throw APIError.noData
            }
            
            let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
            
            guard let firstCandidate = geminiResponse.candidates.first,
                  let firstPart = firstCandidate.content.parts.first else {
                throw APIError.noData
            }
            
            return firstPart.text
            
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}
