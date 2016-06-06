//
//  BrandEntryViewController.h
//  EquiptiLity
//
//  Created by MBPinTheAir on 06/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNXEquipment.h"


@interface BrandEntryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *eBrandModelTextfield;
@property(strong,nonatomic)CNXEquipment *nwEquipment;

@end
