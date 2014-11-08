//
//  LocationCell.h
//  houseplot
//
//  Created by Riley Parsons on 9/11/13.
//  Copyright (c) 2013 scnscope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
