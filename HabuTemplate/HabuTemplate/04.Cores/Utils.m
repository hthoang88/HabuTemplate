//
//  Utils.m
//  HabuTemplate
//
//  Created by Hoang Ho on 7/7/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "Utils.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

@implementation Utils

+ (void)showHUDForView:(UIView*)v
{
    [MBProgressHUD showHUDAddedTo:v
                         animated:YES];
}

+ (void)showHUDForView:(UIView*)v
               message:(NSString*)msg
{
    if (!msg)
        [MBProgressHUD showHUDAddedTo:v
                             animated:YES];
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:v
                                                  animated:YES];
        hud.labelText = msg;
    }
}

+ (void)hideHUDForView:(UIView*)v
{
    [MBProgressHUD hideHUDForView:v
                         animated:NO];
}


//Object
+ (NSString*)autoDescribe:(id)instance
{
    @try {
        NSString *headerString = [NSString stringWithFormat:@"%@:%p:: ",[instance class], instance];
        return [headerString stringByAppendingString:[self autoDescribe:instance classType:[instance class]]];
    }
    @catch (NSException *exception){
        return [instance description];
    }
    @finally {
        
    }
}

// Finds all properties of an object, and prints each one out as part of a string describing the class.
+ (NSString*)autoDescribe:(id)instance classType:(Class)classType
{
    NSUInteger count;
    objc_property_t *propList = class_copyPropertyList(classType, &count);
    NSMutableString *propPrint = [NSMutableString string];
    int numberLine = 3;
    for ( int i = 0; i < count; i++ )
    {
        objc_property_t property = propList[i];
        
        const char *propName = property_getName(property);
        NSString *propNameString =[NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
        
        if(propName)
        {
            id value = [instance valueForKey:propNameString];
            [propPrint appendString:[NSString stringWithFormat:@"%@=%@ ; ", propNameString, value]];
            numberLine --;
            if (numberLine == 0){
                numberLine = 3;
                [propPrint appendString:@"\n"];
            }
        }
    }
    free(propList);
    
    
    // Now see if we need to map any superclasses as well.
    Class superClass = class_getSuperclass( classType );
    if ( superClass != nil && ! [superClass isEqual:[NSObject class]] )
    {
        NSString *superString = [self autoDescribe:instance classType:superClass];
        [propPrint appendString:superString];
    }
    
    return propPrint;
}

@end
