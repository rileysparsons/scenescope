//
//  DetailViewController.m
//  SceneScope
//
//  Created by Riley Parsons on 8/4/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import "DetailViewController.h"
#import <Parse/Parse.h>

@interface DetailViewController ()

@end

@implementation DetailViewController{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Location";
    
    self.detailTableView.delegate = self;
    self.cellTitles  = @[@"Address", @"Affiliation", @"Residents"];
    self.titleLabel.text = self.selectedLocation.title;
    
    if ([self.selectedLocation.nearbyUsers count] > 0){
        self.userNumberLabel.text = [NSString stringWithFormat: @"%@ users nearby", [@([self.selectedLocation.nearbyUsers count]) stringValue]];
    } else {
        self.userNumberLabel.text = @"No users nearby";
    }
    
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Locations"];
    [query whereKey:@"Title" equalTo:self.selectedLocation.title];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error){
            NSLog(@"Error, %@, %@", error, [error userInfo]);
        } else{
            for (PFObject *object in objects){
                self.locationResidents = [object objectForKey:@"Residents"];
                NSLog(@"%@", self.locationResidents);
                [self.activityIndicator stopAnimating];
                [self.detailTableView reloadData];
            }
        }
    }];
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:16];
    if (tableView == self.detailTableView){
        cell.textLabel.text = self.cellTitles[indexPath.row];
        
        switch (indexPath.row) {
            case 0:
                if (self.selectedLocation.subtitle){
                    cell.detailTextLabel.text = self.selectedLocation.subtitle;
                } else {
                    cell.detailTextLabel.text = @"No address listed";
                }
                break;
            case 1:
                if (self.selectedLocation.affiliation){
                    cell.detailTextLabel.text = self.selectedLocation.affiliation;
                } else {
                    cell.detailTextLabel.text = @"No known affliliation";
                }
                break;
            case 2:
                if (self.locationResidents){
                    cell.detailTextLabel.text = [@(self.locationResidents.count) stringValue];
                }else{
                    cell.detailTextLabel.text = @"No listed residents";
                }
                break;
        }
    }
    return cell;
}





@end
