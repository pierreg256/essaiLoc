//
//  PGTPlanTripViewController.h
//  essaiLoc
//
//  Created by Pierre Gilot on 05/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGTPlanTripViewController;

@protocol PGTPlanTripViewControllerDelegate <NSObject>
- (void)planTripViewControllerDidCancel:
(PGTPlanTripViewController *)controller;
- (void)planTripViewControllerDidSave:
(PGTPlanTripViewController *)controller;
@end

@interface PGTPlanTripViewController : UIViewController


@property (nonatomic, weak) id <PGTPlanTripViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
