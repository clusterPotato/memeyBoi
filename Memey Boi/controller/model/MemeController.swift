//
//  MemeController.swift
//  Memey Boi
//
//  Created by Gavin Craft on 5/5/21.
//

import UIKit
class MemeController{
    static let modifier = "cursedImages" //felt cute, might remove later
    static let baseUrl = URL(string: "https://meme-api.herokuapp.com")
    static func getMeme(completion: @escaping(Result<Meme, MemeError>)->Void){
        guard let baseUrl = baseUrl else {return completion(.failure(.unknownURL))}
        let secondUrl = baseUrl.appendingPathComponent("gimme")
        let finalURL = secondUrl.appendingPathComponent(modifier)
        //per such a nice request
        print(finalURL)
        URLSession.shared.dataTask(with: finalURL) { data, response, err in
            if let error = err{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.unidentified))
            }
            guard let data = data else {return completion(.failure(.badData))}
            do{
                let meme = try JSONDecoder().decode(Meme.self, from: data)
                return completion(.success(meme))
            }catch{
                return completion(.failure(.cannotParse))
            }
        }.resume()
    }
    static func fetchImage(url: URL, completion: @escaping (Result<UIImage, MemeError>) ->Void){
        let url = url
        print(url)
        URLSession.shared.dataTask(with: url) { data, response, err in
            if let error = err{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.unidentified))
            }
            guard let data = data else {return completion(.failure(.badData))}
            guard let image = UIImage(data: data) else {return completion(.failure(.cannotParse))}
            completion(.success(image))
        }.resume()
    }
}
