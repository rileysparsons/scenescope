//
//  StartViewController.m
//  SceneScope
//
//  Created by Riley Parsons on 7/31/14.
//  Copyright (c) 2014 Riley Parsons. All rights reserved.
//

#import "StartViewController.h"
#import "LoginViewController.h"


@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _pageTitles = @[@"", @"", @""];
    _pageImages = @[@"telescopeFirstScreen", @"", @""];
    
    //Creating Page View Controller
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    LoginViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [self.navigationController.navigationBar setHidden:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(turnPage)
                                                 name:@"TurnPage"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(turnFirstPage)
                                                 name:@"TurnFirstPage"
                                               object:nil];
    
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Page View


-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((LoginViewController *) viewController).pageIndex;
    
    if (index == NSNotFound){
        return nil;
    }
    
    index++;
    
    if (index == [self.pageTitles count]){
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = ((LoginViewController *) viewController).pageIndex;
    
    if ((index > 0)) {
        return [self viewControllerAtIndex:index-1];
    }
    
    return nil;
    
}

-(LoginViewController*)viewControllerAtIndex:(NSUInteger)index{
    
    LoginViewController *logInViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])){
        return  nil;
    }
    for (UIScrollView *view in self.pageViewController.view.subviews) {
            
            if ([view isKindOfClass:[UIScrollView class]]) {
                
                view.scrollEnabled = NO;
            }
        
    }


    
   
  
    switch (index) {
        case 0:
            logInViewController.titleText = @"Welcome to \nSceneScope";
            logInViewController.hideLogInButton = YES;
            logInViewController.hideLocationServicesButton = YES;
            break;
        case 1:
            logInViewController.titleText = @"Know your campus";
            logInViewController.bodyText = @"SceneScope \nhelps you navigate \nthrough an updated map \nof your favorite locations";
            logInViewController.hideContinueButton = YES;
            logInViewController.hideLogInButton = YES;
            logInViewController.disclaimerText = @"Your location will remain anonymous unless otherwise noted.";
            break;
        case 2:
            logInViewController.titleText = @"Get started";
            logInViewController.hideLocationServicesButton = YES;
            logInViewController.bodyText = @"Logging in \nwith Facebook \nkeeps SceneScope secure";
            logInViewController.hideContinueButton = YES;
            logInViewController.disclaimerText = @"We will never post for you on Facebook";
            break;
        case 3:
            
        default:
            break;
    }
    
    logInViewController.imageFile = self.pageImages[index];
    
    logInViewController.pageIndex = index;
    
    return logInViewController;
    
    
}

-(void)turnPage{
    LoginViewController *lastView = [self viewControllerAtIndex:2];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:lastView, nil];
    
    //  Now, tell the pageViewContoller to accept these guys and do the forward turn of the page.
    //  Again, forward is subjective - you could go backward.  Animation is optional but it's
    //  a nice effect for your audience.
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
}

-(void)turnFirstPage{
    LoginViewController *middleView = [self viewControllerAtIndex:1];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:middleView, nil];
    
    //  Now, tell the pageViewContoller to accept these guys and do the forward turn of the page.
    //  Again, forward is subjective - you could go backward.  Animation is optional but it's
    //  a nice effect for your audience.
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
}



@end
