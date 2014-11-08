//
//  OverlayAnnotationView.m
//  SceneScope
//
//  Created by Riley Parsons on 5/15/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import "OverlayAnnotationView.h"
#import "LocationAnnotation.h"

@implementation OverlayAnnotationView

@synthesize label;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self != nil && [annotation isKindOfClass:[LocationAnnotation class]])
        
    {
        
        CGRect frame = self.frame;
        
        frame.size = CGSizeMake(100.0, 40.0);
        
        self.frame = frame;
        
        self.backgroundColor = [UIColor clearColor];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        [label setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        label.text = annotation.title;
        label.textAlignment = NSTextAlignmentCenter;
        //        label.backgroundColor = [UIColor colorWithWhite:.9f alpha:.5];
        label.textColor = [UIColor colorWithWhite:1 alpha:1];
        label.font = [UIFont fontWithName:@"Bodoni 72 Smallcaps" size:75];
        //        label.transform = CGAffineTransformMakeRotation(-45 * M_PI / 180.0);
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 2;
        self.canShowCallout = NO;
        
        [self addSubview:label];
    
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
