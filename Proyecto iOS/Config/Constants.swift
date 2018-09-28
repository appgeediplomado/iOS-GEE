//
//  Constants.swift
////

import UIKit

class Constants: NSObject {
    static let DB_NAME = "Proyecto_iOS"
    static let NEW_DATA_MESSAGE = "kNuevosDatos"
    static let DATA_NUEVOS_PONENTES = "kNuevosPonentes"
    static let DATA_NUEVOS_TRABAJOS = "kNuevosTrabajos"
    static let DATA_DETALLES_PONENTE = "kDetallesPonente"
    static let DATA_SESION_ASISTENTE = "kSesionAsistente"
    
    //Ponentes
    static let PONENTE_CELL_HEIGHT:CGFloat = 80.0
    static let PONENTE_IMAGE_SIZE:CGFloat = 40.0
    
    static let WS_PONENTES_URL = "http://roman.cele.unam.mx/wsgee/ponentes"
    static let WS_DETALLES_PONENTES_URL = "http://roman.cele.unam.mx/wsgee/ponentes/"
    static let WS_TRABAJOS_URL = "http://roman.cele.unam.mx/wsgee/trabajos"
    
    //Asistente
    static let WS_SESION_URL = "http://roman.cele.unam.mx/wsgee/asistentes/sesion/"
    
    static let ENTITY_PONENTE = "Ponente"
    static let ENTITY_TRABAJO = "Trabajo"
}
