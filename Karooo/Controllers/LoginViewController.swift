//
//  LoginViewController.swift
//  Karooo
//
//  Created by Jitender on 22/01/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: PasswordTextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    //MARK: - Properties
    
    private lazy var loginViewModel = LoginViewModel()
    private var countries = [String]()
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleLoader(isHidden: true)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        email.text = "jitu@yopmail.com"
        password.text = "Jitu@6969"
        country.text = "INDIA"
    }
    
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        loginUser()
    }
    
    /// setup UI
    private func setupUI(){
        loginBtn.layer.cornerRadius = 5
        country.delegate = self
        loadCountries()
        setupPicker()
    }
    
    /// setup picker
    func setupPicker(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        country.inputView = pickerView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
    toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.done))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        country.inputAccessoryView = toolBar
    }
    
    @objc func done(){
        view.endEditing(true)
    }
    
    /// load countries
    private func loadCountries(){
        let countries = NSLocale.isoCountryCodes.map { (code:String) -> String in
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            return NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
        }
        
        self.countries = countries
    }
    
    /// Handle loader
    private func handleLoader(isHidden:Bool){
        self.loader.isHidden = isHidden
        if isHidden == true {
        } else {
            self.loader.startAnimating()
        }
    }
    
    //MARK: - Login user
    private func loginUser(){
        errorMsg.text = nil
        loginViewModel.email = email.text!
        loginViewModel.password = password.text!
        loginViewModel.country = country.text!
        switch self.loginViewModel.validate() {
        case .Valid:
            handleLoader(isHidden: true)
            loginViewModel.loginRequest { status,msg  in
                if status ?? false {
                    self.performSegue(withIdentifier: "masterSegue", sender: nil)
                }else{
                    self.errorMsg.text = msg
                }
            }
        case .Invalid(let errmessage):
            errorMsg.text = errmessage
            break
        }
    }
    
    
}

//MARK: - Textfield delegate methods

extension LoginViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}


//MARK: - Tableview delegate methods

extension LoginViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        country.text = countries[row]
    }
}


