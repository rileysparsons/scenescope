//
//  SSLocation.h
//  SceneScope
//
//  Created by Riley Parsons on 9/27/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import <Parse/Parse.h>

@interface SSLocation : PFObject <PFSubclassing>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *address;
@property (nonatomic) PFGeoPoint *location;
@property (nonatomic) NSString *affiliation;
@property (nonatomic) NSInteger type;
@property (nonatomic) BOOL reviewed;

@property (nonatomic) NSArray *residents;

@end
