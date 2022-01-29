//
//  Adam_20220129_EnrouteApp.swift
//  Adam_20220129_Enroute
//
//  Created by Adam on 2022/1/29.
//

import SwiftUI

@main
struct Adam_20220129_EnrouteApp: App {
    var body: some Scene {
        WindowGroup {
            FlightsEnrouteView(flightSearch: FlightSearch(destination: "KSFO"))
        }
    }
}
