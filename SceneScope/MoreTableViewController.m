//
//  MoreTableViewController.m
//  SceneScope
//
//  Created by Riley Parsons on 6/28/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import "MoreTableViewController.h"
#import "TextDisplayViewController.h"
#import "MapViewController.h"
#import "SubmitLocationViewController.h"
#import <Parse/Parse.h>

@interface MoreTableViewController (){
    NSArray *aboutArray;
    NSArray *contactArray;
}

@end

@implementation MoreTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"More";
    
    aboutArray = [[NSArray alloc] initWithObjects:@"Legal",@"Acknowledgments", @"Company", nil];
    contactArray = [[NSArray alloc] initWithObjects:@"Suggestions",@"Jobs", nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) {
        return contactArray.count;
    } else if (section == 1){
        return aboutArray.count;
    } else if (section == 2){
        return 1;
    }
    return 0;
}

/*
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0){
        return @"Preferences";
    }
    if (section == 1) {
        return @"Contact";
    }
    if (section == 2){
        return @"About";
    }
    return 0;
    
}
*/
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Configure the cell...
    if (indexPath.section == 0){
        cell.textLabel.text = [contactArray objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [aboutArray objectAtIndex:indexPath.row];
    } else if (indexPath.section == 2){
        cell.textLabel.text = @"Submit a location for review";
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"Futura" size:16]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectZero];
    UILabel *title = [[UILabel alloc] initWithFrame:(CGRectMake(10, 10, 100, 40))];
    
    if (section == 0){
        title.text = @"Contact";
        header.backgroundColor = [UIColor colorWithRed:186.0/255.0f green:233.0/255.0f blue:131.0/255.0f alpha:0.5];
    } else if (section == 1){
        title.text = @"About";
        header.backgroundColor = [UIColor colorWithRed:0.906 green:0.486 blue:0.561 alpha:0.5];
    } else if (section == 2){
        title.text = @"Contribute";
        header.backgroundColor = [UIColor colorWithRed:0.4 green:0.533 blue:0.867 alpha:1.0];
    }
    [title setFont:[UIFont fontWithName:@"Futura" size:16]];
    [header addSubview:title];
    return header;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([selectedCell.textLabel.text isEqualToString: @"Suggestions"]){
        [self messageButton:self];
    } else if ([selectedCell.textLabel.text isEqualToString: @"Company"] || [selectedCell.textLabel.text isEqualToString: @"Legal"] || [selectedCell.textLabel.text isEqualToString: @"Acknowledgments"] || [selectedCell.textLabel.text isEqualToString: @"Jobs"] ){
        [self performSegueWithIdentifier:@"Text Display" sender:self];
    } else if ([selectedCell.textLabel.text isEqualToString:@"Submit a location for review"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        SubmitLocationViewController *submit = (SubmitLocationViewController*)[storyboard instantiateViewControllerWithIdentifier:@"Submit"];
        [self presentViewController:submit animated:YES completion:nil];
    }
}

- (void)messageButton:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"SceneScope suggestion"];
        [controller setToRecipients:[NSArray arrayWithObjects:@"scenescopeapp@gmail.com",nil]];
        if (controller) [self presentViewController:controller animated:YES completion:NULL];
        
    } else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Device unable to send message at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    
}

#pragma mark - Delegate Methods

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UITableViewCell* selectedCell = [self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
    NSString *selectedCellTitle = selectedCell.textLabel.text;
    TextDisplayViewController *destination = segue.destinationViewController;
    if ([selectedCellTitle isEqualToString:@"Company"]){
        NSString *companyText = @"SceneScope was founded at Santa Clara University in 2014.\n\nThe aim of this application is to enhance overall campus social and navigational awareness in a safe and respectful manner.";
        destination.displayedText = companyText;
        destination.navigationItem.title = @"Company";
    } else if ([selectedCellTitle isEqualToString:@"Legal"]){
        NSString *legalText = @"By downloading and logging into SceneScope you agree to the terms and conditions below: \n\nSceneScope is an independant application with no ties to any institution or society. SceneScope assumes no responsibility for any events that may transpire due to any alleged connection to the application ('SceneScope'). \nUser locations are not linked with explicit identities, and remain anonymous within the application. Any information shown within in the application is considered to be public knowledge and not intellectual property of any individual or organization. \n\nSceneScope reserves the right to adjust these terms and conditions at anytime without warning.\n\nAll rights reserved \u00A9 2014";
        destination.displayedText = legalText;
        destination.navigationItem.title = @"Legal";
    } else if ([selectedCellTitle isEqualToString:@"Acknowledgments"]){
        NSString *acknowlegmentsText = @"Many thanks to Robert Boscacci for the contribution of his photography to the application.";
        destination.displayedText = acknowlegmentsText;
        destination.navigationItem.title = @"Acknowledgments";
    }else if ([selectedCellTitle isEqualToString:@"Jobs"]){
        NSString *jobsText = @"Sorry, no positions are available currently. Check back soon for updates.";
        destination.displayedText = jobsText;
        destination.navigationItem.title = @"Jobs";
    }
    
}

-(void)logOutUser{
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:NO];


}

@end
