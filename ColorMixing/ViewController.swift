//
//  ViewController.swift
//  ColorMixing
//
//  Created by Алексей on 25.05.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    
    // MARK: - Private properties
    private let titleLabel = UILabel()
    
    private let mainVerticalStackView = UIStackView()
    private let firstVerticalStackView = UIStackView()
    private let secondVerticalStackView = UIStackView()
    private let firstHorizontalStackView = UIStackView()
    private let secondHorizontalStackView = UIStackView()
    private let firstColorStackView = UIStackView()
    private let secondColorStackView = UIStackView()
    private let thirdColorStackView = UIStackView()
    private let fourColorStackView = UIStackView()
    
    private let firstNameColorLabel = UILabel()
    private let secondNameColorLabel = UILabel()
    private let threeNameColorLabel = UILabel()
    private let fourNameColorLabel = UILabel()
    
    private let resultNameColorLabel = UILabel()
    private let resultColorView = UIView()
    
    private lazy var firstColorButton = UIButton(primaryAction: showColorPicker())
    private lazy var secondColorButton = UIButton(primaryAction: showColorPicker())
    private lazy var threeColorButton = UIButton(primaryAction: showColorPicker())
    private lazy var fourColorButton = UIButton(primaryAction: showColorPicker())
    
    private var activeButton: UIButton?
    
    private let networkManager = NetworkManager.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: - Private methods
    private func showColorPicker() -> UIAction {
        let action = UIAction { action in
            let colorPicker = UIColorPickerViewController()
            colorPicker.delegate = self
            self.activeButton = action.sender as? UIButton
            self.present(colorPicker, animated: true)
        }
        return action
    }
    
    private func blendColors() {
        guard let firstColor = firstColorButton.backgroundColor,
              let secondColor = secondColorButton.backgroundColor,
              let threeColor = threeColorButton.backgroundColor,
              let fourColor = fourColorButton.backgroundColor else { return }
    
        let mixColors = UIColor.blendColors(firstColor, secondColor, threeColor, fourColor)
        
        UIView.animate(withDuration: 1) {
            self.resultColorView.backgroundColor = mixColors
        }
        
        fetchNameColor(mixColors)
    }
    
    private func fetchNameColor(_ color: UIColor) {
        let rgbString = color.redValue.description
        + "," + color.greenValue.description
        + "," + color.blueValue.description

        networkManager.fetchColor(rgb: rgbString) { [weak self] colorName in
            DispatchQueue.main.async {
                
            }
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
        fetchNameColor(viewController.selectedColor)
    }
}

// MARK: - Setup UI
private extension ViewController {
    func setupLayout() {
        view.backgroundColor = .white
        setupTitleLabel()
        setupMainStackView()
        setupFirstVerticalStackView()
        setupSecondVerticalStackView()
        setupFirstHorizontalStackView()
        setupSecondHorizontalStackView()
        setupFirstColorStackView()
        setupSecondColorStackView()
        setupThirdColorStackView()
        setupFourColorStackView()
        setupLabels(firstNameColorLabel, secondNameColorLabel, threeNameColorLabel, fourNameColorLabel)
        setupButtons(firstColorButton, secondColorButton, threeColorButton, fourColorButton)
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
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupMainStackView() {
        view.addSubview(mainVerticalStackView)
        mainVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        mainVerticalStackView.axis = .vertical
        mainVerticalStackView.distribution = .fillEqually
        mainVerticalStackView.addArrangedSubview(firstVerticalStackView)
        mainVerticalStackView.addArrangedSubview(secondVerticalStackView)
        
        NSLayoutConstraint.activate([
            mainVerticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainVerticalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            mainVerticalStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20),
            mainVerticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupFirstVerticalStackView() {
        firstVerticalStackView.axis = .vertical
        firstVerticalStackView.distribution = .fillEqually
        firstVerticalStackView.addArrangedSubview(firstHorizontalStackView)
        firstVerticalStackView.addArrangedSubview(secondHorizontalStackView)
    }
    
    func setupSecondVerticalStackView() {
        secondVerticalStackView.axis = .vertical
        secondVerticalStackView.distribution = .fillEqually
        secondVerticalStackView.addArrangedSubview(UIView())
        secondVerticalStackView.addArrangedSubview(resultNameColorLabel)
        secondVerticalStackView.addArrangedSubview(resultColorView)
    }
    
    func setupFirstHorizontalStackView() {
        firstHorizontalStackView.axis = .horizontal
        firstHorizontalStackView.distribution = .fillEqually
        firstHorizontalStackView.spacing = 10
        firstHorizontalStackView.addArrangedSubview(firstColorStackView)
        firstHorizontalStackView.addArrangedSubview(secondColorStackView)
    }
    
    func setupSecondHorizontalStackView() {
        secondHorizontalStackView.axis = .horizontal
        secondHorizontalStackView.distribution = .fillEqually
        secondHorizontalStackView.spacing = 20
        secondHorizontalStackView.addArrangedSubview(thirdColorStackView)
        secondHorizontalStackView.addArrangedSubview(fourColorStackView)
    }
    
    func setupFirstColorStackView() {
        firstColorStackView.axis = .vertical
        firstColorStackView.distribution = .fillEqually
        firstColorStackView.addArrangedSubview(firstNameColorLabel)
        firstColorStackView.addArrangedSubview(firstColorButton)
    }
    
    func setupSecondColorStackView() {
        secondColorStackView.axis = .vertical
        secondColorStackView.distribution = .fillEqually
        secondColorStackView.addArrangedSubview(secondNameColorLabel)
        secondColorStackView.addArrangedSubview(secondColorButton)
    }
    
    func setupThirdColorStackView() {
        thirdColorStackView.axis = .vertical
        thirdColorStackView.distribution = .fillEqually
        thirdColorStackView.addArrangedSubview(threeNameColorLabel)
        thirdColorStackView.addArrangedSubview(threeColorButton)
    }
    
    func setupFourColorStackView() {
        fourColorStackView.axis = .vertical
        fourColorStackView.distribution = .fillEqually
        fourColorStackView.addArrangedSubview(fourNameColorLabel)
        fourColorStackView.addArrangedSubview(fourColorButton)
    }
    
    func setupLabels(_ labels: UILabel...) {
        var count = 1
        labels.forEach {
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 20, weight: .bold)
            $0.text = "Color #\(count):"
            count += 1
        }
    }
    
    func setupButtons(_ buttons: UIButton...) {
        buttons.forEach {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.setTitle("tap to choose color", for: .normal)
            $0.layer.cornerRadius = 5
            $0.backgroundColor = .clear
        }
    }
    
    func setupResultNameColorLabel() {
        resultNameColorLabel.font = .systemFont(ofSize: 20, weight: .bold)
        resultNameColorLabel.text = "Result color:"
        resultNameColorLabel.textAlignment = .center
    }
    
    func setupResultColorView() {
        resultColorView.backgroundColor = .clear
        resultColorView.layer.borderWidth = 1
        resultColorView.layer.borderColor = UIColor.lightGray.cgColor
        resultColorView.layer.cornerRadius = 5
    }
}
