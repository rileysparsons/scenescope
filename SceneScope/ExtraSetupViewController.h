//
//  ExtraSetupViewController.h
//  SceneScope
//
//  Created by Riley Parsons on 8/11/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ExtraSetupViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) NSArray *locations;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) NSMutableDictionary *locationDict;

- (IBAction)selectButton:(id)sender;
- (IBAction)preferNotButton:(id)sender;
- (IBAction)residenceNotButton:(id)sender;

@end
