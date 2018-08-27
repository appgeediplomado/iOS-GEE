//
//  ActividadViewCell.swift
//  Programa
//
//  Created by Román Sánchez on 23/08/18.
//  Copyright © 2018 romansg. All rights reserved.
//

import UIKit

class ActividadViewCell: UITableViewCell {
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelPonente: UILabel!
    @IBOutlet weak var labelHora: UILabel!
    @IBOutlet weak var labelLugar: UILabel!
    @IBOutlet weak var labelTipoPonencia: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
