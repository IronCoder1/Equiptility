//
//  RateEntryViewController.m
//  EquiptiLity
//
//  Created by MBPinTheAir on 06/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//

#import "RateEntryViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CNXEquipment.h"
#import "RateEntryViewController.h"

@interface RateEntryViewController ()
@property (weak, nonatomic) IBOutlet UITextField *serialNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *rateTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButtonOutlet;

@end

@implementation RateEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL rc = NO;
    if (![self.rateTextField.text isEqualToString:@""])
    {
        [self.nextButtonOutlet setEnabled:YES];
        rc = YES;
        [textField resignFirstResponder];
    }
    else
    {
    //show alert
    }
    return  rc;
}

- (IBAction)nextTapped:(id)sender
{
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSError *error = nil;
    if (![self.serialNoTextField .text isEqualToString:@""])
    {
        self.anEquipment = [NSEntityDescription insertNewObjectForEntityForName:@"CNXEquipment" inManagedObjectContext:appDelegate.managedObjectContext];
        self.anEquipment.eSerialNo = self.serialNoTextField.text;
        self.anEquipment.eRate = [self.rateTextField.text floatValue];
        
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
