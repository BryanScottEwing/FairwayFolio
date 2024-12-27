//
//  ContentView.swift
//  FairwayFolio Watch App
//
//  Created by Bryan Ewing on 10/2/23.
//

import SwiftData
import SwiftUI

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	@Query(sort: [SortDescriptor(\GolfRound.courseName, order: .forward)]) var golfRounds: [GolfRound]

	@State private var path = [GolfRound]()
	@State private var sortOrder = SortDescriptor(\GolfRound.courseName)
	@State private var searchText = ""
    
    var body: some View {
		NavigationStack(path: $path) {
			RoundListingView(sort: sortOrder, searchString: searchText)
				  .navigationTitle("Rounds")
				  .navigationDestination(for: GolfRound.self, destination: AddRoundView.init)
				  .searchable(text: $searchText)
				  .toolbar {
					  HStack {
						  Button("Add Round", systemImage: "plus.circle", action: addRound)
							  .buttonStyle(.bordered)
							  .labelStyle(.iconOnly)
							  .imageScale(.large)
							  .colorMultiply(.green)
						  
						  Picker("Sort", selection: $sortOrder) {
							  Text("Name")
								  .tag(SortDescriptor(\GolfRound.courseName))
							  Text("Date")
								  .tag(SortDescriptor(\GolfRound.date))
							  Text("Score")
								  .tag(SortDescriptor(\GolfRound.score))
						  }
					  }
				  }
		}
	}
    
	
	private func addRound () {
		withAnimation {
			let newRound = GolfRound()
			modelContext.insert(newRound)
			path = [newRound]
		}
	}
	
}

#Preview {
    ContentView()
		.modelContainer(for: GolfRound.self, inMemory: true)
}
