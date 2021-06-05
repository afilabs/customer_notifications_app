
import Foundation
import SwiftyJSON
import MapKit
import ObjectMapper

class DirectionStep: BaseModel {
  var distance = ObjectKV()
  var duration = ObjectKV()
  var travelMode = ""
  var endLocation = GoogleCoordinate()
  var startLocation = GoogleCoordinate()
  var instructions = ""
  var polyline = ""
  var maneuver = ""
    
    override init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init()
        distance = ObjectKV(json: json["distance"])
        duration = ObjectKV(json: json["duration"])
        travelMode = json["travel_mode"].string ?? ""
        instructions = json["html_instructions"].string ?? ""
        polyline = json["polyline"]["points"].string ?? ""
        maneuver = json["maneuver"].string ?? ""
        endLocation = GoogleCoordinate(json: json["end_location"])
        startLocation = GoogleCoordinate(json: json["start_location"])

    }
    
    required init?(map: Map) {
        super.init()
    }
    
    override func mapping(map: Map) {
        distance <- map["distance"]
        duration <- map["duration"]
        travelMode <- map["travel_mode"]
        instructions <- map["html_instructions"]
        polyline <- map["polyline"]["points"]
        maneuver <- map["maneuver"]
        endLocation <- map["end_location"]
        startLocation <- map["start_location"]
    }
  
}

class ObjectKV: BaseModel {
    var text: String = ""
    var value: Double = 0
    
    
    override init() {
        super.init()
    }
    
    init(json: JSON) {
        super.init()
        text = json["text"].string ?? ""
        value = json["value"].double ?? 0
    }
    
    required init?(map: Map) {
        super.init()
    }
    
    override func mapping(map: Map) {
        text <- map["text"]
        value <- map["value"]
    }
}

class DirectionLeg: BaseModel {
  var distance = ObjectKV()
  var duration = ObjectKV()
  var endAddress = ""
  var startAddress = ""
  var steps = [DirectionStep]()
    
    override init() {
        super.init()
    }
    
    init(json: JSON) {
        super.init()
        
        distance = ObjectKV(json: json["distance"])
        duration = ObjectKV(json: json["duration"])
        endAddress = json["endAddress"].string ?? ""
        startAddress = json["startAddress"].string ?? ""
        steps = json["steps"].arrayValue.map({ (data) -> DirectionStep in
                return DirectionStep(json: data)
        })

    }
    
    required init?(map: Map) {
        super.init()
    }
    
    override func mapping(map: Map) {
        distance  <- map["distance"]
        duration <- map["duration"]
        endAddress <- map["endAddress"]
        startAddress <- map["startAddress"]
        steps <- map["steps"]
    }
}

class GoogleCoordinate: BaseModel {
    var lat: Double = 0.0
    var lng: Double = 0.0
    
    override init() {
        super.init()
    }
    
    init(json: JSON) {
        super.init()
        lat = json["lat"].double ?? 0
        lng = json["lng"].double ?? 0
    }
    
    required init?(map: Map) {
        super.init()
    }
    
    override func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lng"]
    }
    
    func toCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
  
}

class DirectionRoute: BaseModel {
    
    var polyline: String = ""
    var boundsNortheast = GoogleCoordinate()
    var boundsSouthest = GoogleCoordinate()
    var legs = [DirectionLeg]()

    override init() {
        super.init()
    }
    
    init(json: JSON) {
        super.init()
        polyline = json["overview_polyline"]["points"].string ?? ""
        boundsNortheast = GoogleCoordinate(json: json["bounds"]["southwest"])
        boundsSouthest = GoogleCoordinate(json: json["bounds"]["northeast"])
        legs = json["legs"].arrayValue.map({ (data) -> DirectionLeg in
                return DirectionLeg(json: data)
        })
    }
    
    required init?(map: Map) {
        super.init()
    }
    
    override func mapping(map: Map) {
        polyline <- map["overview_polyline.points"]
        boundsNortheast <- map["bounds.southwest"]
        boundsSouthest <- map["bounds.northeast"]
        legs <- map["legs"]
             
    }
}

class MapDirectionResponse: BaseModel {
    var routes: [DirectionRoute] = [DirectionRoute]()
    var status = ""
    
    
    override init() {
        super.init()
    }
    
    init(json: JSON) {
        super.init()
        status = json["status"].string ?? ""
        routes = json["routes"].arrayValue.map({ (data) -> DirectionRoute in
                return DirectionRoute(json: data)
        })
    }
    
    required init?(map: Map) {
        super.init()
    }
    
    override func mapping(map: Map) {
        routes <- map["routes"]
        status <- map["status"]
    }
}
