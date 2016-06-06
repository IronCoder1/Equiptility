//
//  EquipmentsTableViewController.h
//  EquiptiLity
//
//  Created by MBPinTheAir on 06/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CNXEquipment.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"



@interface EquipmentsTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
@property  (strong, nonatomic) AppDelegate *appDelegate;
@property (strong) NSMutableArray *allEquipments;
@end
