//
//  GlobalModel.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 04.03.2025.
//

import UIKit

struct EmotionTime: Hashable {
    let text: String
    let date: String
    
    static func == (lhs: EmotionTime, rhs: EmotionTime) -> Bool {
        return lhs.text == rhs.text && lhs.date == rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(date)
    }
}

var emotionColors: [UIColor] = []
var emotionTexts: [String] = []
var emotionCards: [UIView] = []
var emotionIcons: [UIImage] = []
var emotionDictionary: [String: (image: UIImage, column: Int, color: UIColor)] = [:]
var emotionDictionaryDate: [EmotionTime: (image: UIImage, column: Int, color: UIColor)] = [:]
