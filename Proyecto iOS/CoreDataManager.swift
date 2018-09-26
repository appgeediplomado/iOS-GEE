//
//  CoreDataManager.swift
//

import UIKit
import CoreData
import Alamofire

class CoreDataManager: NSObject {

    static let instance = CoreDataManager()
    
    let urlForDB = Utils.applicationDocumentsDirectory().appendingPathComponent(Constants.DB_NAME + ".sqlite")
    
    private override init() {
        super.init()
    }
    
    // MARK: - CoreData Stack
    // Implementación iOS 10 y posteriores
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name:Constants.DB_NAME)
        
        //Cambias la fuente de datos por un archivo sqlite precargado
//        let persistenStoreDesc = NSPersistentStoreDescription(url: urlForDB)
//        container.persistentStoreDescriptions = [persistenStoreDesc]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // Implementación iOS 9 y anteriores
    lazy var managedObjectContext:NSManagedObjectContext? = {
        var moc: NSManagedObjectContext?
        if #available(iOS 10.0, *){
            // Si es iOS 10 o posterior, los objetos NSManagedObjectModel y NSPersistentStoreCoordinator no son instanciados. En su lugar se instancia el objeto NSPersistentContainer que tiene un NSManagedObjectContext integrado, en su propiedad viewContext
            moc = self.persistentContainer.viewContext
        }
        else{
            // Si es iOS 9 o anterior, se deben instanciar los objetos NSManagedObjectModel y NSPersistentStoreCoordinator
            let persistence = self.persistentStore
            if persistence == nil {
                return nil
            }
            moc = NSManagedObjectContext(concurrencyType:.privateQueueConcurrencyType)
            moc?.persistentStoreCoordinator = persistence
        }
        return moc
    }()
    
    lazy var managedObjectModel:NSManagedObjectModel? = {
        let modelURL = Bundle.main.url(forResource:Constants.DB_NAME, withExtension: "momd")
        var model = NSManagedObjectModel(contentsOf: modelURL!)
        return model
    }()
    
    lazy var persistentStore:NSPersistentStoreCoordinator? = {
        let model = self.managedObjectModel
        if model == nil {
            return nil
        }
        let persist = NSPersistentStoreCoordinator(managedObjectModel: model!)
        do {
            let opcionesDePersistencia = [NSMigratePersistentStoresAutomaticallyOption:true, NSInferMappingModelAutomaticallyOption:true]
            try persist.addPersistentStore(ofType: NSSQLiteStoreType, configurationName:nil, at:urlForDB, options:opcionesDePersistencia)
        }
        catch {
            fatalError("No se puede abrir la BD \(error.localizedDescription)")
        }
        return persist
    }()
    
