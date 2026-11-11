//
//  PacketViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 1.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class PacketsViewModel: BaseListViewModel<BagelPacket>  {
    
    var addressFilterTerm = "" {
        didSet {
            self.refreshItems()
        }
    }
    
    var methodFilterTerm = "" {
        didSet {
            self.refreshItems()
        }
    }
    
    var statusFilterTerm = "" {
        didSet {
            self.refreshItems()
        }
    }
    
    private var allPackets: [BagelPacket] {
        return BagelController.shared.selectedProjectController?.selectedDeviceController?.packets ?? []
    }
    
    
    func register() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: BagelNotifications.didGetPacket, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: BagelNotifications.didUpdatePacket, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: BagelNotifications.didSelectProject, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: BagelNotifications.didSelectDevice, object: nil)
    }
    
    var selectedItem: BagelPacket? {
        return BagelController.shared.selectedProjectController?.selectedDeviceController?.selectedPacket
    }
    
    var selectedItemIndex: Int? {
        guard let selectedItem = self.selectedItem else { return nil }
        
        return self.items.firstIndex { $0 === selectedItem }
    }
    
    @objc func refreshItems() {
        items = filter(items: allPackets)
        onChange?()
    }
    
    func filter(items: [BagelPacket]) -> [BagelPacket] {
        let isAddressFiltering = addressFilterTerm.count > 0
        let isMethodFiltering = methodFilterTerm.count > 0
        let isStatusFiltering = statusFilterTerm.count > 0
        
        guard isAddressFiltering || isMethodFiltering || isStatusFiltering else {
            return items
        }
        
        // Cache lowercased method filter and whitespace checks to avoid O(n) recomputations
        let lowercasedMethodFilter = isMethodFiltering ? methodFilterTerm.lowercased() : ""
        let isStatusWhitespaceOnly = isStatusFiltering ? statusFilterTerm.trimmingCharacters(in: .whitespaces).isEmpty : false
        
        // Combine 3 filter loops into 1 to reduce array allocations and iteration overhead
        return items.filter { item in
            if isAddressFiltering {
                guard item.requestInfo?.url?.contains(self.addressFilterTerm) ?? true else { return false }
            }

            if isMethodFiltering {
                guard item.requestInfo?.requestMethod?.rawValue.lowercased().contains(lowercasedMethodFilter) ?? true else { return false }
            }

            if isStatusFiltering {
                if isStatusWhitespaceOnly {
                    guard item.requestInfo?.statusCode?.trimmingCharacters(in: .whitespaces).isEmpty ?? true else { return false }
                } else {
                    guard item.requestInfo?.statusCode?.contains(self.statusFilterTerm) ?? false else { return false }
                }
            }

            return true
        }
    }
    
    func clearPackets() {
        BagelController.shared.selectedProjectController?.selectedDeviceController?.clear()
        self.refreshItems()
    }
}
