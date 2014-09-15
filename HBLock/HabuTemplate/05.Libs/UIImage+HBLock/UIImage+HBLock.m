//
//  UIImage+HBLock.m
//  VISIKARD
//
//  Created by Hoang Ho on 7/4/14.
//
//

#import "UIImage+HBLock.h"

#define WIDTH_IMAGE_REDUCED_QUALITY_DEFAULT                             720
#define HEIGHT_IMAGE_REDUCED_QUALITY_DEFAULT                            720
#define QUALITY_IMAGE_REDUCED_QUALITY_DEFAULT                           0.95

@implementation UIImage (HBLock)

- (UIImage*)imageByCropFromCenterWithSize:(CGSize)aSize
{
    return [self imageByCropFromCenterWithSize:aSize scaleFactor:1.0f];
}

- (UIImage*)imageByCropFromCenterWithSize:(CGSize)aSize scaleFactor:(float)scale
{
    CGSize deltaSize = [self getMinimum:aSize.width ms:aSize.height];
    CGSize newSize = aSize;
    if (scale  != 1.0f) {
        if ((newSize.height  * scale) <= self.size.height) {
            newSize.height *= scale;
        }
    }
    while ((newSize.width +deltaSize.width) <= self.size.width && (newSize.height + deltaSize.height) <= self.size.height) {
        newSize.width += deltaSize.width;
        newSize.height += deltaSize.height;
    }
    
    double x = (self.size.width - newSize.width) / 2.0;
    double y = (self.size.height - newSize.height) / 2.0;
    
    return [self imageByCropWithNewSize:newSize point:CGPointMake(x, y)];
}

- (UIImage*)imageByCropWithNewSize:(CGSize)nSize point:(CGPoint)nPoint
{
    CGRect cropRect = CGRectMake(nPoint.x, nPoint.y, nSize.width, nSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}


int USCLN(int a, int b)
{
    if(a==0) return b;
    return USCLN(b%a,a);
}

- (CGSize)getMinimum:(int)TS ms:(int)MS
{
    int temp = USCLN(TS, MS);
    TS /= temp;
    MS /= temp;
    return CGSizeMake(TS, MS);
}


- (UIImage *)imageByScalingToSize:(CGSize)size withOption:(enumImageScalingType)type {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize targetSize;
    CGRect drawRect;
    
    if (type == enumImageScalingType_Top) {
        targetSize = CGSizeMake(sourceImage.size.width, size.height*sourceImage.size.width/size.width);
        drawRect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
    }
    else if (type == enumImageScalingType_TargetSize) {
        targetSize = CGSizeMake(sourceImage.size.width, size.height*sourceImage.size.width/size.width);
        drawRect = CGRectMake(0, 0, targetSize.width, targetSize.height);
    }
    else if (type == enumImageScalingType_Center_ScaleSize) {
        CGFloat scaleFactor;
        CGFloat widthFactor = sourceImage.size.width/size.width;
        CGFloat heightFactor = sourceImage.size.height/size.height;
        
        if (widthFactor < heightFactor)
            scaleFactor = heightFactor;
        else
            scaleFactor = widthFactor;
        
        CGFloat scaledWidth  = size.width*scaleFactor;
        CGFloat scaledHeight = size.height*scaleFactor;
        targetSize = CGSizeMake(scaledWidth, scaledHeight);
        
        drawRect = CGRectMake((scaledWidth - sourceImage.size.width)/2, (scaledHeight - sourceImage.size.height)/2, sourceImage.size.width, sourceImage.size.height);
    }
    else if (type == enumImageScalingType_Center_FullSize) {
        //TaiT: 06/24/13 update scale full size, just scale one side (width or height)
        CGFloat scaleFactor;
        CGFloat widthFactor = sourceImage.size.width/size.width;
        CGFloat heightFactor = sourceImage.size.height/size.height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        CGFloat scaledWidth  = sourceImage.size.width/scaleFactor;
        CGFloat scaledHeight = sourceImage.size.height/scaleFactor;
        
        targetSize = size;
        drawRect = CGRectMake(-(scaledWidth - size.width)/2, -(scaledHeight - size.height)/2, scaledWidth, scaledHeight);
    } else if (type == enumImageScalingType_FullSize) {
        CGFloat scaleFactor;
        CGFloat widthFactor = sourceImage.size.width/size.width;
        CGFloat heightFactor = sourceImage.size.height/size.height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        CGFloat scaledWidth  = sourceImage.size.width/scaleFactor;
        CGFloat scaledHeight = sourceImage.size.height/scaleFactor;
        
        drawRect = CGRectMake(0, 0, scaledWidth, scaledHeight);
        targetSize = drawRect.size;
    }
    else if (type == enumImageScalingType_FitSize)
    {
        CGFloat scaleFactor;
        CGFloat widthFactor = sourceImage.size.width/size.width;
        CGFloat heightFactor = sourceImage.size.height/size.height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        CGFloat scaledWidth  = sourceImage.size.width/scaleFactor;
        CGFloat scaledHeight = sourceImage.size.height/scaleFactor;
        
        drawRect = CGRectMake(0, 0, scaledWidth, scaledHeight);
        targetSize = drawRect.size;
    }
    else {
        targetSize = CGSizeMake(size.width*sourceImage.size.height/size.height, sourceImage.size.height);
        drawRect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
    }
    
    if ([[UIDevice currentDevice] resolution] != UIDeviceResolution_iPhoneStandard) {
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, 2.0f);
    } else {
        UIGraphicsBeginImageContext(targetSize);
    }
    
    // draw image
    [sourceImage drawInRect:drawRect];
    
    // grab image
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    return newImage;
}

- (NSData*)getImageDataWithMaxSize:(CGSize)size andQuality:(float)quality {
    CGSize origSize = self.size;
    NSInteger newHeight = origSize.height;
    NSInteger newWidth = origSize.width;
    
    NSInteger maxHeight;
    NSInteger maxWidth;
    if (size.width <= 0 || size.height <= 0) {
        maxHeight = HEIGHT_IMAGE_REDUCED_QUALITY_DEFAULT;
        maxWidth = WIDTH_IMAGE_REDUCED_QUALITY_DEFAULT;
    }
    else {
        maxHeight = size.height;
        maxWidth = size.width;
    }
    
    //Image is taller than it is wide or square
    if(origSize.height > origSize.width && origSize.height > maxHeight) {
        float scale = origSize.height/maxHeight;
        newHeight = maxHeight;
        newWidth = origSize.width/scale;
        
    }
    //Image is wider than it is tall
    else if(origSize.width > origSize.height && origSize.width > maxWidth) {
        float scale = origSize.width/maxWidth;
        newWidth = maxWidth;
        newHeight = origSize.height/scale;
        
    }
    //Else image is too small to need resizing
    
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    NSUInteger imgSize = 0;
    
    float imgQuality = 0.0;
    if (quality <= 0) {
        imgQuality = QUALITY_IMAGE_REDUCED_QUALITY_DEFAULT;
    }
    else {
        imgQuality = quality;
    }
    
    NSData* resizedImageData = nil;
    do {
        UIGraphicsBeginImageContext(newSize);
        [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        resizedImageData = UIImageJPEGRepresentation(newImage, imgQuality);
        imgSize = [resizedImageData length];
        imgQuality -= .1;
        
        //VKLog(@"resizedImageData size = %d", imgSize);
    } while (imgSize > 512000 && imgQuality > 0);
    
    return resizedImageData;
}

@end
