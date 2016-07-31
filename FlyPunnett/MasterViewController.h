//
//  MasterViewController.h
//  FlyPunnett
//
//  Created by Scott Daniel on 2/12/12.
//  Copyright (c) 2012 Scott Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;


#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
