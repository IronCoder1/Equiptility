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
#import "ConfirmHireViewController.h"
#import <GLCalendarView/GLCalendarView.h>
#import <GLCalendarView/GLDateUtils.h>

@import ContactsUI;

@interface CalculateTotalViewController ()<GLCalendarViewDelegate>
{
    int noOfDays;
}
@property (strong, nonatomic)AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableArray *daysArray;
@property (weak, nonatomic) IBOutlet UILabel *dailyRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *retDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextTapped;
@property (strong, nonatomic) NSDate *lastDate;
@property (strong, nonatomic) NSDate *firstDate;
@property (weak, nonatomic) IBOutlet GLCalendarView *calendarView;
@property (nonatomic, weak) GLCalendarDateRange *rangeUnderEdit;
- (IBAction)nextButtonTapped:(id)sender;





@end

@implementation CalculateTotalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.firstDate = [NSDate date];
    self.lastDate = [Calculator calcSixMonthsDate];
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.title = [NSString stringWithFormat:@"Start Hire on %@", self.anEquipment.eBrandModel];
    self.daysArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 1; i <= 66; i++)
    {
        [self.daysArray addObject:[NSNumber numberWithInt:i]];
    }
    
    self.dailyRateLabel.text = [NSString stringWithFormat:@"£%d", [self.anEquipment.eRate intValue]];
//    if (self.anEquipment.returnDate)
//    {
//        [self.checkoutButtonTapped setEnabled:NO];
//        [self.checkoutButtonTapped setTitle:@"Hired Out" forState:UIControlStateDisabled];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.calendarView.firstDate  = self.firstDate;
    self.calendarView.lastDate = self.lastDate;
 
    self.calendarView.delegate = self;
    [self.calendarView reload];
    

}

#pragma MARK Pickerview Delegates
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
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
    self.retDateLabel.text = [NSString stringWithFormat:@"%@",dateString];
    
    self.anEquipment.returnDate = retDate;
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
    if (self.anEquipment.returnDate)
    {
    [self performSegueWithIdentifier:@"toStepTwoSegue" sender:nil];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"Please choose how many days" preferredStyle:UIAlertControllerStyleAlert];
        
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                }];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma MARK CalendarView Delegate Methods

- (BOOL)calenderView:(GLCalendarView *)calendarView canAddRangeWithBeginDate:(NSDate *)beginDate
{
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
    range.backgroundColor = [UIColor colorWithRed:59 green:82 blue:73 alpha:1];
//    self.calendarView.ranges = [@[range] mutableCopy];

    return range;
}
- (void)calenderView:(GLCalendarView *)calendarView beginToEditRange:(GLCalendarDateRange *)range
{
    self.rangeUnderEdit = range;
}
- (void)calenderView:(GLCalendarView *)calendarView finishEditRange:(GLCalendarDateRange *)range continueEditing:(BOOL)continueEditing
{
    self.rangeUnderEdit = nil;
}
- (BOOL)calenderView:(GLCalendarView *)calendarView canUpdateRange:(GLCalendarDateRange *)range toBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate{
    return YES;
}

- (void)calenderView:(GLCalendarView *)calendarView didUpdateRange:(GLCalendarDateRange *)range toBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    
    self.anEquipment.returnDate = endDate;
    
    NSLog(@"did update range: %@", range);
}
/*
//
//
//- (IBAction)checkoutTapped:(id)sender
//{
//    if (self.anEquipment.returnDate == nil)
//    {
//        self.anEquipment.returnDate = [Calculator calcReturnDateByAddingDays:noOfDays];
//        NSError *error = nil;
//        [self.appDelegate.managedObjectContext save:&error];
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Great!" message:@"The checkout was succesful" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//        [alertController addAction:ok];
//        [self presentViewController:alertController animated:YES completion:nil];
//        
//        if (error)
//        {
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"Sorry there as been a problem please go back and try again" preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Back" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            }];
//            [alertController addAction:ok];
//            [self presentViewController:alertController animated:YES completion:nil];
//            
//            NSLog(@"coredata could not saveee at line93 calculatetotal %@", [error localizedDescription]);
//        }
//    }
//}


//- (IBAction)addClientButtonTapped:(id)sender
//{
//    CNContactPickerViewController *cnpvc = [[CNContactPickerViewController alloc]init];
//    cnpvc.delegate = self;
//    [self presentViewController:cnpvc animated:YES completion:nil];
//}




#pragma mark  - private methods

//-(NSString *)saveImageToDisk
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSUUID *uuID = [NSUUID UUID];
//    NSString *secondBaseString = [NSString stringWithFormat:@"%@.png",[uuID UUIDString]];
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:secondBaseString];
//    UIImage *newImage;
//    [UIImagePNGRepresentation(newImage) writeToFile:filePath atomically:YES];
//    NSLog(@"file path %@", filePath);
//    return filePath;
//}
//
//#pragma mark - ImagePicker Delegate Methods
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
//{
//    UIImage *itemImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//   self.anEquipment.eImageString = [self saveImageToDisk];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
*/
@end
