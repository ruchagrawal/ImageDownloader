//
//  ImageDownloaderApp.swift
//  ImageDownloader
//
//  Created by Ruchi Agrawal on 7/18/25.
//

import SwiftUI

@main
struct ImageDownloaderApp: App {
    var body: some Scene {
        WindowGroup {
          ImageListViewFactory().makeImageListView()
        }
    }
}
