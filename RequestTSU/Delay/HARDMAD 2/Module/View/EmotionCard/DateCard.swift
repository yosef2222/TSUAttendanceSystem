//
//  EmotionCard.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 25.02.2025.
//

import UIKit

class EmotionCardView: UIView {
    var SuccessLabel: UILabel
    var dateLabel: UILabel
    var timeLabel: UILabel
    var statusLabel: UILabel
    private var contentView: UIView
    private var gradientLayer: CAGradientLayer?

    init(frame: CGRect, startDate: String, endDate: String, startTime: String, endTime: String) {
        self.SuccessLabel = UILabel()
        self.dateLabel = UILabel()
        self.timeLabel = UILabel()
        self.statusLabel = UILabel()
        self.contentView = UIView()
        super.init(frame: frame)
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        setupView(startDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime)
    }

    required init?(coder: NSCoder) {
        self.SuccessLabel = UILabel()
        self.dateLabel = UILabel()
        self.timeLabel = UILabel()
        self.statusLabel = UILabel()
        self.contentView = UIView()
        super.init(coder: coder)
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        setupView(startDate: "01.01.2000", endDate: "01.01.2000", startTime: "12:00", endTime: "14:00") // Значения по умолчанию
    }

    private func setupView(startDate: String, endDate: String, startTime: String, endTime: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lStaticB
        
        // Настройка dateLabel и timeLabel
        if startDate == endDate {
            // Если даты равны, отображаем одну дату справа
            dateLabel.text = startDate
            dateLabel.textAlignment = .right
            timeLabel.text = "\(startTime) - \(endTime)" // Формат времени
        } else {
            // Если даты разные, отображаем интервал дат слева
            dateLabel.text = "\(startDate) - \(endDate)" // Формат "{StartDate} - {EndDate}"
            dateLabel.textAlignment = .left
            timeLabel.text = "\(startTime) - \(endTime)" // Формат времени
        }
        
        dateLabel.textColor = .white
        dateLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: UIScreen.main.bounds.width / 25)
        
        timeLabel.textColor = .white
        timeLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: UIScreen.main.bounds.width / 25)
        
        // Настройка statusLabel
        statusLabel.text = "Не принято" // Текст "Не принято"
        statusLabel.textColor = .white
        statusLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: UIScreen.main.bounds.width / 20)
        
        // Настройка SuccessLabel
        SuccessLabel.text = "Ваш пропуск" // Текст по умолчанию
        SuccessLabel.textColor = .white
        SuccessLabel.font = UIFont(name: "Gwen-Trial-Bold", size: UIScreen.main.bounds.width / 15)
        SuccessLabel.numberOfLines = 0
        SuccessLabel.lineBreakMode = .byWordWrapping
        
        // Настройка contentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        // Добавление элементов в contentView
        contentView.addSubview(dateLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(SuccessLabel)
        
        // Констрейнты
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            timeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            statusLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            statusLabel.heightAnchor.constraint(equalToConstant: 20),
            
            SuccessLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            SuccessLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            SuccessLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            SuccessLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])

        // Настройка желтого градиента
        setupGradientBackground(color: .yellow)
    }

    private func setupGradientBackground(color: UIColor) {
        gradientLayer?.removeFromSuperlayer()

        let gradient = CAGradientLayer()
        gradient.colors = [
            color.withAlphaComponent(0.3).cgColor,
            color.withAlphaComponent(0.2).cgColor,
            color.withAlphaComponent(0.1).cgColor,
            color.withAlphaComponent(0.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.frame = self.bounds
        gradient.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = self.bounds
    }

    func updateView(startDate: String, endDate: String, startTime: String, endTime: String) {
        if startDate == endDate {
            dateLabel.text = startDate
            dateLabel.textAlignment = .right
        } else {
            dateLabel.text = "\(startDate) - \(endDate)"
            dateLabel.textAlignment = .left
        }
        timeLabel.text = "\(startTime) - \(endTime)"
        setupGradientBackground(color: .yellow)
    }
}
/*

func updateUI(with requests: [Request]) {
    for request in requests {
        // Преобразуем даты и время
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        
        guard let startDate = dateFormatter.date(from: request.absenceDateStart),
              let endDate = dateFormatter.date(from: request.absenceDateEnd) else {
            continue
        }
        
        let dateFormatterDisplay = DateFormatter()
        dateFormatterDisplay.dateFormat = "dd.MM.yyyy"
        let startDateString = dateFormatterDisplay.string(from: startDate)
        let endDateString = dateFormatterDisplay.string(from: endDate)
        
        dateFormatterDisplay.dateFormat = "HH:mm"
        let startTimeString = dateFormatterDisplay.string(from: startDate)
        let endTimeString = dateFormatterDisplay.string(from: endDate)
        
        // Создаем EmotionCardView
        let cardView = EmotionCardView(
            frame: CGRect(x: 0, y: 0, width: 300, height: 200),
            startDate: startDateString,
            endDate: endDateString,
            startTime: startTimeString,
            endTime: endTimeString
        )
        
        // Обновляем статус
        cardView.statusLabel.text = request.status
        
    }
}
*/
