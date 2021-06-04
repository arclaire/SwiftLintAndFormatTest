//
//  CellTableSearchSymbol.swift
//  CyAlphaVantage
//
//  Created by Lucy on 17/01/21.
//

import UIKit

class CellTableSearchSymbol: UITableViewCell {
	@IBOutlet private var labelSymbolDetail: UILabel!
	@IBOutlet private var labelSymbol: UILabel!
	override func awakeFromNib() {
		super.awakeFromNib()
		selectionStyle = .none
		// Initialization code
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}

	func displayData(data: ModelSymbol) {
		labelSymbol.text = data.symbol
		labelSymbolDetail.text = data.name
	}
}
