//
//  AnnotationView.m
//  houseplot
//
//  Created by Riley Parsons on 7/4/13.
//  Copyright (c) 2013 scnscope. All rights reserved.
//

#import "AnnotationView.h"
#import "LocationAnnotation.h"

@implementation AnnotationView
@synthesize imageView = _imageView;
@synthesize label;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self != nil && [annotation isKindOfClass:[LocationAnnotation class]]){
        self.canShowCallout = YES;
        [self setCalloutAccessory];
        CGRect frame = self.frame;
        
        frame.size = CGSizeMake(22.0, 22.0);
        
        self.frame = frame;
        
        self.backgroundColor = [UIColor clearColor];
        
        //self.centerOffset = CGPointMake(-5, -5);
        
//        self.calloutOffset = CGPointMake(0, 0);
/*
        label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height, 40, 15)];
        [label setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height +3)];
        label.text = annotation.title;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithWhite:.9f alpha:.5];
        label.textColor = [UIColor colorWithWhite:.3 alpha:1];
        label.font = [UIFont fontWithName:@"Futura" size:8];
        label.transform = CGAffineTransformMakeRotation(-45 * M_PI / 180.0);
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 2;
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0.0, 1.0);
*/
        if (self) {
            LocationAnnotation *sceneAnnotation = self.annotation;
            switch (sceneAnnotation.type) {
                case 1:
                    label.textColor = [UIColor colorWithRed:0.4 green:0.533 blue:0.867 alpha:1.0];
                    break;
                case 3:
                    label.textColor = [UIColor colorWithRed:0.906 green:0.486 blue:0.561 alpha:1.0];
                    break;
                case 2:
                    label.textColor = [UIColor colorWithWhite:.3 alpha:1];
                    break;
                default:
                    label.textColor = [UIColor colorWithWhite:.3 alpha:1];
                    break;
            }
        }

        [self addSubview:label];
        
    
    
    if (self) {
        LocationAnnotation *sceneAnnotation = self.annotation;
        switch (sceneAnnotation.type) {
            case 1:
                self.image = [UIImage imageNamed:@"apartmentPin.png"];
                break;
            case 3:
                self.image = [UIImage imageNamed:@"housePin.png"];
                break;
            case 2:
                self.image = [UIImage imageNamed:@"universityPin.png"];
                break;
            default:
                self.image = [UIImage imageNamed:@"defaultPin.png"];
                break;
        }


        
    

    }
    }

    return self;

}

-(void)hideLabel {
    
    
    [label setHidden:YES];
}
-(void)showLabel {
    
    [label setHidden:NO];
}



-(void)setCalloutAccessory {
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setBackgroundImage:[UIImage imageNamed:@"telescopedisclosure.png"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    rightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    rightButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [rightButton setImage:[UIImage imageNamed:@"disclosureButton"] forState:UIControlStateNormal];
    [self setRightCalloutAccessoryView:rightButton];
    
}

@end

