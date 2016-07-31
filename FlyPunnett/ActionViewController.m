//
//  ActionViewController.m
//  FlyPunnett
//
//  Created by Scott Daniel on 2/23/12.
//  Copyright (c) 2012 Scott Daniel. All rights reserved.
//

#import "ActionViewController.h"
#import "AppDelegate.h"

@implementation ActionViewController

@synthesize managedObjectContext = __managedObjectContext;

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if ([error code] != 0) {
        NSLog(@"This went wrong with email: %@, %@",error,[error userInfo]);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popoverShouldDismiss" object:nil];
    [self dismissModalViewControllerAnimated:YES];
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Email Selected Cross";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"Email Entire History";
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"Email Last Performed Cross";
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"See Credits...";
    }

    if (indexPath.row == 4) {
        cell.textLabel.text = @"Send Feedback / Question";
    }
    
    // Configure the cell...
    
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
    if (indexPath.row < 3 && [MFMailComposeViewController canSendMail] == FALSE) {
        UIAlertView *cantEmail = [[UIAlertView alloc] initWithTitle:@"Can't send email" message:@"Your device is not set up to send emails.\nTry copying and pasting the progeny list into the Notes app" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [cantEmail show];
    }
    
    if (indexPath.row == 4 && [MFMailComposeViewController canSendMail] == FALSE) {
        UIAlertView *cantEmail = [[UIAlertView alloc] initWithTitle:@"Can't send email" message:@"Your device is not set up to send emails." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [cantEmail show];
    }
    
    if (indexPath.row == 0) {
        NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"TextBox"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            NSLog(@"Something went wrong with the fetch!");}
        //email connection for send current progeny
        MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
        emailer.mailComposeDelegate = self;
        [emailer setSubject:@"Progeny from selected cross"];
        
        // Fill out the email body text.
        NSManagedObject *selectedCross = [fetchedObjects lastObject];
        NSString *body = [NSString stringWithFormat:@"%@\n",[selectedCross valueForKey:@"currentText"]];
        [emailer setMessageBody:body isHTML:NO];
        // Present the mail composition interface.
        [self presentModalViewController:emailer animated:YES];
    }
    if (indexPath.row == 1) {
        
        //Fetch the crosses
        NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp"
                                                                       ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            NSLog(@"Something went wrong with the fetch!");}
        //email connection for send entire progeny
        MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
        emailer.mailComposeDelegate = self;
        [emailer setSubject:@"All crosses"];
        
        // Fill out the email body text.
        NSUInteger i=0;
        NSMutableString *cross = [NSMutableString stringWithFormat:@""];
        for (i=0; i<[fetchedObjects count]; i++) {
            NSManagedObject *currentCross = [fetchedObjects objectAtIndex:i];
            NSMutableString *nextCross = [NSMutableString stringWithFormat:@"%@\n Done on %@\n\n",[currentCross valueForKey:@"possibleProgeny"], [currentCross valueForKey:@"timeStamp"]];
            [cross appendString:nextCross];
        }
        NSString *body = cross;
        [emailer setMessageBody:body isHTML:NO];
        
        // Present the mail composition interface.
        [self presentModalViewController:emailer animated:YES];
    }
    if (indexPath.row == 2) {
        //Fetch the crosses
        NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp"
                                                                       ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            NSLog(@"Something went wrong with the fetch!");}
        
        MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
        emailer.mailComposeDelegate = self;
        [emailer setSubject:@"Progeny from last performed cross"];
        
        // Fill out the email body text.
        if ([fetchedObjects count] > 0) {
            NSManagedObject *currentCross = [fetchedObjects objectAtIndex:0];
            NSString *body = [NSString stringWithFormat:@"%@\n Done on %@\n\n",[currentCross valueForKey:@"possibleProgeny"], [currentCross valueForKey:@"timeStamp"]];
            [emailer setMessageBody:body isHTML:NO];
            // Present the mail composition interface.
            [self presentModalViewController:emailer animated:YES];
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"popoverShouldDismiss" object:nil];
            UIAlertView *noCrosses = [[UIAlertView alloc] initWithTitle:@"Can't send email" message:@"You have to perform a cross first before you can send anything." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [noCrosses show];
        }
        
    }
    
    if (indexPath.row == 3) {
        // Create a uialert
        [[NSNotificationCenter defaultCenter] postNotificationName:@"popoverShouldDismiss" object:nil];
        UIAlertView *credits = [[UIAlertView alloc] initWithTitle:@"Credits" message:@"-Creator / Developer: Scott Daniel\n-Portrait Launch Image: Andre Karwath (licensed under Creative Commons Attribution-Share Alike 2.5 Generic)\n-Landscape Launch Image: Bbski (licensed under Creative Commons Attribution-Share Alike 3.0 Unported)\n-App Icon: Muhammad Mahdi Karim (micro2macro.net) (licensed under GNU Free Documentation License 1.2)\n-Genetics Help: Ashley Boehringer\n-Inspiration: The Zarnescu Lab at the University of Arizona" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [credits show];
    }
    
    // Send email for questions / feedback
    
    if (indexPath.row == 4) {
        
        MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
        emailer.mailComposeDelegate = self;
        [emailer setSubject:@"Question / Feedback for FlyPunnett"];
        
        // Fill out the email body text.
        [emailer setToRecipients:[NSArray arrayWithObject:[NSString stringWithFormat:@"scottdaniel25@gmail.com"]]];
        // Present the mail composition interface.
        [self presentModalViewController:emailer animated:YES];
    }
}

@end











