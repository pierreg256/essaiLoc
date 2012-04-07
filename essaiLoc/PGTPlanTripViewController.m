//
//  PGTPlanTripViewController.m
//  essaiLoc
//
//  Created by Pierre Gilot on 05/03/12.
//  Copyright (c) 2012 Joyent. All rights reserved.
//

#import "PGTPlanTripViewController.h"

@interface PGTPlanTripViewController ()

@end

@implementation PGTPlanTripViewController

@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancel:(id)sender
{
	[self.delegate planTripViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
	[self.delegate planTripViewControllerDidSave:self];
}

@end
