//
//  PGTTableViewController.h
//  essaiLoc
//
//  Created by Pierre Gilot on 05/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGTPlanTripViewController.h"
#import "PGTTripDetailViewControllerViewController.h"
#import "PGTTrip.h"
#import "PGTCell.h"

@interface PGTTableViewController : UITableViewController <PGTPlanTripViewControllerDelegate, 
                                                          PGTTripDetailViewControllerDelegate>

@property (nonatomic, assign) NSUInteger lastIndex;
@property (nonatomic, retain) NSMutableArray* trips;

@end
