//
//  File.swift
//  
//
//  Created by Ибрагим on 23.03.2023.
//

import Foundation

struct FlightDTO: Codable {
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
}

protocol IObjectService {
    var baseURL: URL { get }
    func fetchFlights(completion: @escaping (([FlightDTO]?) -> Void))
}

class FlightService: IObjectService {
    let baseURL = URL(string: "https://api.schiphol.nl/public-flights/flights")!
    
    func fetchFlights(completion: @escaping (([FlightDTO]?) -> Void)) {
        var request = URLRequest(url: baseURL)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("<ce41dfe3ee66eacabfde5792357de89c>", forHTTPHeaderField: "f8cad984")
//        request.addValue("<API_SECRET>", forHTTPHeaderField: "app_key")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let flights = try decoder.decode([FlightDTO].self, from: data)
                completion(flights)
            } catch {
                completion(nil)
            }
        }.resume()
    }
}
