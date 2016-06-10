//
//  EquipmentsTableViewController.m
//  EquiptiLity
//
//  Created by MBPinTheAir on 06/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//

#import "EquipmentsTableViewController.h"
#import "CalculateTotalViewController.h"
#import "EquipmentListTableViewCell.h"
#import "CheckInViewController.h"



@interface EquipmentsTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation EquipmentsTableViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        self.allEquipments = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Equipment List";
    self.appDelegate = [UIApplication sharedApplication].delegate ;
    
    
}


- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }



- (IBAction)addButtonTapped:(id)sender

{
    [self performSegueWithIdentifier:@"toTextFieldSegue" sender:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CNXEquipment" inManagedObjectContext:_appDelegate.managedObjectContext];

    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchResults = [self.appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        NSLog(@"fetch request failed : %@", [error localizedDescription]);
    }
    else
    {
        for  (CNXEquipment *anEquip in fetchResults)
        {
            NSPredicate *itemSearch = [NSPredicate predicateWithFormat:@"eBrandModel=%@", anEquip.eBrandModel];
            NSArray *foundEquip = [self.allEquipments filteredArrayUsingPredicate:itemSearch];
            if (foundEquip.count == 0)
            {
                [self.allEquipments addObject:anEquip];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allEquipments.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    EquipmentListTableViewCell *cell = (EquipmentListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"equipmentCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
   // [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calculator"]]];

    
    
    CNXEquipment *anEquipment = self.allEquipments[indexPath.row];
    cell.eBrandLabel.text = anEquipment.eBrandModel;
    cell.eBrandLabel.font = [UIFont fontWithName:@"Helvetica" size: 20];
    cell.eRateLabel.text = [NSString stringWithFormat:@"£%@ per day", anEquipment.eRate];
    cell.eRateLabel.textColor = [UIColor redColor];
   // cell.eRateLabel.font = [UIFont fontWithName:@"Menlo" size: 16];
    if (anEquipment.returnDate == nil)
    {
        cell.retDateLabel.text = @"Available Now";
        cell.retDateLabel.textColor = [UIColor greenColor];
        //cell.retDateLabel.font = [UIFont fontWithName:@"Menlo" size: 13];
    }
    else
    {
    NSDateFormatter *dateFormatted = [[NSDateFormatter alloc]init];
    [dateFormatted setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *dateString = [dateFormatted stringFromDate:anEquipment.returnDate];
    cell.retDateLabel.text  = [NSString stringWithFormat:@"Return Date: %@",dateString];
        cell.retDateLabel.textColor = [UIColor redColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        int row = (int)indexPath.row;
        [self.allEquipments removeObjectAtIndex:row];
        [self.appDelegate.managedObjectContext deleteObject:self.allEquipments[row]];
        NSError *error = nil;
        [self.appDelegate.managedObjectContext save:&error];
        if (error) {
            NSLog(@"coredata could not saveee at line 116 equpmentvc%@", [error localizedDescription]);
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CNXEquipment *anEquipment = self.allEquipments[indexPath.row];
    if (anEquipment.returnDate == nil)
    {
        [self performSegueWithIdentifier:@"toCheckOutSegue" sender:nil];
    }
    else
    {
    [self performSegueWithIdentifier:@"toCheckInSegue" sender:nil];
    }
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toCheckOutSegue" sender:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toCheckOutSegue"])
    {
    CalculateTotalViewController *ctvc = [segue destinationViewController];
        NSIndexPath *newPath = [self.tableView indexPathForSelectedRow];
        CNXEquipment *anEquipment = self.allEquipments[newPath.row];
        ctvc.anEquipment = anEquipment;
    }
    
    if ([segue.identifier isEqualToString:@"toCheckInSegue"])
    {
//        CheckInViewController *ciVC = [segue destinationViewController];
        UINavigationController *navController = (UINavigationController *) segue.destinationViewController;
       CheckInViewController *ciVC = (CheckInViewController *) navController.topViewController;
        NSIndexPath *newPath = [self.tableView indexPathForSelectedRow];
        CNXEquipment *anEquipment = self.allEquipments[newPath.row];
        ciVC.anEquipment = anEquipment;
    }
}

@end
