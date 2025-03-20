//
//  RegisterView.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 21.02.2025.
//

import UIKit

class RegisterController: UIViewController {
    let TextLabel = UILabel()
    let registrationButton = UIButton(type: .system)
    let loginButton = UIButton(type: .system)
    
    var PresentRegisterButtons: Bool = false
    var PresentLoginButtons: Bool = false
    
    let RegView = RegButtons()
    let LoginView = LoginButtons()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Настройка TextLabel
        TextLabel.text = "Добро\nПожаловать"
        TextLabel.textColor = .black
        TextLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Bold", size: 48)
        TextLabel.numberOfLines = 0
        TextLabel.lineBreakMode = .byWordWrapping
        TextLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(TextLabel)
        TextLabel.layer.zPosition = 1

        NSLayoutConstraint.activate([
            TextLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            TextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 76)
        ])
        
        registrationButton.setTitle("Зарегистрироваться", for: .normal)
        registrationButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        registrationButton.contentHorizontalAlignment = .center
        registrationButton.tintColor = .black
        registrationButton.backgroundColor = .white
        registrationButton.layer.cornerRadius = 35
        registrationButton.clipsToBounds = true
        registrationButton.addTarget(self, action: #selector(RegisterButtonTaped), for: .touchUpInside)
        registrationButton.layer.zPosition = 1
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.setTitle("Войти", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        loginButton.contentHorizontalAlignment = .center
        loginButton.tintColor = .black
        loginButton.backgroundColor = .white
        loginButton.layer.cornerRadius = 35
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(LoginButtonTaped), for: .touchUpInside)
        loginButton.layer.zPosition = 1
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(registrationButton)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            registrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            registrationButton.widthAnchor.constraint(equalToConstant: 364),
            registrationButton.heightAnchor.constraint(equalToConstant: 70),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            loginButton.widthAnchor.constraint(equalToConstant: 364),
            loginButton.heightAnchor.constraint(equalToConstant: 70)
        ])

        RegView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(RegView)
        RegView.isHidden = true
        
        LoginView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(LoginView)
        LoginView.isHidden = true
        
        
        if let button = LoginView.subviews.first(where: { $0 is UIButton }) as? UIButton {
            button.addTarget(self, action: #selector(LoginToDbButtonTaped), for: .touchUpInside)
        }
        
        if let button = RegView.subviews.first(where: { $0 is UIButton && ($0 as! UIButton).titleLabel?.text == "Зарегистрироваться" }) as? UIButton {
            button.addTarget(self, action: #selector(RegisterToDbButtonTaped), for: .touchUpInside)
        }
        
        
        NSLayoutConstraint.activate([
            RegView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            RegView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            RegView.widthAnchor.constraint(equalToConstant: 364),
            RegView.heightAnchor.constraint(equalToConstant: 700),
            
            LoginView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            LoginView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            LoginView.widthAnchor.constraint(equalToConstant: 364),
            LoginView.heightAnchor.constraint(equalToConstant: 700),
        ])

        let gradientView = AnimatedGradientView(frame: view.bounds)
        view.addSubview(gradientView)
        view.sendSubviewToBack(gradientView)
    }
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func LoginButtonTaped() {
        PresentLoginButtons = true
        UIView.animate(withDuration: 0.3, animations: {
            self.TextLabel.alpha = 0
            self.loginButton.isHidden = true
            self.RegView.isHidden = true
            self.registrationButton.isHidden = true
        }, completion: { _ in
            self.TextLabel.text = "Вход"
            self.LoginView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.TextLabel.alpha = 1
            }
        })
    }
    
    @objc func RegisterButtonTaped() {
        PresentRegisterButtons = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.TextLabel.alpha = 0
            self.loginButton.isHidden = true
            self.registrationButton.isHidden = true
        }, completion: { _ in
            self.TextLabel.text = "Регистрация"
            self.RegView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.TextLabel.alpha = 1
            }
        })
    }
    
    @objc func RegisterToDbButtonTaped() {
        guard let name = RegView.nameField.text, !name.isEmpty else {
            showAlert(title: "Ошибка", message: "Введите ФИО")
            return
        }
        
        guard let email = RegView.emailField.text, !email.isEmpty else {
            showAlert(title: "Ошибка", message: "Введите email")
            return
        }
        
        guard let password = RegView.passwordField.text, !password.isEmpty else {
            showAlert(title: "Ошибка", message: "Введите пароль")
            return
        }
        
        if RegView.isStudent, let groupNumber = RegView.groupField.text, groupNumber.isEmpty {
            showAlert(title: "Ошибка", message: "Введите номер группы")
            return
        }
        
        let isStudent = RegView.isStudent
        let groupNumber = isStudent ? RegView.groupField.text : nil
        print("group -" + groupNumber!)
        let user = UserDto(
            fullName: name,
            birthday: "2000-01-01",
            email: email,
            password: password,
            groupNumber: groupNumber == nil ? "none" : groupNumber,
            isStudent: isStudent
        )
        
        AuthService.shared.register(user: user) { result in
            switch result {
            case .success(let authResponse):
                TokenManager.shared.saveToken(authResponse.token)
                
                DispatchQueue.main.async {
                    let tabBarController = TabBarController()
                    tabBarController.modalPresentationStyle = .fullScreen
                    self.present(tabBarController, animated: true, completion: nil)
                }
            case .failure(let error):
                self.showAlert(title: "Ошибка", message: "Ошибка регистрации: \(error.localizedDescription)")
            }
        }
    }

    @objc func LoginToDbButtonTaped() {
        guard let email = LoginView.emailField.text, !email.isEmpty,
              let password = LoginView.passwordField.text, !password.isEmpty else {
            print("Заполните все поля")
            return
        }
        
        let credentials = LoginDto(email: email, password: password)
        
        AuthService.shared.login(credentials: credentials) { result in
            switch result {
            case .success(let authResponse):
                // Сохраняем токен
                TokenManager.shared.saveToken(authResponse.token)
                
                // Переход на TabBarController
                DispatchQueue.main.async {
                    let tabBarController = TabBarController()
                    tabBarController.modalPresentationStyle = .fullScreen
                    self.present(tabBarController, animated: true, completion: nil)
                }
            case .failure(let error):
                print("Ошибка входа: \(error)")
            }
        }
    }
}
