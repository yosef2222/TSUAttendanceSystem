//
//  NotificationsView.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 02.03.2025.
//

import UIKit
/*
class SettingAllView: UIView {
    
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
        
        let notificSwitch = TextSwitchView(frame: .zero, textUI: "Присылать напоминания", iconName: "Alert On")
        notificSwitch.translatesAutoresizingMaskIntoConstraints = false
        addSubview(notificSwitch)
        
        let notific = NotificationButtonView(frame: .zero, buttonColor: .lGrayCircle, text: "12:00")
        notific.translatesAutoresizingMaskIntoConstraints = false
        addSubview(notific)
        
        let notificButton = AddNotificationView()
        notificButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(notificButton)
        
        var iphoneversionText: String
        var iphoneversionImage: String
        switch isiPhoneWithNotch(){
        case true:
            iphoneversionText = "Вход по FaceID"
            iphoneversionImage = "FaceID"
        case false:
            iphoneversionText = "Вход по отпечатку пальца"
            iphoneversionImage = "Fingerprint"
        }
        let FaceIdSwitch = TextSwitchView(frame: .zero, textUI: iphoneversionText, iconName: iphoneversionImage)
        FaceIdSwitch.translatesAutoresizingMaskIntoConstraints = false
        addSubview(FaceIdSwitch)
        
        NSLayoutConstraint.activate([
            notificSwitch.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            notificSwitch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            notificSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            notificSwitch.heightAnchor.constraint(equalToConstant: 60),
            
            notific.topAnchor.constraint(equalTo: notificSwitch.bottomAnchor, constant: 8),
            notific.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            notific.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            notific.heightAnchor.constraint(equalToConstant: 64),
            
            notificButton.topAnchor.constraint(equalTo: notific.bottomAnchor, constant: 16),
            notificButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            notificButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            notificButton.heightAnchor.constraint(equalToConstant: 56),
            
            FaceIdSwitch.topAnchor.constraint(equalTo: notificButton.bottomAnchor, constant: 8),
            FaceIdSwitch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            FaceIdSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            FaceIdSwitch.heightAnchor.constraint(equalToConstant: 60),
            FaceIdSwitch.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }
}


func isiPhoneWithNotch() -> Bool {
    if UIDevice.current.userInterfaceIdiom == .phone {
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        return keyWindow?.safeAreaInsets.top ?? 0 > 20
    }
    return false
}
*/
