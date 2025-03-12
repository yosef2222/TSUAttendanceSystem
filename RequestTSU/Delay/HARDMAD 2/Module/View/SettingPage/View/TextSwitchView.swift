//
//  TextSwitchView.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 03.03.2025.
//


import UIKit

class TextSwitchView: UIView {
    
    let textUI: String
    let iconName: String
    
    let IconImage: UIImageView
    let textLabel: UILabel
    
    private var textGradientLayer: CAGradientLayer?
    private var textMaskLayer: CATextLayer?

    var onTimeSelected: ((String) -> Void)?

    init(frame: CGRect, textUI: String, iconName: String) {
        self.textUI = textUI
        self.iconName = iconName
        self.IconImage = UIImageView()
        self.textLabel = UILabel()
        
        super.init(frame: frame)
        
        self.layer.cornerRadius = 32
        self.clipsToBounds = true
        setupView()
    }

    required init?(coder: NSCoder) {
        self.textUI = ""
        self.iconName = ""
        self.IconImage = UIImageView()
        self.textLabel = UILabel()
        
        super.init(coder: coder)
        
        self.layer.cornerRadius = 32
        self.clipsToBounds = true
        setupView()
    }

    private func setupView() {
        IconImage.image = UIImage(named: iconName)
        IconImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(IconImage)
        
        textLabel.text = textUI
        textLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: UIFont.labelFontSize * 0.85)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .white
        addSubview(textLabel)
        
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(switchButton)
        
        NSLayoutConstraint.activate([
            IconImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            IconImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            IconImage.widthAnchor.constraint(equalToConstant: 24),
            IconImage.heightAnchor.constraint(equalToConstant: 24),
            
            textLabel.leadingAnchor.constraint(equalTo: IconImage.trailingAnchor, constant: 4),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            switchButton.bottomAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 4),
            switchButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
    }
}
