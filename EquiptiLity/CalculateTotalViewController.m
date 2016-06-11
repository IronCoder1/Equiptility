//
//  CalculateTotalViewController.m
//  EquiptiLity
//
//  Created by MBPinTheAir on 07/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//

#import "CalculateTotalViewController.h"
#import "Calculator.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "NoteEntryViewController.h"

@interface CalculateTotalViewController ()
{
    int noOfDays;
}
@property (strong, nonatomic) NSMutableArray *daysArray;
@property (weak, nonatomic) IBOutlet UILabel *dailyRateLabel;
@property (strong, nonatomic)AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UILabel *retDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButtonTapped;
- (IBAction)checkoutTapped:(id)sender;

- (IBAction)enterNotesButtonTapped:(id)sender;

@end

@implementation CalculateTotalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.title = [NSString stringWithFormat:@"Start Hire %@", self.anEquipment.eBrandModel];
    self.daysArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 1; i <= 66; i++)
    {
        [self.daysArray addObject:[NSNumber numberWithInt:i]];
    }
    
    self.dailyRateLabel.text = [NSString stringWithFormat:@"Daily Rate: £ %d", [self.anEquipment.eRate intValue]];
    if (self.anEquipment.returnDate)
    {
        [self.checkoutButtonTapped setEnabled:NO];
        [self.checkoutButtonTapped setTitle:@"Hired Out" forState:UIControlStateDisabled];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma MARK Pickerview Delegates
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger) component
{
    return [self.daysArray count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger) component
{
    if ([self.daysArray[row] intValue] <=1)
    {
    return [NSString stringWithFormat:@"%@ Day",self.daysArray[row]] ;
    }
    else
    {
    return [NSString stringWithFormat:@"%@ Days",self.daysArray[row]] ;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    noOfDays = [self.daysArray[row] intValue];
  
    int total = [Calculator calcTotal:noOfDays with:[self.anEquipment.eRate intValue]];
    self.totalLabel.text = [NSString stringWithFormat:@"£%d",total];
    
    NSDateFormatter *dateFormatted = [[NSDateFormatter alloc]init];
    [dateFormatted setDateStyle:NSDateFormatterMediumStyle];
    
    NSDate *retDate = [Calculator calcReturnDateByAddingDays:noOfDays];
    NSString *dateString = [dateFormatted stringFromDate:retDate];
    self.retDateLabel.text = [NSString stringWithFormat:@"Return Date: %@",dateString];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        NoteEntryViewController *noteVC = [segue destinationViewController];
        noteVC.anEquipment = self.anEquipment;
}


#pragma MARK - User Action Methods

- (IBAction)enterNotesButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"toNoteSegue" sender:nil];
}

- (IBAction)checkoutTapped:(id)sender
{
  
    if (self.anEquipment.returnDate == nil)
    {
        self.anEquipment.returnDate = [Calculator calcReturnDateByAddingDays:noOfDays];
        NSError *error = nil;
        [self.appDelegate.managedObjectContext save:&error];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Great!" message:@"The checkout was succesful" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];

        if (error)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"Sorry there as been a problem please go back and try again" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Back" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];

            NSLog(@"coredata could not saveee at line93 calculatetotal %@", [error localizedDescription]);
        }
    }
}

@end
