//
//  NameView.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 02.03.2025.
//

import UIKit

class NameView: UIView {
    
    var profile: Profile? {
        didSet {
            updateUI()
        }
    }
    
    var roles: Role? {
        didSet {
            updateUI()
        }
    }
    
    private var nameLabel: UILabel!
    private var roleLabel: UILabel!
    private var avatarView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 10
        layer.borderWidth = 2
        
        nameLabel = UILabel()
        nameLabel.text = "Загрузка..."
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: 24)
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        roleLabel = UILabel()
        roleLabel.text = "Роль: Загрузка..."
        roleLabel.textColor = .lightGray
        roleLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: 16)
        roleLabel.textAlignment = .center
        roleLabel.adjustsFontSizeToFitWidth = true
        roleLabel.minimumScaleFactor = 0.5
        roleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        avatarView = UIImageView()
        avatarView.image = UIImage(named: "avatar")
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [avatarView, nameLabel, roleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        if UIScreen.main.bounds.width < 350 {
            nameLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: 18)
            roleLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: 14)
        } else {
            nameLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: 24)
            roleLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: 16)
        }
        
        // Загрузите данные профиля и роли
        loadProfile()
        loadRoles()
    }
    
    private func updateUI() {
        if let profile = profile {
            nameLabel.text = profile.fullName
        } else {
            nameLabel.text = "Нет ролей"
        }
        
        if let roles = roles {
            roleLabel.text = formatRoles(roles)
        } else {
            roleLabel.text = "Роль: Ошибка загрузки"
        }
    }
    
    private func formatRoles(_ roles: Role) -> String {
        var rolesString = "Роль: "
        var rolesArray = [String]()
        
        if roles.isStudent {
            rolesArray.append("Студент")
        }
        if roles.isTeacher {
            rolesArray.append("Учитель")
        }
        if roles.isAdmin {
            rolesArray.append("Админ")
        }
        if roles.isDean {
            rolesArray.append("Декан")
        }
        
        rolesString += rolesArray.joined(separator: ", ")
        return rolesString
    }
    
    private func loadProfile() {
        ProfileService.shared.fetchProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.profile = profile
                case .failure(let error):
                    print("Ошибка загрузки профиля: \(error.localizedDescription)")
                    self?.profile = nil
                }
            }
        }
    }
    
    private func loadRoles() {
        ProfileService.shared.fetchRoles { [weak self] (result: Result<Role, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let roles):
                    self?.roles = roles
                case .failure(let error):
                    print("Ошибка загрузки ролей: \(error.localizedDescription)")
                    self?.roles = nil
                }
            }
        }
    }
}
