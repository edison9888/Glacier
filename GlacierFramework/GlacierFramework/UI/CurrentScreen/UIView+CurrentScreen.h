//
//  UIView+CurrentImage.h
//  GlacierApplication
//
//  Created by cnzhao on 12-9-13.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CurrentScreen)
@property (nonatomic, readonly) UIImage *currentImage;      // 获得截屏图像
@end
