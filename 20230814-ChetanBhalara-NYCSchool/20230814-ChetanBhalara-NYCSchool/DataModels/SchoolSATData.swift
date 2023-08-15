//
//  SchoolSATData.swift
//  20230814-ChetanBhalara-NYCSchool
//
//  Created by Chetan Bhalara on 8/15/23.
//

import Foundation

struct SchoolSATData: Codable, Identifiable {
    let id = UUID()
    let dbn, schoolName, numOfSatTestTakers, satCriticalReadingAvgScore: String
    let satMathAvgScore, satWritingAvgScore: String

    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case numOfSatTestTakers = "num_of_sat_test_takers"
        case satCriticalReadingAvgScore = "sat_critical_reading_avg_score"
        case satMathAvgScore = "sat_math_avg_score"
        case satWritingAvgScore = "sat_writing_avg_score"
    }
}
