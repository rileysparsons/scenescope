//
//  UserAnnotationView.h
//  SceneScope
//
//  Created by Riley Parsons on 8/13/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface UserAnnotationView : MKAnnotationView <MKMapViewDelegate>

@property (nonatomic, strong) UIImageView* imageView;

@end
