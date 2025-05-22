import SwiftUI

actor AssetLoader: ObservableObject {

    private var loadedAssets = NSCache<NSString, CacheEntryObject>()

    static let shared = AssetLoader()

    private init() {
        // ..
    }

    final private class CacheEntryObject {
        let entry: State
        init(entry: State) {
            self.entry = entry
        }
    }

    private enum State {
        case ready(Image)
        case process(Task<Image, any Error>)
    }

    func preloadAssets(for pages: [StoryPageAsset]) async throws {
        try await withThrowingTaskGroup { [weak self] group in
            guard let self else { return }
            for page in pages {
                group.addTask {
                    try await self.loadAsset(for: page)
                }
            }
            try await group.waitForAll()
        }
    }

    @discardableResult
    func loadAsset(for page: StoryPageAsset) async throws -> Image {
        if let loadingTask = loadedAssets.object(forKey: page.id.uuidString as NSString) {
            switch loadingTask.entry {
                case .ready(let image):
                    return image
                case .process(let task):
                    return try await task.value
            }
        } else {
            let task = Task {
                let (data, _) = try await URLSession.shared.data(from: page.mediaUrl)
                if let image = await UIImage(data: data)?.byPreparingForDisplay() {
                    return Image(uiImage: image)
                }
                throw NSError(domain: "failed to load", code: -1)
            }
            loadedAssets.setObject(CacheEntryObject(entry: .process(task)), forKey: page.id.uuidString as NSString)

            let image = try await task.value
            loadedAssets.setObject(CacheEntryObject(entry: .ready(image)), forKey: page.id.uuidString as NSString)

            return image
        }
    }
}
