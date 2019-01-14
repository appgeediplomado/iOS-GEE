//
//  LoginViewController.swift
//  Proyecto iOS
//
//  Created by Román Sánchez on 26/08/18.
//  Copyright © 2018 App Gee. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    //El botón de notificaciones no está dentro del alcance del proyecto
    //Se deshabilita
    //@IBOutlet weak var alertButton: UIBarButtonItem!
    
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtContrasenia: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenus()
        //MARK: Validación de sesión del Asistente
        //Verificamos si el asistente ha iniciado sesión
        //Si ya existe la sesión se muestra el programa del evento de lo contrario agregamos un Observador al NotificationCenter
        //para validar las credenciales si el asistente inicia sesión
        
        if AsistenteData.instance.existeSesionAsistente(){
            self.performSegue(withIdentifier: "mostrarPrograma", sender: nil )
        }
        else
        {
            txtUsuario.autocapitalizationType = .none
            NotificationCenter.default.addObserver(self, selector:#selector(validarSesion), name:NSNotification.Name(rawValue: Constants.DATA_SESION_ASISTENTE), object: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sideMenus(){
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 300
            
            //El botón de notificaciones no está dentro del alcance del proyecto
            //Se deshabilita

            //alertButton.target = revealViewController()
            //alertButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            //srevealViewController().rightViewRevealWidth = 200
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    @IBAction func btnIniciarSesionTouch(_ sender: UIButton) {
        //Se validan los campos del formulario.
        //Sí los campos no están vacíos y el campo de usuario tiene el formato de corre electrónico se verifica
        //solo el correo electrónico del usuario con el WS
        
        if validarCampos(usuario: txtUsuario.text!, contrasenia: txtContrasenia.text!) {
            AsistenteData.instance.validarAsistente(correoUsuario: txtUsuario.text!, passUsuario: txtContrasenia.text!)
        }
        else{
            let alert = UIAlertController(title: "Error", message: "El formato del campo usuario es incorrecto o algún campo está vacío. Verifique.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func validarCampos(usuario: String, contrasenia: String) -> Bool{
        let correoUsuarioReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let correoUsuarioTest = NSPredicate(format:"SELF MATCHES %@", correoUsuarioReg)
        return correoUsuarioTest.evaluate(with:usuario) && contrasenia != ""
    }
    
    //Si los datos ingresados en el formulario son válidos (correo electrónico)
    //Se muestra el programa y se quita el observador del NotificationCenter
    @objc func validarSesion(){
        if AsistenteData.instance.existeSesionAsistente() {
            NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: Constants.DATA_SESION_ASISTENTE), object: nil)
            self.performSegue(withIdentifier: "mostrarPrograma", sender: nil )
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Usuario incorrecto. Verifique", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

