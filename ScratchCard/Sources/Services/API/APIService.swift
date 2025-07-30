import Foundation

protocol APIServiceType {
    func getScratchCardVersion(code: String) async throws -> GetScratchCardVersionResponse
}

final class APIService: APIServiceType {
    
    // MARK: - APIServiceType
    
    func getScratchCardVersion(code: String) async throws -> GetScratchCardVersionResponse {
        return try await fetch(
            urlString: "https://api.o2.sk/version",
            queryItems: [URLQueryItem(name: "code", value: code)]
        )
    }
    
    // MARK: - Private methids

    private func fetch<T: Decodable>(urlString: String, queryItems: [URLQueryItem]?) async throws -> T {
        guard var urlComponents = URLComponents(string: urlString) else {
            throw URLError(.badURL)
        }
        urlComponents.queryItems = queryItems
        
        guard let requestURL = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: requestURL)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
