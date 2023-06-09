//
//  TransactionHistoryController.swift
//  MoneyLover
//
//  Created by xhieu21 on 13/04/2023.
//

import UIKit
import TYPagerController

class TransactionHistoryController: UIViewController {

	@IBOutlet weak var accountBalanceLabel: UILabel!
	@IBOutlet weak var tabBarView: UIView!
	@IBOutlet weak var pagerView: UIView!

	lazy var tabBar = TYTabPagerBar()
	lazy var pagerController = TYPagerController()
	let transactionHistoryManager = TransactionHistoryManager()

	//MARK: - LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		accountBalanceLabel.text = transactionHistoryManager.curentAmount.formatMoneyNumber()
		configTabBar()
		configPagerController()
		NotificationCenter.default.addObserver(self, selector: #selector(updateAccountBalance), name: .changedAmount, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateAccountBalance), name: .deletedTransaction, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateAccountBalance), name: .createdNewTransaction, object: nil)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tabBar.frame = CGRect(x: 0.0, y: 0.0, width: tabBarView.frame.width, height: tabBarView.frame.height)
		pagerController.view.frame = CGRect(x: 0, y: 0, width: pagerView.frame.width, height: pagerView.frame.height)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		pagerController.scrollToController(at: transactionHistoryManager.indexOfThisMonth, animate: true)
	}

	//MARK: - Methods
	@objc private func updateAccountBalance() {
		accountBalanceLabel.text = transactionHistoryManager.curentAmount.formatMoneyNumber()
	}

	private func configTabBar() {
		tabBar.delegate = self
		tabBar.dataSource = self
		tabBar.layout.barStyle = .progressView
		tabBar.layout.progressColor = Theme.shared.primaryColor
		tabBar.layout.normalTextColor = .systemGray
		tabBar.layout.selectedTextColor = Theme.shared.primaryColor
		tabBar.register(TYTabPagerBarCell.classForCoder(), forCellWithReuseIdentifier: TYTabPagerBarCell.identifier)
		tabBarView.addSubview(tabBar)
		tabBar.reloadData()
	}

	private func configPagerController() {
		pagerController.delegate = self
		pagerController.dataSource = self
		pagerView.addSubview(pagerController.view)
	}

	@IBAction func buttonSearchAction(_ sender: Any) {
		let searchVC = SearchTransactionHistoryVC()
		present(searchVC, animated: true, completion: nil)
	}
}

//MARK: - Conform TYTabPagerBarDelegate, TYTabPagerBarDataSource
extension TransactionHistoryController: TYTabPagerBarDelegate, TYTabPagerBarDataSource {
	func numberOfItemsInPagerTabBar() -> Int {
		return transactionHistoryManager.months.count
	}

	func pagerTabBar(_ pagerTabBar: TYTabPagerBar, cellForItemAt index: Int) -> UICollectionViewCell & TYTabPagerBarCellProtocol {
		let cell = tabBar.dequeueReusableCell(withReuseIdentifier: TYTabPagerBarCell.identifier, for: index)
		cell.titleLabel.text = transactionHistoryManager.months[index].nameOfTwentyMonths()
		return cell
	}

	func pagerTabBar(_ pagerTabBar: TYTabPagerBar, widthForItemAt index: Int) -> CGFloat {
		return tabBar.frame.width / 3
	}

	func pagerTabBar(_ pagerTabBar: TYTabPagerBar, didSelectItemAt index: Int) {
		pagerController.scrollToController(at: index, animate: true)
	}

}

//MARK: - Conform TYPagerControllerDataSource, TYPagerControllerDelegate
extension TransactionHistoryController: TYPagerControllerDataSource, TYPagerControllerDelegate {
	func numberOfControllersInPagerController() -> Int {
		return transactionHistoryManager.months.count
	}

	func pagerController(_ pagerController: TYPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
		let vc = TransactionsInMonthVC()
		vc.transactionsInMonthManager.month = transactionHistoryManager.months[index]
		return vc
	}

	func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, animated: Bool) {
		self.tabBar.scrollToItem(from: fromIndex, to: toIndex, animate: animated)
	}

	func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, progress: CGFloat) {
		self.tabBar.scrollToItem(from: fromIndex, to: toIndex, progress: progress)
	}
}
