//
//  MapViewController.m
//  scnscopeupdate
//
//  Created by Riley Parsons on 11/24/13.
//  Copyright (c) 2013 Riley Parsons. All rights reserved.
//

#import "MapViewController.h"
#import "LocationAnnotation.h"
#import "AnnotationView.h"
#import "LocationCell.h"
#import "OverlayAnnotationView.h"
#import "DetailViewController.h"
#import "ExtraSetupViewController.h"
#import "UserAnnotationView.h"
#import "UserLocationAnnotation.h"
#import "AppDelegate.h"
#import "SimpleKML.h"
#import "SimpleKMLContainer.h"
#import "SimpleKMLDocument.h"
#import "SimpleKMLFeature.h"
#import "SimpleKMLPlacemark.h"
#import "SimpleKMLPoint.h"
#import "SimpleKMLPolygon.h"
#import "SimpleKMLLinearRing.h"
#import "SSLocation.h"
#import "LocationTracker.h"

#define centerSantaClaraLat 37.349236f
#define centerSantaClaraLong  -121.939064f
#define maximumAltitude 4000
#define annotationRemovalAltitude 750


@interface MapViewController ()

@property (nonatomic, strong) MKCircle* scnCircle;
@property (nonatomic, strong) MKPolygon* thePolygon;
@property BOOL mapFinishedLoading;

@property (nonatomic) NSDictionary *overlayRects;

@property (nonatomic) NSMutableDictionary *userAnnotationsDict;

@end

@implementation MapViewController

@synthesize locationSearchBar;

@synthesize scnMapView;

@synthesize locationSearchDisplayController;

@synthesize searchResults;

@synthesize moreButton;

@synthesize manuallyChangingMapRect, lastGoodMapRect;

@synthesize userLocationButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scnCircle = [MKCircle circleWithCenterCoordinate:(CLLocationCoordinate2DMake(centerSantaClaraLat, centerSantaClaraLong)) radius:2414.02];
    self.navigationItem.title = @"Map";
    
    [self startLocationManager];
    
    self.scnMapView.delegate = self;
    [self.scnMapView setShowsPointsOfInterest:NO];
    
    //Add Location Annotations to Map
    [self loadAnnotations];
    
    // Allocate and Initialize the search results array.
    self.searchResults = [[NSMutableArray alloc] init];
    self.locationSearchBar = [[UISearchBar alloc] init];
    
    
    //Panning Recognition: Adds gesture recognize to intercept the movement of the map.
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didInteractWithMap:)];
    [panRecognizer setDelegate:self];
    [self.scnMapView addGestureRecognizer:panRecognizer];
    
    [self setUpLocationServices];
    
    // This array holds all of the locations (houses not users) of the map
    _mapLocations = [[NSMutableArray alloc] init];
    
    [self zoomControl];
    
    [self drawOverlay];
    
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        scnMapView.showsUserLocation = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectResidence) name:@"DisplayResidencePrompt" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpLocationServices) name:@"LocationServicesApproved" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserAnnotations) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserAnnotations) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)startLocationManager {
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.delegate mapViewControllerDidApproveLocationUpdates:self];
}

