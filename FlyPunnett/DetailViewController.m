//
//  DetailViewController.m
//  FlyPunnett
//
//  Created by Scott Daniel on 2/12/12.
//  Copyright (c) 2012 Scott Daniel. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

__weak UIPopoverController *myPopover;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize f1stCopyOfX = _f1stCopyOfX;
@synthesize f2ndCopyOfX = _f2ndCopyOfX;
@synthesize mX = _mX;
@synthesize mY = _mY;
@synthesize m1stCopyOf2nd = _m1stCopyOf2nd;
@synthesize m2ndCopyOf2nd = _m2ndCopyOf2nd;
@synthesize m1stCopyOf3rd = _m1stCopyOf3rd;
@synthesize m2ndCopyOf3rd = _m2ndCopyOf3rd;

@synthesize f1stCopyOf2nd = _f1stCopyOf2nd;
@synthesize f2ndCopyOf2nd = _f2ndCopyOf2nd;
@synthesize f1stCopyOf3rd = _f1stCopyOf3rd;
@synthesize f2ndCopyOf3rd = _f2ndCopyOf3rd;

@synthesize progenyList = _progenyList;
@synthesize detailItem = _detailItem;
@synthesize masterPopoverController = _masterPopoverController;

#pragma mark - The real work

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    myPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
}

-(void)dismissThePopover {
    [myPopover dismissPopoverAnimated:YES];
}

- (IBAction)showActions:(id)sender {
    if (myPopover) 
        [myPopover dismissPopoverAnimated:YES];
    else
        [self performSegueWithIdentifier:@"showPopover" sender:sender];  
}

