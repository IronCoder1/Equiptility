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
#import "CNXContact.h"
@import ContactsUI;

@interface CalculateTotalViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, CNContactPickerDelegate>
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
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButtonTapped;
- (IBAction)addPhotoButtonTapped:(id)sender;
- (IBAction)addClientButtonTapped:(id)sender;

@end

@implementation CalculateTotalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
    self.title = [NSString stringWithFormat:@"Start Hire on %@", self.anEquipment.eBrandModel];
    self.daysArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 1; i <= 66; i++)
    {
        [self.daysArray addObject:[NSNumber numberWithInt:i]];
    }
    
    self.dailyRateLabel.text = [NSString stringWithFormat:@"£%d", [self.anEquipment.eRate intValue]];
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
- (IBAction)addPhotoButtonTapped:(id)sender
{
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Add Equipment photo" message:@"Please make a selection below" preferredStyle:UIAlertControllerStyleActionSheet];
    
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        UIAlertAction *option1 = [UIAlertAction actionWithTitle:@"Use Camera" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
        {
            NSLog(@"Option 1 was tapped");
                picker.allowsEditing = NO;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:nil];
        }];
    
        UIAlertAction *option2 = [UIAlertAction actionWithTitle:@"Open Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            NSLog(@"Option 2 was tapped");
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        UIAlertAction *option3 = [UIAlertAction actionWithTitle:@"Open Photo Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            NSLog(@"Option 3 was tapped");
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:picker animated:YES completion:nil];
        }];
    
        [actionSheet addAction:option1];
        [actionSheet addAction:option2];
        [actionSheet addAction:option3];
        [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)addClientButtonTapped:(id)sender
{
    CNContactPickerViewController *cnpvc = [[CNContactPickerViewController alloc]init];
    cnpvc.delegate = self;
    [self presentViewController:cnpvc animated:YES completion:nil];
}

-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    CNXContact *cnxcontact = [NSEntityDescription insertNewObjectForEntityForName:@"CNXContact" inManagedObjectContext:self.appDelegate.managedObjectContext];
    cnxcontact.cGivenName = contact.givenName;
    cnxcontact.cFamilyName = contact.familyName;
    NSArray *phoneNumbers = contact.phoneNumbers;
    cnxcontact.cIphoneNumber = [[(CNLabeledValue*)phoneNumbers.firstObject value] stringValue];
    NSArray *emailAddresses = contact.emailAddresses;
    cnxcontact.cEmailAddress = [(CNLabeledValue*)emailAddresses.firstObject value];
    NSLog(@"contacts %@", cnxcontact.cEmailAddress);
    self.anEquipment.cnxcontact = cnxcontact;
}



#pragma mark  - private methods

-(NSString *)saveImageToDisk
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSUUID *uuID = [NSUUID UUID];
    NSString *secondBaseString = [NSString stringWithFormat:@"%@.png",[uuID UUIDString]];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:secondBaseString];
    UIImage *newImage;
    [UIImagePNGRepresentation(newImage) writeToFile:filePath atomically:YES];
    NSLog(@"file path %@", filePath);
    return filePath;
}

#pragma mark - ImagePicker Delegate Methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *itemImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
   self.anEquipment.eImageString = [self saveImageToDisk];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
