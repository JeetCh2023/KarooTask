//
//  HomeViewController.swift
//  Karooo
//
//  Created by Jitender on 22/01/23.
//

import UIKit
import Lottie

class HomeViewController: UIViewController {
    
    @IBOutlet weak var userTableView: UITableView!
    
    private var lottieAnimation: LottieAnimationView?
    
    var viewModel = EmployeeViewModel()
    
    var profileData = [Employee]()
    
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Home"
        
        setupTableView()
        loadData()
        
        let backImage = UIImage(named: "icon-back")
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    private func setupTableView(){
        
        userTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        userTableView.delegate = self
        userTableView.dataSource = self
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    private func loadData(){
        showLoader(status: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewModel.fetchProfile { [weak self] response in
                guard let weakSelf = self else {return}
                if response.count > 0 {
                    weakSelf.profileData = response
                    weakSelf.userTableView.reloadData()
                    weakSelf.showLoader(status: false)
                }
            } failure: { [weak self] message in
                guard let weakSelf = self else {return}
                weakSelf.showLoader(status: false)
                weakSelf.alert(message: message)
            }
        }
    }
    
    private func showLoader(status:Bool){
        if status {
            lottieAnimation = LottieAnimationView(name: "loader")
            lottieAnimation?.frame = view.bounds
            lottieAnimation?.contentMode = .scaleAspectFill
            lottieAnimation?.frame = CGRect(x: 0, y: 0, width: 200, height: 300)
            lottieAnimation?.center = self.view.center
            lottieAnimation?.isHidden = false
            view.addSubview(lottieAnimation!)
            lottieAnimation?.loopMode = .loop
            lottieAnimation?.play()
        }else{
            lottieAnimation?.stop()
            lottieAnimation?.isHidden = true
        }
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        
        
        cell.employeeInfo = profileData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        vc.employeeInfo = profileData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
