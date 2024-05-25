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
        
    private let firstView = UIView()
    private let secondView = UIView()
    
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
    private var activeLabel: UILabel?
    
    private let networkManager = NetworkManager.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
    }
    
    // MARK: - Private methods
    private func showColorPicker() -> UIAction {
        let action = UIAction { [weak self] action in
            let button = action.sender as? UIButton
            self?.activeButton = button
            
            switch button?.tag {
            case 0:
                self?.activeLabel = self?.firstNameColorLabel
            case 1:
                self?.activeLabel = self?.secondNameColorLabel
            case 2:
                self?.activeLabel = self?.threeNameColorLabel
            default:
                self?.activeLabel = self?.fourNameColorLabel
            }
            
            UIView.animate(withDuration: 1) {
                button?.setTitle("", for: .normal)
                button?.layer.borderWidth = 0
            }
            
            let colorPicker = UIColorPickerViewController()
            colorPicker.delegate = self
            self?.present(colorPicker, animated: true)
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
        
        fetchNameColor(mixColors, isResultColor: true)
    }
    
    private func fetchNameColor(_ color: UIColor, isResultColor: Bool = false) {
        func getRgbString(fromColor: UIColor) -> String {
            let rgbString = color.redValue.description
            + "," + color.greenValue.description
            + "," + color.blueValue.description
            return rgbString
        }
        
        networkManager.fetchColor(rgb: getRgbString(fromColor: color)) { [weak self] colorName in
            DispatchQueue.main.async {
                if isResultColor {
                    self?.resultNameColorLabel.text = colorName
                } else {
                    self?.activeLabel?.text = colorName
                }
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
        view.backgroundColor = .black
        setupTitleLabel()
        setupFirstView()
        setupSecondView()
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
        titleLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupFirstView() {
        view.addSubview(firstView)
        firstView.translatesAutoresizingMaskIntoConstraints = false
        
        firstView.addSubview(firstNameColorLabel)
        firstView.addSubview(firstColorButton)
        firstView.addSubview(secondNameColorLabel)
        firstView.addSubview(secondColorButton)
        firstView.addSubview(threeNameColorLabel)
        firstView.addSubview(threeColorButton)
        firstView.addSubview(fourNameColorLabel)
        firstView.addSubview(fourColorButton)
        
        NSLayoutConstraint.activate([
            firstView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            firstView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            firstView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            firstView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            firstNameColorLabel.topAnchor.constraint(equalTo: firstView.topAnchor),
            firstNameColorLabel.leadingAnchor.constraint(equalTo: firstView.leadingAnchor),
            firstNameColorLabel.trailingAnchor.constraint(equalTo: firstView.centerXAnchor, constant: -10),
            firstColorButton.topAnchor.constraint(equalTo: firstNameColorLabel.bottomAnchor),
            firstColorButton.leadingAnchor.constraint(equalTo: firstView.leadingAnchor),
            firstColorButton.trailingAnchor.constraint(equalTo: firstNameColorLabel.trailingAnchor),
            firstColorButton.bottomAnchor.constraint(equalTo: firstView.centerYAnchor),
            
            secondNameColorLabel.leadingAnchor.constraint(equalTo: firstNameColorLabel.trailingAnchor, constant: 10),
            secondNameColorLabel.topAnchor.constraint(equalTo: firstView.topAnchor),
            secondNameColorLabel.trailingAnchor.constraint(equalTo: firstView.trailingAnchor),
            secondColorButton.leadingAnchor.constraint(equalTo: secondNameColorLabel.leadingAnchor),
            secondColorButton.topAnchor.constraint(equalTo: secondNameColorLabel.bottomAnchor),
            secondColorButton.trailingAnchor.constraint(equalTo: secondNameColorLabel.trailingAnchor),
            secondColorButton.bottomAnchor.constraint(equalTo: firstView.centerYAnchor),
            
            threeNameColorLabel.topAnchor.constraint(equalTo: firstColorButton.bottomAnchor),
            threeNameColorLabel.leadingAnchor.constraint(equalTo: firstView.leadingAnchor),
            threeNameColorLabel.trailingAnchor.constraint(equalTo: firstNameColorLabel.trailingAnchor),
            threeColorButton.leadingAnchor.constraint(equalTo: firstView.leadingAnchor),
            threeColorButton.topAnchor.constraint(equalTo: threeNameColorLabel.bottomAnchor),
            threeColorButton.trailingAnchor.constraint(equalTo: threeNameColorLabel.trailingAnchor),
            threeColorButton.bottomAnchor.constraint(equalTo: firstView.bottomAnchor),
            
            fourNameColorLabel.leadingAnchor.constraint(equalTo: secondNameColorLabel.leadingAnchor),
            fourNameColorLabel.topAnchor.constraint(equalTo: threeNameColorLabel.topAnchor),
            fourNameColorLabel.trailingAnchor.constraint(equalTo: secondNameColorLabel.trailingAnchor),
            fourColorButton.leadingAnchor.constraint(equalTo: fourNameColorLabel.leadingAnchor),
            fourColorButton.topAnchor.constraint(equalTo: fourNameColorLabel.bottomAnchor),
            fourColorButton.trailingAnchor.constraint(equalTo: fourNameColorLabel.trailingAnchor),
            fourColorButton.bottomAnchor.constraint(equalTo: threeColorButton.bottomAnchor)
        ])
    }
    
    func setupSecondView() {
        view.addSubview(secondView)
        secondView.translatesAutoresizingMaskIntoConstraints = false
        
        secondView.addSubview(resultNameColorLabel)
        secondView.addSubview(resultColorView)
        
        NSLayoutConstraint.activate([
            secondView.topAnchor.constraint(equalTo: firstView.bottomAnchor, constant: 50),
            secondView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            secondView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            secondView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            resultNameColorLabel.topAnchor.constraint(equalTo: secondView.topAnchor),
            resultNameColorLabel.leadingAnchor.constraint(equalTo: secondView.leadingAnchor),
            resultNameColorLabel.trailingAnchor.constraint(equalTo: secondView.trailingAnchor),
            resultColorView.topAnchor.constraint(equalTo: resultNameColorLabel.bottomAnchor),
            resultColorView.leadingAnchor.constraint(equalTo: resultNameColorLabel.leadingAnchor),
            resultColorView.trailingAnchor.constraint(equalTo: resultNameColorLabel.trailingAnchor),
            resultColorView.bottomAnchor.constraint(equalTo: secondView.bottomAnchor)
        ])
    }
    
    func setupLabels(_ labels: UILabel...) {
        var count = 1
        labels.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = .white
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 20, weight: .bold)
            $0.text = "Color #\(count):"
            count += 1
        }
    }
    
    func setupButtons(_ buttons: UIButton...) {
        var counter = 0
        buttons.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.borderWidth = 5
            $0.layer.borderColor = UIColor.white.cgColor
            $0.setTitle("tap to choose color", for: .normal)
            $0.layer.cornerRadius = 15
            $0.backgroundColor = .clear
            $0.tag = counter
            counter += 1
        }
    }
    
    func setupResultNameColorLabel() {
        resultNameColorLabel.translatesAutoresizingMaskIntoConstraints = false
        resultNameColorLabel.font = .systemFont(ofSize: 20, weight: .bold)
        resultNameColorLabel.text = "Result color:"
        resultNameColorLabel.textAlignment = .center
        resultNameColorLabel.textColor = .white
    }
    
    func setupResultColorView() {
        resultColorView.translatesAutoresizingMaskIntoConstraints = false
        resultColorView.backgroundColor = .clear
        resultColorView.layer.borderWidth = 5
        resultColorView.layer.borderColor = UIColor.white.cgColor
        resultColorView.layer.cornerRadius = 15
    }
}
