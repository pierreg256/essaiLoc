//
//  PGTTrip.m
//  essaiLoc
//
//  Created by Pierre Gilot on 05/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import "PGTTrip.h"

@implementation PGTTrip

@synthesize departure, arrival, dateFormatter;
//@synthesize subTitle;


- (NSString*) title
{
  if (!departure) {
    return @"Not Started";
  } else {
    NSString* result = [NSString stringWithFormat:@"From %@", departure.city];
    
    if (arrival) {
      result = [NSString stringWithFormat:@"%@ to %@", result, arrival.city];
    }
    
    return result;
  }
    
  return @"uh oh!"; //[NSString stringWithFormat:@"From %@ to %@", departureCity, @"YYY"];
}

- (NSString*) subTitle
{
  if (!self.dateFormatter) {
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"]];

  }
  
  if (!departure) {
    return @"This trip has not yet started...";
  } else {
    return [dateFormatter stringFromDate:departure.timeStamp];
  }
  return @"Uh oh";
}


@end
