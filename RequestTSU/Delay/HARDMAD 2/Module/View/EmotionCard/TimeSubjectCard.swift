//
//  EmotionCard.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 25.02.2025.
//

import UIKit
/*
class TimeCardView: UIView {
    var SuccessLabel: UILabel
    var subjectLabel: UILabel
    var timeInterval: UILabel
    var timeLabel: UILabel
    var dateLabel: UILabel
    private var contentView: UIView
    private var gradientLayer: CAGradientLayer?

    init(frame: CGRect, subject: String, time: String, date: String, text: String) {
        self.SuccessLabel = UILabel()
        self.dateLabel = UILabel()
        self.contentView = UIView()
        super.init(frame: frame)
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        setupButton(buttonColor: .lorange, text: text)
    }

    required init?(coder: NSCoder) {
        self.SuccessLabel = UILabel()
        self.dateLabel = UILabel()
        self.contentView = UIView()
        super.init(coder: coder)
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        setupButton(buttonColor: .gray, text: "Default Text")
    }

    private func setupButton(buttonColor: UIColor, text: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lStaticB
        
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let calendar = Calendar.current
        
        var dateString = ""
        if calendar.isDateInToday(currentDate) {
            dateString = "cегодня, \(dateFormatter.string(from: currentDate))"
        } else if calendar.isDateInYesterday(currentDate) {
            dateString = "вчера, \(dateFormatter.string(from: currentDate))"
        } else {
            dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
            dateString = dateFormatter.string(from: currentDate)
        }
        
        dateLabel.text = dateString
        dateLabel.textColor = .white
        dateLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: UIScreen.main.bounds.width / 25)
        
        let feelingLabel = UILabel()
        feelingLabel.text = "я чувствую"
        feelingLabel.textColor = .white
        feelingLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: UIScreen.main.bounds.width / 20)
        
        var imageName = ""
        if buttonColor == .lblue {
            imageName = "SSad"
        }
        else if buttonColor == .lred {
            imageName = "SFlower"
        }
        else if buttonColor == .lorange {
            imageName = "SLight"
        }
        else if buttonColor == .lgreen {
            imageName = "SMithosis"
        }
        
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        contentView.addSubview(feelingLabel)
        contentView.addSubview(SuccessLabel)
        contentView.addSubview(imageView)
        
        addSubview(dateLabel)

        SuccessLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        feelingLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        SuccessLabel.numberOfLines = 0
        SuccessLabel.lineBreakMode = .byWordWrapping
        SuccessLabel.textColor = buttonColor
        SuccessLabel.font = UIFont(name: "Gwen-Trial-Bold", size: UIScreen.main.bounds.width / 15)
        SuccessLabel.text = text

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            feelingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            feelingLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor, constant: -16),
            feelingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            feelingLabel.heightAnchor.constraint(equalToConstant: 20),
            
            SuccessLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            SuccessLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor, constant: -16),
            SuccessLabel.topAnchor.constraint(equalTo: feelingLabel.bottomAnchor, constant: 8),
            SuccessLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])

        setupGradientBackground(color: buttonColor)
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

    func updateButton(buttonColor: UIColor, text: String) {
        SuccessLabel.text = text
        dateLabel.text = text
        setupGradientBackground(color: buttonColor)
    }
}
*/
