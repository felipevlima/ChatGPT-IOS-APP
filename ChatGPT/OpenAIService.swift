//
//  OpenAIService.swift
//  ChatGPT
//
//  Created by Felipe Vieira Lima on 21/03/23.
//

import Foundation
import Alamofire
import Combine

class OpenAIService {
    let baseUrl = "https://api.openai.com/v1/completions"
    var isLoading: Bool = false
    
    func sendMessage(message: String) -> AnyPublisher<OpenAIResponse, Error> {
        self.isLoading = true
        let body = OpenAICompletionsBody(model: "text-davinci-003", prompt: message, temperature: 0.6, max_tokens: 256)
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(Constants.OpenAIAPIKey)"
        ]
        
        return Future { [weak self] promise in
            guard let self = self else {return}
            AF.request(self.baseUrl, method: .post, parameters: body, encoder: .json, headers: headers).responseDecodable(of: OpenAIResponse.self) { response in
                
                switch response.result {
                    case .success(let result):
                        self.isLoading = false
                        promise(.success(result))
                        
                    case.failure(let error):
                        self.isLoading = false
                        promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