-(void) selectResidence {
    ExtraSetupViewController *extraSetupViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ExtraSetupViewController"];
    [self presentViewController:extraSetupViewController animated:YES completion:^{
        nil;
    }];
}

                                                                
-(void)updateUserAnnotations {
    if (!self.userAnnotationsDict) {
        self.userAnnotationsDict = [NSMutableDictionary dictionary];
    }
    NSMutableArray *annotationsToAdd = [[NSMutableArray alloc] init];
    _userQuery = [PFUser query];
    [_userQuery setLimit:1000];
    [_userQuery whereKey:@"objectId" notEqualTo:[[PFUser currentUser] objectId]];
    [_userQuery whereKeyExists:@"currentLocation"];
    [_userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [UIView animateWithDuration:.5 animations:^{
                for (SSUser *object in objects) {
                    LocationAnnotation *currentAnnotation = self.userAnnotationsDict[object.objectId];
                    PFGeoPoint *geopoint = [object objectForKey:@"currentLocation"];
                    
                    if (currentAnnotation) {
                        currentAnnotation.geopoint = geopoint;
                    } else {
                        UserLocationAnnotation *geoPointAnnotation = [[UserLocationAnnotation alloc] initWithSSUser:object];
                        [annotationsToAdd addObject:geoPointAnnotation];

                         
                    }
                   
                    [self.scnMapView addAnnotations:annotationsToAdd];
                    
                        /* Facebook friend check (Needs to be refined)
                                    if ([self checkIfUserIsFriend:object]){
                                        LocationAnnotation *geoPointAnnotation = [[LocationAnnotation alloc] initWithCoordinate:geopointCoordinate andTitle:[object objectId] andSubtitle:nil withInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"userLocationAnnotation", @"Category", [NSNumber numberWithBool:YES], @"FBFriend", nil]];
                                        [userAnnotations addObject:geoPointAnnotation];
                                    } else {
                                        LocationAnnotation *geoPointAnnotation = [[LocationAnnotation alloc] initWithCoordinate:geopointCoordinate andTitle:[object objectId] andSubtitle:nil withInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"userLocationAnnotation", @"Category", [NSNumber numberWithBool:NO], @"FBFriend", nil]];
                                        [userAnnotations addObject:geoPointAnnotation];
                                    }
                         */
                }
            }];
            [self adjustViewForActivity];
        } else {
                //error handling
        }
    }];

}
/* Check if a user is a Facebook friend of currentUser
-(BOOL)checkIfUserIsFriend:(PFObject *)user{
    
    // Issue a Facebook Graph API request to get your user's friend list
    
    __block BOOL userIsFriend;
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            
            NSLog(@"%@", friendIds);
            
            for (PFObject *fbId in friendObjects){
                
                if ([[user objectForKey:@"fbId"] isEqualToString:[fbId objectId]]) {
                    userIsFriend = YES;
                    NSLog(@"FBID: %@", fbId);
                } else {
                    userIsFriend = NO;
                    NSLog(@"FBID: %@", fbId);
                }
            }
            
            
        }
    }];
    
    return userIsFriend;
}
*/

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    // Prompt Login if there is no user logged in. Otherwise update the locations.
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser){
        [self updateUserAnnotations];
    } else {
        
    }
}

-(void)setUpLocationServices{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 5;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.scnMapView.showsUserLocation = YES;
    [self.locationManager startUpdatingLocation];
}

