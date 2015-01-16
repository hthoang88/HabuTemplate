//
//  TPLMacros.m
//  MusicPlayer
//
//  Created by Hoang Ho on 12/6/12.
//  Copyright (c) 2012 Tech Propulsion Labs. All rights reserved.
//

#import "HBMacros.h"

// TYPES

NSNumber *BOX_BOOL(BOOL x) { return [NSNumber numberWithBool:x]; }
NSNumber *BOX_INT(int x) { return [NSNumber numberWithInt:x]; }
NSNumber *BOX_SHORT(short x) { return [NSNumber numberWithShort:x]; }
NSNumber *BOX_LONG(long x) { return [NSNumber numberWithLong:x]; }
NSNumber *BOX_UINT(unsigned int x) { return [NSNumber numberWithUnsignedInt:x]; }
NSNumber *BOX_FLOAT(float x) { return [NSNumber numberWithFloat:x]; }
NSNumber *BOX_DOUBLE(double x) { return [NSNumber numberWithDouble:x]; }
NSInteger KEYBOARD_HEIGHT_IPHONE()
{
    if (IS_PORTRAIT) {
        return 162;
    }
    return 216;
}
BOOL UNBOX_BOOL(NSNumber *x) { return [x boolValue]; }
NSInteger UNBOX_INT(NSNumber *x) { return [x intValue]; }
short UNBOX_SHORT(NSNumber *x) { return [x shortValue]; }
long UNBOX_LONG(NSNumber *x) { return [x longValue]; }
NSUInteger UNBOX_UINT(NSNumber *x) { return [x unsignedIntValue]; }
float UNBOX_FLOAT(NSNumber *x) { return [x floatValue]; }
double UNBOX_DOUBLE(NSNumber *x) { return [x doubleValue]; }

// STRINGIFY

NSString *STRINGIFY_BOOL(BOOL x) { return (x ? @"true" : @"false"); }
NSString *STRINGIFY_INT(NSInteger x) { return [NSString stringWithFormat:@"%li", (long)x]; }
NSString *STRINGIFY_SHORT(short x) { return [NSString stringWithFormat:@"%i", x]; }
NSString *STRINGIFY_LONG(long x) { return [NSString stringWithFormat:@"%li", x]; }
NSString *STRINGIFY_UINT(NSUInteger x) { return [NSString stringWithFormat:@"%lu", (unsigned long)x]; }
NSString *STRINGIFY_FLOAT(float x) { return [NSString stringWithFormat:@"%f", x]; }
NSString *STRINGIFY_DOUBLE(double x) { return [NSString stringWithFormat:@"%f", x]; }

// BOUNDS

CGRect RECT_WITH_X(CGRect rect, float x) { return CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height); }
CGRect RECT_WITH_Y(CGRect rect, float y) { return CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height); }
CGRect RECT_WITH_X_Y(CGRect rect, float x, float y) { return CGRectMake(x, y, rect.size.width, rect.size.height); }

CGRect RECT_WITH_X_WIDTH(CGRect rect, float x, float width) { return CGRectMake(x, rect.origin.y, width, rect.size.height); }
CGRect RECT_WITH_Y_HEIGHT(CGRect rect, float y, float height) { return CGRectMake(rect.origin.x, y, rect.size.width, height); }

CGRect RECT_WITH_WIDTH_HEIGHT(CGRect rect, float width, float height) { return CGRectMake(rect.origin.x, rect.origin.y, width, height); }
CGRect RECT_WITH_WIDTH(CGRect rect, float width) { return CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height); }
CGRect RECT_WITH_HEIGHT(CGRect rect, float height) { return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height); }
CGRect RECT_WITH_HEIGHT_FROM_BOTTOM(CGRect rect, float height) { return CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - height, rect.size.width, height); }

CGRect RECT_INSET_BY_LEFT_TOP_RIGHT_BOTTOM(CGRect rect, float left, float top, float right, float bottom) { return CGRectMake(rect.origin.x + left, rect.origin.y + top, rect.size.width - left - right, rect.size.height - top - bottom); }
CGRect RECT_INSET_BY_TOP_BOTTOM(CGRect rect, float top, float bottom) { return CGRectMake(rect.origin.x, rect.origin.y + top, rect.size.width, rect.size.height - top - bottom); }
CGRect RECT_INSET_BY_LEFT_RIGHT(CGRect rect, float left, float right) { return CGRectMake(rect.origin.x + left, rect.origin.y, rect.size.width - left - right, rect.size.height); }

