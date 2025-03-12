//
//  NotesViewOneDay.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 06.03.2025.
//

import UIKit
import MobileCoreServices
import Alamofire

protocol NotesViewOneDayDelegate: AnyObject {
    func didSelectFile(fileURL: URL)
}

class NotesViewOneDay: UIView {
    weak var delegate: NotesViewOneDayDelegate?
    
    let StartTime = TimeButtonView(frame: .zero, buttonColor: .lGrayCircle, text: "начальная дата")
    let EndTime = TimeButtonView(frame: .zero, buttonColor: .lGrayCircle, text: "конечная дата")
    var StartTimeText = UILabel()
    var ReasonText = UILabel()
    var textField = UITextField()
    var uploadButton = UIButton()
    var selectedFileURL: URL?
    var selectedFiles: [URL] = []
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
        layer.borderColor = UIColor.white.cgColor
        
        // Настройка StartTimeText
        StartTimeText.text = "Время пропуска"
        StartTimeText.textColor = .white
        StartTimeText.font = UIFont.systemFont(ofSize: 16)
        StartTimeText.translatesAutoresizingMaskIntoConstraints = false
        addSubview(StartTimeText)
        
        // Настройка StartTime
        StartTime.translatesAutoresizingMaskIntoConstraints = false
        addSubview(StartTime)
        
        // Настройка EndTime
        EndTime.translatesAutoresizingMaskIntoConstraints = false
        addSubview(EndTime)
        
        // Настройка горизонтальной линии
        let lineView = UIView()
        lineView.backgroundColor = .white
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.layer.cornerRadius = 2
        addSubview(lineView)
        
        ReasonText.text = "Причина пропуска"
        ReasonText.textColor = .white
        ReasonText.font = UIFont.systemFont(ofSize: 16)
        ReasonText.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ReasonText)
        
        // Настройка UITextField
        textField.backgroundColor = .lStaticB
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.placeholder = "Введите текст"
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        
        // Настройка кнопки загрузки файла
        uploadButton.setTitle("Загрузить файл", for: .normal)
        uploadButton.setTitleColor(.white, for: .normal)
        uploadButton.backgroundColor = .lStaticB
        uploadButton.layer.cornerRadius = 8
        uploadButton.layer.masksToBounds = true
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(uploadButton)
        
        // Констрейнты
        NSLayoutConstraint.activate([
            StartTimeText.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            StartTimeText.heightAnchor.constraint(equalToConstant: 50),
            StartTimeText.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            StartTime.topAnchor.constraint(equalTo: StartTimeText.bottomAnchor, constant: 4),
            StartTime.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            StartTime.heightAnchor.constraint(equalToConstant: 50),
            StartTime.widthAnchor.constraint(equalToConstant: 180),
            
            EndTime.topAnchor.constraint(equalTo: StartTimeText.bottomAnchor, constant: 4),
            EndTime.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            EndTime.heightAnchor.constraint(equalToConstant: 50),
            EndTime.widthAnchor.constraint(equalToConstant: 180),
            
            lineView.centerXAnchor.constraint(equalTo: centerXAnchor),
            lineView.centerYAnchor.constraint(equalTo: StartTime.centerYAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 30),
            lineView.heightAnchor.constraint(equalToConstant: 4),
            
            ReasonText.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 40),
            ReasonText.heightAnchor.constraint(equalToConstant: 50),
            ReasonText.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: ReasonText.bottomAnchor, constant: 4),
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.widthAnchor.constraint(equalToConstant: 400),
            textField.heightAnchor.constraint(equalToConstant: 60),
            
            uploadButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            uploadButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            uploadButton.widthAnchor.constraint(equalToConstant: 200),
            uploadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // Обработка нажатия на кнопку загрузки файла
    @objc private func uploadButtonTapped() {
        openDocumentPicker()
    }
    
    // Открытие UIDocumentPickerViewController
    private func openDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false

        if let parentViewController = self.parentViewController {
            parentViewController.present(documentPicker, animated: true, completion: nil)
        } else {
            print("Ошибка: родительский UIViewController не найден")
        }
    }

        private func handleSelectedFiles(at urls: [URL]) {
            for url in urls {
                if url.startAccessingSecurityScopedResource() {
                    defer { url.stopAccessingSecurityScopedResource() }

                    do {
                        let fileData = try Data(contentsOf: url)
                        selectedFiles.append(url)
                        print("Добавлен файл: \(url.lastPathComponent)")
                    } catch {
                        print("Ошибка при чтении файла: \(error.localizedDescription)")
                    }
                } else {
                    print("Нет доступа к файлу: \(url.lastPathComponent)")
                }
            }
        }
    
    // Обработка выбранного файла
    private func handleSelectedFile(at url: URL) {
        if url.startAccessingSecurityScopedResource() {
            defer { url.stopAccessingSecurityScopedResource() }
            
            do {
                let fileData = try Data(contentsOf: url)
                let fileName = url.lastPathComponent
                print("Файл выбран: \(fileName)")
                print("Размер файла: \(fileData.count) байт")
                
                // Сохраняем выбранный файл
                selectedFileURL = url
            } catch {
                print("Ошибка при чтении файла: \(error.localizedDescription)")
            }
        } else {
            print("Нет доступа к файлу")
        }
    }
    
}

// Расширение для UIDocumentPickerDelegate
extension NotesViewOneDay: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else {
            print("Файл не выбран")
            return
        }

        // Сохраняем выбранный файл
        selectedFileURL = fileURL
        print("Файл выбран: \(fileURL.lastPathComponent)")

        // Уведомляем делегата
        delegate?.didSelectFile(fileURL: fileURL)
    }
}
