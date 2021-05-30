//
//  ViewController.swift
//  MVVMSampleApp
//
//  Created by Shotaro Maruyama on 2021/04/22.
//  
//

import UIKit

/// MVVMでいうViewに相当するクラス
/// ・ユーザー入力をViewModelに伝搬する
/// ・自身の状態とViewModelの状態をバインディングする
/// ・ViewModelから返却されるイベントをもとに描画処理を実行する
class ViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!

    private let notificationCenter = NotificationCenter()
    private lazy var viewModel = ViewModel(notificationCenter: notificationCenter)


    // オブザーバーを利用してUIパーツに変更を通知させる
    override func viewDidLoad() {
        super.viewDidLoad()

        idTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)

        notificationCenter.addObserver(self, selector: #selector(updateValidationText), name: viewModel.changeText, object: nil)
        notificationCenter.addObserver(self, selector: #selector(updateValicationColor), name: viewModel.changeColor, object: nil)
    }

}

extension ViewController {
    @objc func textFieldEditingChanged(sender: UITextField) {
        viewModel.idPasswordChanged(
            id: idTextField.text,
            password: passwordTextField.text
        )
    }
    /// VIewの描画を担当
    @objc func updateValidationText(notification: Notification) {
        guard let text = notification.object as? String else { return }
        validationLabel.text = text
    }
    /// VIewの描画を担当
    @objc func updateValicationColor(notification: Notification) {
        guard let color = notification.object as? UIColor else { return }
        validationLabel.textColor = color
    }
}

