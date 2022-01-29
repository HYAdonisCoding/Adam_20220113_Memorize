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

    var body: some Scene {
        WindowGroup {
            FlightsEnrouteView(
                flightSearch: FlightSearch(
                    destination: Airport.withICAO("KSFO", context: persistenceController.container.viewContext) ))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
