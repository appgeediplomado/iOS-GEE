//
//  ServerDataManager.swift
//  Proyecto iOS
//
//  Created by Román Sánchez on 27/09/18.
//  Copyright © 2018 App Gee. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ServerDataManager: NSObject {
    static let instance = ServerDataManager()
    var coreDataManager: CoreDataManager
    
    private override init() {
        self.coreDataManager = CoreDataManager.instance
        super.init()
    }

    // MARK: PONENTES
    
    func cargaDatosPonentes () {
        if let urljson = URL(string:Constants.WS_PONENTES_URL) {
            Alamofire.request(urljson).responseJSON { (response) in
                // Prevenir el caso de que no haya conexión
                guard response.result.isSuccess else {
                    print("Error al traer datos")
                    return
                }
                
                let tmp = response.result.value as! [String:Any]
                if let jsonArray = tmp["ponentes"] as? [[String:String]] {
                    for persona:[String:String] in jsonArray {
                        var pId:Int16 = 0
                        
                        if let nsid: String = persona["id"] {
                            pId = Int16(nsid) ?? 0
                        }
                        
                        if !self.coreDataManager.existeRegistroPonente(conId: pId) {
                            _ = self.coreDataManager.insertaPonente(datos: persona)
                        }
                    }
                    
                    self.coreDataManager.saveContext()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.DATA_NUEVOS_PONENTES), object: nil)
                }
            }
        }
    }
    
    /**
     * Carga detalles de un ponente desde el servidor. Si el ponente ya existe localmente,
     * actualiza los datos. En caso contrario, inserta un nuevo registro local.
     */
    func cargaDetallesPonente(conId: Int16) {
        let urlJSON = Constants.WS_DETALLES_PONENTE_URL + String(conId);
        
        Alamofire.request(urlJSON).responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error al traer datos")
                return
            }
            
            let result = response.result.value as! [String:Any]
            
            if let datosPonente = result["datos"] as? [String:String] {
                if let ponente = self.coreDataManager.buscaPonente(conId: conId) {
                    // ponente.id = Int16(datosPonente["id"] ?? "0")!
                    ponente.nombre = datosPonente["nombre"]
                    ponente.apellidos = datosPonente["apellidos"]
                    ponente.institucion = datosPonente["institucion"]
                    ponente.biodata = datosPonente["biodata"]
                    ponente.datosCompletos = true
                } else {
                    _ = self.coreDataManager.insertaPonente(datos: datosPonente)
                }
                
                self.coreDataManager.saveContext()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.DATA_DETALLES_PONENTE), object: nil)
            }
        }
    }
    
    // MARK: PROGRAMA
    
    func cargaTrabajos() {
        Alamofire.request(Constants.WS_TRABAJOS_URL).responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error al traer datos")
                return
            }
            
            let result = response.result.value as! [String:Any]
            
            if let trabajos = result["trabajos"] as? [[String:String]] {
                for datosTrabajo: [String:String] in trabajos {
                    let trabajoId = Int16(datosTrabajo["id"] ?? "0")!
                    
                    if !self.coreDataManager.existeTrabajo(conId: trabajoId) {
                        self.coreDataManager.insertaTrabajo(datos: datosTrabajo)
                    }
                }
                
                self.coreDataManager.saveContext()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.DATA_NUEVOS_TRABAJOS), object: nil)
            }
        }
    }
    
    /**
     * Carga detalles de un trabajo desde el servidor. Si el trabajo ya existe localmente,
     * actualiza los datos. En caso contrario, inserta un nuevo registro local.
     */
    func cargaDetallesTrabajo(conId: Int16) {
        let urlJSON = Constants.WS_DETALLES_TRABAJO_URL + String(conId);
        
        Alamofire.request(urlJSON).responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error al traer datos")
                return
            }
            
            let result = response.result.value as! [String:Any]
            
            if let datos = result["datos"] as? [String:String] {
                if let trabajo = self.coreDataManager.buscaTrabajo(conId: conId) {
                    trabajo.titulo = datos["titulo"]
                    trabajo.modalidad = datos["modalidad"]
                    trabajo.nombrePonente = datos["ponente"]
                    trabajo.sinopsis = datos["sinopsis"]
                    trabajo.datosCompletos = true
                } else {
                    _ = self.coreDataManager.insertaTrabajo(datos: datos)
                }
                
                self.coreDataManager.saveContext()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.DATA_DETALLES_TRABAJO), object: nil)
            }
        }
    }
    
    // MARK: RETROALIMENTACIÓN
    
    /*
     * Manda la retroalimentación de una ponencia al servidor
     * En caso exitoso inserta la evaluación localmente
     */
    func evaluarTrabajo(asistenteId: Int16, trabajoId: Int16, evaluacion: Evaluacion) {
        let urlJSON = String(format: Constants.WS_RETROALIMENTACION_URL, asistenteId, trabajoId)
        var parametros: [String:Int16] = [:]
        
        parametros["ponencia"] = evaluacion.ponencia
        parametros["ponente"] = evaluacion.ponente
        parametros["relevancia"] = evaluacion.relevancia
        
        Alamofire.request(urlJSON, method: .post, parameters: parametros).responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error al traer datos")
                return
            }

            self.coreDataManager.insertaRetroalimentacion(trabajoId: trabajoId, evaluacion: evaluacion)
            self.coreDataManager.saveContext()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.DATA_RETROALIMENTACION), object: nil)
        }
    }
}
