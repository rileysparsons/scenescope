//
//  LoginViewController.m
//  SceneScope
//
//  Created by Riley Parsons on 7/26/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "MapViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    self.navigationController.navigationBarHidden = YES;
    self.loadingView.hidden = YES;
    self.titleLabel.text = self.titleText;
    self.bodyLabel.text = self.bodyText;
    self.disclaimerLabel.text = self.disclaimerText;
    self.accentImage.image = [UIImage imageNamed:self.imageFile];
    
    if (_hideLogInButton){
        self.LogInButton.hidden = YES;
    }
    
    if (_hideLocationServicesButton){
        self.locationServicesButton.hidden = YES;
    }
    if (_hideContinueButton)
        self.continueButton.hidden = YES;
    
    [self hidesBottomBarWhenPushed];
    
    
}

/* Login to facebook method */
- (IBAction)loginButtonPressed:(id)sender  {
    // Set permissions required from the facebook user account
    
    // Add @"user_education_history" for check.
    
    NSArray *permissionsArray = @[@"email", @"public_profile", @"user_friends"];
    
    //Add this line for check
//    CLLocationCoordinate2D santaClaraCoordinates = CLLocationCoordinate2DMake(37.345827,-121.940024);
    MapViewController *mapViewController = (MapViewController*)[self.navigationController.viewControllers objectAtIndex:0];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                [self handleAuthError:error];
            }
        } else if (user.isNew) {
            [self.loadingView setHidden:NO];
            [self.activityIndicator setHidden:NO];
            [self.activityIndicator startAnimating];
            NSLog(@"User with facebook logged in!");
            [self.navigationController.navigationBar setHidden:NO];
            //Add this for check
            
            //            [FBRequestConnection startWithGraphPath:@"/me?fields=education.fields(school.fields(id))"
            //                                         parameters:nil
            //                                         HTTPMethod:@"GET"
            //                                  completionHandler:^(
            //                                                      FBRequestConnection *connection,
            //                                                      id result,
            //                                                      NSError *error
            //                                                      ) {
            //                                      if (!error){
            //
            //                                          NSArray *resultsArray = (NSArray *)[result objectForKey:@"education"];
            //                                          if (resultsArray.count > 0 ){
            //                                              for (NSUInteger i=0; i<[resultsArray count]; i++){
            //                                                  NSDictionary *education = [resultsArray objectAtIndex:i];
            //
            //                                                  NSDictionary *school = [education objectForKey:@"school"];
            //                                                  long long fbid = [[school objectForKey:@"id"] longLongValue];
            //                                                  NSLog(@"Id ,%lld", fbid);
            //                                                  if (fbid == 112545315425325){
            //                                                      NSLog(@"Santa Clara University Student");
            //                                                      NSLog(@"%lld", fbid);
            //                                                      NSNumber *lat = [NSNumber numberWithDouble:santaClaraCoordinates.latitude];
            //                                                      NSNumber *lon = [NSNumber numberWithDouble:santaClaraCoordinates.longitude];
            //                                                      NSDictionary *userLocation=@{@"lat":lat,@"long":lon};
            //
            //                                                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //                                                      [defaults setObject:userLocation forKey:@"userLocation"];
            //                                                      [defaults synchronize];
            
            [mapViewController zoomControl];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            //                                                  }
            //                                              }
            //                                          }
            
            
            //                                      }else{
            //
            //                                          // There was an error
            //                                      }
            
            /* handle the result */
            //                                  }];

            /* Post FBid to database */
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // Store the current user's Facebook ID on the user
                    [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                             forKey:@"fbId"];
                    [[PFUser currentUser] saveInBackground];
                } else {
                    [self handleAuthError:error];
                }
            }];

        } else {
            NSLog(@"User with facebook logged in!");
            [self.loadingView setHidden:NO];
            [self.activityIndicator setHidden:NO];
            [self.activityIndicator startAnimating];
            [self.navigationController.navigationBar setHidden:NO];
//            [FBRequestConnection startWithGraphPath:@"/me?fields=education.fields(school.fields(id))"
//                                         parameters:nil
//                                         HTTPMethod:@"GET"
//                                  completionHandler:^(
//                                                      FBRequestConnection *connection,
//                                                      id result,
//                                                      NSError *error
//                                                      ) {
//                                      if (!error){
//                                          
//                                          NSArray *resultsArray = (NSArray *)[result objectForKey:@"education"];
//                                          if (resultsArray.count > 0 ){
//                                              for (NSUInteger i=0; i<[resultsArray count]; i++){
//                                                  NSDictionary *education = [resultsArray objectAtIndex:i];
//                                                  
//                                                  NSDictionary *school = [education objectForKey:@"school"];
//                                                  long long fbid = [[school objectForKey:@"id"] longLongValue];
//                                                  NSLog(@"Id ,%lld", fbid);
//                                                  if (fbid == 112545315425325){
//                                                      NSLog(@"Santa Clara University Student");
//                                                      NSLog(@"%lld", fbid);
//                                                      NSNumber *lat = [NSNumber numberWithDouble:santaClaraCoordinates.latitude];
//                                                      NSNumber *lon = [NSNumber numberWithDouble:santaClaraCoordinates.longitude];
//                                                      NSDictionary *userLocation=@{@"lat":lat,@"long":lon};
//            
//                                                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                                                      [defaults setObject:userLocation forKey:@"userLocation"];
//                                                      [defaults synchronize];
            
                                                      [mapViewController zoomControl];
                                                      [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
                                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                                      
//                                                  }
//                                              }
//                                          }
            
                                          
//                                      }else{
//                                          
//                                          // There was an error
//                                      }
        
                                      /* handle the result */
//                                  }];
            
            /* Post FBid to database */
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // Store the current user's Facebook ID on the user
                    [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                             forKey:@"fbId"];
                    [[PFUser currentUser] saveInBackground];
                } else {
                    [self handleAuthError:error];
                }
            }];
        }
    }];

}

- (void)handleAuthError:(NSError *)error
{
    NSString *alertText;
    NSString *alertTitle;
    
    if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
        // Error requires people using you app to make an action outside your app to recover
        alertTitle = @"Something went wrong";
        alertText = [FBErrorUtility userMessageForError:error];
        UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertMessage show];
        
    } else {
        // You need to find more information to handle the error within your app
        if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
            //The user refused to log in into your app, either ignore or...
            alertTitle = @"Login cancelled";
            alertText = @"You need to login to access this part of the app";
            UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertMessage show];
            
        } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
            // We need to handle session closures that happen outside of the app
            alertTitle = @"Session Error";
            alertText = @"Your current session is no longer valid. Please log in again.";
            UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertMessage show];
            
        } else {
            // All other errors that can happen need retries
            // Show the user a generic error message
            alertTitle = @"Something went wrong";
            alertText = @"Please retry";
            UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertMessage show];
        }
    }
}

- (IBAction)locationServicesPressed:(id)sender {
    
    [locationManager requestAlwaysAuthorization];
    NSLog(@"Loc Pressed");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TurnPage" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationServicesApproved" object:self];
    
}

- (IBAction)continueButtonPressed:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TurnFirstPage" object:self];
}

@end