-(void)loadAnnotations{

    [PFCloud callFunctionInBackground:@"fetchLocations" withParameters:@{} block:^(id object, NSError *error) {
        if (!error) {
            NSArray *objects = (NSArray *)object;
            for (SSLocation *location in objects) {
                if ((location.reviewed = YES)){
                LocationAnnotation *geoPointAnnotation = [[LocationAnnotation alloc] initWithSSLocation:location];
                MKAnnotationView *annView = [scnMapView viewForAnnotation:geoPointAnnotation];
                [self configureAnnotationView:annView];
                [_mapLocations addObject:geoPointAnnotation];
                [self.scnMapView addAnnotations:_mapLocations];
                }
            }
        } else if(error){
            UIAlertView *loadingErrorAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Unable to load map, please connect to network and try again" delegate:self cancelButtonTitle:@"Reload" otherButtonTitles: nil];
            [loadingErrorAlert setTag:1];
            [loadingErrorAlert show];
        }

        
    }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

-(void)didInteractWithMap:(UIGestureRecognizer*)gestureRecognizer{
    
}

-(void)moreButtonTapped:(id)sender {
 
    [self performSegueWithIdentifier:@"MorePushed" sender:self];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_userQuery cancel];
    [_nearbyQuery cancel];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search Display Controller

-(CLLocationDistance)calculateDistanceFromUser:(id<MKAnnotation>)annotation{
    
    CLLocation *annotationLocation = [[CLLocation alloc]
                               initWithLatitude:annotation.coordinate.latitude
                               longitude:annotation.coordinate.longitude];
    
    CLLocation *userLocation = [[CLLocation alloc]
                                initWithLatitude:scnMapView.userLocation.coordinate.latitude
                                longitude:scnMapView.userLocation.coordinate.longitude];
    
    CLLocationDistance distance = [annotationLocation distanceFromLocation:userLocation];
    
    CLLocationDistance distanceInFeet= distance*3.28024;
    
    
    
    return distanceInFeet;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return self.searchResults.count;

};

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"title contains[cd] %@",
                                    searchText];
    
    searchResults = [_mapLocations filteredArrayUsingPredicate:resultPredicate];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"LocationCellView" owner:self options:nil];
        for(id currentObject in objects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell = (LocationCell*)currentObject;
                break;
            }
        }
    }
    
    if (tableView == self.locationSearchDisplayController.searchResultsTableView) {
        cell.locationLabel.text = [[searchResults objectAtIndex:indexPath.row] title];
        switch ((NSInteger)[(LocationAnnotation*)[searchResults objectAtIndex:indexPath.row] type]) {
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"apartmentPinLevel1"];
                break;
            case 3:
                cell.imageView.image = [UIImage imageNamed:@"housePinLevel1"];
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"universityPin"];
                break;
            default:
                cell.imageView.image = [UIImage imageNamed:@"defaultPin"];
                break;
    }


        
        CLLocationDistance distance = [self calculateDistanceFromUser:[searchResults objectAtIndex:indexPath.row]];
        
        if (distance > 2000){
            
            CLLocationDistance distanceInMiles = distance/5280;
            if ( 5 < distanceInMiles) {
                
                cell.distanceLabel.text = @"More than 5 miles away";
            
            } else {
                
            
            cell.distanceLabel.text = [NSString stringWithFormat:@"%.02f miles", distanceInMiles];
            
            }
            
        }else{
            
            cell.distanceLabel.text = [NSString stringWithFormat:@"%.f feet", 50.0 * floor((distance/50.0)+0.5)];
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationCell *locationCell = (LocationCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (tableView == self.locationSearchDisplayController.searchResultsTableView) {
        [self.locationSearchDisplayController setActive:NO animated:YES];
        for (id<MKAnnotation> annotationSelect in scnMapView.annotations){
                if ([annotationSelect isKindOfClass:[LocationAnnotation class]]){
                        if ([annotationSelect.title isEqualToString:locationCell.locationLabel.text]){
                            MKMapCamera* camera = [MKMapCamera cameraLookingAtCenterCoordinate:annotationSelect.coordinate fromEyeCoordinate:annotationSelect.coordinate eyeAltitude:0];
                            MKAnnotationView *view = [self.scnMapView viewForAnnotation:annotationSelect];
                            view.enabled = YES;
                            view.hidden = NO;
                            [self.scnMapView selectAnnotation:annotationSelect animated:NO];
                            [self.scnMapView setCamera:camera animated:NO];
                            [self.scnMapView setUserInteractionEnabled:YES];
                        }
                }
          }
    }
}


#pragma mark - MapView

-(void)adjustViewForActivity{

    
    for (LocationAnnotation *annotation in [self.scnMapView annotations]){
        
        if ([annotation isKindOfClass:[LocationAnnotation class]]){
            
            _nearbyQuery = [PFUser query];
            PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
            [_nearbyQuery whereKey:@"currentLocation" nearGeoPoint:geoPoint withinMiles:.02];
            [_nearbyQuery findObjectsInBackgroundWithBlock:^(NSArray *userObjects, NSError *error) {
                if (error){
                    
                } else {
                    if (userObjects.count != [annotation.nearbyUsers count]){
                        annotation.nearbyUsers = userObjects;
                        MKAnnotationView *annView = [scnMapView viewForAnnotation:annotation];
                        [self configureAnnotationView:annView];
                    }
                }
                
            }];
        }
    }
        
}

-(void)configureAnnotationView:(MKAnnotationView *)av
{
    // Adjusts coloring of LocationAnnotationView based on count in nearbyUsers property of each LocationAnnotation
    LocationAnnotation *myAnn = (LocationAnnotation *)av.annotation;
    if ([av.annotation isKindOfClass:[LocationAnnotation class]]){
        if ([myAnn.nearbyUsers count] <1){
            if ((myAnn.type == 3)){
            av.image =[UIImage imageNamed:@"housePinLevel1"];
            } else if ((myAnn.type == 1)){
               av.image =[UIImage imageNamed:@"apartmentPinLevel1"];
            }
        } else if (1 <= [myAnn.nearbyUsers count] && [myAnn.nearbyUsers count] <= 5){
            if ((myAnn.type == 3)){
                av.image =[UIImage imageNamed:@"housePinLevel2"];
            } else if ((myAnn.type == 1)){
                av.image =[UIImage imageNamed:@"apartmentPinLevel2"];
            }
        } else if (5 < [myAnn.nearbyUsers count] && [myAnn.nearbyUsers count] <= 10){
            if ((myAnn.type == 3)){
                av.image =[UIImage imageNamed:@"housePinLevel3"];
            }else if ((myAnn.type == 1)){
                av.image =[UIImage imageNamed:@"apartmentPinLevel3"];
            }
        } else if (10 < [myAnn.nearbyUsers count] && [myAnn.nearbyUsers count] <= 20){
           
            if ((myAnn.type == 3)){
                av.image =[UIImage imageNamed:@"housePinLevel4"];
            }else if ((myAnn.type == 1)){
                av.image =[UIImage imageNamed:@"apartmentPinLevel4"];
            }
        } else if (20 < [myAnn.nearbyUsers count] && [myAnn.nearbyUsers count] <= 30){
            if ((myAnn.type == 3)){
                av.image =[UIImage imageNamed:@"housePinLevel5"];
            }else if ((myAnn.type == 1)){
                av.image =[UIImage imageNamed:@"apartmentPinLevel5"];
            }
        } else if (30 < [myAnn.nearbyUsers count]){
            if ((myAnn.type == 3)){
                av.image =[UIImage imageNamed:@"housePinLevel6"];
            }else if ((myAnn.type == 1)){
                av.image =[UIImage imageNamed:@"apartmentPinLevel6"];
            }
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    AnnotationView* pinView = [[AnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"locationAnnotationIdentifier"];
    OverlayAnnotationView *overlayAnnotationPin = [[OverlayAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"overlayAnnotationIdentifier"];
    UserAnnotationView *userAnnotationView = [[UserAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"userAnnotationIdentifier"];
    
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    if (!pinView) {
        
    } else {
        if ([annotation isKindOfClass:[LocationAnnotation class]]){
            
            if ([annotation.title isEqualToString:@"Bellomy"] || [annotation.title isEqualToString:@"Campus"] || [annotation.title isEqualToString:@"Dark Side"] ||
                [annotation.title isEqualToString:@"Domicilio"] ||
                [annotation.title isEqualToString:@"Villas"]){
                overlayAnnotationPin.annotation = annotation;
                overlayAnnotationPin.canShowCallout = NO;
                return  overlayAnnotationPin;
                
            } else {
                pinView.annotation = annotation;
                [self configureAnnotationView:pinView];
                [pinView setCalloutAccessory];
                return pinView;
            }
        
        } else if ([annotation isKindOfClass:[UserLocationAnnotation class]]){
            /* For Facebook Check (Needs to be refined)
            if ([[campusAnnotation.infoDictionary objectForKey:@"FBFriend"] isEqualToNumber:[NSNumber numberWithBool:YES]]){
                userAnnotationView.image = [UIImage imageNamed:@"yellowUserAnnotation"];
                return userAnnotationView;
            } else {
                userAnnotationView.image = [UIImage imageNamed:@"greenUserAnnotation"];
                return userAnnotationView;
            }
            */
            userAnnotationView.image = [UIImage imageNamed:@"greenUserAnnotation"];
            return userAnnotationView;
        }
    };
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    if ([view isKindOfClass:[AnnotationView class]]){
        [self performSegueWithIdentifier:@"locationDetail" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"locationDetail"]){
        DetailViewController *detailViewController = (DetailViewController *)[segue destinationViewController];
        LocationAnnotation *annotationSelected = self.scnMapView.selectedAnnotations[0];
        [detailViewController setSelectedLocation:annotationSelected];
        
        MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
        MKCoordinateRegion snapRegion = MKCoordinateRegionMakeWithDistance(annotationSelected.coordinate, 30, 30);
        options.region = snapRegion;
        options.scale = [UIScreen mainScreen].scale;
        options.size = CGSizeMake(320, 123);
        options.mapType = MKMapTypeSatellite;
        options.showsBuildings = NO;
        options.showsPointsOfInterest = NO;
        
        MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
        [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
            UIImage *image = snapshot.image;
            detailViewController.locationImageView.image = image;
        }];
    }
}

-(void)zoomControl {
    MKMapPoint userPoint = MKMapPointForCoordinate(self.scnMapView.userLocation.coordinate);
    BOOL inside = MKMapRectContainsPoint(_scnCircle.boundingMapRect, userPoint);
    CLLocationCoordinate2D santaClaraCenter = CLLocationCoordinate2DMake(_scnCircle.coordinate.latitude, _scnCircle.coordinate.longitude);
    if (inside) {
            MKMapCamera* camera = [MKMapCamera cameraLookingAtCenterCoordinate:self.locationManager.location.coordinate
                                                             fromEyeCoordinate:self.locationManager.location.coordinate
                                                                   eyeAltitude:320];
            [self.scnMapView setCamera:camera animated:NO];
         } else {
        MKMapCamera* camera = [MKMapCamera
                               cameraLookingAtCenterCoordinate:santaClaraCenter
                               fromEyeCoordinate: santaClaraCenter
                               eyeAltitude:(1800)];
        [self.scnMapView setCamera:camera animated:NO];
    }
    _mapFinishedLoading = YES;
}

-(void)setTitleOnLocation {
    MKMapPoint centerPoint = MKMapPointForCoordinate(self.scnMapView.centerCoordinate);
    BOOL inside = MKMapRectContainsPoint(_scnCircle.boundingMapRect, centerPoint);
    if (inside) {
            self.searchDisplayController.searchBar.placeholder = @"Search Santa Clara University";
        } else {
            self.searchDisplayController.searchBar.placeholder = @"Search";
        }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    // Changes the placeholder text within the searchbar when nearby SCU
    [self setTitleOnLocation];
    
    
    // Prevents users from leaving the SCU area by scrolling
    
    if (_mapFinishedLoading){
        //Prevents the restrictions before the map has zoomed.
        if (manuallyChangingMapRect) {
            return;
        }
        
        if (![_scnCircle intersectsMapRect:mapView.visibleMapRect]) {
            // Overlay is no longer visible in the map view.
            // Reset to last "good" map rect...
            manuallyChangingMapRect = YES;
            [mapView setVisibleMapRect:lastGoodMapRect animated:YES];
            manuallyChangingMapRect = NO;
        } else {
            lastGoodMapRect = mapView.visibleMapRect;
        }
    }
    
    
    // Adds and removes AnnotationViews based on Zoom Level to prevent crowding on the UI. Needs to be refined.
    NSArray *annotations = [self.scnMapView annotations];
    LocationAnnotation *annotation = nil;
    for (int i=0; i<[annotations count]; i++) {
        annotation = (LocationAnnotation*)[annotations objectAtIndex:i];
        MKAnnotationView *annotationView = [self.scnMapView viewForAnnotation:annotation];
        if ([annotationView isKindOfClass:[AnnotationView class]]){
            if (self.scnMapView.camera.altitude > annotationRemovalAltitude) {
                // For when the zoom level is at the highest level, most annotations will be removed.
                if([annotation.nearbyUsers count] < 4){
                    [UIView animateWithDuration:0.65f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^(void){
                                         annotationView.alpha = 0.0f;
                                     }
                                     completion:^(BOOL Finished){
                                         annotationView.hidden = YES;
                                         annotationView.enabled = NO;
                    }];
                } else {
                    annotationView.alpha = 1.0f;
                    annotationView.hidden = NO;
                    annotationView.enabled = YES;
                }
            } else {
                if ([annotation.nearbyUsers count] < 4){
                [UIView animateWithDuration:0.1f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^(void){
                                     annotationView.alpha =1.0f;
                                 }
                                 completion:^(BOOL Finished){
                                     annotationView.hidden = NO;
                                     annotationView.enabled = YES;
                                 }];
               
                } else{
                    annotationView.alpha = 1.0f;
                    annotationView.hidden = NO;
                    annotationView.enabled = YES;
                }
            }
        }
    }
   
    for (int i=0; i<[annotations count]; i++)
    {
        annotation = (LocationAnnotation*)[annotations objectAtIndex:i];
        MKAnnotationView *annotationView = [self.scnMapView viewForAnnotation:annotation];
        if ([annotationView isKindOfClass:[AnnotationView class]]){
            if (self.scnMapView.camera.altitude < annotationRemovalAltitude)
            {
                if( [annotationView isKindOfClass:[OverlayAnnotationView class]]){
                    
                    [UIView animateWithDuration:0.65f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^(void){
                                         annotationView.alpha = 0.0f;
                                         
                                     }
                                     completion:^(BOOL Finished){
                                         annotationView.hidden = YES;
    //                                     annotationView.enabled = NO;
                                     }];
                }
                
            }
            else {
                if ([annotationView isKindOfClass:[OverlayAnnotationView class]]){
                    [UIView animateWithDuration:0.1f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^(void){
                                         annotationView.alpha =1.0f;
                                     }
                                     completion:^(BOOL Finished){
                                         annotationView.hidden = NO;
    //                                     annotationView.enabled = YES;
                                     }];
                }
            }
        }
    }
    for (id<MKOverlay> overlayToRemove in self.scnMapView.overlays){
        MKOverlayRenderer *polygonView = [self.scnMapView rendererForOverlay:overlayToRemove];
        if ([overlayToRemove isKindOfClass:[MKPolygon class]])
        {
            if (self.scnMapView.camera.altitude < annotationRemovalAltitude && self.scnMapView.camera.pitch == 0){
                
                [UIView animateWithDuration:1.0f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^(void){
                                     polygonView.alpha = 0;
                                     
                                 }
                                 completion:^(BOOL Finished){
                                     
                }];

                
            } else {
                [UIView animateWithDuration:1.0f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^(void){
                                     polygonView.alpha = 1;
                                 }
                                 completion:^(BOOL Finished){
                }];
            }
        }
    }
    
    if(self.scnMapView.camera.altitude > maximumAltitude && self.scnMapView.camera.pitch == 0  && self.mapFinishedLoading == YES) {
       
        UIAlertView *zoomedOutAlert = [[UIAlertView alloc] initWithTitle:@"Outside supported area" message:@"Sorry, we only support specific areas on the map" delegate:self cancelButtonTitle:@"Ok, take me back" otherButtonTitles: nil];
        [zoomedOutAlert setTag:0];
        
        [scnMapView setUserInteractionEnabled:NO];
        [zoomedOutAlert show];
    }
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    
    for (int i=0; i<[views count]; i++)
    {
        MKAnnotationView *annotationView = [views objectAtIndex:i];
        LocationAnnotation *annotationForView = (LocationAnnotation *)annotationView.annotation;
        if( [annotationView isKindOfClass:[AnnotationView class]]){
            
            [UIView animateWithDuration:0.65f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^(void){
                                 annotationView.alpha = 0.0f;
                                 
                             }
                             completion:^(BOOL Finished){
                                 annotationView.hidden = YES;
                                 annotationView.enabled = NO;
                             }];
            
        }
        
        if ([annotationForView isKindOfClass:[UserAnnotationView class]] || [annotationForView isKindOfClass:[MKUserLocation class]]){
            [[annotationView superview] sendSubviewToBack:annotationView];
        } else if ([annotationForView isKindOfClass:[AnnotationView class]]){
            [[annotationView superview] bringSubviewToFront:annotationView];
        }
    
    }

}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKMapPoint centerPoint = MKMapPointForCoordinate(self.scnMapView.centerCoordinate);
    BOOL inside = MKMapRectContainsPoint(_scnCircle.boundingMapRect, centerPoint);
    if (inside) {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.distanceFilter = 5;
    } else {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.locationManager.distanceFilter = 500;
    }
}

#pragma mark - Detail View Functions

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    MKPolygonRenderer *polygonRender = [[MKPolygonRenderer alloc] initWithOverlay:overlay];
    MKCircleRenderer *circleRender = [[MKCircleRenderer alloc] initWithCircle:overlay];
    if ([overlay.title isEqualToString:@"Bellomy"]){
    polygonRender.lineWidth=1;
    polygonRender.strokeColor=[UIColor colorWithRed:0.906 green:0.486 blue:0.561 alpha:0.9];
    polygonRender.fillColor=[UIColor colorWithRed:0.906 green:0.486 blue:0.561 alpha:0.5];
    return polygonRender;
    }
    if ([overlay.title isEqualToString:@"Campus"]){
        polygonRender.lineWidth=1;
        polygonRender.strokeColor=[UIColor colorWithRed:0.4 green:0.533 blue:0.867 alpha:1.0];
        polygonRender.fillColor=[UIColor colorWithRed:0.4 green:0.533 blue:0.867 alpha:0.5];
        return polygonRender;
    }
    if ([overlay.title isEqualToString:@"Dark Side"]){
        polygonRender.lineWidth=1;
        polygonRender.strokeColor=[UIColor colorWithRed:16.0/255.0f green:21.0/255.0f blue:54.0/255.0f alpha:0.5];
        polygonRender.fillColor=[UIColor colorWithRed:16.0/255.0f green:21.0/255.0f blue:54.0/255.0f alpha:0.5];
        return polygonRender;
    }
    if ([overlay.title isEqualToString:@"Domicilio"]){
        polygonRender.lineWidth=1;
        polygonRender.strokeColor=[UIColor colorWithRed:186.0/255.0f green:233.0/255.0f blue:131.0/255.0f alpha:0.5];
        polygonRender.fillColor=[UIColor colorWithRed:186.0/255.0f green:233.0/255.0f blue:131.0/255.0f alpha:0.5];
        return polygonRender;
    }
    if ([overlay.title isEqualToString:@"Villas"]){
        polygonRender.lineWidth=1;
        polygonRender.strokeColor=[UIColor colorWithRed:0.906 green:0.486 blue:0.561 alpha:0.9];
        polygonRender.fillColor=[UIColor colorWithRed:0.906 green:0.486 blue:0.561 alpha:0.5];
        return polygonRender;
    }
    if ([overlay.title isEqualToString:@"background"]){
        circleRender.lineWidth=1;
        circleRender.strokeColor=[UIColor colorWithRed:0.906 green:0.486 blue:0.561 alpha:0.2];
        circleRender.fillColor=[UIColor colorWithWhite:0 alpha:.1];
        return circleRender;
    }
    
    
//    if ([overlay isKindOfClass:[MKPolygon class]]){
//        // we get here in order to draw any polygon
//        //
//        MKPolygonRenderer *polygonView = [[MKPolygonRenderer alloc] initWithPolygon:(MKPolygon *)overlay];
//        
//        // use some sensible defaults - normally, you'd probably look for LineStyle & PolyStyle in the KML
//        //
//        polygonView.fillColor   = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:.4];
//        polygonView.strokeColor = [UIColor colorWithWhite:0.8f alpha:0.9f];
//        
//        polygonView.lineWidth = 2.0;
//        
//        return polygonView;
//    }
//    
    
    return nil;
}

-(void)drawOverlay{
    NSArray *allFiles = [[NSBundle mainBundle] pathsForResourcesOfType:@".kmz" inDirectory:nil];
    NSLog(@"Files Found:%@", allFiles);
    for (NSString __strong *filename in allFiles){
        
        NSError *error;
        filename = [[[[filename componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."] firstObject];
        SimpleKML *myKML = [SimpleKML KMLWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@".kmz"] error:&error];
        NSLog(@"%@", myKML.feature.name);
        
        
        if (myKML.feature && [myKML.feature isKindOfClass:[SimpleKMLDocument class]])
        {
            // see if the document has features of its own
            //
            for (SimpleKMLFeature *feature in ((SimpleKMLContainer *)myKML.feature).features)
            {
                // see if we have any placemark features with a point
                //
                if ([feature isKindOfClass:[SimpleKMLPlacemark class]] && ((SimpleKMLPlacemark *)feature).point)
                {
                    SimpleKMLPoint *point = ((SimpleKMLPlacemark *)feature).point;
                    
                    // create a normal point annotation for it
                    //
                    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                    
                    annotation.coordinate = point.coordinate;
                    NSLog(@"Coordinate %f", point.coordinate.latitude);
                    annotation.title      = feature.name;
                    
                    [self.scnMapView addAnnotation:annotation];
                }
                
                // otherwise, see if we have any placemark features with a polygon
                //
                else if ([feature isKindOfClass:[SimpleKMLPlacemark class]] && ((SimpleKMLPlacemark *)feature).polygon)
                {
                    SimpleKMLPolygon *polygon = (SimpleKMLPolygon *)((SimpleKMLPlacemark *)feature).polygon;
                    
                    SimpleKMLLinearRing *outerRing = polygon.outerBoundary;
                    
                    CLLocationCoordinate2D points[[outerRing.coordinates count]];
                    NSUInteger i = 0;
                    
                    for (CLLocation *coordinate in outerRing.coordinates)
                        points[i++] = coordinate.coordinate;
                    
                    // create a polygon annotation for it
                    
                    MKPolygon *overlayPolygon = [MKPolygon polygonWithCoordinates:points count:[outerRing.coordinates count]];
                    
                    NSLog(@"%lu", (unsigned long)self.scnMapView.overlays.count);
                    
                    [overlayPolygon setTitle:feature.name];
                    
                    [self.scnMapView addOverlay:overlayPolygon level:MKOverlayLevelAboveRoads];
                    
                    
                    double x, y;
                        x = MKMapRectGetMidX([overlayPolygon boundingMapRect]);
                        y = MKMapRectGetMidY([overlayPolygon boundingMapRect]);
                    NSLog(@"%f, %f", x, y);
                    NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
                    
                    
                    
                    /* FIX THIS!
                    LocationAnnotation *centerAnnotation = [[LocationAnnotation alloc] initWithCoordinate: MKCoordinateForMapPoint(MKMapPointMake(x, y)) andTitle:feature.name andSubtitle:[@([annotationArray count]) stringValue] withInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"OverlayAnnotation", @"Category", nil]];
                    
                    [self.scnMapView addAnnotation:centerAnnotation];
                     
                     */
                    // zoom the map to the polygon bounds
                    //
                }
            }
        }
    }
}

- (IBAction)currentLocationPressed:(id)sender {
    MKMapPoint userPoint = MKMapPointForCoordinate(scnMapView.userLocation.coordinate);
    NSLog(@"%f" ,scnMapView.userLocation.coordinate.latitude);
    BOOL inside = MKMapRectContainsPoint(_scnCircle.boundingMapRect, userPoint);
    if (inside){
        
        MKMapCamera* camera = [MKMapCamera
                               cameraLookingAtCenterCoordinate:self.scnMapView.userLocation.coordinate
                               fromEyeCoordinate:self.scnMapView.userLocation.coordinate
                               eyeAltitude:320];
        [self.scnMapView setCamera:camera animated:YES];
    }
    NSLog(@"Current Location Called");
}

#pragma mark-  UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0){
        if (buttonIndex == 0){
            MKMapPoint userPoint = MKMapPointForCoordinate(self.scnMapView.centerCoordinate);
            BOOL inside = MKMapRectContainsPoint(_scnCircle.boundingMapRect, userPoint);
            if (inside){
                MKMapCamera* camera = [MKMapCamera
                                   cameraLookingAtCenterCoordinate:self.scnMapView.centerCoordinate
                                   fromEyeCoordinate:self.scnMapView.centerCoordinate
                                   eyeAltitude:maximumAltitude-300];
                [self.scnMapView setCamera:camera animated:YES];
                [self.scnMapView setUserInteractionEnabled:YES];
            } else {
                MKMapCamera* camera = [MKMapCamera
                                       cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(centerSantaClaraLat, centerSantaClaraLong)
                                       fromEyeCoordinate:CLLocationCoordinate2DMake(centerSantaClaraLat, centerSantaClaraLong)
                                       eyeAltitude:maximumAltitude-200];
                [self.scnMapView setCamera:camera animated:YES];
                [self.scnMapView setUserInteractionEnabled:YES];
            }
        }
    }
    if (alertView.tag == 1){
        if  (buttonIndex == 0){
            [self loadAnnotations];
        }
    }
}

@end