- (IBAction)breedFlies:(id)sender {
    
    //Create three arrays with combinations for 1st, 2nd and 3rd chromosomes
    
    NSMutableArray *possibleProgenyLev3 = [NSMutableArray arrayWithObjects:
                                           [NSMutableString stringWithFormat:@"%@/%@",_f1stCopyOfX.text,_mX.text],
                                           [NSMutableString stringWithFormat:@"%@/%@",_f1stCopyOfX.text,_mY.text],
                                           [NSMutableString stringWithFormat:@"%@/%@",_f2ndCopyOfX.text,_mX.text],
                                           [NSMutableString stringWithFormat:@"%@/%@",_f2ndCopyOfX.text,_mY.text],
                                           nil];
    NSMutableArray *possibleProgenyLev2 = [NSMutableArray arrayWithObjects:
                                           [NSMutableString stringWithFormat:@"%@/%@",_f1stCopyOf2nd.text,_m1stCopyOf2nd.text],
                                           [NSMutableString stringWithFormat:@"%@/%@",_f1stCopyOf2nd.text,_m2ndCopyOf2nd.text],
                                           [NSMutableString stringWithFormat:@"%@/%@",_f2ndCopyOf2nd.text,_m1stCopyOf2nd.text],
                                           [NSMutableString stringWithFormat:@"%@/%@",_f2ndCopyOf2nd.text,_m2ndCopyOf2nd.text],
                                           nil];
    NSMutableArray *possibleProgenyLev1 = [NSMutableArray arrayWithObjects:
                                           [NSMutableString stringWithFormat:@"%@/%@",_f1stCopyOf3rd.text,_m1stCopyOf3rd.text],
                                           [NSMutableString stringWithFormat:@"%@/%@",_f1stCopyOf3rd.text,_m2ndCopyOf3rd.text],
                                           [NSMutableString stringWithFormat:@"%@/%@",_f2ndCopyOf3rd.text,_m1stCopyOf3rd.text],
                                           [NSMutableString stringWithFormat:@"%@/%@",_f2ndCopyOf3rd.text,_m2ndCopyOf3rd.text],
                                           nil];
    
    //Now iterate and combine each array to produce the 64 possible genotypes (some of which may be duplicates)
    
    NSMutableArray *possibleProgeny = [NSMutableArray arrayWithCapacity:64];
    NSUInteger j,k,l = 0;
    for (j=0; j<4; j++) {
        for (k=0; k<4; k++) {
            for (l=0; l<4; l++) {
                [possibleProgeny addObject:[NSMutableString stringWithFormat:@"%@; %@; %@",
                                            [possibleProgenyLev3 objectAtIndex:j],
                                            [possibleProgenyLev2 objectAtIndex:k],
                                            [possibleProgenyLev1 objectAtIndex:l]]];
            }
        }
    }

// Reduce array to unique genotypes, calculate percentages and sort
    
    NSCountedSet *possibleProgenyCounts = [[NSCountedSet alloc] initWithArray:possibleProgeny];
    NSMutableArray *possibleProgenyFractions = [NSMutableArray array];
    
    for (NSString *string in possibleProgenyCounts) {
        NSUInteger count = [possibleProgenyCounts countForObject:string];
        double fraction = ((double)count/64)*100;
        [possibleProgenyFractions addObject:[NSString stringWithFormat:@"%g%% -- %@", fraction, string]];
    }
    
    NSArray *possibleProgenyFractionsSorted = [possibleProgenyFractions sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    // Define mom, dad and possibly progeny for output and saving to Core Data
    
    NSString *momGenotype = [NSString stringWithFormat:@"%@/%@; %@/%@; %@/%@", _f1stCopyOfX.text, _f2ndCopyOfX.text, _f1stCopyOf2nd.text, _f2ndCopyOf2nd.text, _f1stCopyOf3rd.text, _f2ndCopyOf3rd.text];
    
    NSString *dadGenotype = [NSString stringWithFormat:@"%@/%@; %@/%@; %@/%@", _mX.text, _mY.text, _m1stCopyOf2nd.text, _m2ndCopyOf2nd.text, _m1stCopyOf3rd.text, _m2ndCopyOf3rd.text];
    
    NSString *possibleProgenyFinal = [NSString stringWithFormat:@"%@",[possibleProgenyFractionsSorted description]];
    
    // Output the results to the UITextView

    NSString *listText = [NSString stringWithFormat:@"Female Virgins of %@ crossed with Males of %@ = \n %@", momGenotype, dadGenotype, possibleProgenyFinal];
    _progenyList.text = listText;
    
    //Save the cross and put in Core Data
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
    
    [newManagedObject setValue:_mX.text forKey:@"mX"];
    [newManagedObject setValue:_mY.text forKey:@"mY"];
    [newManagedObject setValue:_m1stCopyOf2nd.text forKey:@"m1stCopyOf2nd"];
    [newManagedObject setValue:_m2ndCopyOf2nd.text forKey:@"m2ndCopyOf2nd"];
    [newManagedObject setValue:_m1stCopyOf3rd.text forKey:@"m1stCopyOf3rd"];
    [newManagedObject setValue:_m2ndCopyOf3rd.text forKey:@"m2ndCopyOf3rd"];
    [newManagedObject setValue:_f1stCopyOfX.text forKey:@"f1stCopyOfX"];
    [newManagedObject setValue:_f2ndCopyOfX.text forKey:@"f2ndCopyOfX"];
    [newManagedObject setValue:_f1stCopyOf2nd.text forKey:@"f1stCopyOf2nd"];
    [newManagedObject setValue:_f2ndCopyOf2nd.text forKey:@"f2ndCopyOf2nd"];
    [newManagedObject setValue:_f1stCopyOf3rd.text forKey:@"f1stCopyOf3rd"];
    [newManagedObject setValue:_f2ndCopyOf3rd.text forKey:@"f2ndCopyOf3rd"];
    
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    [newManagedObject setValue:momGenotype forKey:@"momGenotype"];
    [newManagedObject setValue:dadGenotype forKey:@"dadGenotype"];
    [newManagedObject setValue:_progenyList.text forKey:@"possibleProgeny"];

    NSError *error = nil;
    if (![context save:&error]) {
        _progenyList.text = [_progenyList.text stringByAppendingFormat:@"\n\nSomething went wrong when saving!!!"];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (IBAction)resetFlies:(id)sender {
    _f1stCopyOfX.text=@"X";
    _f2ndCopyOfX.text=@"X";
    _mX.text=@"X";
    _mY.text=@"Y";
    _m1stCopyOf2nd.text=@"+";
    _m2ndCopyOf2nd.text=@"+";
    _m1stCopyOf3rd.text=@"+";
    _m2ndCopyOf3rd.text=@"+";
    _f1stCopyOf2nd.text=@"+";
    _f2ndCopyOf2nd.text=@"+";
    _f1stCopyOf3rd.text=@"+";
    _f2ndCopyOf3rd.text=@"+";
    _progenyList.text=@"Progeny Genotypes Appear Here";
}

#pragma mark - Managing the detail item (the item selected in the history)

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    // Remember, this happens everytime a user selects a new item from history (via MVC)

    if (self.detailItem) {
        _progenyList.text = [self.detailItem valueForKey:@"possibleProgeny"];  
        _f1stCopyOfX.text=[self.detailItem valueForKey:@"f1stCopyOfX"]; 
        _f2ndCopyOfX.text=[self.detailItem valueForKey:@"f2ndCopyOfX"]; 
        _mX.text=[self.detailItem valueForKey:@"mX"]; 
        _mY.text=[self.detailItem valueForKey:@"mY"]; 
        _m1stCopyOf2nd.text=[self.detailItem valueForKey:@"m1stCopyOf2nd"]; 
        _m2ndCopyOf2nd.text=[self.detailItem valueForKey:@"m2ndCopyOf2nd"]; 
        _m1stCopyOf3rd.text=[self.detailItem valueForKey:@"m1stCopyOf3rd"]; 
        _m2ndCopyOf3rd.text=[self.detailItem valueForKey:@"m2ndCopyOf3rd"]; 
        _f1stCopyOf2nd.text=[self.detailItem valueForKey:@"f1stCopyOf2nd"]; 
        _f2ndCopyOf2nd.text=[self.detailItem valueForKey:@"f2ndCopyOf2nd"]; 
        _f1stCopyOf3rd.text=[self.detailItem valueForKey:@"f1stCopyOf3rd"]; 
        _f2ndCopyOf3rd.text=[self.detailItem valueForKey:@"f2ndCopyOf3rd"];
    }
    
    // Clear the TextBox entity first so we don't have an accumulation of entries
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TextBox"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Something went wrong with the fetch!");}
    for (id element in fetchedObjects) {
        [context deleteObject:element];
    }
        
    // Save the selected cross to a core data object for use in other view controllers
    
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"TextBox" inManagedObjectContext:context];
    [newManagedObject setValue:_progenyList.text forKey:@"currentText"];
    
    NSError *error2 = nil;
    if (![context save:&error2]) {
        _progenyList.text = [_progenyList.text stringByAppendingFormat:@"\n\nSomething went wrong when saving!!!"];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissThePopover) name:@"popoverShouldDismiss" object:nil];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setF1stCopyOfX:nil];
    [self setF2ndCopyOfX:nil];
    [self setMX:nil];
    [self setMY:nil];
    [self setM1stCopyOf2nd:nil];
    [self setM2ndCopyOf2nd:nil];
    [self setM1stCopyOf3rd:nil];
    [self setM2ndCopyOf3rd:nil];
    [self setF1stCopyOf2nd:nil];
    [self setF2ndCopyOf2nd:nil];
    [self setF1stCopyOf3rd:nil];
    [self setF2ndCopyOf3rd:nil];
    [self setProgenyList:nil];
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

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"History", @"History");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


@end
