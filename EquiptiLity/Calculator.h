//
//  CalculatorClass.h
//  EquiptiLity
//
//  Created by MBPinTheAir on 07/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculator : NSObject
+(int)calcTotal:(int)daysSelected with:(int)dailyRate;
+(NSDate*)calcSixMonthsDate;
+(NSDate *)calcReturnDateByAddingDays:(NSInteger)days;
@end
