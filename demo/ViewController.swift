//
//  ViewController.swift
//  demo
//
//  Created by saini on 14/08/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let apiClient = APIClient()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupActivityIndicator()

    }
    
    // MARK: - Private Functions
    private func setupActivityIndicator() {
           activityIndicator.center = view.center
           activityIndicator.hidesWhenStopped = true
           view.addSubview(activityIndicator)
       }
    
    func showAlert(title: String, message: String ,status: Bool) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            let retryAction = UIAlertAction(title: "RETRY", style: .default, handler: nil)
            
        if (status == true) {
            alertController.addAction(okAction)
        }
        else{
            alertController.addAction(okAction)
            alertController.addAction(retryAction)

        }

            present(alertController, animated: true, completion: nil)
        }

    // MARK: - Button Action
    @IBAction func fetch(_ sender: Any) {
        activityIndicator.startAnimating()
        apiClient.fetchData { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let data):
                    print("Data fetched: \(data)")
                    // Update UI here if needed, for example:
                    // self.myLabel.text = "Data: \(data)"
                    self.showAlert(title: "Data fetched", message: "Data successfully fetched!", status: true)
                case .failure(let error):
                    print("Failed to fetch data: \(error.localizedDescription)")
                    // Update UI here, like showing an alert
                    self.showAlert(title: "Error", message: error.localizedDescription, status: false)
                }
            }
        }
    }
    
    
    
}

