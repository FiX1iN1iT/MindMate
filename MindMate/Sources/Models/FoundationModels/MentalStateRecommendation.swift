//
//  MentalStateRecommendation.swift
//  MindMate
//
//  Created by Alexander on 26.10.2025.
//

import FoundationModels

@Generable
struct MentalStateRecommendation {
    @Guide(description: "2 sentences encouraging text")
    let encouragingText: String

    @Guide(description: "A list of action points which might improve mental state", .count(5))
    let actionPoints: [String]
}
