//
//  PGTTripDetailViewControllerViewController.h
//  essaiLoc
//
//  Created by Pierre Gilot on 07/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "DDLog.h"
#import "PGTDepartureAnnotation.h"
#import "PGTArrivalAnnotation.h"
#import "PGTTrip.h"

@class PGTTripDetailViewController;

@protocol PGTTripDetailViewControllerDelegate <NSObject>

- (void)tripDetailViewController:(PGTTripDetailViewController *)controller didAddDepartureAnnotation:(PGTDepartureAnnotation*)annotation;
- (void)tripDetailViewController:(PGTTripDetailViewController *)controller didAddArrivalAnnotation:(PGTArrivalAnnotation*)annotation;
- (void)tripDetailViewControllerWillStart:(PGTTripDetailViewController *)controller ;

@end


@interface PGTTripDetailViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, weak) id <PGTTripDetailViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet MKMapView* tripDetailMap;
@property (nonatomic, retain) IBOutlet MKUserTrackingBarButtonItem* userTrackingButton;
@property (nonatomic, retain) PGTDepartureAnnotation* departureAnnotation;
@property (nonatomic, retain) PGTArrivalAnnotation* arrivalAnnotation;
@property (nonatomic, retain) PGTTrip* tripDetails;

-(IBAction)markLocation:(id)sender;
- (void) startDetail:(NSNotification *)notif;
@end
