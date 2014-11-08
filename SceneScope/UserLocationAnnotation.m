//
//  UserLocationAnnotation.m
//  SceneScope
//
//  Created by Riley Parsons on 10/26/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import "UserLocationAnnotation.h"

@implementation UserLocationAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andResidenceId:(NSArray*)residenceId{
    if (self = [super init]) {
        self.currentLocation = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        _residenceId = residenceId;
    }
    
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.currentLocation.latitude, self.currentLocation.longitude);
}

- (id)initWithSSUser:(PFUser *)aUser;
{
    
    
    
    // Extract the PFUser and PFGeoPoint
    self.object = aUser;
    self.currentLocation = aUser[@"currentLocation"];
    
    
    // Extract the title, subtitle and coordinate
    CLLocationCoordinate2D aCoordinate =
    CLLocationCoordinate2DMake(self.currentLocation.latitude, self.currentLocation.longitude);
  
    NSArray *residenceId = aUser[@"residenceId"];
    
    // Set the title, subtitle and coordinate using the designated initializer
    return [self initWithCoordinate:aCoordinate andResidenceId:residenceId];
            
    
}



@end
