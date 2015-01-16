//
//  TPLMacros.h
//  MusicPlayer
//
//  Created by Hoang Ho on 12/6/12.
//  Copyright (c) 2012 Tech Propulsion Labs. All rights reserved.
//


#import <Foundation/Foundation.h>

// BOXING
NSNumber *BOX_BOOL(BOOL x);
NSNumber *BOX_INT(int x);
NSNumber *BOX_SHORT(short x);
NSNumber *BOX_LONG(long x);
NSNumber *BOX_UINT(unsigned int x);
NSNumber *BOX_FLOAT(float x);
NSNumber *BOX_DOUBLE(double x);
NSInteger KEYBOARD_HEIGHT_IPHONE();

// UNBOXING
BOOL UNBOX_BOOL(NSNumber *x);
NSInteger UNBOX_INT(NSNumber *x);
short UNBOX_SHORT(NSNumber *x);
long UNBOX_LONG(NSNumber *x);
NSUInteger UNBOX_UINT(NSNumber *x);
float UNBOX_FLOAT(NSNumber *x);
double UNBOX_DOUBLE(NSNumber *x);

// STRINGIFY
NSString *STRINGIFY_BOOL(BOOL x);
NSString *STRINGIFY_INT(NSInteger x);
NSString *STRINGIFY_SHORT(short x);
NSString *STRINGIFY_LONG(long x);
NSString *STRINGIFY_UINT(NSUInteger x);
NSString *STRINGIFY_FLOAT(float x);
NSString *STRINGIFY_DOUBLE(double x);


// BOUNDS
CGRect RECT_WITH_X(CGRect rect, float x);
CGRect RECT_WITH_Y(CGRect rect, float y);
CGRect RECT_WITH_X_Y(CGRect rect, float x, float y);

CGRect RECT_WITH_X_WIDTH(CGRect rect, float x, float width);
CGRect RECT_WITH_Y_HEIGHT(CGRect rect, float y, float height);

CGRect RECT_WITH_WIDTH_HEIGHT(CGRect rect, float width, float height);
CGRect RECT_WITH_WIDTH(CGRect rect, float width);
CGRect RECT_WITH_HEIGHT(CGRect rect, float height);
CGRect RECT_WITH_HEIGHT_FROM_BOTTOM(CGRect rect, float height);

CGRect RECT_INSET_BY_LEFT_TOP_RIGHT_BOTTOM(CGRect rect, float left, float top, float right, float bottom);
CGRect RECT_INSET_BY_TOP_BOTTOM(CGRect rect, float top, float bottom);
CGRect RECT_INSET_BY_LEFT_RIGHT(CGRect rect, float left, float right);

CGRect RECT_STACKED_OFFSET_BY_X(CGRect rect, float offset);
CGRect RECT_STACKED_OFFSET_BY_Y(CGRect rect, float offset);

CGRect RECT_ADD_X(CGRect rect, float value);
CGRect RECT_ADD_Y(CGRect rect, float value);
CGRect RECT_ADD_WIDTH(CGRect rect, float value);
CGRect RECT_ADD_HEIGHT(CGRect rect, float value);
// MATH
double DEG_TO_RAD(double degrees);
double RAD_TO_DEG(double radians);

// COMPARES
BOOL fequal(double a, double b);
BOOL fequalf(float a, float b);
BOOL fequalzero(double a);
BOOL fequalzerof(float a);


// DUMPS
NSString *RECT_TO_STR(CGRect r);
NSString *POINT_TO_STR(CGPoint p);
NSString *SIZE_TO_STR(CGSize s);

// DIRECTORIES
NSString *DOCUMENTS_DIR(void);
NSString *LIBRARY_DIR(void);
NSString *TEMP_DIR(void);
NSString *BUNDLE_DIR(void);
NSString *NSDCIM_DIR(void);

BOOL IS_MULTITASKING_AVAILABLE(void);
BOOL IS_CAMERA_AVAILABLE(void);
BOOL IS_GAME_CENTER_AVAILABLE(void);
BOOL IS_EMAIL_ACCOUNT_AVAILABLE(void);
BOOL IS_GPS_ENABLED(void);
BOOL IS_GPS_ENABLED_ON_DEVICE(void);
BOOL IS_GPS_ENABLED_FOR_APP(void);

// DISPATCHERS
void DISPATCH_TO_MAIN_QUEUE(BOOL isAsync, void (^block)());
void DISPATCH_TO_GLOBAL_QUEUE(dispatch_queue_priority_t priority, BOOL isAsync, void (^block)());
void DISPATCH_TO_QUEUE(dispatch_queue_t queue, BOOL isAsync, void (^block)());
void DISPATCH_TO_MAIN_QUEUE_AFTER(NSTimeInterval delay, void (^block)());
void DISPATCH_TO_GLOBAL_QUEUE_AFTER(NSTimeInterval delay, dispatch_queue_priority_t priority, void (^block)());
void DISPATCH_TO_CURRENT_QUEUE_AFTER(NSTimeInterval delay, void (^block)());
void DISPATCH_TO_QUEUE_AFTER(NSTimeInterval delay, dispatch_queue_t queue, void (^block)());


// LOG Trace
void printRect(CGRect);

// COLOR
UIColor* RGB(int r,int g, int b);
UIColor* RGBA(int r,int g, int b,float a);
UIColor* HEX_COLOR_STRING(NSString *string);
UIColor* HEX_COLOR_STRING_A(NSString *string, float a);
UIImage* IMAGE_FROM_COLOR(UIColor *color);
UIImage* IMAGE_FROM_COLOR_RECT(UIColor *color, CGRect rect);
UIImage* BUY_IMAGE_COLOR();
UIImage* SELL_IMAGE_COLOR();
UIImage* NAV_IMAGE_COLOR();
UIImage* SCALE_IMAGE_TO_SIZE(UIImage* image, CGSize size);
NSString* localizedString(NSString *string);

CGFloat DegreesToRadians(CGFloat degrees);
//System Version


#define STR_TRIMALL( object )[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

#define SYSTEM_VERSION_EQUAL_TO(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)             ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#define IS_PORTRAIT UIDeviceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])
#define IS_LANDSCAPE  UIDeviceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation])

#define WIDTH_SCREEN        IS_IPHONE ? (IS_4_INCHES ? 568 : 480) : 1024
#define HEIGH_SCREEN        IS_IPHONE ? 320 : 768

#define IS_IPAD	(UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0)
#define IS_4_INCHES         [UIDevice currentDevice].resolution == UIDeviceResolution_iPhoneRetina4
#define IS_IOS7  SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define SizeMakeIphone CGSizeMake(320, 480)
#define SizeMakeIphoneLandscape CGSizeMake(480, 320)
#define SizeMakeIphone5 CGSizeMake(320, 568.0f)
#define SizeMakeIphone5Lanscape CGSizeMake(568.0f, 320)

#define DDebug 1

#if DDebug
#define DLog(fmt, ...) DLoga((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(fmt, ...) DLoga(fmt, ##__VA_ARGS__);
#endif

void DLoga(NSString *format,...);

NSString* localizedString(NSString *key);

