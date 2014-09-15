//
//  Define.h
//  HabuTemplate
//
//  Created by Hoang Ho on 7/7/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#ifndef ah_retain
#if __has_feature(objc_arc)
#define ah_retain self
#define ah_dealloc self
#define release self
#define autorelease self
#else
#define ah_retain retain
#define ah_dealloc dealloc
#define __bridge
#endif
#endif


#define _AFNETWORKING_PIN_SSL_CERTIFICATES_
#define TIMER_REQUEST_TIMEOUT                                                           5.0

#define SDWEBIMAGE_TIME_OUT                                                 60
typedef enum
{
    
    ENUM_API_REQUEST_TYPE_CHECK_SHOW_INVITE,
    ENUM_API_REQUEST_TYPE_GET_FB_LIST_FRIENDS
    
}ENUM_API_REQUEST_TYPE;

typedef enum
{
    enumPhotoViewType_Camera = 0,
    enumPhotoViewType_Preview,
    enumPhotoViewType_Num
}enumPhotoViewType;

typedef enum {
	enumImageScalingType_Invalid,
    enumImageScalingType_Left,
    enumImageScalingType_Top,
    enumImageScalingType_Right,
    enumImageScalingType_Bottom,
    enumImageScalingType_TargetSize,
    enumImageScalingType_Center_ScaleSize,
    enumImageScalingType_Center_FullSize,
    enumImageScalingType_FullSize,
    enumImageScalingType_FitSize // fit to size
} enumImageScalingType;

typedef enum
{
    enumPhoneType_iPhone4 = 1,
    enumPhoneType_iPhone5,
    enumPhoneType_iPhone6,
    enumPhoneType_iPhonePlus,
    enumPhoneType_iPad,
    enumPhoneType_iPadMini
}enumPhoneType;

#define RANDOM_STRING_LENGHT                        10

#define dataCenterInstanced                         [DataCenter shared]
//CoreData
#define sharedManageObjectContent               dataCenterInstanced.managedObjectContext
#define kCDCategoryEntity                 @"CategoryModel"
#define kCDStoryEntity                     @"StoryModel"
#define kCDPageEntity                     @"PageModel"
