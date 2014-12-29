//
//  StartViewController.h
//  SceneScope
//
//  Created by Riley Parsons on 7/31/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StartViewController;

@protocol StartViewControllerDelegate <NSObject>

-(void)startViewControllerDidLogin:(StartViewController *)controller;

@end

@interface StartViewController : UIViewController <UIPageViewControllerDataSource>


@property (nonatomic, weak) id <StartViewControllerDelegate> delegate;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;


@end
