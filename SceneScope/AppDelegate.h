//
//  AppDelegate.h
//  scnscopeupdate
//
//  Created by Riley Parsons on 11/24/13.
//  Copyright (c) 2013 Riley Parsons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "LocationTracker.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, MapViewControllerDelegate> {

}

@property LocationTracker * locationTracker;
@property (nonatomic) NSTimer* locationUpdateTimer;
@property (strong, nonatomic) UIWindow *window;

-(void)customizeUserInterface;
-(void)updateLocation;
-(void)presentHomeViewController;
-(void)presentLoginViewController;


@end
