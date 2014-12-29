//
//  NewLoginViewController.m
//  SceneScope
//
//  Created by Riley Steele Parsons on 12/28/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import "NewLoginViewController.h"
#import <Facebook-iOS-SDK/FacebookSDK/Facebook.h>
#import "ExtraSetupViewController.h"
#import <Parse/Parse.h>

@interface NewLoginViewController () <ExtraSetupViewControllerDelegate>

@end

@implementation NewLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.backgroundImageView.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,(id)[UIColor colorWithRed:186.0/255.0f green:233.0/255.0f blue:131.0/255.0f alpha:1.0].CGColor, nil];
//    [self.backgroundImageView.layer insertSublayer:gradient atIndex:1];
    
    CALayer *white = [CALayer layer];
    white.frame = self.backgroundImageView.bounds;
    white.backgroundColor = [[UIColor blackColor] CGColor];
    white.opacity = 0.5f;
    [self.backgroundImageView.layer insertSublayer:white atIndex:0];
     
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Login Methods

- (IBAction)loginWithFacebookButtonPressed:(id)sender {
    // Set permissions required from the facebook user account
    
    // Add @"user_education_history" for check.
    
    NSArray *permissionsArray = @[@"email", @"public_profile", @"user_friends"];
    
    //Add this line for check
    //    CLLocationCoordinate2D santaClaraCoordinates = CLLocationCoordinate2DMake(37.345827,-121.940024);
   
    
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
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
            [self checkIfLocationHasBeenSubmitted];
            
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
            
        
            [self checkIfLocationHasBeenSubmitted];
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

-(void)checkIfLocationHasBeenSubmitted {
    NSLog(@"Users' residence: %@", [PFUser currentUser][@"residenceId"]);
    if ([[PFUser currentUser] objectForKey:@"residenceId"]){
        [self.delegate newLoginViewControllerDidLogin:self];
    } else {
        [self presentExtraSetupViewController];
    }
}

#pragma mark - SubmitLocationViewController

-(void)presentExtraSetupViewController{
    ExtraSetupViewController *submitLocationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ExtraSetupViewController"];
    submitLocationViewController.delegate = self;
    [self presentViewController:submitLocationViewController animated:YES completion:nil];
}

#pragma mark - SubmitLocationViewController Delegate

-(void)extraSetupViewControllerDidSelectLocation:(ExtraSetupViewController *)controller{
    [self.delegate newLoginViewControllerDidLogin:self];
}

@end
