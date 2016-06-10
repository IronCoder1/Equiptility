//
//  BrandEntryViewController.m
//  EquiptiLity
//
//  Created by MBPinTheAir on 06/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//

#import "BrandEntryViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CNXEquipment.h"
#import "RateEntryViewController.h"

@interface BrandEntryViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButtonOutlet;
//@property (strong, nonatomic) NSArray *categoryArray;
@end

@implementation BrandEntryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add an Equipment";
  //  self.categoryArray = @[@"Accessories",@"Audio Location", @"Audio Studio", @"Cameras", @"Computer",@"Crew", @"Grip", @"Lenses", @"Lighting", @"Shooting Kits", @"Make Up Kit", @"Monitors",  @"Studios", @"Musical Instruments", @"Props", @"Prosthetics", @"Software"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self.eBrandModelTextfield becomeFirstResponder];
    
}

#pragma mark - Text field delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
   
    NSMutableString *stringAfterApplyingChanges = [[NSMutableString alloc] initWithString:textField.text];

    if ([string isEqual:@""]) {
        [stringAfterApplyingChanges replaceCharactersInRange:range withString:string];
//        [textField resignFirstResponder];
    } else {
        [stringAfterApplyingChanges insertString:string atIndex:range.location ];
        
    }

    
    if (![stringAfterApplyingChanges isEqualToString:@""])
    {
        [self.nextButtonOutlet setEnabled:YES];
    }
    else
    {
        [self.nextButtonOutlet setEnabled:NO];
        
    }
    
//    [self.nextButtonOutlet setEnabled:[ValidationHelper isTextValid:textfield.text afterApplyingChangeAtRange: range withReplacementString: string]
   
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)nextTapped:(id)sender
{
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSError *error = nil;
    if (![self.eBrandModelTextfield.text isEqualToString:@""])
    {
        self.nwEquipment = [NSEntityDescription insertNewObjectForEntityForName:@"CNXEquipment" inManagedObjectContext:appDelegate.managedObjectContext];
        self.nwEquipment.eBrandModel = self.eBrandModelTextfield.text;
        
        [appDelegate.managedObjectContext save:&error];
    }
    if (error)
    {
        NSLog(@"error %@", [error localizedDescription]);
    }
    
    [self performSegueWithIdentifier:@"toRateSegue" sender:self];
}



- (IBAction)cancelAdding:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RateEntryViewController *rateVC = [segue destinationViewController];
    rateVC.anEquipment = self.nwEquipment;
    
}


@end
