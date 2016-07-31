//
//  ActionViewController.h
//  FlyPunnett
//
//  Created by Scott Daniel on 2/23/12.
//  Copyright (c) 2012 Scott Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ActionViewController : UITableViewController <MFMailComposeViewControllerDelegate>

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
