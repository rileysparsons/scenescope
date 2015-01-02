//
//  Campus Annotations.m
//  houseplot
//
//  Created by Riley Parsons on 7/3/13.
//  Copyright (c) 2013 scnscope. All rights reserved.
//

#import "LocationAnnotation.h"
#import "SSLocation.h"


@interface LocationAnnotation ()
@end


@implementation LocationAnnotation

@synthesize object;
@synthesize geopoint;
@synthesize title = _title,
subtitle = _subtitle, residents = _residents, type = _type, affiliation = _affiliation;


-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate
                andTitle:(NSString*)title andSubtitle:(NSString *)subtitle andAffiliation:(NSString *)affiliation andType:(NSInteger)type andResidents:(NSArray *)residents {
    if (self = [super init]) {
        self.geopoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        _title      = title;
        _subtitle = subtitle;
        _residents = residents;
        _type = type;
        _affiliation = affiliation;
    }
    
	return self;
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.geopoint.latitude, self.geopoint.longitude);
}

-(NSMutableArray*)nearbyUsers{
    if (!_nearbyUsers)
    _nearbyUsers = [[NSMutableArray alloc] init];
    return _nearbyUsers;
}

- (id)initWithSSLocation:(SSLocation *)aLocation;
{
    
    
    
    // Extract the PFUser and PFGeoPoint
    self.object = aLocation;
    self.geopoint = aLocation.location;
    

    // Extract the title, subtitle and coordinate
    CLLocationCoordinate2D aCoordinate =
    CLLocationCoordinate2DMake(self.geopoint.latitude, self.geopoint.longitude);
    NSString *aTitle = aLocation.name;
    NSString *anAddress = aLocation.address;
    NSString *aAffiliation;
    if (aLocation.affiliation != nil){
        aAffiliation = aLocation.affiliation;
    }
    
    NSInteger typeNumber;
    typeNumber = aLocation.type;
    NSArray *residentList = aLocation.residents;
    
    // Set the title, subtitle and coordinate using the designated initializer
    return [self initWithCoordinate:aCoordinate
                           andTitle:aTitle
                        andSubtitle:anAddress andAffiliation:aAffiliation andType:typeNumber andResidents:residentList];

}



@end








