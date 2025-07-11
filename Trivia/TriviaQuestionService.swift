//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Abdul Hussien on 7/10/25.
//

import Foundation

class TriviaQuestionService {
    func fetchQuestions(completion: @escaping ([TriviaQuestion]?) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=5&type=multiple"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(TriviaResponse.self, from: data)
                    completion(decoded.results)
                } catch {
                    print("Decoding error: \(error)")
                    completion(nil)
                }
            } else {
                print("Network error: \(error?.localizedDescription ?? "Unknown")")
                completion(nil)
            }
        }.resume()
    }
}
