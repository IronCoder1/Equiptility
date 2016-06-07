//
//  NoteEntryViewController.h
//  EquiptiLity
//
//  Created by MBPinTheAir on 06/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNXEquipment.h"

@interface NoteEntryViewController : UIViewController
@property (strong, nonatomic) CNXEquipment *anEquipment;
@property (weak, nonatomic) IBOutlet UITextField *noteTextfield;

@end
