//
//  SearchItem.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import Foundation

struct SearchItem: Hashable {
    let item: Media
    let section: SearchSection
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(item.trackId)
    }
    
    static func == (lhs: SearchItem, rhs: SearchItem) -> Bool {
        lhs.item.trackId == rhs.item.trackId
    }
}
