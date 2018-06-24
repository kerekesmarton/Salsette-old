//
//  GraphAuthViewController.swift
//  Salsette
//
//  Created by Marton Kerekes on 19/11/2017.
//  Copyright © 2017 Marton Kerekes. All rights reserved.
//

import UIKit

struct GraphCreateAccountLauncher {
    func loginViewController(loginCompletion:@escaping ()->()) -> GraphCreateAccountViewController {
        let loginVC: GraphCreateAccountViewController = UIStoryboard.viewController(name: "GraphCreateAccountViewController")
        loginVC.modalPresentationStyle = .popover
        loginVC.modalPresentationStyle = UIModalPresentationStyle.popover
        loginVC.preferredContentSize = CGSize(width: 300, height: 350)
        loginVC.completion = loginCompletion
        return loginVC
    }
}

class GraphCreateAccountViewController: UITableViewController {
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    fileprivate var graphManager = GraphManager.shared
    var completion: (()->Void)? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) {
            if marketingEmails {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
    }
    
    @IBAction func createAccount() {
        if let email = emailField.text, let pwd = passwordField.text,
            isValidEmail(str: email),
            isValidPassword(str: pwd) {
            showLoading(true, "Setting you up...")
            graphManager.createUser(email: email, password: pwd, closure: { (success, error) in
                self.dismissWith(result: success, error: error)
            })
        }
    }
    
    @IBAction func login() {
        if let email = emailField.text, let pwd = passwordField.text,
            isValidEmail(str: email),
            isValidPassword(str: pwd) {
            showLoading(true, "Signing in...")
            graphManager.signIn(email: email, password: pwd, closure: { (success, error) in
                self.dismissWith(result: success, error: error)
            })
        }
    }
}

extension GraphCreateAccountViewController {
    var marketingEmails: Bool {
        get {
            return UserDefaults.standard.value(forKey: "marketingEmails") as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "marketingEmails")
            if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) {
                if newValue {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            marketingEmails = !marketingEmails
        }
    }
    
    private struct Data{
        static let privacy = URL(string: "https://sites.google.com/site/salsetteevents/privacy-policy")!
        static let termsAndConditions = URL(string: "https://sites.google.com/site/salsetteevents/terms-and-conditions")!
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if indexPath.row == 4 {
            UIApplication.shared.open(Data.termsAndConditions, options: [:], completionHandler: nil)
        }
        if indexPath.row == 5 {
            UIApplication.shared.open(Data.privacy, options: [:], completionHandler: nil)
        }
    }
}

extension GraphCreateAccountViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailField:
            return validateEmail()
        default:
            return validatePassword()
        }
    }
}

fileprivate extension GraphCreateAccountViewController {
    func validateEmail() -> Bool {
        if isValidEmail(str: emailField.text) {
            passwordField.becomeFirstResponder()
            return true
        } else {
            showError(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Invalid email"]))
            return false
        }
    }
    
    func validatePassword() -> Bool {
        if isValidPassword(str: passwordField.text) {
            passwordField.resignFirstResponder()
            login()
            return true
        } else {
            showError(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Password must consist of numbers, letters, minimum 6 characters long."]))
            return false
        }
    }
    func isValidEmail(str: String?) -> Bool {
        guard let testStr = str else { return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPassword(str: String?) -> Bool {
        guard let testStr = str else { return false }
        let passwordRegex = "^(?=.*[a-z])(?=.*[0-9]).{6,}$"
        let pwdTest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return pwdTest.evaluate(with: testStr)
    }
    
    func showLoading(_ active: Bool, _ message: String?, _ completion: (() -> Void)? = nil) {
        if active {
            present(UIAlertController.loadingAlert(with: message), animated: false, completion: completion)
        } else {
            dismiss(animated: false, completion: completion)
        }
    }
    
    private func showError(_ error: Error) {
        present(UIAlertController.errorAlert(with: error), animated: false, completion: nil)
    }
    
    func dismissWith(result: Bool?, error: Error?) {
        if let success = result, success {
            showLoading(false, nil)
            presentingViewController?.dismiss(animated: true, completion: completion)
        } else if let error = error {
            showLoading(false, nil)
            showError(error)
        }
    }
    
}

