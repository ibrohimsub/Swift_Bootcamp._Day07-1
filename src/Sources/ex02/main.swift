//
//  File.swift
//  
//
//  Created by Ибрагим on 23.03.2023.
//

import Foundation

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

class ObjectURLSessionService: IObjectService {
    let baseURL = URL(string: "https://api.schiphol.nl/public-flights/flights")!
    
    func fetchFlights(completion: @escaping (([FlightDTO]?) -> Void)) {
        var request = URLRequest(url: baseURL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("<ce41dfe3ee66eacabfde5792357de89c>", forHTTPHeaderField: "f8cad984")
//        request.addValue("<API_SECRET>", forHTTPHeaderField: "app_key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonArr = json as? [[String: Any]] else {
                    completion(nil)
                    return
                }
                
                let flights = jsonArr.compactMap { FlightDTO(json: $0) }
                completion(flights)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
}
