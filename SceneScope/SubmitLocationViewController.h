//
//  SubmitLocationViewController.h
//  SceneScope
//
//  Created by Riley Parsons on 8/22/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitLocationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *affiliationTextField;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)submitButtonPressed:(id)sender;

@end
