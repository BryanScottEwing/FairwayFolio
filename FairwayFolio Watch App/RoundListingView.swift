//
//  RoundListingView.swift
//  FairwayFolio Watch App
//
//  Created by Bryan Ewing on 10/22/23.
//

import SwiftData
import SwiftUI

struct RoundListingView: View {
	@Environment(\.modelContext) var modelContext
	@Query(sort: [SortDescriptor(\GolfRound.date, order: .forward)]) var rounds: [GolfRound]
	
    var body: some View {
		List {
			ForEach(rounds) { round in
				NavigationLink(value: round) {
					HStack {
						Text(round.courseName)
							.font(.body)
							.foregroundColor(.green)
						
						Spacer()
						
						Text(getDate(date: round.date))
							.font(.caption2)
							.foregroundColor(.orange)
						
						Spacer()
						
						Text("\(round.score)")
							.font(.title2)
							.foregroundColor(.blue)
					}
				}
			}
			.onDelete(perform: deleteRound)
		}
	}
	
	init(sort: SortDescriptor<GolfRound>, searchString: String) {
		_rounds = Query(filter: #Predicate {
			if searchString.isEmpty {
				return true
			} else {
				return $0.courseName.localizedStandardContains(searchString)
			}
		}, sort: [sort])
	}
	
	func deleteRound (_ indexSet: IndexSet) {
		for index in indexSet {
			let round = rounds[index]
			modelContext.delete(round)
		}
	}
	
	func getDate(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		return formatter.string(from: date)
	}
	
}

#Preview {
	RoundListingView(sort: SortDescriptor(\GolfRound.date), searchString: "")
}
