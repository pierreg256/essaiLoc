//
//  PGTSettingsViewController.h
//  essaiLoc
//
//  Created by Pierre Gilot on 20/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "PGTUser.h"

@class PGTSettingsViewController;

@protocol PGTSettingsViewControllerDelegate <NSObject>
- (void)settingsViewControllerDidCancel:(PGTSettingsViewController *)controller;
- (BOOL)settingsViewControllerCanShowCancel:(PGTSettingsViewController *)controller;
- (void)settingsViewController:(PGTSettingsViewController*)controller didLogUserIn:(PGTUser*)user;
-(void)settingsViewControllerDidLogUserOut:(PGTSettingsViewController *)controller;


@optional
- (void)playerDetailsViewControllerDidSave:(PGTSettingsViewController *)controller;
@end

@interface PGTSettingsViewController : UITableViewController <RKObjectLoaderDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id<PGTSettingsViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *signupEmailTextField;
@property (strong, nonatomic) IBOutlet UITextField *signupPasswordTextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UITableViewCell *loginButtonCell;

-(IBAction)cancel:(id)sender;
-(IBAction)nextField:(id)sender;
-(void) logIn;
-(void) signUp;

@end
