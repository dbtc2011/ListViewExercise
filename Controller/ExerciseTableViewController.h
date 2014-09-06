//
//  ExerciseTableViewController.h
//  ListViewExercise
//
//  Created by Mark Angeles on 9/5/14.
//  Copyright (c) 2014 Chua's Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FactsObject.h"
#import <AFHTTPRequestOperation.h>
#import "ExerciseTableViewCell.h"
#import "ImageDownloader.h"

@interface ExerciseTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, ImageDownloaderDelegate>{
    
    NSOperationQueue *mainQue;
}

@end