CGRect RECT_STACKED_OFFSET_BY_X(CGRect rect, float offset) { return CGRectMake(rect.origin.x + rect.size.width + offset, rect.origin.y, rect.size.width, rect.size.height); }
CGRect RECT_STACKED_OFFSET_BY_Y(CGRect rect, float offset) { return CGRectMake(rect.origin.x, rect.origin.y + rect.size.height + offset, rect.size.width, rect.size.height); }

CGRect RECT_ADD_X(CGRect rect, float value)
{
    return RECT_WITH_X(rect, rect.origin.x + value);
}

CGRect RECT_ADD_Y(CGRect rect, float value)
{
    return RECT_WITH_Y(rect, rect.origin.y + value);
}
CGRect RECT_ADD_WIDTH(CGRect rect, float value)
{
    return RECT_WITH_WIDTH(rect, rect.size.width + value);
}
CGRect RECT_ADD_HEIGHT(CGRect rect, float value)
{
    return RECT_WITH_HEIGHT(rect, rect.size.height + value);
}

// MATH
double DEG_TO_RAD(double degrees) { return degrees * M_PI / 180.0; }
double RAD_TO_DEG(double radians) { return radians * 180.0 / M_PI; }

// COMPARES
BOOL fequal(double a, double b) { return (fabs(a - b) < FLT_EPSILON); }
BOOL fequalf(float a, float b) { return (fabsf(a - b) < FLT_EPSILON); }
BOOL fequalzero(double a) { return (fabs(a) < FLT_EPSILON); }
BOOL fequalzerof(float a) { return (fabsf(a) < FLT_EPSILON); }

// DUMPS
NSString *RECT_TO_STR(CGRect r) { return [NSString stringWithFormat:@"X=%0.1f Y=%0.1f W=%0.1f H=%0.1f", r.origin.x, r.origin.y, r.size.width, r.size.height]; }
NSString *POINT_TO_STR(CGPoint p) { return [NSString stringWithFormat:@"X=%0.1f Y=%0.1f", p.x, p.y]; }
NSString *SIZE_TO_STR(CGSize s) { return [NSString stringWithFormat:@"W=%0.1f H=%0.1f", s.width, s.height]; }

// DIRECTORIES
NSString *DOCUMENTS_DIR(void) { return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]; }
NSString *LIBRARY_DIR(void) { return [NSHomeDirectory() stringByAppendingPathComponent:@"Library"]; }
NSString *TEMP_DIR(void) { return  [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]; }
NSString *BUNDLE_DIR(void) { return  [[NSBundle mainBundle] bundlePath]; }
NSString *NSDCIM_DIR(void) { return  @"/var/mobile/Media/DCIM"; }

BOOL IS_MULTITASKING_AVAILABLE(void) {
    return [[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)] && [[UIDevice currentDevice] isMultitaskingSupported] == YES;
}

