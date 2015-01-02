//
//  Campus Annotations.h
//  houseplot
//
//  Created by Riley Parsons on 7/3/13.
//  Copyright (c) 2013 scnscope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "SSLocation.h"


@interface LocationAnnotation: NSObject <MKAnnotation>

@property (nonatomic, strong) SSLocation *object;

@property (nonatomic, strong) PFGeoPoint *geopoint;

@property (nonatomic, strong) NSMutableArray *nearbyUsers;

@property (nonatomic, strong) NSString *affiliation;

@property (nonatomic, strong) NSMutableDictionary *infoDictionary;

@property (nonatomic) NSArray *residents;

@property (nonatomic) NSInteger type;


-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate
                andTitle:(NSString*)title andSubtitle:(NSString *)subtitle andAffiliation:(NSString *)affiliation andType:(NSInteger)type andResidents:(NSArray *)residents;

- (id)initWithSSLocation:(SSLocation *)aLocation;




@end