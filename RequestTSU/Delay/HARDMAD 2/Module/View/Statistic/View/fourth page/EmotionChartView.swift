//
//  EmotionChartView.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 05.03.2025.
//
import UIKit

class EmotionChartView: UIView {
    var emotionLabel: UILabel
    var height: CGFloat
    private var contentView: UIView
    private var gradientLayer: CAGradientLayer?

    init(frame: CGRect, textColor: UIColor, text: String, height: CGFloat) {
        self.emotionLabel = UILabel()
        self.contentView = UIView()
        self.height = height
        super.init(frame: frame)
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        setupButton(buttonColor: textColor, text: text, height: height)
    }

    required init?(coder: NSCoder) {
        self.emotionLabel = UILabel()
        self.contentView = UIView()
        self.height = 400
        super.init(coder: coder)
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        setupButton(buttonColor: .gray, text: "Default Text", height: 400)
    }

    private func setupButton(buttonColor: UIColor, text: String, height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lStaticB

        emotionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        emotionLabel.numberOfLines = 0
        emotionLabel.lineBreakMode = .byWordWrapping
        emotionLabel.textColor = .black
        emotionLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: UIScreen.main.bounds.width / 30)
        emotionLabel.text = text

        addSubview(contentView)
        contentView.addSubview(emotionLabel)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            emotionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emotionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emotionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 32),
            emotionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
            emotionLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16)
        ])

        setupGradientBackground(color: buttonColor)
    }

    private func setupGradientBackground(color: UIColor) {
        gradientLayer?.removeFromSuperlayer()

        let gradient = CAGradientLayer()
        switch color {
        case UIColor.lblue:
            gradient.colors = [
                UIColor.lblueLG.cgColor,
                UIColor.lblueG.cgColor
            ]
        case UIColor.lred:
            gradient.colors = [
                UIColor.lredLG.cgColor,
                UIColor.lredG.cgColor
            ]
        case UIColor.lorange:
            gradient.colors = [
                UIColor.lorangeLG.cgColor,
                UIColor.lorangeG.cgColor
            ]
        case UIColor.lgreen:
            gradient.colors = [
                UIColor.lgreenLG.cgColor,
                UIColor.lgreenG.cgColor
            ]
        default:
            gradient.colors = [
                UIColor.lgreenLG.cgColor,
                UIColor.lgreenG.cgColor
            ]
        }
        gradient.startPoint = CGPoint(x: 0.0, y: 0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1)
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
        emotionLabel.text = text
        setupGradientBackground(color: buttonColor)
    }
}
