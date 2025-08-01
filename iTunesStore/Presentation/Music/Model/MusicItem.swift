//
//  MusicItem.swift
//  iTunesStore
//
//  Created by estelle on 8/1/25.
//

import Foundation

struct MusicItem: Hashable {
    let music: Media
    let section: MusicSection
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(music.trackId)
        hasher.combine(section.rawValue)
    }
    
    static func == (lhs: MusicItem, rhs: MusicItem) -> Bool {
        lhs.music.trackId == rhs.music.trackId &&
        lhs.section == rhs.section
    }
}
