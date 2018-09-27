//
//  ActividadViewCell.swift
//  Programa
//
//  Created by Román Sánchez on 23/08/18.
//  Copyright © 2018 romansg. All rights reserved.
//

import UIKit
import EventKit

class ActividadViewCell: UITableViewCell {
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelPonente: UILabel!
    @IBOutlet weak var labelHora: UILabel!
    @IBOutlet weak var labelLugar: UILabel!
    @IBOutlet weak var labelTipoPonencia: UILabel!
    
    var fechaActividad: Date?
    
    @IBAction func botonAgendarTouch(_ sender: Any) {
        let titulo = self.labelTitulo.text
        let lugar = self.labelLugar.text
        
        let eventStore: EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted && (error == nil) {
                let event: EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = titulo
                event.location = lugar
                
                if let fecha = self.fechaActividad {
                    event.startDate = fecha
                    event.endDate = fecha
                }
                
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                   try eventStore.save(event, span: .thisEvent)
                } catch {
                   print("failed to save event with error : \(error) or access not granted")
                }
            } else {
                print("Event failed")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
