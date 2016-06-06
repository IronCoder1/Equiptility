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

@end

@implementation BrandEntryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.eBrandModelTextfield.delegate = self;
    self.title = @"Add an Equipment";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Text field delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL rc = NO;
    if (![self.eBrandModelTextfield.text isEqualToString:@""])
    {
        [self.nextButtonOutlet setEnabled:YES];
        rc = YES;
        [textField resignFirstResponder];
    }
    return  rc;
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
