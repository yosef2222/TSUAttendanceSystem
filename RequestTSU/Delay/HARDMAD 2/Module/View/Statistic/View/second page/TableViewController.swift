//
//  TableViewController.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 03.03.2025.
//



import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView()
    private var data: [(dayOfWeek: String, dayOfMonth: String, states: [String], icons: [UIImage])] = []
    private let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        generateData()
        setupTitleLabel()
        setupTableView()
    }

    private func generateData() {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")

        let shortMonths = dateFormatter.standaloneMonthSymbols.map { month -> String in
            let trimmed = month.prefix(3)
            return trimmed.trimmingCharacters(in: .whitespaces)
        }

        let today = Date()

        for dayOffset in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: today) {
                dateFormatter.dateFormat = "EEEE"
                let dayOfWeek = dateFormatter.string(from: date)

                let components = calendar.dateComponents([.day, .month], from: date)
                if let day = components.day, let monthIndex = components.month {
                    let shortMonth = shortMonths[monthIndex - 1]
                    let dayOfMonth = "\(day) \(shortMonth)"
                    let states = getStates(for: dayOffset) 
                    let icons = getIcons(for: dayOffset)
                    data.append((dayOfWeek: dayOfWeek, dayOfMonth: dayOfMonth, states: states, icons: icons))
                }
            }
        }
    }

    private func getStates(for dayOffset: Int) -> [String] {
        switch dayOffset {
        case 0:
            return emotionTexts
        case 1:
            return []
        default:
            return []
        }
    }
    
    private func getIcons(for dayOffset: Int) -> [UIImage] {
        switch dayOffset {
        case 0:
            if emotionIcons.count == 0 {
                return [UIImage(named: "Ellipse")!]
            }
            return emotionIcons
        default:
            return [UIImage(named: "Ellipse")!]
        }
    }

    private func setupTitleLabel() {
        titleLabel.text = "Эмоции\nпо дням недели"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "Gwen-Trial-Bold", size: UIScreen.main.bounds.width / 10)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.separatorColor = .gray
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let (dayOfWeek, dayOfMonth, states, icons) = data[indexPath.row]

        cell.dayLabel.text = dayOfWeek
        cell.dateLabel.text = dayOfMonth
        cell.stateLabel.text = states.joined(separator: "\n")
        cell.configure(with: icons)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}


func getIcon(with colr: UIColor) -> UIImage{
    switch colr {
    case .lred:
        return (UIImage(named: "SFlower")!)
    case .lorange:
        return(UIImage(named: "SLight")!)
    case .lblue:
        return (UIImage(named: "SSad")!)
    case .lgreen:
        return (UIImage(named: "SMithosis")!)
    default:
        return(UIImage(named: "SMithosis")!)
    }
}
