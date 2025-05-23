# ReadME

# Written after the end of the test 

## Architecture 

### Tech stack

SwiftUI/SPM/StrictConcurrency (Swift6 *though not tested but surely close to full compatibility*)

*I also implemented the feature with `existentialAny` in mind.*

### Micro app pattern

The entire feature in implemented inside a swift package. The idea is to make the feature reusable and easily testable. We could image implementing a sample app uniquely for this feature which would allow 
- Good SOC and isolation from the rest of the app
- Easy QA
- Increased velocity 

At scale we could imaging having meta packages such as 
- Design system 
- Shared components (reachability, location manager etc.)

At scale we would probably need some dependency injection which could be done through a dependency container with a configure SDK method for instance. 

### About the library

Implemented StoriesLibrary is divided into three targets. Only the main target is visible to the SDK user. The package is self contained integrating the entire feature stack. 
This pattern allows quick iterations and easy integration and testing thanks to physical isolation.  

The three targets are as follow: 
- StoriesUI: Implementation of all the UI and UI related logic (timer, prefetching etc.)
- StoriesCore: Implementation and definition of a Repository and a service. The repository (not implemented) would be responsible of holding any cached stories for instance. In our case it is simply an abstraction layer.
- Stories: The main target of the library. This is the meeting point of Core and UI to build a usable Screen by the end user. 

The UI target is designed to be easy to work with. It has no dependencies which allows for quick building times and blazing fast preview **leveraging SwiftUI previews power**. 
The core target follows the same logic, it builds quickly allowing quick and easy testing. This layer is easly testable with mocked data thanks to the service struct which takes easy to implement closures.

Event though no test is implemented it would be easy to do so since ViewModels and Repositories have DI mechanisms in place. I would basically test all the VMs, the repository and the cache layer (*AssetLoader**).

The pattern applied in the UI target resemble to **MVVM** yet with SwiftUI it is mostly a choice of convenience to avoid massive views.  

## Improvements 

### Bugs
- The story does not go to the next one automatically, I forgot to call a method and the VisualTimer handler. 

### UX
- Didn't have the time to implement iOS 18 zoom transition but it would have been a great addition in terms of UI. 
- When tapped rapidly transparent buttons in StoriesScreen some weird not satisfying behavior might occur. Easily fixable by disabling the button on `finishedWatching`
- Didn't had the time to properly implement the *send message feature* with the keyboard showing up in an unoptimized way. 

### Code
- I took a **major shortcut** implementing the `MockService`, I should have defined a service data model itself mapped to core model (business). Instead I made the core object `Codable` which saved me about 20 mins at the end of the test.
- Obviously, a lot of logic is involved in this test and thorough unit testing on key parts would be very important before shipping. 
- Prefetch scroll view has interesting APIs but it would need fine tuning and testing before production. It would for instance probably need a *cancel prefetch* call back (the same way its implemented in UITableView and UICollectionView). In our case it is not that bad, we want the assets anyway I believe plus the cache layer is sufficiently smart to call each URL once... 
-  More tidiness, a linter would have been a good addition here.  

### Features

- I did not had the time to implement the *seen* feature because I was missing time. I focused on finishing the implemented feature. Should I implement it I would ad a Bool value on StoryPage indicating `seen: Bool`, when all the pages would have been seen I would mark the story as seen. This would also allow automatic selection of the last *unseen* story page when opening the screen. (Same mechanism as the Id passed to the StoriesScreen)
