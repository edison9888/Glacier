//
//  NSObject+UIHelper_ViewFixer.h
//  GlacierFramework
//
//  Created by cnzhao on 13-4-16.
//  Copyright (c) 2013年 Glacier. All rights reserved.
//

CGRect CGRectMakeInt(CGFloat x, CGFloat y, CGFloat width,
                     CGFloat height);

@interface UIView(Fixer)
- (void)fixY:(CGFloat)y;
- (void)fixHeight:(CGFloat)height;
@end