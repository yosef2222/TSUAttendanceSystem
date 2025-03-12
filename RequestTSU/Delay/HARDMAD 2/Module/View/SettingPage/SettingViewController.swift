//
//  SettingViewController.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 01.03.2025.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        view.backgroundColor = .black
        
        // Заголовок "Настройки"
        let textLabel = UILabel()
        textLabel.text = "Настройки"
        textLabel.textColor = .white
        textLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: 36)
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        // NameView
        let nameView = NameView()
        nameView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameView)

        // Кнопка выхода
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .red
        logoutButton.layer.cornerRadius = 10
        logoutButton.titleLabel?.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: 18)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)

        // Констрейнты
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        
            nameView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 15),
            nameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // Обработка нажатия на кнопку выхода
    @objc private func logoutButtonTapped() {
        // Удаляем токен из локального хранилища
        TokenManager.shared.deleteToken()
        
        // Переход на экран регистрации
        navigateToRegistrationScreen()
    }

    // Переход на экран регистрации
    private func navigateToRegistrationScreen() {
        TokenManager.shared.deleteToken()
        let registrationViewController = RegisterController() // Замените на ваш экран регистрации
        let navigationController = UINavigationController(rootViewController: registrationViewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        // Анимация перехода
        UIView.transition(with: UIApplication.shared.windows.first!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            UIApplication.shared.windows.first?.rootViewController = navigationController
        }, completion: nil)
    }
}
