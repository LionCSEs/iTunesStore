//
//  MediaInfo.swift
//  iTunesStore
//
//  Created by 김우성 on 8/4/25.
//

struct MediaInfo: Hashable {
    let title: String
    let subtitle: String
    let collectionTitle: String
    let imageUrl: String?
    let description: String?
    let mediaType: String
}

extension MediaInfo {
    static func from(_ music: Music) -> MediaInfo {
        return MediaInfo(
            title: music.trackName ?? "제목 없음",
            subtitle: music.artistName ?? "아티스트 없음",
            collectionTitle: music.collectionName ?? "앨범 없음",
            imageUrl: music.artworkUrl100?.replacingOccurrences(of: "100x100bb.jpg", with: "600x600bb.jpg"),
            description: nil,
            mediaType: "음악"
        )
    }
    
    static func from(_ movie: Movie) -> MediaInfo {
        return MediaInfo(
            title: movie.trackName ?? "제목 없음",
            subtitle: movie.artistName ?? "감독 없음",
            collectionTitle: movie.collectionName ?? "시리즈 없음",
            imageUrl: movie.artworkUrl100?.replacingOccurrences(of: "100x100bb.jpg", with: "600x600bb.jpg"),
            description: movie.longDescription,
            mediaType: "영화"
        )
    }
    
    static func from(_ podcast: Podcast) -> MediaInfo {
        return MediaInfo(
            title: podcast.trackName ?? "제목 없음",
            subtitle: podcast.artistName ?? "아티스트 없음",
            collectionTitle: podcast.collectionName ?? "시리즈 없음",
            imageUrl: podcast.artworkUrl100?.replacingOccurrences(of: "100x100bb.jpg", with: "600x600bb.jpg"),
            description: nil,
            mediaType: "팟캐스트"
        )
    }
}
