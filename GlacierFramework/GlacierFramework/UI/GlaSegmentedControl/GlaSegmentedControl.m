//
//  GlaSegmentedControl.m
//  GlacierFramework
//
//  Created by cnzhao on 13-6-1.
//  Copyright (c) 2013年 Glacier. All rights reserved.
//

#import "GlaSegmentedControl.h"
#define Ani_Seconds 0.3f
@interface GlaSegmentedControl()
@property (nonatomic,strong) NSMutableDictionary * buttonDictionary;
@end

@implementation GlaSegmentedControl

- (void)dealloc
{
    [_backgrondView release];
    [_buttonDictionary release];
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.buttonDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSUInteger)numForSegments
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(numForSegments)])
    {
        return [self.delegate numForSegments];
    }
    else
    {
        return 0;
    }
}

- (UIControl *)buttonForIndex:(NSUInteger)index
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonForIndex:)])
    {
        return [self.delegate buttonForIndex:index];
    }
    else
    {
        return nil;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self refreshButtonsState];
}

- (void)initButtons
{
    if (self.backgrondView)
    {
        self.backgrondView.frame = self.bounds;
        [self addSubview:self.backgrondView];
    }
    
    CGFloat xAxis = 0;
    CGFloat step = self.bounds.size.width / [self numForSegments];
    for (int i = 0; i< [self numForSegments]; i++)
    {
        UIControl * cont = [self buttonForIndex:i];
        cont.frame = CGRectMake(xAxis + i * step, 0, step, CGRectGetHeight(self.bounds));
        cont.tag = i;
        [self.buttonDictionary setObject:cont forKey:@(i)];
        [self addSubview:cont];
        [cont addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside ];
    }
    
    if (self.buttomView)
    {
        self.buttomView.frame = CGRectMake(0,
                                           CGRectGetHeight(self.bounds) - CGRectGetHeight(self.buttomView.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.buttomView.bounds));
        [self addSubview:self.buttomView];
    }
    
    if (self.showIndicator)
    {
        [self layoutIndicator:false];
    }
}

- (void)layoutIndicator:(bool)animated
{
    if (self.indicatorView)
    {
        [self addSubview:self.indicatorView];
        [self sendSubviewToBack:self.indicatorView];
        UIControl * control = self.buttonDictionary[@(self.selectedIndex)];
        CGFloat x = CGRectGetMidX(control.frame);
        if (animated)
        {
            [UIView animateWithDuration:Ani_Seconds animations:^{
                self.indicatorView.frame = CGRectMake(x - CGRectGetWidth(self.indicatorView.bounds) /2, self.indicatorViewTopPadding, CGRectGetWidth(self.indicatorView.bounds), CGRectGetHeight(self.indicatorView.bounds));
            }];
        }
        else
        {
            self.indicatorView.frame = CGRectMake(x - CGRectGetWidth(self.indicatorView.bounds) /2, self.indicatorViewTopPadding, CGRectGetWidth(self.indicatorView.bounds), CGRectGetHeight(self.indicatorView.bounds));
        }
    }
}

- (void)refreshButtonsState
{
    [self.buttonDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber * index, UIControl * btn, BOOL *stop) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onChangeState:index:selected:)])
        {
            [self.delegate onChangeState:btn index:index.integerValue selected:index.integerValue == self.selectedIndex];
        };
    }];
}

- (void)onClick:(UIControl *)sender
{
    self.selectedIndex = sender.tag;
    [self refreshButtonsState];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSegmentChange:)])
    {
        [self.delegate onSegmentChange:self.selectedIndex];
    };
    [self layoutIndicator:true];
}

@end


