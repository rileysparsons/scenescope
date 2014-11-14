//
//  AppDelegate.m
//  scnscopeupdate
//
//  Created by Riley Parsons on 11/24/13.
//  Copyright (c) 2013 Riley Parsons. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import <Parse/Parse.h>
#import "SSLocation.h"
#import "SSUser.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.window makeKeyAndVisible];

    // Register Parse Subclass
    [SSLocation registerSubclass];
    
/* This line throws an error:
    [SSUser registerSubclass];
*/

    //Parse Setup
    
    [Parse setApplicationId:@"2Pl7iXMOJewDQtuovq1fl4SSL3jvkT6Np2WZQJ2z"
                  clientKey:@"Vb5Wp5ZFcc1PlVxT6il2HDMoqZRydb4Oys13hJbI"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Set up Facebook features
    [PFFacebookUtils initializeFacebook];

    //UI Customization
    
    [self customizeUserInterface];
    
    UIAlertView * alert;
    
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        alert = [[UIAlertView alloc] initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else{
        
        self.locationTracker = [[LocationTracker alloc]init];
        [self.locationTracker startLocationTracking];
        
        //Send the best location to server every 60 seconds
        //You may adjust the time interval depends on the need of your app.
        NSTimeInterval time = 300.0;
        self.locationUpdateTimer =
        [NSTimer scheduledTimerWithTimeInterval:time
                                         target:self
                                       selector:@selector(updateLocation)
                                       userInfo:nil
                                        repeats:YES];
    }

    return YES;
}

-(void)updateLocation {
    NSLog(@"updateLocation");
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]){
    [self.locationTracker updateLocationToServer];
    }
}

-(void)customizeUserInterface {
    //Customize Navigation Bar
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Futura" size:18], NSFontAttributeName, nil]];
    
    // Toolbar
    [[UIToolbar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UIToolbar appearance] setShadowImage:[[UIImage alloc] init]  forToolbarPosition:UIBarPositionBottom];
    
    
    //Bar Buttons
    NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [UIFont fontWithName:@"Futura" size:12.0]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];
    [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[PFFacebookUtils session] close];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Facebook Methods

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}



@end
