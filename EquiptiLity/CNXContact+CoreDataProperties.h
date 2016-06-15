//
//  CNXContact+CoreDataProperties.h
//  EquiptiLity
//
//  Created by MBPinTheAir on 15/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CNXContact.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNXContact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *cEmailAddress;
@property (nullable, nonatomic, retain) NSString *cFamilyName;
@property (nullable, nonatomic, retain) NSString *cGivenName;
@property (nullable, nonatomic, retain) NSString *cIphoneNumber;
@property (nullable, nonatomic, retain) NSSet<CNXEquipment *> *cnxequipment;

@end

@interface CNXContact (CoreDataGeneratedAccessors)

- (void)addCnxequipmentObject:(CNXEquipment *)value;
- (void)removeCnxequipmentObject:(CNXEquipment *)value;
- (void)addCnxequipment:(NSSet<CNXEquipment *> *)values;
- (void)removeCnxequipment:(NSSet<CNXEquipment *> *)values;

@end

NS_ASSUME_NONNULL_END
