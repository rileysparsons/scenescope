//
//  ExtraSetupViewController.m
//  SceneScope
//
//  Created by Riley Parsons on 8/11/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import "ExtraSetupViewController.h"
#import "MapViewController.h"
#import <Parse/Parse.h>

@interface ExtraSetupViewController ()

@end

@implementation ExtraSetupViewController{
    PFObject *selectedObject;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    [_loadingView setHidden:NO];
    [_activityIndicator startAnimating];
    PFQuery *locationApartmentQuery = [PFQuery queryWithClassName:@"Location"];
    [locationApartmentQuery whereKey:@"type" equalTo:@1];
    PFQuery *locationHouseQuery = [PFQuery queryWithClassName:@"Location"];
    [locationHouseQuery whereKey:@"type" equalTo:@3];
    PFQuery *compoundQuery = [PFQuery orQueryWithSubqueries:@[locationHouseQuery,locationApartmentQuery]];
    [compoundQuery whereKey:@"reviewed" equalTo:[NSNumber numberWithBool:YES]];
    [compoundQuery orderByAscending:@"name"];
    [compoundQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error){
            // Insert error handling
        } else {
                self.locations = objects;
            
                [self.locationPicker reloadAllComponents];
                [self.selectButton setEnabled:YES];
                [self pickerView:self.locationPicker didSelectRow:0 inComponent:0];
                [_loadingView removeFromSuperview];
                [_loadingView setHidden:YES];
                [_activityIndicator setHidden:YES];
            
        }
    }];
   
    UIFont *futuraLight = [UIFont fontWithName:@"Futura-Medium" size:18];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:futuraLight, NSFontAttributeName, nil];
    NSAttributedString *labelText = [[NSAttributedString alloc] initWithString:@"Select" attributes:attributes];
    [self.selectButton setAttributedTitle:labelText forState:UIControlStateNormal];
    [self.selectButton setEnabled:NO];
}
    
    
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return self.locations.count;
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    PFObject *object = [self.locations objectAtIndex:row];
    NSString *locationTitle = [object objectForKey:@"Title"];
    
    return locationTitle;
   
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedObject = [self.locations objectAtIndex:row];
        
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    // Reuse the label if possible, otherwise create and configure a new one
    if ((pickerLabel == nil) || ([pickerLabel class] != [UILabel class])) { //newlabel
        CGRect frame = CGRectMake(0.0, 0.0, 270, 32.0);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.backgroundColor = [UIColor clearColor];
        pickerLabel.font = [UIFont fontWithName:@"Futura" size:16];
        
    }
    pickerLabel.text = [[self.locations objectAtIndex:row] objectForKey:@"name"];
    pickerLabel.textColor = [UIColor darkGrayColor];
    return pickerLabel;
}



- (IBAction)selectButton:(id)sender {
    
    UIAlertView *confirmAlert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:[NSString stringWithFormat:@"You have selected %@ as your residence. Please ensure this is accurate.", [selectedObject objectForKey:@"name"]] delegate:self cancelButtonTitle:@"Back" otherButtonTitles:@"Confirm", nil];
    [confirmAlert show];
}

- (IBAction)preferNotButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate extraSetupViewControllerDidSelectLocation:self];
}

- (IBAction)residenceNotButton:(id)sender {
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        PFQuery *updateLocationForResident = [PFQuery queryWithClassName:@"Locations"];
        NSString *objectId = [selectedObject objectId];
        
        [updateLocationForResident getObjectInBackgroundWithId:objectId block:^(PFObject *location, NSError *error) {
            if (error){
                
            } else {
                NSMutableArray *residentArray = [NSMutableArray arrayWithArray:location[@"Residents"]];
                [residentArray addObject:[[PFUser currentUser] objectId]];
                [location setObject:residentArray forKey:@"Residents"];
                [location saveInBackground];
            }
            
        }];
        
        PFUser *user = [PFUser currentUser];
        [user addObject:objectId forKey:@"residenceId"];
        [user saveInBackground];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate extraSetupViewControllerDidSelectLocation:self];
    }
}
@end
