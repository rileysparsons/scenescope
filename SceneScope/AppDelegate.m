//
//  AppDelegate.m
//  scnscopeupdate
//
//  Created by Riley Parsons on 11/24/13.
//  Copyright (c) 2013 Riley Parsons. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import "NewLoginViewController.h"
#import <Parse/Parse.h>
#import "SSLocation.h"
#import "SSUser.h"

@interface AppDelegate () <NewLoginViewControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([PFUser currentUser]){
        [self presentHomeViewController];
    } else {
        [self presentLoginViewController];
    }
    
    return YES;
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

#pragma mark LoginViewController
- (void)presentLoginViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    NewLoginViewController *newLoginViewController = [storyboard instantiateViewControllerWithIdentifier:@"NewLoginViewController"];
    newLoginViewController.delegate = self;
    self.window.rootViewController = newLoginViewController;
    [self.window makeKeyAndVisible];
}

#pragma mark HomeViewController

- (void)presentHomeViewController {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"InitialNavigationController"];
    [self.window makeKeyAndVisible];
    NSLog(@"present called!");
}

#pragma mark LoginViewController delegate methods
-(void)newLoginViewControllerDidLogin:(NewLoginViewController *)controller{
    [self presentHomeViewController];
}

@end
