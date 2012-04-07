//
//  PGTFirstViewController.h
//  essaiLoc
//
//  Created by Pierre Gilot on 05/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "PGTDepartureAnnotation.h"
@class PGTFirstViewController;

@protocol PGTFirstViewControllerDelegate <NSObject>

- (void)firstViewController:(PGTFirstViewController *)controller didAddDepartureMark:(CLLocation*)mark;

@end

@interface PGTFirstViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, retain) IBOutlet MKMapView* mapView;
@property (nonatomic, retain) PGTDepartureAnnotation* departureAnnotation;

@property (nonatomic, weak) id <PGTFirstViewControllerDelegate> delegate;

-(IBAction)markLocation:(id)sender;

@end
