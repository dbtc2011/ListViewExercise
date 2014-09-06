//
//  ImageDownloader.h
//  ListViewExercise
//
//  Created by Mark Angeles on 9/5/14.
//  Copyright (c) 2014 Chua's Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageDownloaderDelegate;

@interface ImageDownloader : NSOperation

@property (assign, nonatomic) int index;
@property (weak, nonatomic) NSString *stringImageName;
@property (weak, nonatomic) NSString *stringDirectory;
@property (weak, nonatomic) NSString *stringURL;
@property (weak) id <ImageDownloaderDelegate>delegate;

@end

@protocol ImageDownloaderDelegate <NSObject>

@optional
// Delegate function to update/prompt that the image is already downloaded
- (void)imageDownloader: (ImageDownloader *)downloader finishDownloading: (UIImage *)image;

@end
