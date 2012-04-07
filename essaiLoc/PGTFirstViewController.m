//
//  PGTFirstViewController.m
//  essaiLoc
//
//  Created by Pierre Gilot on 05/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import "PGTFirstViewController.h"
#import "DDLog.h"

@interface PGTFirstViewController ()

@end

@implementation PGTFirstViewController

@synthesize mapView;
@synthesize departureAnnotation;

@synthesize delegate;

- (void)viewDidLoad
{
  DDLog(@"");
  [super viewDidLoad];
  
  self.mapView.userTrackingMode = MKUserTrackingModeFollow;
  //[self startStandardUpdates];
}

- (void)viewDidUnload
{
  DDLog(@"");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning {
	DDLog(@"");
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Appication Methods

-(IBAction)markLocation:(id)sender
{
  DDLog(@"User location : %@", self.mapView.userLocation.location);
  if (nil == self.departureAnnotation)
  {
    self.departureAnnotation = [[PGTDepartureAnnotation alloc] initWithLocation:self.mapView.userLocation.location ];
    [self.mapView addAnnotation:self.departureAnnotation];
    [self.delegate firstViewController:self didAddDepartureMark:self.mapView.userLocation.location];
  }

}


#pragma mark - MKMapView delegate methods
- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
  DDLog(@"");
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
	DDLog(@"");
	/*MKCoordinateRegion toto;
   MKCoordinateSpan titi;
   titi.latitudeDelta = .1;
   titi.longitudeDelta = .1;
   toto.center = mapView.userLocation.location.coordinate;
   toto.span = titi;
   [mapView setRegion:toto animated:YES];
   //[mapView setCenterCoordinate:mapView.userLocation.location.coordinate];
   // we have received our current location, so enable the "Get Current Address" button
   */
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
      UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
      [rightButton addTarget:self
                      action:@selector(showDetails:)
            forControlEvents:UIControlEventTouchUpInside];
      customPinView.rightCalloutAccessoryView = rightButton;
      
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



@end
