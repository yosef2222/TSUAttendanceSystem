//
//  RegLoginButton.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 06.03.2025.
//

import UIKit

class RegButtons: UIView {
    
    let registrationButton = UIButton(type: .system)
    let StudentButton = UIButton(type: .system)
    
    let nameField = UITextField()
    let emailField = UITextField()
    let passwordField = UITextField()
    let groupField = UITextField()
    
    var isStudent: Bool = false {
        didSet {
            updateGroupFieldState() // Обновляем состояние groupField при изменении isStudent
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Настройка nameField
        nameField.attributedPlaceholder = NSAttributedString(
            string: "ФИО",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        nameField.font = UIFont.systemFont(ofSize: 16)
        nameField.delegate = self
        nameField.layer.cornerRadius = 15
        nameField.layer.masksToBounds = true
        nameField.tintColor = .black
        nameField.backgroundColor = .white
        nameField.textColor = .black
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.autocapitalizationType = .none
        nameField.autocorrectionType = .no
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        nameField.leftViewMode = .always
        addSubview(nameField)
        
        // Настройка emailField
        emailField.attributedPlaceholder = NSAttributedString(
            string: "email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        emailField.font = UIFont.systemFont(ofSize: 16)
        emailField.delegate = self
        emailField.layer.cornerRadius = 15
        emailField.layer.masksToBounds = true
        emailField.tintColor = .black
        emailField.backgroundColor = .white
        emailField.textColor = .black
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.keyboardType = .emailAddress
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        emailField.leftViewMode = .always
        addSubview(emailField)
        
        // Настройка passwordField
        passwordField.attributedPlaceholder = NSAttributedString(
            string: "пароль",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        passwordField.font = UIFont.systemFont(ofSize: 16)
        passwordField.delegate = self
        passwordField.layer.cornerRadius = 15
        passwordField.layer.masksToBounds = true
        passwordField.tintColor = .black
        passwordField.backgroundColor = .white
        passwordField.textColor = .black
        passwordField.isSecureTextEntry = true
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        passwordField.leftViewMode = .always
        addSubview(passwordField)
        
        // Настройка groupField
        groupField.attributedPlaceholder = NSAttributedString(
            string: "Номер группы",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        groupField.font = UIFont.systemFont(ofSize: 16)
        groupField.delegate = self
        groupField.layer.cornerRadius = 15
        groupField.layer.masksToBounds = true
        groupField.tintColor = .black
        groupField.backgroundColor = .white
        groupField.textColor = .black
        groupField.isSecureTextEntry = false
        groupField.translatesAutoresizingMaskIntoConstraints = false
        groupField.autocapitalizationType = .none
        groupField.autocorrectionType = .no
        groupField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        groupField.leftViewMode = .always
        addSubview(groupField)
        
        updateGroupFieldState()
        
        StudentButton.setTitle("Я студент", for: .normal)
        StudentButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        StudentButton.contentHorizontalAlignment = .center
        StudentButton.tintColor = .black
        StudentButton.backgroundColor = .white
        StudentButton.layer.cornerRadius = 35
        StudentButton.clipsToBounds = true
        StudentButton.layer.zPosition = 1
        StudentButton.translatesAutoresizingMaskIntoConstraints = false
        StudentButton.addTarget(self, action: #selector(studentButtonTapped), for: .touchUpInside)
        addSubview(StudentButton)
        
        registrationButton.setTitle("Зарегистрироваться", for: .normal)
        registrationButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        registrationButton.contentHorizontalAlignment = .center
        registrationButton.tintColor = .black
        registrationButton.backgroundColor = .white
        registrationButton.layer.cornerRadius = 35
        registrationButton.clipsToBounds = true
        registrationButton.layer.zPosition = 1
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(registrationButton)
        
        // Констрейнты
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            nameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nameField.heightAnchor.constraint(equalToConstant: 50),
            
            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
            emailField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            groupField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16),
            groupField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            groupField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            groupField.heightAnchor.constraint(equalToConstant: 50),
            
            StudentButton.topAnchor.constraint(equalTo: groupField.bottomAnchor, constant: 24),
            StudentButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            StudentButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            StudentButton.heightAnchor.constraint(equalToConstant: 70),
            
            registrationButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 180),
            registrationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            registrationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            registrationButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    @objc private func studentButtonTapped() {
        isStudent.toggle() // Меняем состояние isStudent
        updateStudentButtonAppearance() // Обновляем внешний вид кнопки
        updateGroupFieldState() // Обновляем состояние groupField
    }
    
    // Обновление внешнего вида кнопки "Я студент"
    private func updateStudentButtonAppearance() {
        UIView.animate(withDuration: 0.3) {
            if self.isStudent {
                self.StudentButton.backgroundColor = .lightGray
                self.StudentButton.setTitleColor(.white, for: .normal)
            } else {
                self.StudentButton.backgroundColor = .white
                self.StudentButton.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    // Обновление состояния groupField
    private func updateGroupFieldState() {
        groupField.isUserInteractionEnabled = isStudent // Включаем или отключаем взаимодействие
        groupField.alpha = isStudent ? 1.0 : 0.5 // Меняем прозрачность для визуального отключения
    }
}

extension RegButtons: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
