//
//  Constants.swift
////

import UIKit

class Constants: NSObject {
    static let DB_NAME = "Proyecto_iOS"
    
    // Notificaciones de datos del servidor
    static let NEW_DATA_MESSAGE = "kNuevosDatos"
    static let DATA_NUEVOS_PONENTES = "kNuevosPonentes"
    static let DATA_NUEVOS_TRABAJOS = "kNuevosTrabajos"
    static let DATA_DETALLES_PONENTE = "kDetallesPonente"
    static let DATA_DETALLES_TRABAJO = "kDetallesTrabajo"
    
    // Ponentes
    static let PONENTE_CELL_HEIGHT:CGFloat = 80.0
    static let PONENTE_IMAGE_SIZE:CGFloat = 40.0
    
    // Rutas de servicios web
    static let WS_PONENTES_URL = "http://roman.cele.unam.mx/wsgee/ponentes"
    static let WS_DETALLES_PONENTE_URL = "http://roman.cele.unam.mx/wsgee/ponentes/"
    static let WS_TRABAJOS_URL = "http://roman.cele.unam.mx/wsgee/trabajos"
    static let WS_DETALLES_TRABAJO_URL = "http://roman.cele.unam.mx/wsgee/trabajos/"
    
    // Nombre de entidades de CoreData
    static let ENTITY_PONENTE = "Ponente"
    static let ENTITY_TRABAJO = "Trabajo"
}
