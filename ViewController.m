//
//  ViewController.m
//  ListViewExercise
//
//  Created by Mark Angeles on 9/5/14.
//  Copyright (c) 2014 Chua's Company. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blueColor]];
    NSLog(@"Webservice Link = %@",WEB_LINK_GET_LIST);
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
