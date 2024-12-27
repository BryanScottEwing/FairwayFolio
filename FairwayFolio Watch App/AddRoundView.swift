//
//  AddRoundView.swift
//  FairwayFolio Watch App
//
//  Created by Bryan Ewing on 10/22/23.
//
import Foundation
import SwiftData
import SwiftUI

struct AddRoundView: View {
	@Environment(\.modelContext) private var modelContext
	@Bindable var currentRound: GolfRound
	
	@State var editing: Bool = false
	
    var body: some View {
		ScrollView {
			Button {
				editing = !editing
			} label: {
				if editing {
					Text("Save")
						.scaleEffect(CGSize(width: 1.25, height: 2.0))
				} else {
					Text("Edit")
						.scaleEffect(CGSize(width: 1.25, height: 2.0))
				}
			}
			.scaleEffect(CGSize(width: 0.75, height: 0.5))
			.buttonStyle(.bordered)
			.colorMultiply(editing ? .green : .gray)
			.padding(-10)
			
			if editing {
				TextField("Name", text: $currentRound.courseName)
				
				Spacer()
				
				DatePicker("Date", selection: $currentRound.date)
					.frame(height: 70)
				
				Spacer()
					.padding()
				
			} else {
				Text(currentRound.courseName)
					.font(.title2)
					.foregroundColor(.green)
				
				Spacer()
				
				Text(getDate(date: currentRound.date))
					.font(.title3)
					.foregroundColor(.orange)
				
				Spacer()
				
				HStack {
					Text("Score:")
						.font(.title2)
						.foregroundColor(.white)
					
					Text(" \(getCourseScore())")
						.font(.title)
						.foregroundColor(.blue)
				}
				
				Divider()
				
				if currentRound.holes.isEmpty {
					Text("No Holes Added")
						.font(.caption2)
				} else {
					Text("Hole Count: \(currentRound.holes.count)")
						.font(.caption2)
					
					Button {
						addHole()
					} label: {
						Image(systemName: "plus.circle")
							.scaleEffect(CGSize(width: 1.0, height: 2.0))
					}
					.buttonStyle(.bordered)
					.labelStyle(.titleOnly)
					.imageScale(.large)
					.colorMultiply(.green)
					.scaleEffect(CGSize(width: 1.0, height: 0.5))
					
					HStack {
						Spacer()
						
						Spacer()
						let fontSize: CGFloat = 12
						
						Text("#")
							.font(.system(size: fontSize))
							.foregroundColor(.white)
						
						Spacer()
						
						Text("Par")
							.font(.system(size: fontSize))
							.foregroundColor(.green)
						
						Spacer()
						
						Text("Stroke")
							.font(.system(size: fontSize))
							.foregroundColor(.orange)
						
						Spacer()
						
						Text("Putt")
							.font(.system(size: fontSize))
							.foregroundColor(.white)
						
						Spacer()
						
						Text("Score")
							.font(.system(size: fontSize))
							.foregroundColor(.blue)
					}
				}
				
				ForEach(currentRound.holes.sorted(by: holeNumberAscending), id: \.self) { hole in
						HoleListingView(hole: hole)
							.padding(0)
				}
				.frame(minHeight: 30, maxHeight: 100)
				
				HStack {
					Button {
						addHole()
					} label: {
						Image(systemName: "plus.circle")
							.scaleEffect(CGSize(width: 1.0, height: 2.0))
					}
					.buttonStyle(.bordered)
					.labelStyle(.titleOnly)
					.imageScale(.large)
					.colorMultiply(.green)
					.scaleEffect(CGSize(width: 1.0, height: 0.5))
					
					if currentRound.holes.count > 0 {
						Button {
							deleteLastHole()
						} label: {
							Image(systemName: "trash")
								.scaleEffect(CGSize(width: 1.0, height: 2.0))
						}
						.buttonStyle(.bordered)
						.labelStyle(.titleOnly)
						.imageScale(.large)
						.colorMultiply(.red)
						.scaleEffect(CGSize(width: 1.0, height: 0.5))
					}
				}
			}
		}
		
    }
	
	init(newRound: GolfRound) {
		self.currentRound = newRound
	}
	
	func getCourseScore() -> Int {
		var finalScore: Int = 0
		
		for i in 0..<currentRound.holes.count {
			finalScore += currentRound.holes[i].getScore
		}
		
		currentRound.score = finalScore
		return finalScore
	}
	
	func holeNumberAscending (hole1: Hole, hole2: Hole) -> Bool {
		if hole1.number < hole2.number { return true }
		else if hole2.number < hole1.number { return false }
		return hole1.number < hole2.number
	}
	
	func addHole() {
		let newHole = Hole(number: currentRound.holes.count + 1, par: 3, strokes: 3, putts: 2)
		currentRound.holes.append(newHole)
	}
	
	func deleteLastHole() {
		if currentRound.holes.isEmpty { return }
		
		var largestNumber: Int = 0
		var largestNumberIndex: Int = 0
		
		for i in 0..<currentRound.holes.count {
			if currentRound.holes[i].number > largestNumber {
				largestNumber = currentRound.holes[i].number
				largestNumberIndex = i
			}
		}
		
		currentRound.holes.remove(at: largestNumberIndex)
		
		print("Largest Number: \(largestNumber) at [\(largestNumberIndex)]")
		
		do {
			try modelContext.save()
		} catch {
			print("Poop")
		}
	}
	
	func deleteHole (at offsets: IndexSet) {
		currentRound.holes.remove(atOffsets: offsets)
	}
	
	func getDate(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		return formatter.string(from: date)
	}
}

#Preview {
	do {
		let config = ModelConfiguration(for: GolfRound.self, isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: GolfRound.self, configurations: config)
		return AddRoundView(newRound: GolfRound())
			.modelContainer(container)
	} catch {
		fatalError("Failed to create model contianer.")
	}
}
