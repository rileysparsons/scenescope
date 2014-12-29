//
//  LoginViewController.h
//  SceneScope
//
//  Created by Riley Parsons on 7/26/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface LoginViewController : UIViewController <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;

@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (assign, nonatomic) BOOL hideLogInButton;
@property (assign, nonatomic) BOOL hideLocationServicesButton;
@property (assign, nonatomic) BOOL hideContinueButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property NSUInteger pageIndex;
@property NSString *bodyText;
@property NSString *titleText;
@property NSString *disclaimerText;
@property NSString *imageFile;
@property (weak, nonatomic) IBOutlet UIButton *LogInButton;
@property (weak, nonatomic) IBOutlet UIButton *locationServicesButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIImageView *accentImage;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)locationServicesPressed:(id)sender;
- (IBAction)continueButtonPressed:(id)sender;



@end
