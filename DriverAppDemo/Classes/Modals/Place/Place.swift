//
//  Place.swift
//  RouteSimply
//
//  Created by Apple on 1/21/20.
//  Copyright © 2020 NguyenMV. All rights reserved.
//

import UIKit

struct Place: Codable {
    var formattedAddress: String?
    var geometry: PGeometry?
    var icon: String?
    var id: String?
    var name: String?
    var placeId: String?
    var reference: String?
}

struct PGeometry: Codable {
    var location: PLocation?
}

struct PLocation: Codable {
    var lat: Double?
    var lng: Double?
}



