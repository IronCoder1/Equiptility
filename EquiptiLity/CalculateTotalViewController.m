//
//  CalculateTotalViewController.m
//  EquiptiLity
//
//  Created by MBPinTheAir on 07/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//

#import "CalculateTotalViewController.h"
#import "CalculatorClass.h"


@interface CalculateTotalViewController ()
@property (strong, nonatomic) NSMutableArray *daysArray;
@property (weak, nonatomic) IBOutlet UILabel *dailyRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberofDaysLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;


@end

@implementation CalculateTotalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    if (noOfDays <=1 ) {
        
    self.numberofDaysLabel.text = [NSString stringWithFormat:@"%d Day",noOfDays];
    }
    else
    {
    self.numberofDaysLabel.text = [NSString stringWithFormat:@"%d Days",noOfDays];
    }
  
    CalculatorClass *totalObj = [[CalculatorClass alloc]init];
    
    int total = [totalObj calcTotal:noOfDays with:[self.anEquipment.eRate intValue]];
    self.totalLabel.text = [NSString stringWithFormat:@"£ %d",total];
    
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
