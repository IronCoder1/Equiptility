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

@end

@implementation CalculateTotalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.title = [NSString stringWithFormat:@"Hire %@", self.anEquipment.eBrandModel];
    self.daysArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 1; i <= 66; i++)
    {
        [self.daysArray addObject:[NSNumber numberWithInt:i]];
    }
    
    self.dailyRateLabel.text = [NSString stringWithFormat:@"Daily Rate: £ %d", [self.anEquipment.eRate intValue]];
    if (self.anEquipment.returnDate != nil)
    {
        [self.checkoutButtonTapped setEnabled:NO];
        [self.checkoutButtonTapped setTitle:@"Checked Out" forState:UIControlStateDisabled];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
  // self.totalLabel.font = [UIFont fontWithName:@"Menlo" size:32];
    
    NSDateFormatter *dateFormatted = [[NSDateFormatter alloc]init];
    [dateFormatted setDateStyle:NSDateFormatterMediumStyle];
    
    NSDate *retDate = [Calculator calcReturnDateByAddingDays:noOfDays];
    NSString *dateString = [dateFormatted stringFromDate:retDate];
    self.retDateLabel.text = [NSString stringWithFormat:@"Return Date: %@",dateString];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma MARK - User Action Methods

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
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];

            NSLog(@"coredata could not saveee at line93 calculatetotal %@", [error localizedDescription]);
        }
        
    }
}
@end
