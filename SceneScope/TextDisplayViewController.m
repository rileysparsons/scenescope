//
//  TextDisplayViewController.m
//  SceneScope
//
//  Created by Riley Parsons on 7/11/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import "TextDisplayViewController.h"

@interface TextDisplayViewController ()

@end

@implementation TextDisplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view

    self.textDisplay.delegate = self;
    self.textDisplay.text = self.displayedText;
    self.textDisplay.textAlignment = NSTextAlignmentCenter;
    self.textDisplay.font = [UIFont fontWithName:@"Futura" size:14];
}


@end
