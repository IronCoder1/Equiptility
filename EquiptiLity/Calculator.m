//
//  CalculatorClass.m
//  EquiptiLity
//
//  Created by MBPinTheAir on 07/06/2016.
//  Copyright © 2016 moorsideinc. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator

+(int)calcTotal:(int)daysSelected with:(int)dailyRate
{
    return daysSelected * dailyRate;
}


+(NSDate *)calcReturnDateByAddingDays:(NSInteger)days
{
    
    NSDate *todaysDate = [NSDate date];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:days];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   NSDate *returnDate = [gregorian dateByAddingComponents:componentsToAdd
                                                        toDate:todaysDate
                                                  options:0];
    return returnDate;
    
}

@end
