//
//  Adam_20220128_EnrouteApp.swift
//  Adam_20220128_Enroute
//
//  Created by Adam on 2022/1/29.
//

import SwiftUI

@main
struct Adam_20220128_EnrouteApp: App {
    let persistenceController = PersistenceController.shared
    let defaultAirport: Airport
    
    init() {
        defaultAirport = Airport.withICAO("KSFO", context: PersistenceController.shared.container.viewContext)
        defaultAirport.fetchIncomingFlights()
    }
    var body: some Scene {
//        let airport = Airport.withICAO("KSFO", context: persistenceController.container.viewContext)
//        airport.fetchIncomingFlights()
       return WindowGroup {
        
            FlightsEnrouteView(
                flightSearch: FlightSearch(
                    destination: defaultAirport))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
