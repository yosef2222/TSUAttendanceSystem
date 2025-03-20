//
//  RegLoginButton.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 06.03.2025.
//

import UIKit

class LoginButtons: UIView {
    
    let LoginButton = UIButton(type: .system)
    
    let emailField = UITextField()
    let passwordField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
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
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.translatesAutoresizingMaskIntoConstraints = false
        
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        emailField.leftViewMode = .always
        
        addSubview(emailField)
        
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
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        passwordField.leftViewMode = .always
        
        addSubview(passwordField)
        
        LoginButton.setTitle("Войти", for: .normal)
        LoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        LoginButton.contentHorizontalAlignment = .center
        LoginButton.tintColor = .black
        LoginButton.backgroundColor = .white
        LoginButton.layer.cornerRadius = 35
        LoginButton.clipsToBounds = true
        LoginButton.layer.zPosition = 1
        LoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(LoginButton)
        
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            LoginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 250),
            LoginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            LoginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            LoginButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}

extension LoginButtons: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
