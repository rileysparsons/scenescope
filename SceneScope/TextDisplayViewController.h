//
//  TextDisplayViewController.h
//  SceneScope
//
//  Created by Riley Parsons on 7/11/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextDisplayViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textDisplay;
@property (weak, nonatomic) NSString *displayedText;
@end
