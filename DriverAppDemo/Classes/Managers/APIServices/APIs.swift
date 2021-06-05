//
//  APIs.swift
//  SDBaseIOS
//
//  Created by machnguyen_uit on 6/8/18.
//  Copyright © 2018 machnguyen_uit. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation
import Alamofire

extension BaseAPI {
    
    @discardableResult
    func getRouting(origin:CLLocationCoordinate2D,
                              destination:CLLocationCoordinate2D,
                              waypoints:Array<CLLocationCoordinate2D>,
                              callback: @escaping APICallback<MapDirectionResponse>) -> APIRequest{
        let path = CommonUtils.getPathDirections(origin, destination, waypoints)
        let server = "https://maps.googleapis.com/maps/api"
        return request(method: HTTPMethod.get,
                       serverURL: server,
                       path: path,
                       input: APIInput.empty,
                       callback: callback)
    }
    
    @discardableResult
    func getStopById(id:Int,callback: @escaping APICallback<OrderModel>) -> APIRequest{
        let path = "stops/\(id)"
        let server = "https://customer-notifications-sample.herokuapp.com/"
        return request(method: .get,
                       serverURL: server,
                       path: path,
                       input: APIInput.empty,
                       callback: callback)
    }
    
    @discardableResult
    func updateStop(id:Int, params:[String:Any], callback: @escaping APICallback<OrderModel>) -> APIRequest{
        let path = "stops/\(id)"
        let server = "https://customer-notifications-sample.herokuapp.com/"
        return request(method: .put,
                       serverURL: server,
                       path: path,
                       input: .json(params),
                       callback: callback)
    }
    
    @discardableResult
    func sendETAToCustomer(params:[String:Any], callback: @escaping APICallback<OrderModel>) -> APIRequest{
        let path = "customers/send-eta"
        let server = "https://customer-notifications-sample.herokuapp.com/"
        return request(method: .post,
                       serverURL: server,
                       path: path,
                       input: .json(params),
                       callback: callback)
    }
}
