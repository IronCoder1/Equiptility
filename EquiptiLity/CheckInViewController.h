//
//  CheckInViewController.h
//  EquiptiLity
//
//  Created by MBPinTheAir on 08/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNXEquipment.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface CheckInViewController : UIViewController
@property (strong, nonatomic)CNXEquipment *anEquipment;
@end
