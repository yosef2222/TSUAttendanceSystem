//
//  File.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 04.03.2025.
//

import UIKit


func updateEmotionDictionary(with emotionText: String, image: UIImage, color: UIColor) {
    if var existingEntry = emotionDictionary[emotionText] {
        existingEntry.column += 1
        emotionDictionary[emotionText] = existingEntry
    } else {
        emotionDictionary[emotionText] = (image: image, column: 1, color: color)
    }
}

func updateEmotionDateDictionary(with emotionText: EmotionTime, image: UIImage, color: UIColor) {
    if var existingEntry = emotionDictionaryDate[emotionText] {
        existingEntry.column += 1
        emotionDictionaryDate[emotionText] = existingEntry
    } else {
        emotionDictionaryDate[emotionText] = (image: image, column: 1, color: color)
    }
    print(emotionDictionaryDate)
}
