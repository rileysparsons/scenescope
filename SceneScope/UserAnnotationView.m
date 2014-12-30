//
//  UserAnnotationView.m
//  SceneScope
//
//  Created by Riley Parsons on 8/13/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import "UserAnnotationView.h"


@implementation UserAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self != nil)
        
    {
        self.canShowCallout = YES;
        
        self.backgroundColor = [UIColor clearColor];
//        
//        self.contentMode = UIViewContentModeScaleAspectFill;
        
        self.canShowCallout = NO;
        
        self.frame = CGRectMake(0, 0, 5, 5);
    
        self.image = [UIImage imageNamed:@"yellowUserAnnotation"];
    
    }
    return self;
	
}

-(void)setAnnotation:(id<MKAnnotation>)annotation{
    [super setAnnotation:annotation];
    [self refresh];
}

//-(void)setCalloutAccessory {
//    
//    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    //    [rightButton setBackgroundImage:[UIImage imageNamed:@"telescopedisclosure.png"] forState:UIControlStateNormal];
//    rightButton.frame = CGRectMake(0, 0, 25, 25);
//    rightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    rightButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [rightButton setImage:[UIImage imageNamed:@"disclosureButton"] forState:UIControlStateNormal];
//    [self setRightCalloutAccessoryView:rightButton];
//    
//}

-(void)refresh{
    [UIView animateWithDuration:.5 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 animations:^{
            self.alpha = 1.0f;
        } completion:nil];
    }];
}

@end


