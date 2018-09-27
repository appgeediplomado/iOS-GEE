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
        
        ServerDataManager.instance.cargaDetallesPonente(conId: ponente?.id ?? 0)

        lblNombre.text = ponente?.nombre
        lblDescripcion.text = ponente?.institucion
        tvBiodata.text = ponente?.biodata
        
        //Para mostrar la imagen del ponente, si existe
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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
