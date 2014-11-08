//
//  MapViewController.h
//  scnscopeupdate
//
//  Created by Riley Parsons on 11/24/13.
//  Copyright (c) 2013 Riley Parsons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>


@class LocationAnnotation;
@class CustomUIActionSheetViewController;





@interface MapViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>{
    CustomUIActionSheetViewController *customUIActionSheetViewController;
}

@property(nonatomic, retain) CustomUIActionSheetViewController *customUIActionSheetViewController;
@property (weak, nonatomic) IBOutlet MKMapView *scnMapView;
@property (strong, nonatomic) IBOutlet UISearchBar *locationSearchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *locationSearchDisplayController;
@property (weak, nonatomic) UIBarButtonItem *moreButton;
@property (nonatomic, strong) NSArray *searchResults;
@property BOOL manuallyChangingMapRect;
@property (nonatomic, assign) MKMapRect lastGoodMapRect;
@property (nonatomic, weak) UIButton *userLocationButton;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) PFQuery *userQuery;
@property (nonatomic, strong) PFQuery *nearbyQuery;
@property (nonatomic) NSMutableArray *mapLocations;

-(void)zoomControl;
-(void)setTitleOnLocation;
-(CLLocationDistance)calculateDistanceFromUser:(id<MKAnnotation>)annotation;
-(void)didInteractWithMap:(UIGestureRecognizer*)gestureRecognizer;
-(void)mapShift;
-(void)loadAnnotations;
-(void)setUpLocationServices;
-(void)updateUserLocation;
-(IBAction)currentLocationPressed:(id)sender;
-(IBAction)moreButtonTapped:(id)sender;

@end
