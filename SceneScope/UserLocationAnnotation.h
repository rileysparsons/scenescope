//
//  UserLocationAnnotation.h
//  SceneScope
//
//  Created by Riley Parsons on 10/26/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "SSUser.h"

@interface UserLocationAnnotation : NSObject <MKAnnotation>


@property (nonatomic, strong) PFUser *object;
@property (nonatomic) NSArray *residenceId;
@property (nonatomic) PFGeoPoint *currentLocation;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andResidenceId:(NSArray*)residenceId;

- (id)initWithSSUser:(PFUser *)aUser;

@end
