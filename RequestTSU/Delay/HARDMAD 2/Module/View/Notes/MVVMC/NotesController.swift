//
//  NotesController.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 04.03.2025.
//


import UIKit
import Alamofire
import JWTDecode

class NotesController: UIViewController, NotesViewOneDayDelegate {
    let notesViewOneDay = NotesViewOneDay()
    let SuccessButton = UIButton()
    let leftButtonView = LeftButtonView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        notesViewOneDay.delegate = self
        // Настройка notesViewOneDay
        notesViewOneDay.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(notesViewOneDay)
        
        SuccessButton.translatesAutoresizingMaskIntoConstraints = false
        // Настройка SuccessButton
        SuccessButton.setTitle("Сохранить", for: .normal)
        SuccessButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        SuccessButton.contentHorizontalAlignment = .center
        SuccessButton.setTitleColor(.black, for: .normal) // Устанавливаем цвет текста
        SuccessButton.backgroundColor = .white
        SuccessButton.layer.cornerRadius = 35
        SuccessButton.clipsToBounds = true
        SuccessButton.addTarget(self, action: #selector(SuccessButtonTaped), for: .touchUpInside)
        SuccessButton.layer.zPosition = 1
        SuccessButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(SuccessButton)
        
        view.addSubview(leftButtonView)
        if let button = leftButtonView.subviews.first(where: { $0 is UIButton }) as? UIButton {
            button.addTarget(self, action: #selector(LeftButtonTapped), for: .touchUpInside)
        }
        
        // Констрейнты
        NSLayoutConstraint.activate([
            leftButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            leftButtonView.topAnchor.constraint(equalTo: view.topAnchor, constant: 78),
            leftButtonView.heightAnchor.constraint(equalToConstant: 40),
            leftButtonView.widthAnchor.constraint(equalToConstant: 40),
            
            notesViewOneDay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notesViewOneDay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notesViewOneDay.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            notesViewOneDay.heightAnchor.constraint(equalToConstant: 420),
            
            SuccessButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            SuccessButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            SuccessButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 730),
            SuccessButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        notesViewOneDay.isHidden = false
    }
    
    @objc func LeftButtonTapped() {
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    @objc func SuccessButtonTaped() {
        print("StartTime: \(notesViewOneDay.StartTime.text ?? "не заполнено")")
        print("EndTime: \(notesViewOneDay.EndTime.text ?? "не заполнено")")
        print("Reason: \(notesViewOneDay.textField.text ?? "не заполнено")")
        print("FileURL: \(notesViewOneDay.selectedFileURL?.absoluteString ?? "не выбран")")
        print("StudentID: \(getStudentIdFromToken() ?? "не найден")")

        guard let startTime = notesViewOneDay.StartTime.text,
              let endTime = notesViewOneDay.EndTime.text,
              let reason = notesViewOneDay.textField.text,
              let fileURL = notesViewOneDay.selectedFileURL,
              let studentId = getStudentIdFromToken() else {
            print("Не все данные заполнены или studentId не найден")
            return
        }
        guard let startTime = notesViewOneDay.StartTime.text,
              let endTime = notesViewOneDay.EndTime.text,
              let reason = notesViewOneDay.textField.text,
              let fileURL = notesViewOneDay.selectedFileURL,
              let studentId = getStudentIdFromToken() else {
            print("Не все данные заполнены или studentId не найден")
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy - HH:mm"
        guard let startDate = dateFormatter.date(from: startTime),
              let endDate = dateFormatter.date(from: endTime) else {
            print("Ошибка форматирования даты")
            return
        }

        do {
            let fileData = try Data(contentsOf: fileURL)
            // Оберните fileData в массив, так как files ожидает [Data]?
            let requestModel = RequestModel(studentId: studentId, reason: reason, absenceDateStart: startDate, absenceDateEnd: endDate, status: true, files: [fileData])

            uploadRequest(requestModel: requestModel)
        } catch {
            print("Ошибка при чтении файла: \(error.localizedDescription)")
        }
    }
    func didSelectFile(fileURL: URL) {
            print("Файл выбран в контроллере: \(fileURL.lastPathComponent)")
            // Сохраняем файл в контроллере, если нужно
        }
    
    func uploadRequest(requestModel: RequestModel) {
        let url = "http://localhost:5163/api/Requests"

        let headers: HTTPHeaders = [
                "Authorization": "Bearer \(getJWTToken() ?? "")",
                "Content-Type": "multipart/form-data"
            ]

            print("Отправка запроса с данными:")
            print("StudentID: \(requestModel.studentId)")
            print("Reason: \(requestModel.reason)")
            print("Start Date: \(requestModel.absenceDateStart)")
            print("End Date: \(requestModel.absenceDateEnd)")
            print("Files: \(requestModel.files?.count ?? 0)")

            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(requestModel.studentId.data(using: .utf8)!, withName: "studentId")
                multipartFormData.append(requestModel.reason.data(using: .utf8)!, withName: "reason")
                multipartFormData.append(requestModel.absenceDateStart.description.data(using: .utf8)!, withName: "absenceDateStart")
                multipartFormData.append(requestModel.absenceDateEnd.description.data(using: .utf8)!, withName: "absenceDateEnd")
                multipartFormData.append(requestModel.status.description.data(using: .utf8)!, withName: "status")

                // Добавляем файлы
                if let files = requestModel.files {
                    for (index, fileData) in files.enumerated() {
                        multipartFormData.append(fileData, withName: "files", fileName: "file\(index).jpg", mimeType: "image/jpeg")
                    }
                }
            }, to: url, headers: headers).response { response in
                switch response.result {
                case .success(let data):
                    if let data = data {
                        print("Ответ от сервера: \(String(data: data, encoding: .utf8) ?? "Нет данных")")
                    } else {
                        print("Ответ от сервера: Нет данных")
                    }
                case .failure(let error):
                    print("Ошибка: \(error.localizedDescription)")
                    if let data = response.data {
                        print("Ошибка от сервера: \(String(data: data, encoding: .utf8) ?? "Нет данных")")
                    }
                }
            }
        }
}

func getStudentIdFromToken() -> String? {
    guard let jwtToken = getJWTToken() else {
        print("JWT токен не найден")
        return nil
    }

    // Разделяем токен на части
    let segments = jwtToken.components(separatedBy: ".")
    guard segments.count == 3 else {
        print("Некорректный JWT токен")
        return nil
    }

    // Декодируем payload (вторая часть токена)
    let payload = segments[1]
    guard let payloadData = base64UrlDecode(payload) else {
        print("Ошибка декодирования payload")
        return nil
    }

    // Преобразуем payload в JSON
    do {
        if let payloadJson = try JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] {
            // Ищем Id в payload
            if let studentId = payloadJson["Id"] as? String {
                return studentId
            } else {
                print("Id не найден в токене. Проверьте ключ 'Id' в payload.")
                print("Payload: \(payloadJson)")
                return nil
            }
        } else {
            print("Payload не является JSON")
            return nil
        }
    } catch {
        print("Ошибка декодирования JSON: \(error)")
        return nil
    }
}

// Функция для декодирования Base64Url
func base64UrlDecode(_ value: String) -> Data? {
    var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")
    
    // Добавляем padding, если необходимо
    let length = Double(base64.count)
    let requiredLength = 4 * ceil(length / 4.0)
    let paddingLength = requiredLength - length
    if paddingLength > 0 {
        let padding = String(repeating: "=", count: Int(paddingLength))
        base64 += padding
    }
    
    return Data(base64Encoded: base64)
}

func getJWTToken() -> String? {
    return UserDefaults.standard.string(forKey: "jwtToken")
}
