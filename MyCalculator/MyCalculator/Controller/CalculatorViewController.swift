import UIKit

final class CalculatorViewController: UIViewController {
    private var  isFinishedTyping: Bool = true
    private var calculator = CalculatorLogic()

    private var displayValue: Double {
        get {
            guard let currentDisplayLabel = Double(displayLabel.text!) else {
                fatalError("Cannot conver to Double")
            }
            return currentDisplayLabel
        }
        
        set {
            displayLabel.text = String(newValue)
        }
    }

    private let displayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 70, weight: .light)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let displayContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#4A4A4A")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let buttonTitles: [[String]] = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]

    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 1
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubview()
        setupConstraints()
    }

    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false

        if ["÷", "×", "-", "+", "="].contains(title) {

            button.backgroundColor = UIColor(hex: "#FF9500")
            button.setTitleColor(.white, for: .normal)
        } else if ["AC", "+/-", "%"].contains(title) {

            button.backgroundColor = UIColor(hex: "#A5A5A5")
            button.setTitleColor(.white, for: .normal)
        } else {

            button.backgroundColor = UIColor(hex: "#339CEC")
            button.setTitleColor(.white, for: .normal)
        }

        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        guard let number = sender.title(for: .normal) else { return }

        UIView.animate(withDuration: 0.1, animations: {
            sender.alpha = 0.7
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.alpha = 1.0
            }
        }

         if ["7","8","9","4","5","6","1","2","3","0","."].contains(number) {
             if isFinishedTyping {
                 displayLabel.text = number
                 isFinishedTyping = false
             } else {
                 if number == "." {
                     let isInt = floor(displayValue) == displayValue
                     if !isInt {
                         return
                     }
                 }
                 displayLabel.text =  displayLabel.text! + number
                }
            } else  {

             isFinishedTyping = true
             calculator.setNumber(displayValue)

             if let result = calculator.calculate(symbol: number) {
                 displayValue = result
             }
         } 
    }
}

//MARK: Subviews

private extension CalculatorViewController {
    func addSubview() {
           view.addSubview(displayContainer)
           displayContainer.addSubview(displayLabel)
           view.addSubview(buttonsStackView)

           for row in buttonTitles {
               let rowStack = UIStackView()
               rowStack.axis = .horizontal
               rowStack.spacing = 1
               rowStack.distribution = .fillEqually

               if row.contains("0") {

                   rowStack.distribution = .fill

                   let zeroButton = createButton(title: "0")
                   let dotButton = createButton(title: ".")
                   let equalButton = createButton(title: "=")

                   rowStack.addArrangedSubview(zeroButton)
                   rowStack.addArrangedSubview(dotButton)
                   rowStack.addArrangedSubview(equalButton)


                   zeroButton.widthAnchor.constraint(equalTo: dotButton.widthAnchor, multiplier: 2).isActive = true
                   dotButton.widthAnchor.constraint(equalTo: equalButton.widthAnchor).isActive = true
               } else {

                   row.forEach { title in
                       let button = createButton(title: title)
                       rowStack.addArrangedSubview(button)
                   }
               }
               buttonsStackView.addArrangedSubview(rowStack)
           }
       }

     func setupConstraints() {
        NSLayoutConstraint.activate(
            [
            displayContainer.topAnchor.constraint(equalTo: view.topAnchor),
            displayContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            displayContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            displayContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),

            displayLabel.leadingAnchor.constraint(equalTo: displayContainer.leadingAnchor, constant: 20),
            displayLabel.trailingAnchor.constraint(equalTo: displayContainer.trailingAnchor, constant: -20),
            displayLabel.bottomAnchor.constraint(equalTo: displayContainer.bottomAnchor, constant: -20),

            buttonsStackView.topAnchor.constraint(equalTo: displayContainer.bottomAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
}