BOOL IS_CAMERA_AVAILABLE(void) {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

BOOL IS_GAME_CENTER_AVAILABLE(void) {
    return NSClassFromString(@"GKLocalPlayer") && [[[UIDevice currentDevice] systemVersion] compare:@"4.1" options:NSNumericSearch] != NSOrderedAscending;
}

BOOL IS_EMAIL_ACCOUNT_AVAILABLE(void) {
    Class composerClass = NSClassFromString(@"MFMailComposeViewController");
    return [composerClass respondsToSelector:@selector(canSendMail)];
}

BOOL IS_GPS_ENABLED(void) {
    return IS_GPS_ENABLED_ON_DEVICE() && IS_GPS_ENABLED_FOR_APP();
}

BOOL IS_GPS_ENABLED_ON_DEVICE(void) {
    BOOL isLocationServicesEnabled;
    
    Class locationClass = NSClassFromString(@"CLLocationManager");
    NSMethodSignature *signature = [locationClass instanceMethodSignatureForSelector:@selector(locationServicesEnabled)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    [invocation invoke];
    [invocation getReturnValue:&isLocationServicesEnabled];
    
    return locationClass && isLocationServicesEnabled;
}

BOOL IS_GPS_ENABLED_FOR_APP(void) {
    // for 4.2+ only, we can check down to the app level
#ifdef kCLAuthorizationStatusAuthorized
    Class locationClass = NSClassFromString(@"CLLocationManager");
    
    if ([locationClass respondsToSelector:@selector(authorizationStatus)]) {
        NSInteger authorizationStatus;
        
        NSMethodSignature *signature = [locationClass instanceMethodSignatureForSelector:@selector(authorizationStatus)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        [invocation invoke];
        [invocation getReturnValue:&authorizationStatus];
        
        return locationClass && (authorizationStatus == kCLAuthorizationStatusAuthorized);
    }
#endif
    
    // we can't know this
    return YES;
}

// DISPATCHERS

void DISPATCH_TO_MAIN_QUEUE(BOOL isAsync, void (^block)()) {
    if (isAsync) {
        dispatch_async(dispatch_get_main_queue(), block);
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

void DISPATCH_TO_GLOBAL_QUEUE(dispatch_queue_priority_t priority, BOOL isAsync, void (^block)()) {
    if (isAsync) {
        dispatch_async(dispatch_get_global_queue(priority, 0), block);
    } else {
        dispatch_sync(dispatch_get_global_queue(priority, 0), block);
    }
}

void DISPATCH_TO_QUEUE(dispatch_queue_t queue, BOOL isAsync, void (^block)()) {
    if (isAsync) {
        dispatch_async(queue, block);
    } else {
        dispatch_sync(queue, block);
    }
}

void DISPATCH_TO_MAIN_QUEUE_AFTER(NSTimeInterval delay, void (^block)()) {
    dispatch_time_t runTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(runTime, dispatch_get_main_queue(), block);
}

void DISPATCH_TO_GLOBAL_QUEUE_AFTER(NSTimeInterval delay, dispatch_queue_priority_t priority, void (^block)()) {
    dispatch_time_t runTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(runTime, dispatch_get_global_queue(priority, 0), block);
}

void DISPATCH_TO_QUEUE_AFTER(NSTimeInterval delay, dispatch_queue_t queue, void (^block)()) {
    dispatch_time_t runTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(runTime, queue, block);
}

// Log trace
void printRect(CGRect rect){
    //DLog(@"Rect: %@",NSStringFromCGRect(rect));
}

UIColor* RGB(int r,int g, int b){
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

UIColor* RGBA(int r,int g, int b, float a){
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

NSMutableDictionary *saveColor;
UIColor* HEX_COLOR_STRING(NSString *string) {
    if (!saveColor) {
        saveColor = [NSMutableDictionary dictionary];
    }
    UIColor *savedItemColor = nil;
    savedItemColor = [saveColor objectForKey:string];
    if (savedItemColor) {
        return savedItemColor;
    }
    NSString *cleanString = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    UIColor *color =  [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    [saveColor setObject:color forKey:string];
    return color;
}

UIColor* HEX_COLOR_STRING_A(NSString *string, float a) {
    NSString *cleanString = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:a];
}

UIImage* IMAGE_FROM_COLOR(UIColor *color) {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

UIImage* IMAGE_FROM_COLOR_RECT(UIColor *color, CGRect rect)
{
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

UIImage* SCALE_IMAGE_TO_SIZE(UIImage* image, CGSize size)
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, size) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(size); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        //DLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

NSString* localizedString(NSString *string)
{
    //    NSString *path= [[NSBundle mainBundle] pathForResource:@"vi" ofType:@"lproj"];
    //    NSBundle* languageBundle = [NSBundle bundleWithPath:path];
    //    NSString *st = [languageBundle localizedStringForKey:string value:@"" table:nil];
//    return [[appConfigInstance getCurrentLanguageBundle] localizedStringForKey:string value:@"" table:nil];
    return NSLocalizedString(string, nil);
}

#pragma mark - Debug log
void DLoga(NSString *format,...)
{
#if DDebug
    {
        va_list args;
        va_start(args,format);
        NSLogv(format, args);
        va_end(args);
    }
#endif
}


CGFloat DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
};

