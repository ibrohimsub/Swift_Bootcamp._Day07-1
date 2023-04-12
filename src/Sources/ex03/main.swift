//
//  File.swift
//  
//
//  Created by Ибрагим on 23.03.2023.
//

import Foundation
import Alamofire

struct FlightDTO {
    let flightName: String
    let scheduleDate: String
    let scheduleTime: String
    let gate: String?
    let terminal: String?
    let status: String
    let airlineName: String
    let airlineCode: String
    let destination: String
    let aircraftType: String?
    
    init?(json: [String: Any]) {
        guard let flightName = json["flightName"] as? String,
              let scheduleDate = json["scheduleDate"] as? String,
              let scheduleTime = json["scheduleTime"] as? String,
              let status = json["flightDirection"] as? String,
              let airlineName = json["airlineName"] as? String,
              let airlineCode = json["airlineCode"] as? String,
              let destination = json["destination"] as? String else {
            return nil
        }
        
        self.flightName = flightName
        self.scheduleDate = scheduleDate
        self.scheduleTime = scheduleTime
        self.gate = json["gate"] as? String
        self.terminal = json["terminal"] as? String
        self.status = status
        self.airlineName = airlineName
        self.airlineCode = airlineCode
        self.destination = destination
        self.aircraftType = json["aircraftType"] as? String
    }
}


protocol IObjectService {
    var baseURL: URL { get }
    func fetchFlights(completion: @escaping (([FlightDTO]?) -> Void))
}

class ObjectAlamofireService: IObjectService {
    
    let baseURL = "https://api.schiphol.nl/public-flights/"
    
    func fetchObjects(completion: @escaping (ObjectDTO?) -> Void) {
        let headers: HTTPHeaders = [
            "ResourceVersion": "v4",
            "Accept": "application/json",
            "app_id": "<f8cad984>",
            "app_key": "<ce41dfe3ee66eacabfde5792357de89c>"
        ]
        
        let url = "\(baseURL)flights"
        
        AF.request(url, headers: headers)
            .validate()
            .responseDecodable(of: ObjectDTO.self) { response in
                switch response.result {
                case .success(let objectDTO):
                    completion(objectDTO)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
    }
}
