//
//  UIViewController.swift
//  Proyecto iOS
//
//  Created by Román Sánchez on 28/09/18.
//  Copyright © 2018 App Gee. All rights reserved.
//

import Foundation

/**
 * Extensión para facilitar los avisos y mensajes de error
 */
extension UIViewController {
    private func mensaje(titulo: String, texto: String) {
        let alert = UIAlertController(title: titulo, message: texto, preferredStyle: .alert)
        let action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    public func aviso(texto: String) {
        mensaje(titulo: "AVISO", texto: texto)
    }
    
    public func error(texto: String) {
        mensaje(titulo: "ERROR", texto: texto)
    }
}
