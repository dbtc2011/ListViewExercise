//
//  FactsObject.m
//  ListViewExercise
//
//  Created by Mark Angeles on 9/6/14.
//  Copyright (c) 2014 Chua's Company. All rights reserved.
//

#import "FactsObject.h"


@implementation FactsObject
@synthesize stringImagePath = _stringImagePath;
@synthesize stringImageURL = _stringImageURL;
@synthesize stringTitle = _stringTitle;
@synthesize stringDescription = _stringDescription;
@synthesize stringImageFolder = _stringImageFolder;


- (NSString *)stringImagePath
{
    if (!_stringImagePath) {
    
        _stringImagePath = (NSString *)[self.stringImageFolder stringByAppendingFormat:@"/%@.jpg",self.stringTitle];
    
    }
    return _stringImagePath;
}

- (NSString *)stringImageURL
{
    if (!_stringImageURL) {
        _stringImageURL = @"";
    }
    return _stringImageURL;
}

- (NSString *)stringTitle
{
    if (!_stringTitle) {
        _stringTitle = @"";
    }
    return _stringTitle;
}

- (NSString *)stringDescription
{
    if (!_stringDescription) {
        _stringDescription = @"";
    }
    return _stringDescription;
}

- (NSString *)stringImageFolder
{
 
    if (!_stringImageFolder) {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _stringImageFolder = (NSString *)path[0];
        _stringImageFolder = [_stringImageFolder stringByAppendingFormat:@"/images"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_stringImageFolder]) {
            if ([[NSFileManager defaultManager] createDirectoryAtPath:_stringImageFolder withIntermediateDirectories:YES attributes:nil error:nil]) {
                NSLog(@"Created directory/path for images");
            }else{
                NSLog(@"Failed to create directory/path for images");
            }
        }
    }
    return _stringImageFolder;
    
}

@end
