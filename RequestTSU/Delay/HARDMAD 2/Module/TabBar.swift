//
//  TabBar.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 01.03.2025.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // Загружаем роли и настраиваем вкладки
        loadRolesAndSetupTabs()
        
        let appearance = UITabBarAppearance()
                
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lGrayTab,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)
        ]

        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)
        ]
        appearance.backgroundColor = .llgrayButton
        
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        self.tabBar.tintColor = .lGrayTab
    }
    
    private func loadRolesAndSetupTabs() {
        ProfileService.shared.fetchRoles { [weak self] (result: Result<Role, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let roles):
                    // Настраиваем вкладки в зависимости от ролей
                    self?.setupTabs(with: roles)
                case .failure(let error):
                    print("Ошибка загрузки ролей: \(error.localizedDescription)")
                    // По умолчанию показываем только две вкладки
                    self?.setupTabs(with: nil)
                }
            }
        }
    }
    
    private func setupTabs(with roles: Role?) {
        let journal = self.createNav(with: "Журнал", and: UIImage(named: "Notebook"), vc: JournalController())
        let settings = self.createNav(with: "Настройки", and: UIImage(named: "Settings"), vc: SettingViewController())
        
        // Проверяем, есть ли у пользователя роль Admin или Dean
        if let roles = roles, (roles.isAdmin || roles.isDean) {
            let statistics = self.createNav(with: "Статистика", and: UIImage(named: "Data Area"), vc: StatisticsViewController())
            self.setViewControllers([journal, statistics, settings], animated: true)
        } else {
            // Если роли Admin или Dean отсутствуют, показываем только две вкладки
            self.setViewControllers([journal, settings], animated: true)
        }
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image?.withRenderingMode(.alwaysOriginal)
        nav.tabBarItem.selectedImage = image?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        nav.navigationBar.isHidden = true
        
        return nav
    }
}
