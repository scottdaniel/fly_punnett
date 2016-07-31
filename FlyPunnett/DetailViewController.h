//
//  DetailViewController.h
//  FlyPunnett
//
//  Created by Scott Daniel on 2/12/12.
//  Copyright (c) 2012 Scott Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

- (IBAction)breedFlies:(id)sender;
- (IBAction)resetFlies:(id)sender;
- (IBAction)showActions:(id)sender;
- (void)dismissThePopover;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITextField *f1stCopyOfX;
@property (weak, nonatomic) IBOutlet UITextField *f2ndCopyOfX;
@property (weak, nonatomic) IBOutlet UITextField *f1stCopyOf2nd;
@property (weak, nonatomic) IBOutlet UITextField *f2ndCopyOf2nd;
@property (weak, nonatomic) IBOutlet UITextField *f1stCopyOf3rd;
@property (weak, nonatomic) IBOutlet UITextField *f2ndCopyOf3rd;

@property (weak, nonatomic) IBOutlet UITextField *mX;
@property (weak, nonatomic) IBOutlet UITextField *mY;
@property (weak, nonatomic) IBOutlet UITextField *m1stCopyOf2nd;
@property (weak, nonatomic) IBOutlet UITextField *m2ndCopyOf2nd;
@property (weak, nonatomic) IBOutlet UITextField *m1stCopyOf3rd;
@property (weak, nonatomic) IBOutlet UITextField *m2ndCopyOf3rd;
@property (weak, nonatomic) IBOutlet UITextView *progenyList;

@property (strong, nonatomic) id detailItem;

@end
