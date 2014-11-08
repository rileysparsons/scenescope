//
//  AnnotationView.h
//  houseplot
//
//  Created by Riley Parsons on 7/4/13.
//  Copyright (c) 2013 scnscope. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>


@interface AnnotationView : MKAnnotationView <MKMapViewDelegate>

@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSInteger userNumber;


-(void) setCalloutAccessory;
-(void)hideLabel;
-(void)showLabel;
@end