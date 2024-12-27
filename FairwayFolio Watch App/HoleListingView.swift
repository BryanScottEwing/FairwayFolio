//
//  HoleListingView.swift
//  FairwayFolio Watch App
//
//  Created by Bryan Ewing on 10/22/23.
//

import SwiftData
import SwiftUI

struct HoleListingView: View {
	@Bindable var hole: Hole
	
	@State var editing: Bool = false
		
    var body: some View {
		VStack {
			HStack {
				Button {
					editing = !editing
				} label: {
					Text("Hole \(hole.number)")
						.foregroundColor(.white)						
						
				}
				.buttonStyle(.borderless)
				
				Spacer()
				
				Text("\(hole.par)")
					.foregroundColor(.green)
				
				Spacer()
				
				Text("\(hole.strokes)")
					.foregroundColor(.orange)
				
				Spacer()
				
				Text("\(hole.putts)")
					.foregroundColor(.white)
				
				Spacer()
				
				let score = hole.getScore
				Text("\(score)")
					.foregroundColor(.blue)
				
				/*
				Button {
					editing = !editing
				} label: {
					Image(systemName: "square.and.pencil")
						
				}
				.buttonStyle(.borderless)
				 */
			}
			
			HStack {
				if editing {
					HStack {
						VStack {
							Text("Par")
								.frame(height: 0)
								.font(.caption2)
							Picker("", selection: $hole.par) {
								ForEach(0...6, id: \.self) { par in
									Text("\(par)")
								}
							}
							.pickerStyle(.wheel)
							.frame(height: 50)
						}
						
						VStack {
							Text("Strokes")
								.frame(height: 0)
								.font(.footnote)
							Picker("", selection: $hole.strokes) {
								ForEach(0...6, id: \.self) { stroke in
									Text("\(stroke)")
								}
							}
							.pickerStyle(.wheel)
							.frame(height: 50)
						}
						
						VStack {
							Text("Putts")
								.frame(height: 0)
								.font(.footnote)
							Picker("", selection: $hole.putts) {
								ForEach(0...6, id: \.self) { putt in
									Text("\(putt)")
								}
							}
							.pickerStyle(.wheel)
							.frame(height: 50)
						}
					}
					.frame(height: 70)
				}
			}
			.frame(height: editing ? 70 : 5)
		}
    }
	
	//init(hole: Hole, index: Int) {
	init(hole: Hole) {
		self.hole = hole
		//self.index = index
	}
}

#Preview {
	do {
		let config = ModelConfiguration(for: GolfRound.self, isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: GolfRound.self, configurations: config)
		
		//return HoleListingView(hole: Hole(), index: 0)
		return HoleListingView(hole: Hole())
			.modelContainer(container)
	} catch {
		fatalError("Failed to create model contianer.")
	}
}
