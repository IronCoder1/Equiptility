//
//  CalculateTotalViewController.m
//  EquiptiLity
//
//  Created by MBPinTheAir on 07/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//

#import "CalculateTotalViewController.h"
#import "Calculator.h"
#import "ConfirmHireViewController.h"
#import <GLCalendarView/GLCalendarView.h>
#import <GLCalendarView/GLDateUtils.h>

@import ContactsUI;

@interface CalculateTotalViewController ()<GLCalendarViewDelegate>
{
    int noOfDays;
}

@property (strong, nonatomic) NSMutableArray *daysArray;
@property (weak, nonatomic) IBOutlet UILabel *dailyRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *retDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextTapped;
@property (weak, nonatomic) IBOutlet GLCalendarView *calendarView;
@property (nonatomic, weak) GLCalendarDateRange *rangeUnderEdit;
@property (strong, nonatomic) NSDate *lastDate;
@property (strong, nonatomic) NSDate *firstDate;
- (IBAction)nextButtonTapped:(id)sender;

@end

@implementation CalculateTotalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.firstDate = [NSDate date];
    self.lastDate = [Calculator calcSixMonthsDate];
    self.dailyRateLabel.text = [NSString stringWithFormat:@"£%d", [self.anEquipment.eRate intValue]];
    self.calendarView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.calendarView.firstDate  = self.firstDate;
    self.calendarView.lastDate = self.lastDate;
    [self.calendarView reload];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        ConfirmHireViewController *chVC = [segue destinationViewController];
        chVC.anEquipment = self.anEquipment;
}


#pragma MARK - User Action Methods

- (IBAction)nextButtonTapped:(id)sender
{
    if (self.anEquipment.startDate && self.anEquipment.returnDate)
    {
    [self performSegueWithIdentifier:@"toStepTwoSegue" sender:nil];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"Please select a lease period" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                }];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma MARK CalendarView Delegate Methods

- (BOOL)calenderView:(GLCalendarView *)calendarView canAddRangeWithBeginDate:(NSDate *)beginDate
{
    NSComparisonResult compareDates = [beginDate compare:[NSDate date]];
    if (compareDates == NSOrderedAscending)
    {
        return NO;
    }
       
    return YES;
}
- (GLCalendarDateRange *)calenderView:(GLCalendarView *)calendarView rangeToAddWithBeginDate:(NSDate *)beginDate
{
    
    NSArray *rangesToRemove = [NSArray arrayWithArray:calendarView.ranges];
    for (GLCalendarDateRange *range in rangesToRemove)
    {
        [calendarView removeRange:range];
    }

    
    NSDate *endDate = [GLDateUtils dateByAddingDays:1 toDate:beginDate];
    GLCalendarDateRange *range = [GLCalendarDateRange rangeWithBeginDate:beginDate endDate:endDate];
    range.editable = YES;
    range.backgroundColor = [UIColor greenColor];
    noOfDays = (int)[Calculator calcDays:beginDate withEndDate:endDate];
    self.anEquipment.returnDate = endDate;
    self.anEquipment.startDate = beginDate;
    [self updateTotal];
    [self updateRetDate];
   
    NSLog(@"rangetoadd dates begin:%@ end: %@", self.anEquipment.startDate, self.anEquipment.returnDate);
    return range;
}
- (void)calenderView:(GLCalendarView *)calendarView beginToEditRange:(GLCalendarDateRange *)range
{
    self.rangeUnderEdit = range;
    self.anEquipment.startDate = nil;
    self.anEquipment.returnDate = nil;
}
- (void)calenderView:(GLCalendarView *)calendarView finishEditRange:(GLCalendarDateRange *)range continueEditing:(BOOL)continueEditing
{
    self.rangeUnderEdit = nil;
}
- (BOOL)calenderView:(GLCalendarView *)calendarView canUpdateRange:(GLCalendarDateRange *)range toBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    NSComparisonResult compareDates = [beginDate compare:[NSDate date]];
    if (compareDates != NSOrderedDescending)
    {
        return NO;
    }
        self.anEquipment.returnDate = endDate;
        self.anEquipment.startDate = beginDate;
        return YES;
}

- (void)calenderView:(GLCalendarView *)calendarView didUpdateRange:(GLCalendarDateRange *)range toBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    noOfDays = (int)[Calculator calcDays:beginDate withEndDate:endDate];
    self.anEquipment.returnDate = endDate;
    self.anEquipment.startDate = beginDate;
    [self updateRetDate];
    [self updateTotal];
        NSLog(@"did update dates begin:%@ end: %@", self.anEquipment.startDate, self.anEquipment.returnDate);
    NSLog(@"days = %d", noOfDays);
}


-(void)updateTotal
{
    int total = [Calculator calcTotal:noOfDays with:[self.anEquipment.eRate intValue]];
    self.totalLabel.text = [NSString stringWithFormat:@"£%d",total];
}
-(void)updateRetDate
{
    NSDateFormatter *dateFormatted = [[NSDateFormatter alloc]init];
    [dateFormatted setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [dateFormatted stringFromDate:self.anEquipment.returnDate];
    self.retDateLabel.text = [NSString stringWithFormat:@"%@",dateString];
    [self.nextTapped setEnabled:YES];
}
@end
