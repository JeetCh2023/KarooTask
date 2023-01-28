//
//  DetailsViewController.swift
//  Karooo
//
//  Created by Jitender on 23/01/23.
//

import UIKit
import MapKit

class DetailViewController: UITableViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var employeeInfo:Employee? = nil
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Profile"
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        updateUI()
        setupMap()
    }
    
    private func updateUI(){
        
        guard let employeeInfo = employeeInfo else { return }
        
        name.text = "Name : \(employeeInfo.name ?? "")"
        email.text = "Email : \(employeeInfo.email ?? "")"
        userName.text = "Username : \(employeeInfo.username ?? "")"
        phone.text = "Phone : \(employeeInfo.phone ?? "")"
        street.text = "Street : \(employeeInfo.address?.street ?? "")"
        city.text = "City : \(employeeInfo.address?.city ?? "")"
        companyName.text = "Company : \(employeeInfo.company?.name ?? "")"
    }
    
    private func setupMap(){
        checkLocationServices()
        setupUserLocationonMap()
    }
}

//MARK: - Location Methods

extension DetailViewController{
    
    func checkLocationServices() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.checkLocationAuthorization()
            } else {
              // Show alert letting the user know they have to turn this on.
            }
        }
      
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            
            // For these case, you need to show a pop-up telling users what's up and how to turn on permisneeded if needed
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    func setupUserLocationonMap(){
        let annotations = MKPointAnnotation()
        annotations.title = employeeInfo?.address?.city ?? ""
        if let latitude = Double(employeeInfo?.address?.geo?.lat ?? "28.637623"),let longitude = Double(employeeInfo?.address?.geo?.lng ?? "77.233694"){
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotations.coordinate = coordinates
            let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.addAnnotation(annotations)
            mapView.setRegion(region, animated: true)
            mapView.regionThatFits(region)
        }
    }
    
}

extension DetailViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
}
