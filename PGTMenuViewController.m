//
//  PGTMenuViewController.m
//  essaiLoc
//
//  Created by Pierre Gilot on 20/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import "PGTMenuViewController.h"
#import "CustomCellBackground.h"
#import "CustomFooter.h"
#import "CustomHeader.h"
#import "PGTCell.h"
#import "DDLog.h"
#import "PGTCache.h"
#import "PGTUser.h"
#import "PGTMove.h"
//#import <RestKit/NSString+RestKit.h>

@interface PGTMenuViewController ()

@end

@implementation PGTMenuViewController

@synthesize tripMenuEntries = _tripMenuEntries, applicationMenuEntries = _applicationMenuEntries;
@synthesize tripMenuSubtitlesEntries = _tripMenuSubtitlesEntries, applicationMenuSubtitlesEntries = _applicationMenuSubtitlesEntries;
@synthesize authenticated = _authenticated;
@synthesize currentUser, currentTrips;


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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  //self.title = @"Home";
  _authenticated = NO;
  UIImage *image = [UIImage imageNamed:@"essaiLocTitle"];
  self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
  self.navigationItem.titleView.contentMode = UIViewContentModeScaleToFill;
  self.tripMenuEntries = [NSMutableArray arrayWithObjects:@"Current Trips", @"Upcoming trips", @"Last Trips", nil];
  self.tripMenuSubtitlesEntries = [NSMutableArray arrayWithObjects:@"See what's next", @"Manage your planned trips", @"Check out your history", nil];
  self.applicationMenuEntries = [NSMutableArray arrayWithObjects:@"Horses", @"Network", @"Settings", nil];
  self.applicationMenuSubtitlesEntries = [NSMutableArray arrayWithObjects:@"Declare and Manage Horses", @"Tell your firends about your trips", @"Manage your credentials", nil];
  
  [self setupClient];
  [self getClient];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)updateViewsWithUser:(PGTUser *)newUser
{
  DDLog(@"");
  self.currentUser = newUser;
  _authenticated = YES;
  
 /*
  PGTMove* myMove = [PGTMove object];
  myMove.departureCountry = @"Italy";
  myMove.departureCity = @"Milan";
  myMove.departureDate = [NSDate date];
  myMove.arrivalCity = @"Paris";
  myMove.arrivalCountry=@"France";
  myMove.arrivalDate=[NSDate date];
  myMove.user_id = self.currentUser.email;
  
  [[RKObjectManager sharedManager] postObject:myMove delegate:self block:^(RKObjectLoader* loader) {
    //    loader.objectMapping = user.mapping;
    loader.username = [[NSUserDefaults standardUserDefaults] stringForKey:kUserIDKey];// @"pierre.gilot@me.com";
    loader.password = [[NSUserDefaults standardUserDefaults] stringForKey:kUserPwdKey];;
    loader.authenticationType=RKRequestAuthenticationTypeHTTPBasic;
    loader.cachePolicy =  RKRequestCachePolicyLoadIfOffline | RKRequestCachePolicyTimeout;
    loader.cache.storagePolicy = RKRequestCacheStoragePolicyPermanently;
  }];
  
  */

  
  [self getTripsForCurrentUser];
  // get users trips :-)
  
}

