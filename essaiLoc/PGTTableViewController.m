//
//  PGTTableViewController.m
//  essaiLoc
//
//  Created by Pierre Gilot on 05/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import "PGTTableViewController.h"
#import "DDLog.h"
#import <QuartzCore/QuartzCore.h>

@interface PGTTableViewController ()

@end

@implementation PGTTableViewController

@synthesize lastIndex;
@synthesize trips;

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
  DDLog(@"");
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  self.trips = [NSMutableArray arrayWithCapacity:5];
  PGTTrip *trip1 = [[PGTTrip alloc] init];
  //trip1.title = @"Paris - Versailles";
  //trip1.subTitle = [dateFormatter stringFromDate:date];
  //trip1.departure = [[CLLocation alloc] initWithLatitude:0 longitude:0];
  
  PGTTrip *trip2 = [[PGTTrip alloc] init];
  //trip2.title = @"Versailles - San Francisco";
  //trip2.subTitle = [dateFormatter stringFromDate:date];
  //trip2.departure = [[CLLocation alloc] initWithLatitude:0 longitude:0];
  
  [self.trips addObject:trip1];
  [self.trips addObject:trip2];

}

- (void)viewDidUnload
{
  DDLog(@"");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  DDLog(@"");
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  DDLog(@"");
    // Return the number of rows in the section.
    return [self.trips count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  DDLog(@"index: %@", indexPath);
  static NSString *CellIdentifier = @"PGTCell";
  static NSString *HeaderCellIdentifier = @"HeaderCell";
  UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
  if (indexPath.row == 0)
  {
    cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    cell.textLabel.text = @"Express Trip";
    cell.detailTextLabel.text = @"Click Here To Setup A New Trip";
    /*
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = cell.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor]CGColor], (id)[[UIColor redColor]CGColor], nil];
    [cell.layer addSublayer:gradient];
     */
  }
  else {
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    PGTTrip *trip = [self.trips objectAtIndex:(indexPath.row-1)];
    cell.textLabel.text = trip.title;
    cell.detailTextLabel.text = trip.subTitle;
  }

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
  DDLog(@"");
  // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
  self.lastIndex = indexPath.row;
  [[NSNotificationCenter defaultCenter] 
   postNotificationName:@"tripidentified" object:nil];
  
}

#pragma mark - StoryBoardElements

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  DDLog(@"Prepare for segue : %@", segue.identifier);
	if ([segue.identifier isEqualToString:@"tripDetail"])
	{
    PGTTripDetailViewController *navigationController = segue.destinationViewController;
    navigationController.delegate = self;
	}
	if ([segue.identifier isEqualToString:@"newTrip"])
	{
    PGTTripDetailViewController *navigationController = segue.destinationViewController;
    navigationController.delegate = self;
	}
	if ([segue.identifier isEqualToString:@"planTrip"])
	{
		UINavigationController *navigationController = 
    segue.destinationViewController;
		PGTPlanTripViewController *planTripViewController = [[navigationController viewControllers] objectAtIndex:0];
		planTripViewController.delegate = self;
	}
}

#pragma mark - Table PGTPlanTripViewController delegate
- (void)planTripViewControllerDidCancel:
(PGTPlanTripViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)planTripViewControllerDidSave:
(PGTPlanTripViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PGTTripDetailViewController Delegate methods
- (void) tripDetailViewController:(PGTTripDetailViewController *)controller didAddDepartureAnnotation:(PGTDepartureAnnotation *)annotation
{
  DDLog(@"annotation: %@", annotation);
  PGTTrip* trip = [trips objectAtIndex:self.lastIndex-1];
  trip.departure = annotation;
  [self.tableView reloadData];
}

- (void) tripDetailViewController:(PGTTripDetailViewController *)controller didAddArrivalAnnotation:(PGTArrivalAnnotation *)annotation
{
  DDLog(@"annotation: %@", annotation);
  PGTTrip* trip = [trips objectAtIndex:self.lastIndex-1];
  trip.arrival = annotation;
  [self.tableView reloadData];
}

- (void)tripDetailViewControllerWillStart:(PGTTripDetailViewController *)controller 
{
  DDLog(@"");
  if (lastIndex == 0) {
    [self.trips addObject:[PGTTrip alloc]];
    lastIndex = [self.trips count];
  }
  
  controller.tripDetails = [self.trips objectAtIndex:lastIndex-1];
  [self.tableView reloadData];
  DDLog(@"trips count:%d", [self.trips count]);
}

@end
