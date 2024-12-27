//
//  GolfRound.swift
//  FairwayFolio Watch App
//
//  Created by Bryan Ewing on 10/22/23.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

@Model
final class GolfRound {
	var courseName: String
	var date: Date
	var score: Int
	
	@Relationship(deleteRule: .cascade) var holes: [Hole]
	
	init(courseName: String = "Course Name", date: Date = Date.now, score: Int = 0, holes: [Hole] = []) {
		self.courseName = courseName
		self.date = date
		self.score = score
		self.holes = holes
	}
	
	func calculateScore() {
		if holes.count == 0 { return }
		
		var finalScore: Int = 0
		
		for i in 0...holes.count {
			finalScore += holes[i].strokes - holes[i].par
		}
		
		score = finalScore
	}
}

@Model
final class Hole: Identifiable {
	let id = UUID()
	let number: Int
	var par: Int
	var strokes: Int
	var putts: Int
	
	var getScore: Int {
		return strokes - par
	}
	
	init(number: Int = 0, par: Int = 3, strokes: Int = 3, putts: Int = 2) {
		self.number = number
		self.par = par
		self.strokes = strokes
		self.putts = putts
	}
}
