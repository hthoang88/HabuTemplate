//
//  NSDate+CompareDay.m
//  VISIKARD
//
//  Created by Mac Center on 5/12/14.
//
//

#import "NSDate+CompareDay.h"

@implementation NSDate (CompareDay)

- (BOOL)compareOnlyDay:(NSDate*)anotherDay
{
    if (!self || !anotherDay) {
        return NO;
    }
    int day1 = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:self];
    int day2 = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:anotherDay];
    if (day1 != day2) {
        return NO;
    }
    return YES;
}
@end
