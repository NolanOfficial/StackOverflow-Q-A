//
//  Network.swift
//  StackOverflow Q&A
//
//  Created by Nolan Fuchs on 1/16/19.
//  Copyright © 2019 Nolan Fuchs. All rights reserved.
//

import UIKit

class Network {
    
    func urlStartSession(url: URL, completion: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if err != nil {
                print(err ?? "Error with URL Session")
            } else {
                guard let data = data else { return }
                completion(data)
            }
            }.resume()
    }
    
}
