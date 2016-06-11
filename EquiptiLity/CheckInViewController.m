//
//  CheckInViewController.m
//  EquiptiLity
//
//  Created by MBPinTheAir on 08/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//

#import "CheckInViewController.h"
#import "Calculator.h"
#import "CalculateTotalViewController.h"

@interface CheckInViewController ()
- (IBAction)cancelButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *equipmentLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteView;

@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnDateLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkInButtonOutlet;
@property  (strong, nonatomic) AppDelegate *appDelegate;
- (IBAction)checkInButtonTapped:(id)sender;

@end

@implementation CheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate   = [UIApplication sharedApplication].delegate;
    self.title = @"Lease Summary";
    self.equipmentLabel.text = self.anEquipment.eBrandModel;
    [self.noteView setScrollEnabled:YES];
    if (self.anEquipment.eNote == nil || [self.anEquipment.eNote isEqualToString:@""])
    {
        self.noteView.text = @"n/a";
    }
    else
    {
        self.noteView.text = self.anEquipment.eNote;
    }
    if ([self.anEquipment.eSerialNo isEqualToString:@""]) {
        self.serialNumberLabel.font = [UIFont systemFontOfSize:13 weight:0.01];
        self.serialNumberLabel.text = @"No serial number on record";
    }
    else
    {
    self.serialNumberLabel.text = self.anEquipment.eSerialNo;
    }
    NSDateFormatter *dateFormatted = [[NSDateFormatter alloc]init];
    [dateFormatted setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *dateString = [dateFormatted stringFromDate:self.anEquipment.returnDate];
    self.returnDateLabel.text = [NSString stringWithFormat:@"Return Date: %@",dateString];
    
    if (self.anEquipment.returnDate != nil)
    {
        [self.checkInButtonOutlet setEnabled:YES];
    }
//    else
//    {
//        [self.checkInButtonOutlet setEnabled:YES];
//        
//        //[self.checkInButtonOutlet setTitle:@"Check Out" forState: UIControlStateNormal];
//        self.returnDateLabel.font = [UIFont systemFontOfSize:12 weight:0.01];
//        self.returnDateLabel.text = @"This gear is available";
//    }
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CalculateTotalViewController *ctVC = [segue destinationViewController];
    ctVC.anEquipment = self.anEquipment;
}


- (IBAction)cancelButtonTapped:(id)sender
{
[self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)checkInButtonTapped:(id)sender
{
    if (self.anEquipment.returnDate)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hang On" message:@"Have you inspected the equipment notes?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
                                 self.anEquipment.returnDate = nil;
                                 NSError *error = nil;
                                 [self.appDelegate.managedObjectContext save:&error];
                                 //[self.navigationController popViewControllerAnimated:YES];
                                 [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Back" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {NSLog(@"cancel tapped"); }];
        
        [alertController addAction:cancel];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"toCheckOutSegue2" sender:nil];
    }
}
@end
