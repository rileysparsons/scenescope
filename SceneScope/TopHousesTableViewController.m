//
//  TopHousesTableViewController.m
//  SceneScope
//
//  Created by Riley Steele Parsons on 1/3/15.
//  Copyright (c) 2015 Riley Parsons. All rights reserved.
//

#import "TopHousesTableViewController.h"
#import "LocationCell.h"
#import "LocationAnnotation.h"

@implementation TopHousesTableViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.houseLocations = [[NSMutableArray alloc] init];
    self.orderedHouseLocations = [[NSArray  alloc] init];
    
    [self filterForHouseLocations];
    [self filterForTopHouse];

}

-(void)filterForHouseLocations {
    for (LocationAnnotation *location in self.mapLocations){
        if (location.type == 3){
            [self.houseLocations addObject:location];
        }
    }
}

-(void)filterForTopHouse {

    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"nearbyUsersCount" ascending:NO];
    NSArray *sds = [NSArray arrayWithObject:sd];
    NSArray *sortedArray = [self.houseLocations sortedArrayUsingDescriptors:sds];

    self.orderedHouseLocations = sortedArray;
    
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
    
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@", (long)indexPath.row + 1, [(LocationAnnotation *)[self.orderedHouseLocations objectAtIndex:indexPath.row] title]];
    NSString *number = [NSString stringWithFormat:@"%ld users nearby", (long)[(LocationAnnotation *)[self.orderedHouseLocations objectAtIndex:indexPath.row] nearbyUsersCount]];

    cell.detailTextLabel.text = number;
    
    return cell;
}

- (IBAction)returnButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
