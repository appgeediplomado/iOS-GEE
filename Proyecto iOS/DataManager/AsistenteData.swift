//
//  AsistenteData.swift
//  Proyecto iOS
//
//  Created by Luis Vázquez on 9/27/18.
//  Copyright © 2018 App Gee. All rights reserved.
//

import UIKit
import Alamofire

class AsistenteData {
    static let instance = AsistenteData()
    var registroAsistencia:[String] = []
    
    //MARK: SESIÓN ASISTENTE
    /**
     * Validar si el asistente está registrado
     * Se realiza una consulta al WS para verificar si el usuario existe
     * Si el correo existe se guarda en UserDefaults el ID del asistente y
     * una variable boleana en true (sesionIniciada) que define la sesión iniciada
     */
    func validarAsistente(correoUsuario: String, passUsuario: String) {
        let urlJSON = Constants.WS_SESION_URL + correoUsuario
        
        Alamofire.request(urlJSON).responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error al traer datos de usuario")
                return
            }
            
            let result = response.result.value as! [String:Any]
            
            if let datosAsistente = result["asistente"] as? [String:String] {
                let asistenteId = Int(datosAsistente["id"] ?? "0")!
                let asistentePass = datosAsistente["password"]
                
                if asistenteId != 0 && passUsuario == asistentePass {
                    UserDefaults.standard.setSesion(value: true )
                    UserDefaults.standard.setUsuarioID(value: asistenteId)
                    UserDefaults.standard.setUsuarioNombre(value: datosAsistente["nombre"]!+" "+datosAsistente["apellidos"]!)
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.DATA_SESION_ASISTENTE), object: nil)
        }
    }
    
    func bitacoraAsistencia(){
        
        registroAsistencia.removeAll()
        let urlJSON = Constants.WS_BITACORA_ASISTENCIA_URL + String(getAsistenteID()) + "/bitacora"
        Alamofire.request(urlJSON).responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error al traer la bitacora de asistencia")
                return
            }
            
            let result = response.result.value as! [String:Any]
            
            if let asistencias = result["asistencias"] as? [String] {
                for fecha:String in asistencias {
                    self.registroAsistencia.append(fecha)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.DATA_ASISTENTE_BITACORA), object: nil)
            }
        }
    }
            
    func existeSesionAsistente() -> Bool{
        return UserDefaults.standard.sesionIniciada()
    }
    
    func getAsistenteID() -> Int {
        return UserDefaults.standard.getUsuarioID()
    }
    
    func getAsistenteNombre() -> String {
        return UserDefaults.standard.getUsuarioNombre()!
    }
    func getRegistroAsistencia() -> [String]{
        return registroAsistencia
    }
}
