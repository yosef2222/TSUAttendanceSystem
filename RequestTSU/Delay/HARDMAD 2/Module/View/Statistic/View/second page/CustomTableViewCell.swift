//
//  CustomTableViewCell.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 03.03.2025.
//


import UIKit

class CustomTableViewCell: UITableViewCell {

    let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: UIScreen.main.bounds.width / 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: UIScreen.main.bounds.width / 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let stateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lGrayTab
        label.textAlignment = .center
        label.font = UIFont(name: "VelaSansGX-ExtraLight_Regular", size: UIScreen.main.bounds.width / 30)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let iconsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = -20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(stateLabel)
        contentView.addSubview(iconsStackView)

        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            dateLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            stateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            stateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stateLabel.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 40),
            
            iconsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            iconsStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func configure(with icons: [UIImage]) {
        iconsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for icon in icons {
            let imageView = UIImageView(image: icon)
            imageView.contentMode = .scaleAspectFit
            iconsStackView.addArrangedSubview(imageView)
        }
    }
}
