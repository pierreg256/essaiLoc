//
//  PGTSettingsViewController.m
//  essaiLoc
//
//  Created by Pierre Gilot on 20/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import "PGTSettingsViewController.h"
#import "DDLog.h"
#import "PGTUser.h"

@interface PGTSettingsViewController ()

@end

@implementation PGTSettingsViewController
@synthesize signupEmailTextField;
@synthesize signupPasswordTextField;
@synthesize cancelButton;
@synthesize loginButtonCell;

@synthesize delegate;
@synthesize emailTextField, passwordTextField;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  DDLog(@"");
  self.emailTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kUserIDKey]; 
  self.passwordTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kUserPwdKey]; 
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  if (self.delegate) {
    if ([self.delegate settingsViewControllerCanShowCancel:self]) {
      self.cancelButton.enabled = YES;
      self.emailTextField.enabled=NO;
      self.passwordTextField.enabled=NO;
      self.loginButtonCell.textLabel.text = @"Log Out";
    } else {
      self.cancelButton.enabled = NO;
      self.emailTextField.enabled=YES;
      self.passwordTextField.enabled=YES;
      self.loginButtonCell.textLabel.text = @"Log In";
    }
  }
  
}

- (void)viewDidUnload
{
  [self setEmailTextField:nil];
  [self setSignupEmailTextField:nil];
  [self setSignupPasswordTextField:nil];
  [self setCancelButton:nil];
  [self setLoginButtonCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - application methods
-(IBAction)cancel:(id)sender
{
  [self.delegate settingsViewControllerDidCancel:self];
}

-(void) logOut
{
  DDLog(@"");
  [self.delegate settingsViewControllerDidLogUserOut:self];
  self.cancelButton.enabled = NO;
  self.loginButtonCell.textLabel.text = @"Log In";
  self.emailTextField.enabled=YES;
  self.passwordTextField.enabled=YES;

}

-(void) logIn
{
  DDLog(@"");
  if ((self.emailTextField.text.length > 0) && (passwordTextField.text.length > 0)) {
    // actually do th elogin
      PGTUser* user = [PGTUser object];
      user.email = self.emailTextField.text;
      RKObjectManager* manager = [RKObjectManager sharedManager];  

    [manager getObject:user delegate:self block:^(RKObjectLoader* loader) {
      //loader.objectMapping = user.mapping;
        loader.username = emailTextField.text;
        loader.password = passwordTextField.text;
        loader.authenticationType=RKRequestAuthenticationTypeHTTPBasic;
        loader.cachePolicy =  RKRequestCachePolicyLoadIfOffline | RKRequestCachePolicyTimeout;
        loader.cache.storagePolicy = RKRequestCacheStoragePolicyPermanently;
      }];
      
  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" 
                                                    message:@"email and password are required to log-in."
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];
  }
}

-(void) signUp
{
  DDLog(@"");
  if ((self.signupEmailTextField.text.length > 0) && (self.signupPasswordTextField.text.length > 0)) {
    // actually do th elogin
    PGTUser* user = [PGTUser object];
    user.email = self.signupEmailTextField.text;
    user.password = self.signupPasswordTextField.text;
    
    RKObjectManager* manager = [RKObjectManager sharedManager];  

    [manager postObject:user delegate:self block:^(RKObjectLoader* loader) {
      //loader.serializationMapping = user.serializationMapping;
      //loader.objectMapping = user.mapping;
      loader.username = signupEmailTextField.text;
      loader.password = signupPasswordTextField.text;
      loader.authenticationType=RKRequestAuthenticationTypeHTTPBasic;
      loader.cachePolicy =  RKRequestCachePolicyLoadIfOffline | RKRequestCachePolicyTimeout;
      loader.cache.storagePolicy = RKRequestCacheStoragePolicyPermanently;
    }];
    
  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" 
                                                    message:@"email and password are required to signup."
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];
  }
}

-(IBAction)nextField:(id)sender
{
  DDLog(@"");
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
  if ((indexPath.section ==0) && (indexPath.row == 2)) {
    if ([self.delegate settingsViewControllerCanShowCancel:self]){
      [self logOut];
    } else {
      [self logIn];
    }
  } else {
    if ((indexPath.section == 1) && (indexPath.row == 2)) {
      [self signUp];
    }
  }
}

#pragma mark - RKObjectLoaderDelegate Methods
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
  DDLog(@"status code:%d", objectLoader.response.statusCode);
  if ((objectLoader.isGET) && (objectLoader.response.statusCode ==401)){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" 
                                                    message:@"Invalid Credentials. If this is your first time, try to create an account before loggin in."
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];
  }
  
  if ((objectLoader.isPOST) && (objectLoader.response.statusCode ==403)){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SignUp Error" 
                                                    message:@"This email is already registered. Try to sign up with another one."
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];
  }
  
  if (objectLoader.response.statusCode == 500) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Error" 
                                                    message:@"The server answered with an unexpected error. PLease try again later."
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];
  }
  
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
  DDLog(@"");
  if ((objectLoader.isGET) && (objectLoader.response.statusCode == 200)) {
    [[NSUserDefaults standardUserDefaults] setObject:emailTextField.text forKey:kUserIDKey];
    [[NSUserDefaults standardUserDefaults] setObject:passwordTextField.text forKey:kUserPwdKey];
    [self.delegate settingsViewController:self didLogUserIn:object];
  }
  
  if ((objectLoader.isPOST) && (objectLoader.response.statusCode == 201)) {
    [[NSUserDefaults standardUserDefaults] setObject:signupEmailTextField.text forKey:kUserIDKey];
    [[NSUserDefaults standardUserDefaults] setObject:signupPasswordTextField.text forKey:kUserPwdKey];
    [self.delegate settingsViewController:self didLogUserIn:object];
  }
  
}

#pragma mark _ UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  DDLog(@"");
  if (textField == emailTextField) {
    [emailTextField resignFirstResponder];
    [passwordTextField becomeFirstResponder];
  } else {
    if (textField == passwordTextField) {
      [passwordTextField resignFirstResponder];
      [self logIn];
    } else {
      if (textField == signupEmailTextField) {
        [signupEmailTextField resignFirstResponder];
        [signupPasswordTextField becomeFirstResponder];
      } else {
        if (textField == signupPasswordTextField) {
          [signupPasswordTextField resignFirstResponder];
          [self signUp];
        }
      }
    }
  }
  return YES;
}

@end
