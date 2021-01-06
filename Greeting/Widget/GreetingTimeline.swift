//
//  GreetingTimeline.swift
//  GreetingWidget
//
//  Created by mac-00021 on 30/09/20.
//

import WidgetKit
import SwiftUI
import Kingfisher

struct GreetingTimeline: TimelineProvider {
    
    typealias Entry = GreetingEntryModel
    
    /// Required Methods
    
    func placeholder(in context: Context) -> GreetingEntryModel {
        
        Entry(date: Date(), imageKey: "")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (GreetingEntryModel) -> Void) {
        
        let entry = Entry(date: Date(), imageKey: "")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<GreetingEntryModel>) -> Void) {
        
        var entries: [Entry] = []
        let currentDate = Date()
        let refreshTime = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!

        var resource = [ImageResource]()
        
        for hoursOffset in 0..<24 {
            
            guard let entryDate = Calendar.current.date(byAdding: .hour, value: hoursOffset, to: currentDate) else {
                return
            }

            let imageKey = "kf-image-\(hoursOffset)"
            let entry = Entry(date: entryDate, imageKey: imageKey)
            entries.append(entry)

            resource.append(ImageResource(downloadURL: URL(string: "https://picsum.photos/1080/620")!, cacheKey: imageKey))
        }

        ImagePrefetcher(resources: resource, options: [.forceRefresh], completionHandler: { _, _, _ in
            let timeLine = Timeline(entries: entries, policy: .after(refreshTime))
            print("Timeline done.")
            completion(timeLine)
        }).start()
        print("Start Prefetching...")
    }
}
