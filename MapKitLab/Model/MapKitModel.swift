//
//  MapKitModel.swift
//  MapKitLab
//
//  Created by Melinda Diaz on 2/21/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import Foundation


struct NYSchools: Codable {
    let schoolName: String
    let location: String
    let latitude: String
    let longitude: String
    
    
    enum CodingKeys: String, CodingKey {
        case schoolName = "school_name"
        case location
        case latitude
        case longitude
    }
    
}
