//
//  CNXEquipment+CoreDataProperties.h
//  EquiptiLity
//
//  Created by MBPinTheAir on 11/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CNXEquipment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNXEquipment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *eBrandModel;
@property (nullable, nonatomic, retain) NSString *eNote;
@property (nullable, nonatomic, retain) NSNumber *eRate;
@property (nullable, nonatomic, retain) NSString *eSerialNo;
@property (nullable, nonatomic, retain) NSDate *returnDate;
@property (nullable, nonatomic, retain) NSString *eImageString;
@property (nullable, nonatomic, retain) CNXContact *cnxcontact;

@end

NS_ASSUME_NONNULL_END
