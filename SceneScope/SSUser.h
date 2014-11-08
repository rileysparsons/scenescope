//
//  SSUser.h
//  SceneScope
//
//  Created by Arman Dezfuli-Arjomandi on 10/24/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import <Parse/Parse.h>

@interface SSUser : PFUser <PFSubclassing>

@property (nonatomic) NSArray *residenceId;
@property (nonatomic) PFGeoPoint *currentLocation;


@end
