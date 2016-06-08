//
//  CalculateTotalViewController.h
//  EquiptiLity
//
//  Created by MBPinTheAir on 07/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNXEquipment.h"

@interface CalculateTotalViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong,nonatomic) CNXEquipment *anEquipment;

@end
