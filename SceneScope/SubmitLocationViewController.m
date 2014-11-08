//
//  SubmitLocationViewController.m
//  SceneScope
//
//  Created by Riley Parsons on 8/22/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import "SubmitLocationViewController.h"
#import "ExtraSetupViewController.h"
#import "MoreTableViewController.h"
#import "SSLocation.h"
#import <Parse/Parse.h>

@interface SubmitLocationViewController ()

@end

@implementation SubmitLocationViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", self.presentingViewController);
    // Do any additional setup after loading the view.
}


- (IBAction)submitButtonPressed:(id)sender {
    NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *address = [self.addressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *affiliation = [self.affiliationTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([name length] == 0 || [address length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]  initWithTitle:@"Wait!" message:@"Please enter both the house's name and address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }else{
        self.submitButton.enabled = NO;
        SSLocation *houseObject = [SSLocation object];
        houseObject.name = name;
        houseObject.address = address;
        houseObject.type = [[NSNumber numberWithInt:3] intValue];
        if (affiliation != nil){
            houseObject.affiliation = affiliation;
        }
        [houseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error){
                
                if ([self.presentingViewController isKindOfClass:[ExtraSetupViewController class]]){
                    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                } else if ([self.presentingViewController isKindOfClass:[UINavigationController class]]){
                    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }
            } else {
                
            }
        }];
    }
}
- (IBAction)cancelButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
