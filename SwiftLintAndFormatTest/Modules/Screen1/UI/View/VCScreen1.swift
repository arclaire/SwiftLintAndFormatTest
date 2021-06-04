//
//  VCScreen1.swift
//  CyAlphaVantage
//
//  Created by Lucy on 15/01/21.
//

import UIKit

class VCScreen1: UIViewController {
	@IBOutlet private var viewNoData: UIView!
	@IBOutlet private var searchBar: UISearchBar!
	@IBOutlet private var viewContainer: UIView!
	@IBOutlet private var btnCompare: UIButton!
	@IBOutlet private var btnSettings: UIButton!

	@IBOutlet private var viewBlur: UIVisualEffectView!
	@IBOutlet private var table: UITableView!

	@IBOutlet private var tableSearch: UITableView!

	@IBOutlet private var activitySearch: UIActivityIndicatorView!
	@IBOutlet private var activity: UIActivityIndicatorView!

	@IBOutlet private var consTableBottomToSuperview: NSLayoutConstraint!
	var presenter: PScreen1?
	override func viewDidLoad() {
		super.viewDidLoad()
		searchBar.delegate = self
		registerKeyboardNotifications()
		setupTableView()
		presenter?.loadDataSymbolDetail(str: "IBM")

		let array = [
			"a",
			"b",
			"c", "d"
		]
		// Do any additional setup after loading the view.
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}

	@IBAction private func actionButton(_ sender: Any) {
		if let btn = sender as? UIButton {
			if btn == btnCompare {
				goToCompare()
			}

			if btn == btnSettings {
				goToSettings()
			}
		}
	}

	private func goToCompare() {
		presenter?.navigateToCompare()
	}

	private func goToSettings() {
		presenter?.navigateToSettings()
	}

	private func setupTableView() {
		let nibToRegister = UINib(nibName: String(describing: CellTableSingleInfo.self), bundle: nil)
		table.register(nibToRegister, forCellReuseIdentifier: String(describing: CellTableSingleInfo.self))

		table.delegate = self
		table.dataSource = self
		table.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
		table.separatorInset = .zero

		table.contentInsetAdjustmentBehavior = .never
		table.contentOffset = CGPoint.zero

		let nibToRegister2 = UINib(nibName: String(describing: CellTableSearchSymbol.self), bundle: nil)
		tableSearch.register(nibToRegister2, forCellReuseIdentifier: String(describing: CellTableSearchSymbol.self))

		tableSearch.delegate = self
		tableSearch.dataSource = self
		tableSearch.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
		tableSearch.separatorInset = .zero

		tableSearch.contentOffset = CGPoint.zero
		tableSearch.isHidden = true
	}

	func displayLoading(isLoading: Bool) {
		tableSearch.isHidden = true
		if isLoading {
			viewBlur.isHidden = false
			activity.startAnimating()
		} else {
			viewBlur.isHidden = true
			activity.stopAnimating()
		}

		viewNoData.isHidden = true
		if let data = presenter?.arrModel {
			if data.count < 1 {
				viewNoData.isHidden = false
			}
		}
	}

	func displayLoadingSearch(isLoading: Bool) {
		if isLoading {
			activitySearch.isHidden = false
			activitySearch.startAnimating()
		} else {
			activitySearch.isHidden = true
			activitySearch.stopAnimating()
		}
	}

	func reloadUI() {
		viewNoData.isHidden = false
		if let data = presenter?.arrModel {
			if !data.isEmpty {
				viewNoData.isHidden = true
				table.reloadData()
			}
		}
	}

	func reloadUISearch() {
		tableSearch.reloadData()
	}

	func registerKeyboardNotifications() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow(notification:)),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHide(notification:)),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}

	@objc func keyboardWillShow(notification: NSNotification) {
		guard let userInfo: NSDictionary = notification.userInfo as NSDictionary? else {
			return
		}

		if let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
			let keyboardSize = keyboardInfo.cgRectValue.size
			// let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 30, right: 0)
			consTableBottomToSuperview.constant = -keyboardSize.height
		}
	}

	@objc func keyboardWillHide(notification _: NSNotification) {
		consTableBottomToSuperview.constant = 0
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}

extension VCScreen1: UISearchBarDelegate {
	func searchBarCancelButtonClicked(_: UISearchBar) {
		tableSearch.isHidden = true
	}

	func searchBar(_: UISearchBar, shouldChangeTextIn _: NSRange, replacementText _: String) -> Bool {
		return true
	}

	func searchBar(_: UISearchBar, textDidChange searchText: String) {
		if !searchText.isEmpty {
			print("Call Services")
			tableSearch.isHidden = false
			presenter?.loadSearch(str: searchText)
		} else {
			tableSearch.isHidden = true
		}
	}
}

extension VCScreen1: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in _: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
		var intCount = 0
		if tableView == table {
			if let total = presenter?.arrModel.count {
				intCount = total
			}
		} else {
			if let total = presenter?.arrSymbol.bestMatches?.count {
				intCount = total
			}
		}

		return intCount
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if tableView == table {
			if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CellTableSingleInfo.self)) as? CellTableSingleInfo {
				if let data = presenter?.arrModel[indexPath.row] {
					cell.displayData(data: data)
					return cell
				}
			}
		} else {
			if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CellTableSearchSymbol.self)) as?
				CellTableSearchSymbol
			{
				if let data = presenter?.arrSymbol.bestMatches {
					cell.displayData(data: data[indexPath.row])
				}

				return cell
			}
		}
		return UITableViewCell()
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// self.eventHandler?.goToDetail(index: indexPath.row)
		if tableView == tableSearch {
			if let data = presenter?.arrSymbol.bestMatches {
				if let strSymbol = data[indexPath.row].symbol {
					print("Selected Symbol", strSymbol)
					presenter?.loadDataSymbolDetail(str: strSymbol) // loadSearch(str: data[indexPath.row].symbol!)
					searchBar.text = strSymbol
					searchBar.resignFirstResponder()
				}
			}
		}
	}

	func tableView(_ tableView: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
		var height: CGFloat = 0.0
		if tableView == table {
			if let pH = presenter?.heightTableRow {
				height = pH
			}
		} else {
			if let pH = presenter?.heightTableSearch {
				height = pH
			}
		}

		return height
	}
}
