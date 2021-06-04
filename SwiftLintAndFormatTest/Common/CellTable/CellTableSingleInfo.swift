//
//  CellTableSingleInfo.swift
//  CyAlphaVantage
//
//  Created by Lucy on 15/01/21.
//

import UIKit

class CellTableSingleInfo: UITableViewCell {
	@IBOutlet private var labelValueLow: UILabel!
	@IBOutlet private var labelValueHigh: UILabel!
	@IBOutlet private var labelValueOpen: UILabel!

	@IBOutlet private var labelHour: UILabel!
	@IBOutlet private var labelDate: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		selectionStyle = .none
	}

	func displayData(data: ModelSymbolDetail) {
		selectionStyle = .none
		if DataManager.shared.isDaily {
			labelDate.text = data.formatDate2()
			labelHour.text = ""
		} else {
			labelDate.text = data.formatDate()
			labelHour.text = data.formatHour()
		}

		labelValueLow.text = data.low
		labelValueHigh.text = data.high
		labelValueOpen.text = data.open
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}
}
