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
#import "NoteEntryViewController.h"

@interface RateEntryViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *serialNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *rateTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButtonOutlet;

@end

@implementation RateEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Enter Details";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (![self.rateTextField.text isEqualToString:@""])
    {
    [textField nextResponder];
    }
    [textField resignFirstResponder];
    return  YES;
}

- (IBAction)nextTapped:(id)sender
{
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSError *error = nil;
    if ([self.rateTextField.text length] > 0 && [self.rateTextField.text intValue] >0 && [self.rateTextField.text floatValue] <= 9999 && ![self.rateTextField.text isEqualToString:@""])
    {
        self.anEquipment.eRate = [NSNumber numberWithInt:[self.rateTextField.text intValue]];
        self.anEquipment.eSerialNo = self.serialNoTextField.text;
        [appDelegate.managedObjectContext save:&error];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"You must enter a valid daily rate to continue" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    if (error)
    {
        NSLog(@"error %@", [error localizedDescription]);
    }
}



//#pragma mark - Navigation

@end
