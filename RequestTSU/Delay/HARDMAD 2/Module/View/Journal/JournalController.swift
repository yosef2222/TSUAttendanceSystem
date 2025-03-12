//
//  File.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 21.02.2025.
//
import UIKit

class JournalController: UIViewController {
    var emotionColor: UIColor
    var emotionText: String
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let emotionCardsView = EmotionCardsView()
    
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
            emotionCards.append(EmotionCardView(frame: .zero, startDate: "2020", endDate: "2020", startTime: "12:00", endTime: "13:00"))
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
        emotionCardsView.emotionCards = emotionCards
        emotionCardsView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emotionCardsView)
        
        NSLayoutConstraint.activate([
            
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 72),
            
            plusButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            plusButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 235),
            plusButton.widthAnchor.constraint(equalToConstant: 132),
            plusButton.heightAnchor.constraint(equalToConstant: 97),
            
            emotionCardsView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emotionCardsView.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 100),
            emotionCardsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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
}

