//
//  GroupViewManager.swift
//  MoneyLover
//
//  Created by xhieu21 on 10/04/2023.
//

import UIKit

class GroupViewManager {
	var groupItems: [[TransactionGroup]?] = []
	
	init() {
		groupItems = convertTo2DArray(groups: getAllGroup())
	}

}

//MARK: - Methods
extension GroupViewManager {
	private func getAllGroup() -> [TransactionGroup] {
		let result: [TransactionGroup] = RealmManager.getAllGroupsAndSort()
		return result
	}

	private func convertTo2DArray(groups: [TransactionGroup]) -> [[TransactionGroup]?] {
		var result: [[TransactionGroup]?] = []
		var subArray: [TransactionGroup] = []
		var firstGroup: TransactionGroup = groups[0]
		for group in groups {
			if group.groupType == firstGroup.groupType {
				subArray.append(group)
			} else {
				result.append(subArray)
				subArray = [group]
				firstGroup = group
			}
		}
		result.append(subArray)
		return result
	}

	func handleDeleteTransactionGroup(group: TransactionGroup) -> Bool {
		guard (group.canDelete ?? false) else { return false}
		let result = RealmManager.delete(object: group)
		return result
	}
}
