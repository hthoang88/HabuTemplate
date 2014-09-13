//
//  UIImage+HBLock.m
//  VISIKARD
//
//  Created by Hoang Ho on 7/4/14.
//
//

#import "UIImage+HBLock.h"

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
@end
