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
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
   // [componentsToAdd setDay:days];
    componentsToAdd.day = days;
 
    return [self dateFromComponents:componentsToAdd];;
    
}

+ (NSDate*)dateFromComponents:(NSDateComponents *)components
{
    NSDate *todaysDate = [NSDate date];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *futureDate = [gregorianCalendar dateByAddingComponents:components toDate:todaysDate options:0];
    
    return futureDate;
}

+(NSDate*)calcSixMonthsDate
{
    NSDateComponents *components = [[NSDateComponents alloc]init];
    components.month = 6;
   return [self dateFromComponents:components];
}

@end
