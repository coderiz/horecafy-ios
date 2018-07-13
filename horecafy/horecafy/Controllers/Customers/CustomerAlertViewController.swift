//
//  CustomerAlertViewController.swift
//  horecafy
//
//  Created by Pedro Martin Gomez on 12/2/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import UIKit

protocol CustomerAlertView {
    func didTapInOkButtton()
}

class CustomerAlertViewController: UIViewController {

    private var titulo: String = ""
    private var mensaje: String = ""
    var delegate: CustomerAlertView?
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var mensajeLabel: UILabel!
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    @IBAction func okButtonTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.didTapInOkButtton()
        }
    }
    
    init(titulo: String, mensaje: String) {
        super.init(nibName: nil, bundle: nil)
        self.titulo = titulo
        self.mensaje = mensaje
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        //animateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        //okButton.addBorder(side: .Top, color: alertViewGrayColor, width: 1)
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 5
        self.view.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        self.tituloLabel.text = self.titulo
        self.mensajeLabel.text = self.mensaje
    }
    
    func animateView() {
        alertView.alpha = 0;
        //self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
}
