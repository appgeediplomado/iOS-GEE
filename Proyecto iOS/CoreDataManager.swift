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
            print("TIENE CAMBIOS")
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

    //Traer los datos de todos los ponentes de la BD
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
    
    
    
    //DATOS DE LOS PONENTES
    final let urlStringPonentes = "https://my.api.mockaroo.com/ponentes.json?key=baa58550"

    func cargaDatosPonentes () {
print("En caragar datos")
        if let urljson = URL(string:urlStringPonentes) {
print("if let urlJson")
            Alamofire.request(urljson).responseJSON { (response) in
                //let tmp = response.result.value as! [String:Any]
                let tmp = response.result.value as! [Any]
print(tmp)
                if let jsonArray = tmp as? [[String:Any]] {
                    //if let jsonArray = tmp["response"] as? [Any] {
print(jsonArray)
                    for persona:[String:Any] in jsonArray {
                        
                        //let pId = Int16((persona["fugitiveID"] as? Int) ?? 0)
                        //if !(self.existeRegistro(conId: pId)) {
                        
                        let r:Ponente = NSEntityDescription.insertNewObject(forEntityName:"Ponente", into:self.persistentContainer.viewContext) as! Ponente
                        r.id = Int16((persona["id"] as? NSNumber) ?? 0)
                        r.nombre = (persona["nombre"] as? String) ?? ""
                        r.descripcion = (persona["descripcion"] as? String) ?? ""
                        r.biodata = (persona["biodata"] as? String) ?? ""
                        
                        //}
                    }
                    self.saveContext()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kNuevosDatos"), object: nil)
                }
            }
        }
    }
}
