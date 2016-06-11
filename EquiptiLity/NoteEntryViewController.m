//
//  NoteEntryViewController.m
//  EquiptiLity
//
//  Created by MBPinTheAir on 06/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//

#import "NoteEntryViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"


@interface NoteEntryViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButtonOutlet;

@end

@implementation NoteEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
- (IBAction)skipTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveTapped:(id)sender
{
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSError *error = nil;
    if (![self.noteTextfield .text isEqualToString:@""])
    {
        self.anEquipment.eNote = self.noteTextfield.text;
        
        [appDelegate.managedObjectContext save:&error];
    }
    if (error)
    {
        NSLog(@"error %@", [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
