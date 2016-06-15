//
//  ConfirmHireViewController.m
//  EquiptiLity
//
//  Created by MBPinTheAir on 14/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//

#import "ConfirmHireViewController.h"
#import "CNXContact.h"
@import ContactsUI;
#import "AppDelegate.h"
@interface ConfirmHireViewController ()<CNContactPickerDelegate,UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *confirmHireButtonOutlet;
-(IBAction)confirmHireButtonTapped:(id)sender;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIImageView *eImageView;
@property (weak, nonatomic) IBOutlet UITextView *eNotesTextView;
@property (weak, nonatomic) IBOutlet UILabel *contactsLabel;
- (IBAction)addClientButton:(id)sender;
- (IBAction)addPhotoButtonTapped:(id)sender;

@end

@implementation ConfirmHireViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [UIApplication sharedApplication].delegate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.anEquipment.eNote)
    {
        self.eNotesTextView.text = self.anEquipment.eNote;
    }
    else
    {
        self.eNotesTextView.text = @"Tap to add or edit notes";
    }
    [self updateImageView];
//    self.eNotesTextView.delegate = self;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma MARK -Choosing Client user and delegate methods

- (IBAction)addClientButton:(id)sender
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
    self.contactsLabel.text = [NSString stringWithFormat:@"%@ %@", cnxcontact.cGivenName,cnxcontact.cFamilyName];
    if(self.anEquipment.cnxcontact)
    {
        [self.confirmHireButtonOutlet setEnabled:YES];
    }
}

#pragma MARK - Adding Photo Methods
- (IBAction)addPhotoButtonTapped:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Add Equipment photo" message:@"Please make a selection below" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    UIAlertAction *option1 = [UIAlertAction actionWithTitle:@"Use Camera" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                              {
                                  NSLog(@"Option 1 was tapped");
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
    UIAlertAction *option4 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:option1];
    [actionSheet addAction:option2];
    [actionSheet addAction:option3];
    [actionSheet addAction:option4];
    [self presentViewController:actionSheet animated:YES completion:nil];
}
-(NSString *)saveImageToDisk:(UIImage *)chosenImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSUUID *uuID = [NSUUID UUID];
    NSString *secondBaseString = [NSString stringWithFormat:@"%@.png",[uuID UUIDString]];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:secondBaseString];
    [UIImagePNGRepresentation(chosenImage) writeToFile:filePath atomically:YES];
    NSLog(@"file path %@", filePath);
    return filePath;
}

#pragma mark - ImagePicker Delegate Methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *itemImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        self.anEquipment.eImageString = [self saveImageToDisk:itemImage];
        [self updateImageView];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@""])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(IBAction)confirmHireButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"toTestSegue" sender:nil];
    if (self.anEquipment.cnxcontact)
    {
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
            NSLog(@"coredata could not saveee at line93 confirmvc %@", [error localizedDescription]);
        }
    }
}

-(void)updateImageView
{
    UIImage *imgg = [UIImage imageWithContentsOfFile:self.anEquipment.eImageString];
    if (imgg)
    {
        self.eImageView.image = imgg;
        self.eImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}
@end
