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
            } catch {
                fatalError("No se pueden guardar los cambios a la BD \(error.localizedDescription)")
            }
        } else {
            print("NO TIENE CAMBIOS")
        }
    }

    // MARK: PONENTES
    
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
    
    // Agrega un registro de ponente al CoreData
    func insertaPonente(datos: [String:String]) -> Ponente {
        let ponente: Ponente = NSEntityDescription.insertNewObject(
            forEntityName: Constants.ENTITY_PONENTE,
            into: self.persistentContainer.viewContext) as! Ponente
        
        ponente.id = Int16(datos["id"] ?? "0")!
        ponente.nombre = datos["nombre"] ?? ""
        ponente.apellidos = datos["apellidos"] ?? ""
        ponente.institucion = datos["institucion"] ?? ""
        ponente.biodata = datos["biodata"] ?? ""

        return ponente
    }
    
    // Busca un ponente con id dado en CoreData
    func buscaPonente(conId: Int16) -> Ponente? {
        var datos: [Ponente]
        
        let fetch = NSFetchRequest<Ponente>(entityName:Constants.ENTITY_PONENTE)
        fetch.predicate = NSPredicate(format:"id == %d", conId)
        
        do {
            datos = try self.persistentContainer.viewContext.fetch(fetch)

            if (datos.count > 0) {
                return datos[0]
            }
        }
        catch {
            print("FALLO ALGO EN LA BD")
            //No funciona el fetch, podrían ser problemas con la conexión a la BD
        }

        return nil
    }
    
    func existeRegistroPonente(conId:Int16) -> Bool {
        var result: [Ponente] = []
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
        
    // MARK: PROGRAMA
    
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
    
    func insertaTrabajo(datos: [String:String]) {
        let trabajoId = Int16(datos["id"] ?? "0")!

        let trabajo: Trabajo = NSEntityDescription.insertNewObject(
            forEntityName: "Trabajo",
            into: self.persistentContainer.viewContext) as! Trabajo
        
        trabajo.id = trabajoId
        trabajo.titulo = datos["titulo"]
        trabajo.modalidad = datos["modalidad"]
        trabajo.nombrePonente = datos["nombrePonente"]
        trabajo.lugar = datos["lugar"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        trabajo.fecha = dateFormatter.date(from: datos["fecha"]!)
        
        trabajo.hora = datos["hora"]
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
