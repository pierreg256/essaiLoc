//
//  PGTAnnotation.m
//  essaiLoc
//
//  Created by Pierre Gilot on 07/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import "PGTAnnotation.h"

@implementation PGTAnnotation

@synthesize location, reverseGeo;
@synthesize city, country, timeStamp;

-(id)initWithLocation:(CLLocation*)loc 
{
  self.location = loc;
  
  if (!self.reverseGeo) {
    self.reverseGeo = [[CLGeocoder alloc] init];
  }
  
  [self.reverseGeo reverseGeocodeLocation:loc completionHandler: 
   ^(NSArray *placemarks, NSError *error) {
     
     for (CLPlacemark *placemark in placemarks) {
       
       self.city=[placemark locality];
       self.country=[placemark country];
       self.timeStamp = [NSDate date];
       
     }
   }];
  
  return self;
}


- (CLLocationCoordinate2D) coordinate 
{
  return self.location.coordinate;
}

- (NSString *)title
{
  return self.city;
}

- (NSString *)subtitle
{
  return [NSString stringWithFormat:@"%@, %@", self.country, self.timeStamp];
}

@end
