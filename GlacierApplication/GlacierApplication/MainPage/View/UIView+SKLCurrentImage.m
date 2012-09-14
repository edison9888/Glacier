//
//  UIView+CurrentImage.m
//  GlacierApplication
//
//  Created by yuwan wang on 12-9-13.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "UIView+SKLCurrentImage.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (SKLCurrentImage)

- (UIImage *)currentImage {
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef wCtx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:wCtx];
    UIImage *wCurrentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return wCurrentImage;
}

@end