-(void) reloadData
{
  DDLog(@"");
	NSFetchRequest* request = [PGTMove fetchRequest];
	NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"departureDate" ascending:NO];
	[request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                            @"(user_id = %@)", self.currentUser.email];
  [request setPredicate:predicate];
	//_statuses = [[RKTStatus objectsWithFetchRequest:request] retain];
  NSArray* users = [PGTMove objectsWithFetchRequest:request];
  DDLog(@"users:%d", [users count]);
  //PGTUser* user = [users objectAtIndex:0];
  //DDLog(@"user 1: %@, %@, %@", user.email, user.password, user.createdAt);
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return @"Manage your trips";
  } else {
    return @"Other businesses";
  }
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 50;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  CustomHeader *header = [[CustomHeader alloc] init] ;        
  header.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
  if (section == 1) {
    header.lightColor = [UIColor colorWithRed:147.0/255.0 green:105.0/255.0 blue:216.0/255.0 alpha:1.0];
    header.darkColor = [UIColor colorWithRed:72.0/255.0 green:22.0/255.0 blue:137.0/255.0 alpha:1.0];
  }
  return header;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 15;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  return [[CustomFooter alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section == 0) {
    return _tripMenuEntries.count;
  } else {
    return _applicationMenuEntries.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  DDLog(@"");
    static NSString *CellIdentifier = @"menuCell";
    PGTCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  cell.backgroundView = [[CustomCellBackground alloc] init];
  cell.selectedBackgroundView = [[CustomCellBackground alloc] init];
  
  //DDLog(@"cell: %@", cell);
  
    // Configure the cell...
  NSString *entry;
  NSString *subtitle;
  if (indexPath.section == 0) {
    entry = [_tripMenuEntries objectAtIndex:indexPath.row];
    subtitle = [_tripMenuSubtitlesEntries objectAtIndex:indexPath.row];
    
    ((CustomCellBackground *)cell.backgroundView).lastCell = indexPath.row == _tripMenuEntries.count - 1;
    ((CustomCellBackground *)cell.selectedBackgroundView).lastCell = indexPath.row == _tripMenuEntries.count - 1;
  } else {
    entry = [_applicationMenuEntries objectAtIndex:indexPath.row];
    subtitle = [_applicationMenuSubtitlesEntries objectAtIndex:indexPath.row];

    ((CustomCellBackground *)cell.backgroundView).lastCell = indexPath.row == _applicationMenuEntries.count - 1;
    ((CustomCellBackground *)cell.selectedBackgroundView).lastCell = indexPath.row == _applicationMenuEntries.count - 1;
  }        
  cell.textLabel.text = entry;
  cell.textLabel.backgroundColor = [UIColor clearColor];    
  cell.textLabel.highlightedTextColor = [UIColor blackColor];

  cell.detailTextLabel.text = subtitle;
  cell.detailTextLabel.backgroundColor = [UIColor clearColor];    
  cell.detailTextLabel.highlightedTextColor = [UIColor blackColor];
    
  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if ((indexPath.section == 0) && (indexPath.row == 1)) {
    [self performSegueWithIdentifier:@"upcomingTripsSegue" sender:self];
  }
  
  if ((indexPath.section == 1) && (indexPath.row == 2)) {
    // do segue...
    [self performSegueWithIdentifier: @"settingsSegue" sender: self];
  }
}
#pragma mark - Segue Methods
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  DDLog(@"");
  if ([segue.identifier isEqualToString:@"settingsSegue"])
	{
		UINavigationController *navigationController = segue.destinationViewController;
		PGTSettingsViewController *settingsController = [[navigationController viewControllers] objectAtIndex:0];
		settingsController.delegate = self;
	}
}

