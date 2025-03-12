//
//  StatisticsViewController.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 03.03.2025.
//


import UIKit

class CirclesViewController: UIViewController {

    private var colors: [(color: UIColor, percentage: CGFloat)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black


        setupLayout()
    }

    private func setupLayout() {
        let textLabel = UILabel()
        textLabel.text = "Эмоции \nпо категориям"
        textLabel.textColor = .white
        textLabel.font = UIFont(name: "Gwen-Trial-Bold", size: UIScreen.main.bounds.width / 10)
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        let columnLabel = UILabel()
        let emotionColors = [2, 3, 4]
        switch emotionColors.count{
        case 1:
            columnLabel.text = String(emotionColors.count) + " запись"
        case 0, 5, 6, 7, 9, 11, 12, 13, 14:
            columnLabel.text = String(emotionColors.count) + " записей"
        default:
            columnLabel.text = String(emotionColors.count) + " записи"
        }
        
        columnLabel.textColor = .white
        columnLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: UIScreen.main.bounds.width / 20)
        columnLabel.numberOfLines = 0
        columnLabel.lineBreakMode = .byWordWrapping
        columnLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(columnLabel)
        

        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            columnLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            columnLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 5),
            columnLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
    }

    private func calculateColorPercentages(from emotionColors: [UIColor]) -> [(color: UIColor, percentage: CGFloat)] {
        guard !emotionColors.isEmpty else { return [] }

        let totalColors = CGFloat(emotionColors.count)
        let colorCounts = Dictionary(grouping: emotionColors, by: { $0 }).mapValues { CGFloat($0.count) }

        return colorCounts.map { (color: $0.key, percentage: $0.value / totalColors) }
    }
}
