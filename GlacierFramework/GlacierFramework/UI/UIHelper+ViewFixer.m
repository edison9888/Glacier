//
//  NSObject+UIHelper_ViewFixer.m
//  GlacierFramework
//
//  Created by cnzhao on 13-4-16.
//  Copyright (c) 2013年 Glacier. All rights reserved.
//

#import "UIHelper+ViewFixer.h"

@implementation UIView(Fixer)

- (void)fixY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)fixHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

@end