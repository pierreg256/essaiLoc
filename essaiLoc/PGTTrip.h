//
//  PGTTrip.h
//  essaiLoc
//
//  Created by Pierre Gilot on 05/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PGTDepartureAnnotation.h"
#import "PGTArrivalAnnotation.h"

@interface PGTTrip : NSObject
{
  NSString* departureCountry;
  NSString* departureCity;
}

@property (nonatomic, strong) PGTDepartureAnnotation* departure;
@property (nonatomic, strong) PGTArrivalAnnotation* arrival;
@property (nonatomic, strong, readonly) NSString* title;
@property (nonatomic, strong, readonly) NSString* subTitle;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;


@end
