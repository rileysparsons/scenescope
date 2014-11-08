//
//  SSUser.m
//  SceneScope
//
//  Created by Arman Dezfuli-Arjomandi on 10/24/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import "SSUser.h"
#import <Parse/PFObject+Subclass.h>

@implementation SSUser

@dynamic residenceId, currentLocation;

+ (NSString *)parseClassName {
    return @"User";
}

@end
