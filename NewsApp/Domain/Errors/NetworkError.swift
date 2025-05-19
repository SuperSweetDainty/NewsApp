import Foundation

enum NetworkError: Error {
    case invalidURL
    case noInternet
    case noData
    case decodingFailed
    case invalidResponse
    case other(Error)
    case unknown
}
