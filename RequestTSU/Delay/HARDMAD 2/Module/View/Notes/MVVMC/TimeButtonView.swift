//
//  ReminderView.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 01.03.2025.
//
import UIKit

class TimeButtonView: UIView {
    let textLabel: UIButton
    private var textGradientLayer: CAGradientLayer?
    private var textMaskLayer: CATextLayer?

    var onDateSelected: ((String) -> Void)?

    // Вычисляемое свойство для текста кнопки
    var text: String? {
        return textLabel.title(for: .normal)
    }

    init(frame: CGRect, buttonColor: UIColor, text: String) {
        self.textLabel = UIButton(type: .system)
        super.init(frame: frame)
        self.layer.cornerRadius = 22
        self.clipsToBounds = true
        setupButton(buttonColor: buttonColor, text: text)
    }

    required init?(coder: NSCoder) {
        self.textLabel = UIButton(type: .system)
        super.init(coder: coder)
        self.layer.cornerRadius = 22
        self.clipsToBounds = true
        setupButton(buttonColor: .lightGray, text: "Выбрать дату и время")
    }

    private func setupButton(buttonColor: UIColor, text: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = buttonColor

        textLabel.setTitle(text, for: .normal)
        textLabel.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textLabel.setTitleColor(.white, for: .normal)
        textLabel.contentHorizontalAlignment = .left
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        textLabel.addTarget(self, action: #selector(openDatePicker), for: .touchUpInside)

        addSubview(textLabel)

        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
        ])
    }

    @objc private func openDatePicker() {
        let datePickerViewController = TimePickerViewController()
        datePickerViewController.onTimeSelected = { [weak self] selectedDateTime in
            self?.textLabel.setTitle(selectedDateTime, for: .normal)
            self?.onDateSelected?(selectedDateTime)
        }

        if let parentViewController = self.parentViewController {
            parentViewController.present(datePickerViewController, animated: true, completion: nil)
        }
    }
}

class TimePickerViewController: UIViewController {
    var onTimeSelected: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка фона
        view.backgroundColor = .systemBackground
        
        // Настройка DatePicker для выбора даты и времени
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.tintColor = .label
        datePicker.backgroundColor = .secondarySystemBackground
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        
        // Кнопка "Готово"
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(.label, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)
        
        // Констрейнты
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            datePicker.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func doneButtonTapped() {
        let datePicker = view.subviews.compactMap { $0 as? UIDatePicker }.first
        if let selectedDate = datePicker?.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy - HH:mm" // Устанавливаем нужный формат
            let selectedDateTime = formatter.string(from: selectedDate)
            onTimeSelected?(selectedDateTime)
        }
        dismiss(animated: true, completion: nil)
    }
}

// Расширение для получения родительского UIViewController
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
