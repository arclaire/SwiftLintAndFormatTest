//
//  WfScreen1.swift
//  CyAlphaVantage
//
//  Created by Lucy on 15/01/21.
//

import Foundation
import UIKit
class WfScreen1: NSObject {
	var vc: VCScreen1?
	var wfRoot: WFRoot?

	var presenter: PScreen1?

	func presentVC(fromVC _: UIViewController) {}

	func initiateVC() -> VCScreen1 {
		let storyboard = UIStoryboard.getMainStoryboard()
        if let viewController = storyboard.instantiateViewController(withIdentifier: ID_VC_SCREEN1) as? VCScreen1 {
            viewController.presenter = presenter
            presenter?.vc = viewController
            vc = viewController
            return viewController
        }
        return VCScreen1()
	}

	func presentVCToWindow(_ window: UIWindow) {
		let viewController = initiateVC()
		wfRoot?.showRootViewController(viewController, inWindow: window)
	}

	func navigateToScreen2(model1 _: [ModelSymbolDetail]) {
	}

	func navigateToScreen3() {
	}

	func displayAlert(title: String? = nil, message: String? = nil) {
		var titleString = "Error"
		var messageString = message
		guard let strTitle = title else {
            return
		}
        guard let strmessage = message else {
           return
        }

        titleString = strTitle
        messageString = strmessage

		let alertController = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in

			// refetch data

		}))
		// self.vc?.present(alertController, animated: true, completion: nil)
	}
}