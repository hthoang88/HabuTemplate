//
//  UIImage+HBLock.h
//  VISIKARD
//
//  Created by Hoang Ho on 7/4/14.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (HBLock)

//Crop
- (UIImage*)imageByCropFromCenterWithSize:(CGSize)aSize;
- (UIImage*)imageByCropFromCenterWithSize:(CGSize)aSize scaleFactor:(float)scale;
- (UIImage*)imageByCropWithNewSize:(CGSize)nSize point:(CGPoint)nPoint;
@end
