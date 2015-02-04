//
//  TopHousesTableViewController.h
//  SceneScope
//
//  Created by Riley Steele Parsons on 1/3/15.
//  Copyright (c) 2015 Riley Parsons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopHousesTableViewController : UITableViewController

@property NSArray *mapLocations;
@property NSMutableArray *houseLocations;
@property NSArray *orderedHouseLocations;
- (IBAction)returnButton:(id)sender;

@end
