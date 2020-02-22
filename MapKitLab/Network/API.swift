//
//  API.swift
//  MapKitLab
//
//  Created by Melinda Diaz on 2/21/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import Foundation
import NetworkHelper

struct APIClient {
    static func getSchools(completion: @escaping (Result<[NYSchools], AppError>) ->()) {
        let endpointString = "https://data.cityofnewyork.us/resource/uq7m-95z8.json"
        
        guard let url = URL(string: endpointString) else {
            completion(.failure(.badURL(endpointString)))
            return
        }
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(.networkClientError(error)))
            case .success(let data):
                do{
                    let searchResults = try JSONDecoder().decode([NYSchools].self, from: data)
                    completion(.success(searchResults))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
