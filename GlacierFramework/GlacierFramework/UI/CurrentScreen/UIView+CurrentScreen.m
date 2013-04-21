//
//  UIView+CurrentImage.m
//  GlacierApplication
//
//  Created by cnzhao on 12-9-13.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "UIView+CurrentScreen.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (CurrentScreen)
- (UIImage *)currentImage {
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    UIImage * currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return currentImage;
}
@end
