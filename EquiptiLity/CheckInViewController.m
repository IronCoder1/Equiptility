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
#import "CNXContact.h"

@interface CheckInViewController ()
- (IBAction)cancelButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *equipmentLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteView;

@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnDateLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkInButtonOutlet;
@property  (strong, nonatomic) AppDelegate *appDelegate;
- (IBAction)checkInButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *eImageView;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactPhone;
- (IBAction)callButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *callButtonOutlet;

@end

@implementation CheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate   = [UIApplication sharedApplication].delegate;
    self.title = @"Lease Summary";
    self.contactName.text = self.anEquipment.cnxcontact.cGivenName;
    self.contactPhone.text = self.anEquipment.cnxcontact.cIphoneNumber;
    
    self.equipmentLabel.text = self.anEquipment.eBrandModel;
   // UIImage *eImage = [UIImage imageWithContentsOfFile:self.anEquipment.eImageString];
   // self.eImageView.image = eImage;
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
        self.serialNumberLabel.text = @"n/a";
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
-(void)viewWillAppear:(BOOL)animated
{
    
    CNXContact *contact = self.anEquipment.cnxcontact;
    if ([contact.cIphoneNumber isEqualToString:@""] || !contact.cIphoneNumber)
    {
        self.callButtonOutlet.enabled = NO;
        self.callButtonOutlet.tintColor = [UIColor blackColor];
    }
    
    NSURL *telURL = [NSURL URLWithString:@"tel:"];
    
    if (NO == [[UIApplication sharedApplication] canOpenURL:telURL])
    {
        self.callButtonOutlet.enabled = NO;
        NSLog(@"cannot openurl for call");
    }
    self.eImageView.image = [UIImage imageWithContentsOfFile:self.anEquipment.eImageString];

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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hang On" message:@"Have you inspected the equipment?" preferredStyle:UIAlertControllerStyleAlert];
        
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
- (IBAction)callButtonTapped:(id)sender
{
    
    NSString *URLEncodedTel = [self.anEquipment.cnxcontact.cIphoneNumber stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",URLEncodedTel]];
    [[UIApplication sharedApplication] openURL:URL];
    NSLog(@"phone%@",URL);
    
}

@end
