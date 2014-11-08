//
//  MoreTableViewController.h
//  SceneScope
//
//  Created by Riley Parsons on 6/28/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface MoreTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
