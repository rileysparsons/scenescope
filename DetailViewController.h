//
//  DetailViewController.h
//  SceneScope
//
//  Created by Riley Parsons on 8/4/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationAnnotation.h"

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *cellTitles;
@property (weak, nonatomic) LocationAnnotation *selectedLocation;
@property (strong, nonatomic) NSArray *locationResidents;

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *userNumberLabel;

@end
