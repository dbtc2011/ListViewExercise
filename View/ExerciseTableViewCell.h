//
//  ExerciseTableViewCell.h
//  ListViewExercise
//
//  Created by Mark Angeles on 9/5/14.
//  Copyright (c) 2014 Chua's Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageDisplay;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelDescription;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
