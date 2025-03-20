//
//  Pick2VariantButton.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 06.03.2025.
//

import UIKit

class Pick2VariantButton: UIView {
    let label = UILabel()
    let buttonDay = UIButton()
    let buttonDays = UIButton()
    
    var dayBool: Bool = true {
        didSet {
            updateButtonColors() // Обновляем цвета при изменении dayBool
            onDayBoolChanged?(dayBool) // Вызываем замыкание при изменении dayBool
        }
    }
    
    // Замыкание для обработки изменения dayBool
    var onDayBoolChanged: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = 10
        
        label.text = "На сколько пропускаете?"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        buttonDay.setTitle("Один день", for: .normal)
        buttonDay.layer.cornerRadius = 20
        buttonDay.translatesAutoresizingMaskIntoConstraints = false
        buttonDay.addTarget(self, action: #selector(buttonDayTapped), for: .touchUpInside)
        
        buttonDays.setTitle("Несколько дней", for: .normal)
        buttonDays.layer.cornerRadius = 20
        buttonDays.translatesAutoresizingMaskIntoConstraints = false
        buttonDays.addTarget(self, action: #selector(buttonDaysTapped), for: .touchUpInside)
        
        addSubview(label)
        addSubview(buttonDay)
        addSubview(buttonDays)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            buttonDay.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            buttonDay.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonDay.widthAnchor.constraint(equalToConstant: 120),
            buttonDay.heightAnchor.constraint(equalToConstant: 40),
            
            buttonDays.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            buttonDays.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonDays.widthAnchor.constraint(equalToConstant: 180),
            buttonDays.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        updateButtonColors() // Устанавливаем начальные цвета
    }
    
    private func updateButtonColors() {
        // Убедимся, что обновление происходит на главном потоке
        DispatchQueue.main.async {
            if self.dayBool {
                self.buttonDays.backgroundColor = .lStaticB
                self.buttonDays.setTitleColor(.white, for: .normal)
                self.buttonDay.backgroundColor = .lGrayTab
                self.buttonDay.setTitleColor(.white, for: .normal)
            } else {
                self.buttonDay.backgroundColor = .lStaticB
                self.buttonDay.setTitleColor(.white, for: .normal)
                self.buttonDays.backgroundColor = .lGrayTab
                self.buttonDays.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    @objc func buttonDaysTapped() {
        dayBool = false
        print("buttonDaysTapped: dayBool = \(dayBool)") // Отладочный вывод
    }
    
    @objc func buttonDayTapped() {
        dayBool = true
        print("buttonDayTapped: dayBool = \(dayBool)") // Отладочный вывод
    }
}
