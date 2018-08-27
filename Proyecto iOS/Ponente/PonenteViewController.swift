//
//  PonenteViewController.swift
//  GeeApp
//
//  Created by Emmanuel García on 25/08/18.
//  Copyright © 2018 UNAM. All rights reserved.
//

import UIKit

class PonenteViewController: UIViewController {

    @IBOutlet weak var imgPonente: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var tvBiodata: UITextView!
    //@IBOutlet weak var lblTitleBiodata: PaddingLabel!
    var ponente:Ponente?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        lblNombre.text = ponente?.nombre
        lblDescripcion.text = ponente?.descripcion
        tvBiodata.text = ponente?.biodata
//        tvBiodata.layer.borderWidth = 0.5
//        tvBiodata.layer.cornerRadius = 2
//        tvBiodata.layer.borderColor = UIColor.lightGray.cgColor
        
        //lblTitleBiodata.layer.borderWidth = 0.5
        //lblTitleBiodata.layer.cornerRadius = 2
        //lblTitleBiodata.layer.borderColor = UIColor.lightGray.cgColor
        
        //Para mostrar la imagen del capturado, si existe
        if let bytes = ponente?.imagen {
            if let image = UIImage(data:bytes) {
                imgPonente.image = image
            }
        } else {
            //Mostramos imagen default, como es png, no es necesario anexarle la extension
            imgPonente.image = UIImage(named: "icons8-name_filled")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUX()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func buildUX() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

