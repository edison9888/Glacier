//
//  FiveStarView.m
//  TaxiSeeker
//
//  Created by cnzhao on 13-6-2.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "FiveStarView.h"
#define Star_Image_Hightlight @"star_full.png"
#define Star_Image_Normal @"star_empty.png"
#define Star_Count 5
@interface FiveStarView()
@property (nonatomic,strong) NSMutableDictionary * viewDictionary;
@end

@implementation FiveStarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setRank:(float)rank
{
    _rank = rank;
    [self initViews];
}

- (void)initViews
{
    CGFloat stepWidth = (CGRectGetWidth(self.bounds) - (Star_Count - 1) * _starPadding ) / Star_Count;
    
    for (int i = 0; i<Star_Count; i++)
    {
        UIButton * btn = self.viewDictionary[@(i)];
        if (!btn)
        {
            btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            btn.tag = i;
            [_viewDictionary setObject:btn forKey:@(i)];
        }
        
        btn.frame = CGRectMake(i * (stepWidth + _starPadding), 0, stepWidth, CGRectGetHeight(self.bounds));
        [self addSubview:btn];
        if (i > _rank)
        {
            [btn setBackgroundImage:[UIImage imageNamed:Star_Image_Normal] forState:(UIControlStateNormal)];
            [btn setBackgroundImage:[UIImage imageNamed:Star_Image_Hightlight] forState:(UIControlStateHighlighted)];
        }
        else
        {
            [btn setBackgroundImage:[UIImage imageNamed:Star_Image_Hightlight] forState:(UIControlStateNormal)];
            [btn setBackgroundImage:[UIImage imageNamed:Star_Image_Normal] forState:(UIControlStateHighlighted)];
        }
    }
}
@end
