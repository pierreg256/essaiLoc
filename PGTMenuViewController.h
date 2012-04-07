//
//  PGTMenuViewController.h
//  essaiLoc
//
//  Created by Pierre Gilot on 20/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "PGTSettingsViewController.h"
#import "PGTError.h"

@interface PGTMenuViewController : UITableViewController <RKObjectLoaderDelegate, PGTSettingsViewControllerDelegate>

@property (copy) NSMutableArray *tripMenuEntries;
@property (copy) NSMutableArray *tripMenuSubtitlesEntries;
@property (copy) NSMutableArray *applicationMenuEntries;
@property (copy) NSMutableArray *applicationMenuSubtitlesEntries;
@property (assign) NSArray* currentTrips;
@property (assign, readonly, getter=isAuthenticated) BOOL authenticated;
@property (retain) PGTUser *currentUser;


-(void)setupClient;
-(void)getClient;
-(void)updateViewsWithUser:(PGTUser*)newUser;
-(void)getTripsForCurrentUser;
-(void)reloadData;
@end
