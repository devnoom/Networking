//
//  APIClient.swift
//
//
//  Created by MacBook Air on 02.05.24.
//



import Foundation

enum NetworkError: Error {
    case decodeError
    case wrongResponse
    case wrongStatusCode(code: Int)
}

class NetworkService {
    static var networkService = NetworkService()
    
    private init(){}
    func getData<T: Decodable>(urlString: String, comletion: @escaping (Result<T,Error>) ->(Void)) {
        let url = URL(string: urlString)!

        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            if let error {
                print(error.localizedDescription)
            }
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                print("wrong response")
                return
            }
            guard let data else { return }

            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    comletion(.success(object))
                }
            } catch {
                comletion(.failure(NetworkError.decodeError))
            }
        }.resume()
    }
}


