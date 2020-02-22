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
    let overviewParagraph: String
    let location: String
    let schoolEmail: String
    let website: String
    let latitude: String
    let longitude: String
    let councilDistrict: String
    
    
    
    
    enum CodingKeys: String, CodingKey {
        case schoolName = "school_name"
        case overviewParagraph = "overview_paragraph"
        case location
        case schoolEmail = "school_email"
        case website
        case latitude
        case longitude
        case councilDistrict = "council_district"
        
    }
    
}
