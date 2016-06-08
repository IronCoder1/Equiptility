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
@property (strong, nonatomic) NSMutableArray *daysArray;
@property (weak, nonatomic) IBOutlet UILabel *dailyRateLabel;
@property (strong, nonatomic)AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UILabel *retDateLabel;

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
    
    int noOfDays = [self.daysArray[row] intValue];
  
    Calculator *calc = [[Calculator alloc]init];
    
    int total = [calc calcTotal:noOfDays with:[self.anEquipment.eRate intValue]];
    self.totalLabel.text = [NSString stringWithFormat:@"£ %d",total];
    
    NSDateFormatter *dateFormatted = [[NSDateFormatter alloc]init];
    [dateFormatted setDateStyle:NSDateFormatterMediumStyle];
    
    self.anEquipment.returnDate = [calc calcReturnDateByAddingDays:noOfDays];
    NSString *dateString = [dateFormatted stringFromDate:self.anEquipment.returnDate];
    self.retDateLabel.text = [NSString stringWithFormat:@"Return Date: %@",dateString];
    
    NSError *error = nil;
    [self.appDelegate.managedObjectContext save:&error];
    if (error)
    {
        NSLog(@"coredata could not saveee at line93 calculatetotal %@", [error localizedDescription]);
    }

    
   // self.totalLabeL.textColor = [UIColor redColor];
   // self.totalLabel.font = [UIFont systemFontOfSize:[self fontSizeFromWidth:self.totalLabel.frame.size.width]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
