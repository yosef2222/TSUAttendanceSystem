//
//  emotionToday.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 05.03.2025.
//

import UIKit

class EmotionsTodayViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваше настроение\nв течение дня"
        label.numberOfLines = 0
        label.font = UIFont(name: "Gwen-Trial-Bold", size: UIScreen.main.bounds.width / 12)
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chartContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let timeCategories = ["Раннее\nутро", "Утро", "День", "Вечер", "Поздний\nвечер"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupChart()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(titleLabel)
        view.addSubview(chartContainerView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            chartContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            chartContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            chartContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chartContainerView.heightAnchor.constraint(equalToConstant: 450)
        ])
    }
    
    private func setupChart() {
        let chartStackView = UIStackView()
        chartStackView.axis = .horizontal
        chartStackView.alignment = .bottom
        chartStackView.distribution = .fillEqually
        chartStackView.spacing = 10
        chartStackView.translatesAutoresizingMaskIntoConstraints = false

        let labelsStackView = UIStackView()
        labelsStackView.axis = .horizontal
        labelsStackView.alignment = .center
        labelsStackView.distribution = .fillEqually
        labelsStackView.spacing = 10
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false

        chartContainerView.addSubview(chartStackView)
        chartContainerView.addSubview(labelsStackView)

        NSLayoutConstraint.activate([
            chartStackView.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor),
            chartStackView.trailingAnchor.constraint(equalTo: chartContainerView.trailingAnchor),
            chartStackView.topAnchor.constraint(equalTo: chartContainerView.topAnchor),
            chartStackView.heightAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width / 1.3),

            labelsStackView.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: chartContainerView.trailingAnchor),
            labelsStackView.topAnchor.constraint(equalTo: chartStackView.bottomAnchor, constant: 10),
            labelsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])

        var categorizedData: [String: [UIColor]] = [:]

        for category in timeCategories {
            categorizedData[category] = []
        }

        for (emotion, details) in emotionDictionaryDate {
            let hour = extractHour(from: emotion.date)
            let category = getCategory(for: hour)
            categorizedData[category]?.append(details.color)
        }

        for category in timeCategories {
            let colors = categorizedData[category] ?? []
            let total = colors.count

            if colors.isEmpty {
                let grayColumnView = createDefaultGrayColumn()
                chartStackView.addArrangedSubview(grayColumnView)
            } else {
                let colorCounts = Dictionary(colors.map { ($0, 1) }, uniquingKeysWith: +)
                let columnView = createColumn(colorCounts: colorCounts, total: total)
                chartStackView.addArrangedSubview(columnView)
            }

            let labelContainer = UIView()
            labelContainer.translatesAutoresizingMaskIntoConstraints = false

            let label = UILabel()
            label.text = "\(category)"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 12)
            label.textAlignment = .center
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            labelContainer.addSubview(label)

            let column = UILabel()
            column.text = "\(total)"
            column.textColor = .white
            column.font = UIFont.systemFont(ofSize: 10)
            column.textAlignment = .center
            column.numberOfLines = 0
            column.translatesAutoresizingMaskIntoConstraints = false
            labelContainer.addSubview(column)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: labelContainer.topAnchor),
                label.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor),

                column.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
                column.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor),
                column.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor),
                column.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor)
            ])

            labelsStackView.addArrangedSubview(labelContainer)
        }
    }
    
    private func extractHour(from dateString: String) -> Int {
        let components = dateString.split(separator: ":")
        if let hour = Int(components[0]) {
            return hour
        }
        return 0
    }
    
    private func getCategory(for hour: Int) -> String {
        switch hour {
        case 0..<8: return "Раннее\nутро"
        case 8..<12: return "Утро"
        case 12..<18: return "День"
        case 18..<22: return "Вечер"
        case 22..<24: return "Поздний\nвечер"
        default: return "Поздний\nвечер"
        }
    }
    
    private func createColumn(colorCounts: [UIColor: Int], total: Int) -> UIView {
        let columnView = UIView()
        columnView.backgroundColor = .black
        columnView.layer.cornerRadius = 10
        columnView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            columnView.widthAnchor.constraint(equalToConstant: 66),
            columnView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.3)
        ])

        let columnStack = UIStackView()
        columnStack.axis = .vertical
        columnStack.alignment = .fill
        columnStack.distribution = .fill
        columnStack.spacing = 2
        columnStack.translatesAutoresizingMaskIntoConstraints = false
        columnView.addSubview(columnStack)

        NSLayoutConstraint.activate([
            columnStack.leadingAnchor.constraint(equalTo: columnView.leadingAnchor),
            columnStack.trailingAnchor.constraint(equalTo: columnView.trailingAnchor),
            columnStack.bottomAnchor.constraint(equalTo: columnView.bottomAnchor),
            columnStack.topAnchor.constraint(equalTo: columnView.topAnchor)
        ])

        for (color, count) in colorCounts {
            let height = CGFloat(UIScreen.main.bounds.width / 1.3) * CGFloat(count) / CGFloat(max(1, total))
            let colorView = EmotionChartView(frame: .zero, textColor: color, text: "\(Int(Float(count) / Float(max(1, total)) * 100))%", height:  UIScreen.main.bounds.width / 1.3)
            colorView.layer.cornerRadius = 8
            columnStack.addArrangedSubview(colorView)
            colorView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        return columnView
    }
    
    private func createDefaultGrayColumn() -> UIView {
        let columnView = UIView()
        columnView.backgroundColor = .llgrayButton
        columnView.layer.cornerRadius = 10
        columnView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            columnView.widthAnchor.constraint(equalToConstant: 66),
            columnView.heightAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width / 1.3)
        ])

        return columnView
    }
}


