//
//  StatisticsViewController.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 03.03.2025.
//


import UIKit

func fetchApprovedRequests(completion: @escaping ([ApprovedRequest]?) -> Void) {
    guard let url = URL(string: "http://localhost:5163/api/Requests/approved") else {
        completion(nil)
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    if let token = getJWTToken() {
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }
        
        do {
            let approvedRequests = try JSONDecoder().decode([ApprovedRequest].self, from: data)
            completion(approvedRequests)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }.resume()
}


import UIKit

class StaticViewController: UIViewController {

    private var colors: [(color: UIColor, percentage: CGFloat)] = []
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let acceptedCardsView = AcceptedCardsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupLayout()
        fetchApprovedRequests()
    }

    private func setupLayout() {
        let textLabel = UILabel()
        textLabel.text = "Принятые заявки"
        textLabel.textColor = .white
        textLabel.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: 48)
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        acceptedCardsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(acceptedCardsView)
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            acceptedCardsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            acceptedCardsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            acceptedCardsView.topAnchor.constraint(equalTo: contentView.topAnchor),
            acceptedCardsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func fetchApprovedRequests() {
        HARDMAD_2.fetchApprovedRequests { [weak self] approvedRequests in
            guard let approvedRequests = approvedRequests else { return }
            DispatchQueue.main.async {
                self?.updateUI(with: approvedRequests)
            }
        }
    }
    
    private func updateUI(with approvedRequests: [ApprovedRequest]) {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        
        let dateFormatterDisplay = DateFormatter()
        dateFormatterDisplay.dateFormat = "dd.MM.yyyy"
        
        let timeFormatterDisplay = DateFormatter()
        timeFormatterDisplay.dateFormat = "HH:mm"
        
        for request in approvedRequests {
            guard let startDate = dateFormatter.date(from: request.absenceDateStart),
                  let endDate = dateFormatter.date(from: request.absenceDateEnd) else {
                continue
            }
            
            let startDateString = dateFormatterDisplay.string(from: startDate)
            let endDateString = dateFormatterDisplay.string(from: endDate)
            
            let startTimeString = timeFormatterDisplay.string(from: startDate)
            let endTimeString = timeFormatterDisplay.string(from: endDate)
            
            let cardView = AcceptedCardView(
                frame: CGRect(x: 0, y: 0, width: 300, height: 200),
                startDate: startDateString,
                endDate: endDateString,
                startTime: startTimeString,
                endTime: endTimeString,
                reason: request.reason,
                status: request.status,
                name: request.studentFullName
            )
            
            acceptedCardsView.emotionCards.append(cardView)
        }
    }
}