//    //Se verifica si ya había cargado los datos de la aplicación
//    func copyDataBaseIfNeeded(){
//        //print de prueba para saber en dónde quedó la BD
//        print(urlForDB.path)
//        if !(FileManager.default.fileExists(atPath:urlForDB.path)) {
//            // Obtener la ruta de la BD predeterminada
//            if let readOnlyPathURL = Bundle.main.url(forResource: Constants.DB_NAME, withExtension: "sqlite") {
//                // copiar a la ruta escribible
//                do {
//                    try FileManager.default.copyItem(at: readOnlyPathURL, to:urlForDB)
//                }
//                catch {
//                    fatalError("No se pudo copiar la BD prellenada \(error.localizedDescription)")
//                }
//            }
//        }
//    }
    
    func saveContext () {
        if (managedObjectContext?.hasChanges)! {
            do {
                try managedObjectContext?.save()
                print("GUARDO")
            } catch {
                print("ERROR AL GUARDAR")
                fatalError("No se pueden guardar los cambios a la BD \(error.localizedDescription)")
            }
        } else {
            print("NO TIENE CAMBIOS")
        }
    }

    // Traer los datos de todos los ponentes de la BD
    func allPonentes() -> [Ponente] {
        var result:[Ponente] = []
        
        let fetch = NSFetchRequest<Ponente>(entityName: "Ponente")
        
        do {
            result = try (managedObjectContext?.fetch(fetch))!
        }
        catch {
            print(error.localizedDescription)
        }

        return result
    }
    
    func existeRegistroPonente(conId:Int16) -> Bool {
        var result:[Ponente] = []
        let fetch = NSFetchRequest<Ponente>(entityName:Constants.ENTITY_PONENTE)
        let filtro = NSPredicate(format:"id == %d", conId)
        fetch.predicate = filtro
        
        do {
            result = try persistentContainer.viewContext.fetch(fetch)
        }
        catch {
            print("FALLO ALGO EN LA BD")
            //No funciona el fetch, podrían ser problemas con la conexión a la BD
        }
        
        return result.count > 0
    }
    
    //DATOS DE LOS PONENTES

    func cargaDatosPonentes () {
        if let urljson = URL(string:Constants.WS_PONENTES_URL) {
            Alamofire.request(urljson).responseJSON { (response) in
                // Prevenir el caso de que no haya conexión
                guard response.result.isSuccess else {
                    print("Error al tarer datos")
                    return
                }
                
                let tmp = response.result.value as! [String:Any]
                if let jsonArray = tmp["ponentes"] as? [[String:Any]] {
                    for persona:[String:Any] in jsonArray {
                        var pId:Int16 = 0
                        
                        if let nsid: String = persona["id"] as? String {
                            pId = Int16(nsid) ?? 0
                        }

                        if !self.existeRegistroPonente(conId: pId) {
                            let ponente:Ponente = NSEntityDescription.insertNewObject(
                                forEntityName: Constants.ENTITY_PONENTE,
                                into: self.persistentContainer.viewContext) as! Ponente

                            ponente.id = pId
                            ponente.nombre = (persona["nombre"] as? String) ?? ""
                            ponente.apellidos = (persona["apellidos"] as? String) ?? ""
                            ponente.institucion = (persona["institucion"] as? String) ?? ""
                            ponente.biodata = (persona["biodata"] as? String) ?? "Biodata DEFAULT de la Persona"
                        }
                    }
                    
                    self.saveContext()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NEW_DATA_MESSAGE), object: nil)
                }
            }
        }
    }
    
    func allTrabajos() -> [Trabajo] {
        var result: [Trabajo] = []
        let fetch = NSFetchRequest<Trabajo>(entityName: Constants.ENTITY_TRABAJO)
        
        do {
            result = try persistentContainer.viewContext.fetch(fetch)
        }
        catch {
            print(error.localizedDescription)
        }
        
        return result
    }
    
    func cargaTrabajos() {
        let headers: HTTPHeaders = [
            "Gee-Timestamp": "2018.09.26 13:16"
        ]
        
        if let urlJSON = URL(string: Constants.WS_TRABAJOS_URL) {
            Alamofire.request(urlJSON, headers:headers).responseJSON { (response) in
                guard response.result.isSuccess else {
                    print("Error al tarer datos")
                    return
                }

                let result = response.result.value as! [String:Any]
                
                if let trabajos = result["trabajos"] as? [[String:Any]] {
                    for datosTrabajo: [String:Any] in trabajos {
                        let trabajoId = Int16(datosTrabajo["id"] as! String)!
                        
                        if !self.existeTrabajo(conId: trabajoId) {
                            let trabajo: Trabajo = NSEntityDescription.insertNewObject(
                                forEntityName: "Trabajo",
                                into: self.persistentContainer.viewContext) as! Trabajo
                            
                            trabajo.id = trabajoId
                            trabajo.titulo = datosTrabajo["titulo"] as? String
                            trabajo.modalidad = datosTrabajo["modalidad"] as? String
                            trabajo.nombrePonente = datosTrabajo["nombrePonente"] as? String
                            trabajo.lugar = datosTrabajo["lugar"] as? String
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            trabajo.fecha = dateFormatter.date(from: datosTrabajo["fecha"] as! String)
                            
                            trabajo.hora = datosTrabajo["hora"] as? String
                        }
                    }

                    self.saveContext()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NEW_DATA_MESSAGE), object: nil)
                }
            }
        }
    }
    
    func existeTrabajo(conId: Int16) -> Bool {
        var result: [Trabajo] = []
        
        let fetch = NSFetchRequest<Trabajo>(entityName: Constants.ENTITY_TRABAJO)
        fetch.predicate = NSPredicate(format: "id == %d", conId)
        
        do {
            result = try persistentContainer.viewContext.fetch(fetch)
        } catch {
            print("Error al acceder a la BD")
        }
        
        return result.count > 0
    }
}
