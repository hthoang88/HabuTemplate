//
//  Define.h
//  HabuTemplate
//
//  Created by Hoang Ho on 7/7/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#define _AFNETWORKING_PIN_SSL_CERTIFICATES_
#define TIMER_REQUEST_TIMEOUT                                                           120.0
#define SDWEBIMAGE_TIME_OUT                 60.0
typedef enum
{
    
    ENUM_API_REQUEST_TYPE_CHECK_SHOW_INVITE,
    ENUM_API_REQUEST_TYPE_INVALID,
}ENUM_API_REQUEST_TYPE;

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