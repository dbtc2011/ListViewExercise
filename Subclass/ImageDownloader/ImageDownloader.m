//
//  ImageDownloader.m
//  ListViewExercise
//
//  Created by Mark Angeles on 9/5/14.
//  Copyright (c) 2014 Chua's Company. All rights reserved.
//

#import "ImageDownloader.h"

@implementation ImageDownloader
#pragma mark - Setter
@synthesize delegate;
@synthesize index;
@synthesize stringImageName = _stringImageName;
@synthesize stringDirectory = _stringDirectory;
@synthesize stringURL = _stringURL;

#pragma mark - Getter
- (NSString *)stringImageName{
    if (!_stringImageName) {
        _stringImageName = @"";
    }
    return _stringImageName;
}

- (NSString *)stringDirectory{
    if (!_stringDirectory) {
        _stringDirectory = @"";
    }
    return _stringDirectory;
}

- (NSString *)stringURL{
    if (!_stringURL) {
        _stringURL = @"";
    }
    return _stringURL;
}

- (void)main{
    
    
    @autoreleasepool {
        
        // Set file path of the image to be downloaded
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.jpg",self.stringDirectory, self.stringImageName];
        
        // Check if the image is already downloaded
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            UIImage *downloadedImage = [UIImage imageWithContentsOfFile:filePath];
            if ([delegate respondsToSelector:@selector(imageDownloader:finishDownloading:)]) {
                [delegate imageDownloader:self finishDownloading:downloadedImage];
            }
            
        }
        else{
            //download image
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.stringURL]];
            if (self.isCancelled) {
                imageData = nil;
                return;
            }
            
            if (imageData) {
                UIImage *downloadedImage = [UIImage imageWithData:imageData];
                NSData *data = UIImageJPEGRepresentation(downloadedImage, 1.0);
                
                if([data writeToFile:filePath atomically:YES]){
                    
                    if ([delegate respondsToSelector:@selector(imageDownloader:finishDownloading:)]) {
                        
                        [delegate imageDownloader:self finishDownloading:downloadedImage];
                        
                    }
                }else{
                    
                }
                
            }
        }
        
        if (self.isCancelled)
            return;
    }

    

}


@end
