//
//  UserDefaults.swift
//  Proyecto iOS
//
//  Created by Luis Vázquez on 9/27/18.
//  Copyright © 2018 App Gee. All rights reserved.
//
extension UserDefaults{
    
    enum UserDefaultsKeys : String {
        case sesionIniciada
        case usuarioID
    }
    //MARK: Registrar sesión
    func setSesion(value: Bool)
    {
        set(value, forKey:UserDefaultsKeys.sesionIniciada.rawValue)
        synchronize()
    }
    
    func sesionIniciada()-> Bool{
        return bool(forKey:UserDefaultsKeys.sesionIniciada.rawValue)
    }
    
    //MARK: Guardar datos del usuario
    func setUsuarioID(value: Int){
        set(value, forKey: UserDefaultsKeys.usuarioID.rawValue)
        synchronize()
    }
    
    func getUsuarioID() -> Int{
        return integer(forKey: UserDefaultsKeys.usuarioID.rawValue)
    }
}


