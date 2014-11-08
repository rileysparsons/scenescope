//
//  SSLocation.m
//  SceneScope
//
//  Created by Riley Parsons on 9/27/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import "SSLocation.h"
#import <Parse/PFObject+Subclass.h>

@implementation SSLocation

@dynamic name, address, location, affiliation, residents, type, reviewed;

+ (NSString *)parseClassName {
    return @"Location";
}

@end
