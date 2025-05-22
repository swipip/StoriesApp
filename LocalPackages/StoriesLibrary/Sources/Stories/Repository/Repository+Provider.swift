import Foundation
import StoriesUI
import StoriesCore

extension StoriesRepository: StoriesProvider {

    package func setStoryLiked(liked: Bool, storyId: UUID, pageId: UUID) async throws {
        try await updateStoryLiked(liked: liked, storyId: storyId, pageId: pageId)
    }

    package func loadStories() async throws -> [StoryViewData] {
        try await getStories().map(\.toViewData)
    }
}

extension StoryModel {
    var toViewData: StoryViewData {
        StoryViewData(id: id, index: index, user: user.toViewData, pages: pages.map(\.toViewData))
    }
}

extension UserModel {
    var toViewData: UserViewData {
        UserViewData(
            id: id,
            name: username,
            avatarURL: profileImageURL,
            isApproved: isApproved,
            communication: communication,
            postedSince: postedSince
        )
    }
}

extension PageModel {
    var toViewData: StoryPageViewData {
        StoryPageViewData(id: id, index: index, asset: asset.toViewData, displayDuration: displayDuration, liked: liked)
    }
}

extension AssetModel {
    var toViewData: StoryPageAsset {
        StoryPageAsset(id: id, mediaUrl: mediaUrl)
    }
}
