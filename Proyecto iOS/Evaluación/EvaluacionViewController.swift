//
//  EvaluacionViewController.swift
//  Programa
//
//  Created by Román Sánchez on 24/08/18.
//  Copyright © 2018 romansg. All rights reserved.
//

import UIKit

class EvaluacionViewController: UIViewController {
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var starsCalidadPonencia: CosmosView!
    @IBOutlet weak var starsExperienciaPonente: CosmosView!
    @IBOutlet weak var starsRelevanciaPonencia: CosmosView!
    
    var actividad: [String:String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        labelTitulo.text = actividad?["titulo"]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
