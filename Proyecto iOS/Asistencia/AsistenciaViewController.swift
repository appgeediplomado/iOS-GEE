//
//  AsistenciaViewController.swift
//  eventos
//
//  Created by José Luis Vázquez Torres on 26/08/18.
//  Copyright © 2018 José Luis Vázquez Torres. All rights reserved.
//

import UIKit

class AsistenciaViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !AsistenteData.instance.existeSesionAsistente() {
            self.performSegue(withIdentifier: "mostrarInicioSesion", sender: nil )
        }
        sideMenuLeft()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func sideMenuLeft(){
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 300
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
