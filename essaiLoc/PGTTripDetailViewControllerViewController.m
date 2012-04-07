//
//  PGTTripDetailViewControllerViewController.m
//  essaiLoc
//
//  Created by Pierre Gilot on 07/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import "PGTTripDetailViewControllerViewController.h"

@interface PGTTripDetailViewController ()

@end

@implementation PGTTripDetailViewController

@synthesize delegate;
@synthesize tripDetailMap, userTrackingButton;
@synthesize tripDetails, departureAnnotation, arrivalAnnotation;

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
  DDLog(@"");
    [super viewDidLoad];
  // Register observer to be called when download of data is complete
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(startDetail:) 
                                               name:@"tripidentified" object:nil]; 
  //  self.tripDetailMap.userTrackingMode = MKUserTrackingModeNone;
  self.tripDetailMap.mapType = MKMapTypeHybrid;
  self.tripDetailMap.delegate=self;
  self.tripDetailMap.showsUserLocation = NO;
  self.tripDetailMap.zoomEnabled = YES;
  self.tripDetailMap.scrollEnabled = YES;
  [self.tripDetailMap setUserTrackingMode:MKUserTrackingModeNone animated:YES];
}

- (void)viewDidUnload
{
  DDLog(@"");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc 
{
  DDLog(@"");
  self.tripDetailMap.userTrackingMode = MKUserTrackingModeNone;
  self.tripDetailMap.delegate = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Appication Methods

-(IBAction)markLocation:(id)sender
{
  DDLog(@"");
  if (nil == self.departureAnnotation)
  {
    self.departureAnnotation = [[PGTDepartureAnnotation alloc] initWithLocation:self.tripDetailMap.userLocation.location ];
    [self.tripDetailMap addAnnotation:self.departureAnnotation];
    [self.delegate tripDetailViewController:self didAddDepartureAnnotation:self.departureAnnotation];
    [self.tripDetailMap selectAnnotation:self.departureAnnotation animated:YES];
  }
  else {
    if (nil == self.arrivalAnnotation) {
      self.arrivalAnnotation = [[PGTArrivalAnnotation alloc] initWithLocation:self.tripDetailMap.userLocation.location ];
      [self.tripDetailMap addAnnotation:self.arrivalAnnotation];
      [self.delegate tripDetailViewController:self didAddArrivalAnnotation:self.arrivalAnnotation];
      
      self.tripDetailMap.showsUserLocation = NO;
      [self.tripDetailMap setUserTrackingMode:MKUserTrackingModeNone animated:YES];
      [self centerMyPosition];

    }
  }
  
}

- (void) startDetail:(NSNotification *)notif
{
  DDLog(@"");
  self.tripDetails = nil;
  [self.delegate tripDetailViewControllerWillStart:self];
  
  DDLog("tripdetails: %@", self.tripDetails);
  
  self.departureAnnotation = self.tripDetails.departure;
  self.arrivalAnnotation = self.tripDetails.arrival;
  
  if (self.departureAnnotation) {
    [self.tripDetailMap addAnnotation:self.departureAnnotation];
  }

  if (self.arrivalAnnotation) {
    [self.tripDetailMap addAnnotation:self.arrivalAnnotation];
  }
  
  if ((nil == self.departureAnnotation) || (nil == self.arrivalAnnotation)) {
    //self.tripDetailMap.
    self.tripDetailMap.showsUserLocation = YES;
    DDLog(@"hey");
    [self.tripDetailMap setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
  } else {
    self.tripDetailMap.showsUserLocation = NO;
    [self.tripDetailMap setUserTrackingMode:MKUserTrackingModeNone animated:YES];
    [self centerMyPosition];
  }
	// Do any additional setup after loading the view, typically from a nib.
  //self.userTrackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.tripDetailMap];
}

- (void)centerMyPosition
{
  CLLocationDegrees north = MIN(self.departureAnnotation.coordinate.latitude, self.arrivalAnnotation.coordinate.latitude);
  CLLocationDegrees south = MAX(self.departureAnnotation.coordinate.latitude, self.arrivalAnnotation.coordinate.latitude);
  CLLocationDegrees east = MIN(self.departureAnnotation.coordinate.longitude, self.arrivalAnnotation.coordinate.longitude);
  CLLocationDegrees west = MAX(self.departureAnnotation.coordinate.longitude, self.arrivalAnnotation.coordinate.longitude);
  
  MKCoordinateSpan monSpan = MKCoordinateSpanMake(ABS(south-north)*1.2, ABS(west-east)*1.2);
  MKCoordinateRegion maRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake((north+south)/2, (east+west)/2), monSpan);
  //  toto.center = CLLocationCoordinate2DMake((north+south)/2, (east+west)/2); //[self.departureAnnotation coordinate];//myAnnotation.coordinate;
  //toto.span = titi;
  [self.tripDetailMap setRegion:maRegion animated:YES];
}


#pragma mark - MKMapView Delegate methods
- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
  DDLog(@"user tracking mode:%d", mode);
  if (self.arrivalAnnotation) {
    [self.tripDetailMap setUserTrackingMode:MKUserTrackingModeNone animated:animated];
  } else {
    [self.tripDetailMap setUserTrackingMode:MKUserTrackingModeFollow animated:animated];
  }
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
  DDLog(@"error: %@",error);
}
- (MKAnnotationView *) mapView:(MKMapView *) aMapView viewForAnnotation:(id ) annotation 
{
  DDLog(@"");
  // if it's the user location, just return nil.
  if ([annotation isKindOfClass:[MKUserLocation class]])
    return nil;
  
  if ([annotation isKindOfClass:[PGTDepartureAnnotation class]])
  {
    // try to dequeue an existing pin view first
    static NSString* DepartureAnnotationIdentifier = @"DepartureAnnotationIdentifier";
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)
    [aMapView dequeueReusableAnnotationViewWithIdentifier:DepartureAnnotationIdentifier];
    if (!pinView)
    {
      // if an existing pin view was not available, create one
      MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                            initWithAnnotation:annotation reuseIdentifier:DepartureAnnotationIdentifier];
      customPinView.pinColor = MKPinAnnotationColorGreen;
      customPinView.animatesDrop = YES;
      customPinView.canShowCallout = YES;
      
      // add a detail disclosure button to the callout which will open a new view controller page
      //
      // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
      //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
      //
      /*
      UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
      [rightButton addTarget:self
                      action:@selector(showDetails:)
            forControlEvents:UIControlEventTouchUpInside];
      customPinView.rightCalloutAccessoryView = rightButton;
      */
      UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
      customPinView.leftCalloutAccessoryView = sfIconView;
      //[sfIconView release];
      
      return customPinView;
    }
    else
    {
      pinView.annotation = annotation;
    }
    return pinView;
  }
  
  if ([annotation isKindOfClass:[PGTArrivalAnnotation class]])
  {
    // try to dequeue an existing pin view first
    static NSString* ArrivalAnnotationIdentifier = @"ArrivalAnnotationIdentifier";
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)
    [aMapView dequeueReusableAnnotationViewWithIdentifier:ArrivalAnnotationIdentifier];
    if (!pinView)
    {
      // if an existing pin view was not available, create one
      MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                            initWithAnnotation:annotation reuseIdentifier:ArrivalAnnotationIdentifier];
      customPinView.pinColor = MKPinAnnotationColorRed;
      customPinView.animatesDrop = YES;
      customPinView.canShowCallout = YES;
      
      // add a detail disclosure button to the callout which will open a new view controller page
      //
      // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
      //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
      //
      /*
       UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
       [rightButton addTarget:self
       action:@selector(showDetails:)
       forControlEvents:UIControlEventTouchUpInside];
       customPinView.rightCalloutAccessoryView = rightButton;
       */
      UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
      customPinView.leftCalloutAccessoryView = sfIconView;
      //[sfIconView release];
      
      return customPinView;
    }
    else
    {
      pinView.annotation = annotation;
    }
    return pinView;
  }
  return nil;
}

#pragma mark - StoryBoardElements

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  DDLog(@"Prepare for segue : %@", segue.identifier);
}



@end
