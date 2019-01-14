//
//  MapaLugarViewController.swift
//  Proyecto iOS
//
//  Created by José Luis Vázquez Torres on 14/01/19.
//  Copyright © 2019 App Gee. All rights reserved.
//

import UIKit

class MapaLugarViewController: UIViewController {
    
    @IBOutlet weak var ivMapaLugar: UIImageView!
    var imagen:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage(named: imagen!)
        ivMapaLugar.image = img
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
