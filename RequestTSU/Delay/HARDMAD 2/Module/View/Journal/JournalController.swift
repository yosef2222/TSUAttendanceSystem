//
//  File.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 21.02.2025.
//
import UIKit
import Alamofire
import JWTDecode

class JournalController: UIViewController {
    var emotionColor: UIColor
    var emotionText: String
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let requestCardsView = RequestCardsView()
    
    private var emotionCards: [RequestCardView] = []
    private var emotionColors: [UIColor] = []
    private var emotionTexts: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    init(emotionColor: UIColor = .clear, emotionText: String = "") {
        self.emotionColor = emotionColor
        self.emotionText = emotionText
        if emotionColor != .clear {
            emotionColors.append(emotionColor)
        }
        if !emotionText.isEmpty {
            emotionTexts.append(emotionText)
        }
        if !emotionText.isEmpty && emotionColor != .clear {
            emotionCards.append(RequestCardView(frame: .zero, startDate: "2020", endDate: "2020", startTime: "12:00", endTime: "13:00", reason: "Sample Reason", status: "Pending"))
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        setupUI()
        fetchAbsences()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let label = UILabel()
        label.text = "Вы пропускаете\nзанятие?"
        label.textColor = .white
        label.font = UIFont(name: "VelaSansGX-ExtraLight_Bold", size: 36)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        let plusButton = PlusButtonView()
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(plusButton)
        plusButton.layer.zPosition = 10
        
        requestCardsView.emotionCards = emotionCards
        requestCardsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(requestCardsView)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 72),
            
            plusButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            plusButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 235),
            plusButton.widthAnchor.constraint(equalToConstant: 132),
            plusButton.heightAnchor.constraint(equalToConstant: 97),
            
            requestCardsView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            requestCardsView.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 100),
            requestCardsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        if let button = plusButton.subviews.first(where: { $0 is UIButton }) as? UIButton {
            button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        }
    }
    
    @objc private func plusButtonTapped() {
        let notesController = NotesController()
        notesController.hidesBottomBarWhenPushed = true
        notesController.isModalInPresentation = true
        notesController.modalPresentationStyle = .fullScreen
        self.present(notesController, animated: false, completion: nil)
    }
    
    private func fetchAbsences() {
        guard let url = URL(string: "http://localhost:5163/api/Requests/my") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = getJWTToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let absences = try JSONDecoder().decode([Absence].self, from: data)
                DispatchQueue.main.async {
                    self.updateUI(with: absences)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    private func updateUI(with absences: [Absence]) {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        
        let dateFormatterDisplay = DateFormatter()
        dateFormatterDisplay.dateFormat = "dd.MM.yyyy"
        
        let timeFormatterDisplay = DateFormatter()
        timeFormatterDisplay.dateFormat = "HH:mm"
        
        for absence in absences {
            guard let startDate = dateFormatter.date(from: absence.absenceDateStart),
                  let endDate = dateFormatter.date(from: absence.absenceDateEnd) else {
                continue
            }
            
            let startDateString = dateFormatterDisplay.string(from: startDate)
            let endDateString = dateFormatterDisplay.string(from: endDate)
            
            let startTimeString = timeFormatterDisplay.string(from: startDate)
            let endTimeString = timeFormatterDisplay.string(from: endDate)
            
            let cardView = RequestCardView(
                frame: CGRect(x: 0, y: 0, width: 300, height: 200),
                startDate: startDateString,
                endDate: endDateString,
                startTime: startTimeString,
                endTime: endTimeString,
                reason: absence.reason,
                status: absence.status
            )
            
            requestCardsView.emotionCards.append(cardView)
        }
    }
}