#pragma mark - RKClient functions
-(void) setupClient
{
  // Initialize RestKit
	RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:[NSURL URLWithString:@"http://pierreg256.no.de/api"]];
  
  // Enable automatic network activity indicator management
  objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
  objectManager.serializationMIMEType = RKMIMETypeJSON;
  
  NSString *seedDatabaseName = nil;
  NSString *databaseName = @"essaiLOCData.sqlite";
  
  objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:databaseName usingSeedDatabaseName:seedDatabaseName managedObjectModel:nil delegate:self];


  [RKManagedObjectMapping addDefaultDateFormatterForString:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'" inTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

  
  //objectManager.objectStore.managedObjectCache = [[PGTCache alloc]init];
    objectManager.objectStore.cacheStrategy = [[PGTCache alloc] init];
    
    RKObjectMapping* errorMapping = [RKObjectMapping mappingForClass:[PGTError class]];
    [errorMapping mapAttributes:@"code", @"message", nil];
    [[RKObjectManager sharedManager].mappingProvider setMapping:errorMapping forKeyPath:@"errors"];
    
    RKManagedObjectMapping* horseMapping = [RKManagedObjectMapping mappingForEntityWithName:@"PGTHorse" inManagedObjectStore:objectManager.objectStore];
    horseMapping.primaryKeyAttribute = @"horseID";
    [horseMapping mapKeyPath:@"id" toAttribute:@"horseID"];
    [horseMapping mapKeyPath:@"created_at" toAttribute:@"createdAt"];
    [horseMapping mapAttributes:@"name", nil];  
    [[RKObjectManager sharedManager].mappingProvider setMapping:horseMapping forKeyPath:@"horses"];
  
    
    RKObjectMapping* moveSerializationMapping;
  
    moveSerializationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [moveSerializationMapping mapKeyPathsToAttributes:
     @"createdAt", @"created_at",
     @"lastModified", @"last_modified",
     @"departureCountry", @"departure_country", 
     @"departureCity", @"departure_city",
     @"departureDate", @"departure_date", 
     @"arrivalCountry", @"arrival_country", 
     @"arrivalCity", @"arrival_city", 
     @"arrivalDate",@"arrival_date", 
     @"user_id", @"user_id",
     nil];
  [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:moveSerializationMapping forClass:[PGTMove class]];
  
  
  RKManagedObjectMapping* moveMapping;
  
    /*!
     Map to a target object class -- just as you would for a non-persistent class. The entity is resolved
     for you using the Active Record pattern where the class name corresponds to the entity name within Core Data.
     Twitter status objects will be mapped onto RKTStatus instances.
     */
    moveMapping = [RKManagedObjectMapping mappingForClass:[PGTMove class] inManagedObjectStore:objectManager.objectStore];
    moveMapping.primaryKeyAttribute = @"move_id";
    [moveMapping mapKeyPathsToAttributes:
     @"created_at", @"createdAt",
     @"last_modified", @"lastModified",
     @"departure_country", @"departureCountry",
     @"departure_city", @"departureCity",
     @"departure_date", @"departureDate",
     @"arrival_country", @"arrivalCountry",
     @"arrival_city", @"arrivalCity",
     @"arrival_date", @"arrivalDate",
     @"user_id", @"user_id",
     nil];
  [[RKObjectManager sharedManager].mappingProvider setMapping:moveMapping forKeyPath:@"moves"];

  
  RKObjectMapping* userSerializationMapping;
  
    userSerializationMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [userSerializationMapping mapKeyPathsToAttributes:
     @"createdAt", @"created_at",
     @"lastModified", @"last_modified",
     @"firstName", @"firstname", 
     @"lastName", @"lastname", 
     @"email", @"email", 
     @"password", @"password", 
     nil];
  [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:userSerializationMapping forClass:[PGTUser class]];


  RKManagedObjectMapping* userMapping;
  
    userMapping = [RKManagedObjectMapping mappingForClass:[PGTUser class] inManagedObjectStore:objectManager.objectStore];
    userMapping.primaryKeyAttribute = @"email";
    [userMapping mapKeyPathsToAttributes:
     @"created_at", @"createdAt",
     @"last_modified", @"lastModified",
     @"firstname", @"firstName",
     @"lastname", @"lastName",
     @"email", @"email",
     @"password", @"password", 
     nil];
  [[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@"users"];
  
  RKObjectMapping* errorsMapping = [RKObjectMapping mappingForClass:[PGTError class]];
  [errorsMapping mapKeyPathsToAttributes:@"code", @"message", nil];
  [[RKObjectManager sharedManager].mappingProvider setMapping:errorsMapping forKeyPath:@"errors"];
  
  // setup routes
  RKObjectRouter* router = [objectManager router];
  [router routeClass:[PGTUser class] toResourcePath:@"/users/:email" ];
  [router routeClass:[PGTMove class] toResourcePath:@"/users/:user_id/moves"];
  
}

- (void)loadObjectsFromDataStore {
	//[_statuses release];
	NSFetchRequest* request = [PGTUser fetchRequest];
	//NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
	//[request setSortDescriptors:[NSArray arrayWithObject:descriptor]];
	//_statuses = [[RKTStatus objectsWithFetchRequest:request] retain];
  NSArray* users = [PGTUser objectsWithFetchRequest:request];
  DDLog(@"users:%d", [users count]);
  PGTUser* user = [users objectAtIndex:0];
  DDLog(@"user 1: %@, %@, %@", user.email, user.password, user.createdAt);
}

-(void)getClient
{
  PGTUser* user = [PGTUser object];
  user.email = [[NSUserDefaults standardUserDefaults] stringForKey:kUserIDKey];
  RKObjectManager* manager = [RKObjectManager sharedManager];  
  
  [manager getObject:user usingBlock:^(RKObjectLoader* loader) {
    //loader.objectMapping = user.mapping;
      loader.delegate = self;
    loader.username = [[NSUserDefaults standardUserDefaults] stringForKey:kUserIDKey];// @"pierre.gilot@me.com";
    loader.password = [[NSUserDefaults standardUserDefaults] stringForKey:kUserPwdKey];;
    loader.authenticationType=RKRequestAuthenticationTypeHTTPBasic;
    loader.cachePolicy =  RKRequestCachePolicyLoadIfOffline | RKRequestCachePolicyTimeout;
    loader.cache.storagePolicy = RKRequestCacheStoragePolicyPermanently;
  }];
  
}

-(void)getTripsForCurrentUser
{
  DDLog(@"current user: %@", self.currentUser.email);
  self.currentTrips = nil;
  
  NSString *resourcePath = [NSString stringWithFormat:@"/users/%@/moves", currentUser.email];
  
  [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath usingBlock:^(RKObjectLoader* loader) {
      loader.delegate = self;
      loader.username = currentUser.email;
    loader.password = currentUser.password;
    loader.authenticationType=RKRequestAuthenticationTypeHTTPBasic;
    loader.cachePolicy =  RKRequestCachePolicyLoadIfOffline | RKRequestCachePolicyTimeout;
    loader.cache.storagePolicy = RKRequestCacheStoragePolicyPermanently;
  }];
  
  
  /*
  PGTMove* queryMove = [PGTMove object];
  
  queryMove.user_id = self.currentUser.email;
  
  RKObjectManager* manager = [RKObjectManager sharedManager];  
  [manager getObject:queryMove delegate:self block:^(RKObjectLoader* loader) {
    loader.username = [[NSUserDefaults standardUserDefaults] stringForKey:kUserIDKey];
    loader.password = [[NSUserDefaults standardUserDefaults] stringForKey:kUserPwdKey];
    loader.authenticationType=RKRequestAuthenticationTypeHTTPBasic;
    loader.cachePolicy =  RKRequestCachePolicyLoadIfOffline | RKRequestCachePolicyTimeout;
    loader.cache.storagePolicy = RKRequestCacheStoragePolicyPermanently;
  }];
  */
}
- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
  DDLog(@"Query Error : %d", objectLoader.response.statusCode);
    DDLog(@"Error response: %@", objectLoader.response.bodyAsString);
    
  id rawError = [error.userInfo valueForKey:RKObjectMapperErrorObjectsKey];
  DDLog(@"err type:%@", rawError);
  if ([rawError isKindOfClass:[PGTError class]])
  {
    PGTError* err = (PGTError*)rawError;
    DDLog(@"Error: %@ - %@", err.code, err.message);
  }

  
  if (objectLoader.response.statusCode == 501) {
    // time for debug
    DDLog(@"params %@", objectLoader.params);
  }
  
  if (objectLoader.response.statusCode == 401) {
    _authenticated = NO;
    // lancer le segue
    [self performSegueWithIdentifier: @"settingsSegue" sender: self];
  }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
  DDLog(@"request url:%@, code:%d, #:%d, target:%@", objectLoader.URL, objectLoader.response.statusCode, objects.count, [objectLoader.targetObject class]);

  if ((objectLoader.isGET) && (objectLoader.response.statusCode == 200) && ([objectLoader.sourceObject isKindOfClass:[PGTUser class]])) {
    DDLog(@"Fetching Trips...");
    if (objects.count > 0) {
      PGTUser* fetchedUser = [objects objectAtIndex:0];
      [self updateViewsWithUser: fetchedUser];
    }
  } else {
    if ((objectLoader.isGET) && (objectLoader.response.statusCode == 200) && objects.count>0)
    { 
      if ([[objects objectAtIndex:0] class]==[PGTMove class]) {
        DDLog(@"got moves for user %@", currentUser.email);
        self.currentTrips = objects;
        [self reloadData];
      }
    }
  }
  
  /*
  DDLog(@"objects (%d): %@", objects.count, objects);
  if ([objects count] > 0) {
    PGTUser* user = [objects objectAtIndex:0];
    DDLog(@"user retrieved: %@, %@, %@, %@, %@", user.firstName, user.lastName, user.email, user.password, user.createdAt);
    _authenticated = YES;
    
    DDLog(@"updating...");
    user.firstName = @"Pierre";
    user.lastName = @"Gilot";
    [[RKObjectManager sharedManager] putObject:user delegate:self block:^(RKObjectLoader* loader) {
      loader.username = @"pierre.gilot@me.com";
      loader.password = @"mickey";
      loader.authenticationType=RKRequestAuthenticationTypeHTTPBasic;
      //loader.cachePolicy =  RKRequestCachePolicyLoadIfOffline | RKRequestCachePolicyTimeout;
      //loader.cache.storagePolicy = RKRequestCacheStoragePolicyPermanently;
      //DDLog(@"cachepath: %@", loader.cache.cachePath);
     
    }];
  }*/

}

#pragma mark - PGTSettingsViewController delegate methods
-(BOOL)settingsViewControllerCanShowCancel:(PGTSettingsViewController *)controller
{
  return self.isAuthenticated;
}

-(void)settingsViewControllerDidCancel:(PGTSettingsViewController *)controller
{
  DDLog(@"");
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)settingsViewController:(PGTSettingsViewController *)controller didLogUserIn:(PGTUser *)user
{
  DDLog(@"user: %@", user);
  _authenticated = YES;
  [self dismissViewControllerAnimated:YES completion:nil];
  [self updateViewsWithUser:user];
}

-(void)settingsViewControllerDidLogUserOut:(PGTSettingsViewController *)controller
{
  DDLog(@"");
  _authenticated = NO;
}
@end
