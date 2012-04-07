//
//  PGTAnnotation.h
//  essaiLoc
//
//  Created by Pierre Gilot on 07/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PGTAnnotation : NSObject <MKAnnotation>

@property (nonatomic, retain) CLLocation* location;
@property (nonatomic, retain) CLGeocoder* reverseGeo;
@property (nonatomic, retain) NSString* city;
@property (nonatomic, retain) NSString* country;
@property (nonatomic, retain) NSDate* timeStamp;

-(id)initWithLocation:(CLLocation*)loc ;
- (NSString *)title;
- (NSString *)subtitle;

@end
