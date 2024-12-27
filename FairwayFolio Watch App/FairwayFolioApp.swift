//
//  FairwayFolioApp.swift
//  FairwayFolio Watch App
//
//  Created by Bryan Ewing on 10/2/23.
//

import SwiftData
import SwiftUI

@main
struct FairwayFolio_Watch_AppApp: App {
	
	let modelContainer: ModelContainer
	
	init() {
		do {
			modelContainer = try ModelContainer(for: GolfRound.self)
		} catch {
			fatalError("Could not initialize ModelContainer")
		}
	}

	var body: some Scene {
		WindowGroup {
			ContentView()
		}
		.modelContainer(for: GolfRound.self)
	}
}
