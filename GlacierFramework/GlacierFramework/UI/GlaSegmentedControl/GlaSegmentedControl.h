//
//  GlaSegmentedControl.h
//  GlacierFramework
//
//  Created by cnzhao on 13-6-1.
//  Copyright (c) 2013年 Glacier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GlaSegmentedControlDelegate <NSObject>
- (NSUInteger)numForSegments;
- (UIControl *)buttonForIndex:(NSUInteger)index;
@optional
- (void)onChangeState:(id)button index:(NSUInteger)index selected:(BOOL)isSelected;
- (void)onSegmentChange:(NSUInteger)index;
@end

@interface GlaSegmentedControl : UIView
@property (nonatomic,retain) UIView * backgrondView;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,assign) id<GlaSegmentedControlDelegate> delegate;
- (void)initButtons;
@end
