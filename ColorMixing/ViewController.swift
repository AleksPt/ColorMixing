//
//  ViewController.swift
//  ColorMixing
//
//  Created by Алексей on 25.05.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Private properties
    private lazy var titleLabel = UILabel()
    private lazy var stackView = UIStackView()
    private lazy var firstNameColorLabel = UILabel()
    private lazy var firstColorButton = UIButton(primaryAction: showColorPicker())
    private lazy var secondNameColorLabel = UILabel()
    private lazy var secondColorButton = UIButton(primaryAction: showColorPicker())
    private lazy var threeNameColorLabel = UILabel()
    private lazy var threeColorButton = UIButton(primaryAction: showColorPicker())
    private lazy var resultNameColorLabel = UILabel()
    private lazy var resultColorView = UIView()
    
    private var activeButton: UIButton?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: - Private methods
    private func showColorPicker() -> UIAction {
        let action = UIAction { button in
            let colorPicker = UIColorPickerViewController()
            colorPicker.delegate = self
            self.activeButton = button.sender as? UIButton
            self.present(colorPicker, animated: true)
        }
        return action
    }
    
    private func blendColors() {
        var clr: UIColor?
        
        guard let firstColor = firstColorButton.backgroundColor,
              let secondColor = secondColorButton.backgroundColor,
              let threeColor = threeColorButton.backgroundColor else { return }
    
        let mixColors = UIColor.blendColors(firstColor, secondColor, threeColor)
        
        UIView.animate(withDuration: 1) {
            self.resultColorView.backgroundColor = mixColors
        }
    }
}

// MARK: - UIColorPickerViewControllerDelegate
extension ViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(
        _ viewController: UIColorPickerViewController,
        didSelect color: UIColor,
        continuously: Bool
    ) {
        guard let activeButton = activeButton else { return }
        UIView.animate(withDuration: 1) {
            activeButton.backgroundColor = viewController.selectedColor
        }
        blendColors()
    }
}

// MARK: - Setup UI
private extension ViewController {
    func setupLayout() {
        view.backgroundColor = .white
        setupTitleLabel()
        setupStackView()
        setupFirstNameColorLabel()
        setupFirstColorButton()
        setupSecondNameColorLabel()
        setupSecondColorButton()
        setupThreeNameColorLabel()
        setupThreeColorButton()
        setupResultNameColorLabel()
        setupResultColorView()
    }
    
    func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 50, weight: .black)
        titleLabel.text = "MixColors"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(firstNameColorLabel)
        stackView.addArrangedSubview(firstColorButton)
        stackView.addArrangedSubview(secondNameColorLabel)
        stackView.addArrangedSubview(secondColorButton)
        stackView.addArrangedSubview(threeNameColorLabel)
        stackView.addArrangedSubview(threeColorButton)
        stackView.addArrangedSubview(resultNameColorLabel)
        stackView.addArrangedSubview(resultColorView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupFirstNameColorLabel() {
        firstNameColorLabel.text = "First"
        firstNameColorLabel.textAlignment = .center
        firstNameColorLabel.font = .systemFont(ofSize: 20)
    }
    
    func setupFirstColorButton() {
        firstColorButton.backgroundColor = .red
    }
    
    func setupSecondNameColorLabel() {
        secondNameColorLabel.text = "Second"
        secondNameColorLabel.textAlignment = .center
        secondNameColorLabel.font = .systemFont(ofSize: 20)
    }
    
    func setupSecondColorButton() {
        secondColorButton.backgroundColor = .blue
    }
    
    func setupThreeNameColorLabel() {
        threeNameColorLabel.text = "Three"
        threeNameColorLabel.textAlignment = .center
        threeNameColorLabel.font = .systemFont(ofSize: 20)
    }
    
    func setupThreeColorButton() {
        threeColorButton.backgroundColor = .yellow
    }
    
    func setupResultNameColorLabel() {
        resultNameColorLabel.text = "Result"
        resultNameColorLabel.textAlignment = .center
        resultNameColorLabel.font = .systemFont(ofSize: 20)
    }
    
    func setupResultColorView() {
        resultColorView.backgroundColor = .green
    }
    
}
