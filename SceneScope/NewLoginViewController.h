//
//  NewLoginViewController.h
//  SceneScope
//
//  Created by Riley Steele Parsons on 12/28/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewLoginViewController;

@protocol NewLoginViewControllerDelegate <NSObject>

-(void)newLoginViewControllerDidLogin:(NewLoginViewController *)controller;

@end

@interface NewLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) id <NewLoginViewControllerDelegate> delegate;
- (IBAction)loginWithFacebookButtonPressed:(id)sender;
@end
