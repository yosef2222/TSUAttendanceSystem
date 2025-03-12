//
//  StatisticsModel.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 03.03.2025.
//

import UIKit

struct StatisticsModel {
    let weekRanges: [String]
    let colors: [(color: UIColor, percentage: CGFloat)]
    
    init() {
        self.colors = []
        
        var ranges: [String] = []
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        
        let shortMonths = formatter.standaloneMonthSymbols.map { String($0.prefix(3)) }
        
        let today = Date()
        for i in 0..<4 {
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -i, to: today)!
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: weekAgo)!.start
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
            
            let startComponents = calendar.dateComponents([.day, .month], from: startOfWeek)
            let endComponents = calendar.dateComponents([.day, .month], from: endOfWeek)
            
            if let startDay = startComponents.day, let startMonthIndex = startComponents.month,
               let endDay = endComponents.day, let endMonthIndex = endComponents.month {
                
                let startMonth = shortMonths[startMonthIndex - 1]
                let endMonth = shortMonths[endMonthIndex - 1]
                
                let rangeString = "\(startDay) \(startMonth) - \(endDay) \(endMonth)"
                ranges.append(rangeString)
            }
        }
        
        self.weekRanges = ranges
    }
}
