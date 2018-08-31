//
//  CustomerFamlilyListViewController.swift
//  horecafy
//
//  Created by Pedro Martin Gomez on 18/2/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

class CustomerFamlilyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var category: Category?
    var families: [Family] = []
    
    //To Create Demand
    
    var demandByCustomer: DemandsByCustomer?
    var typeOfFormatSelected: TypeOfFormat?
    var SelectedFamily: Family?
    private var typeOfFormats = [TypeOfFormat]()

    
    @IBOutlet weak var familyTVC: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        self.familyTVC.delegate = self
        self.familyTVC.dataSource = self
        self.familyTVC.tableFooterView = UIView()
        setupUI()
        loadDataFromApi()
    }

    // MARK: UI
    func setupUI() {
        if let category = self.category {
            self.title = category.name
        }
    }
    
    // MARK: API
    func loadDataFromApi() {
        guard let category = self.category else {
            return
        }
        ApiService.instance.getFamilies(categoryId: category.id) { (result) in
            guard let result: [Family] = result as? [Family] else {
                print("NO Families were loaded from api")
                return
            }
            self.families = result
            self.families.remove(at: 0) // delete the firstone because is just for dropdownlists
            self.familyTVC.reloadData()
        }
    }
    
    func loadTypeOfFormat() {
        
        activityIndicator.startAnimating()
        ApiService.instance.getTypesOfFormat { (result) in
            self.activityIndicator.stopAnimating()
            guard let result = result as? [TypeOfFormat] else {
                print("NO type of formats were loaded from api")
                return
            }
            self.typeOfFormats = result
            self.typeOfFormats.remove(at: 0) // delete the firstone because is just for dropdownlists
            self.typeOfFormatSelected = self.typeOfFormats[0]
            self.CreateDamand()
        }
    }
    
    // MARK: UI Table View Controller
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return families.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = familyTVC.dequeueReusableCell(withIdentifier: "familyCellId", for: indexPath)

        let family = families[indexPath.item]
        
        cell.textLabel?.text = family.name

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         DispatchQueue.main.async {
        let alert = UIAlertController(title: WARNING, message: "¿Quieres dar el consumo y tu precio objetivo para obtener mejores ofertas?", preferredStyle: .alert)
        
        let YesAction = UIAlertAction(title: "Sí", style: .default) { (UIAlertAction) in
            self.performSegue(withIdentifier: CUSTOMER_FAMILY_ADD_SEGUE, sender: nil)
        }
        let NoAction = UIAlertAction(title: "No", style: .default) { (UIAlertAction) in
            self.SelectedFamily = self.families[indexPath.item]
            self.loadTypeOfFormat()
        }
        //            UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(YesAction)
        alert.addAction(NoAction)
        
        self.present(alert, animated: true, completion: nil)
            
        }
       
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == CUSTOMER_FAMILY_ADD_SEGUE {
            let vc = segue.destination as! CustomerAddListViewController
            if let itemSelected: IndexPath = self.familyTVC.indexPathForSelectedRow {
                vc.category = self.category
                vc.family = families[itemSelected.item]
            }
        }
    }
    
    //MARK:- Create Demand
    
    var userId: Int64 {
        let credentials = loadCredentials()
        return credentials.userId
    }

    
    func CreateDamand() {
        if let demand = demand() {
            activityIndicator.startAnimating()
            ApiService.instance.createDemand(demand: demand, customerId: userId) { (response) in
                self.activityIndicator.stopAnimating()
                guard let _ = response as? DemandResponse else {
                    showAlert(self, ERROR, CUSTOMER_CREATE_DEMAND_FAILED)
                    return
                }
                if let demandVC = self.navigationController?.viewControllers[2] as? CustomerShowDemandsViewController {
                    self.navigationController?.popToViewController(demandVC, animated: true)
                }
            }
        }

    }
    
    private func demand() -> Demand? {
        
        guard let typeOfFormatSelected = typeOfFormatSelected else {
            return nil
        }
        
        let family = SelectedFamily!
        let brand = ""
        let quantyOfMonth = 0
        let targetPrice = 0.0
        let format = ""
        let comments = ""
        let demand = Demand(hiddenId: "", familyId: family.id, quantyPerMonth: quantyOfMonth, typeOfFormatId: typeOfFormatSelected.id, targetPrice: targetPrice, brand: brand, format: format, comments: comments, createdOn: Date(), borrado: true)
        return demand
    }
    
}
