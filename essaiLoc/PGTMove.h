//
//  PGTMove.h
//  essaiLoc
//
//  Created by Pierre Gilot on 27/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>


@interface PGTMove : NSManagedObject

@property (nonatomic, retain) NSString * arrivalCity;
@property (nonatomic, retain) NSString * arrivalCountry;
@property (nonatomic, retain) NSDate * arrivalDate;
@property (nonatomic, retain) NSString * departureCountry;
@property (nonatomic, retain) NSString * departureCity;
@property (nonatomic, retain) NSDate * departureDate;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * move_id;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * lastModified;

@end
