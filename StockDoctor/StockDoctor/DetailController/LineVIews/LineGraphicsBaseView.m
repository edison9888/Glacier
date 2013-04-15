//
//  LineGraphicsBaseView.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-14.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "LineGraphicsBaseView.h"

@implementation LineGraphicsBaseView

#pragma mark 绘图区域

//网格区域区域
- (CGRect)gridRect
{
    return CGRectMake(self.bounds.size.width * (1 - WidthRate) / 2 ,
                      self.bounds.size.height * (1 - HeightRate) / 2,
                      self.bounds.size.width * WidthRate,
                      self.bounds.size.height * HeightRate);
}

//数据区域
- (CGRect)dataRect
{
    CGFloat lineWidth = 1;
    return CGRectMake(self.bounds.size.width * (1 - WidthRate) / 2 + lineWidth,
                      self.bounds.size.height * (1 - HeightRate) / 2 + lineWidth,
                      self.bounds.size.width * WidthRate - lineWidth * 2,
                      self.bounds.size.height * HeightRate - lineWidth * 2);
}

- (CGRect)leftStringRect
{
    return CGRectMake(0 ,
                      self.bounds.size.height * (1 - HeightRate) / 2,
                      self.bounds.size.width * (1 - WidthRate) / 2,
                      self.bounds.size.height * HeightRate);
}

- (CGRect)buttomStringRect
{
    return CGRectMake(self.bounds.size.width * (1 - WidthRate) / 2 ,
                      self.bounds.size.height * (1 + HeightRate) / 2,
                      self.bounds.size.width * WidthRate,
                      self.bounds.size.height * (1 - HeightRate) / 2);
}

- (CGRect)rightStringRect
{
    return CGRectMake(self.bounds.size.width * (1 + WidthRate) / 2,
                      self.bounds.size.height * (1 - HeightRate) / 2,
                      self.bounds.size.width * (1 - WidthRate) / 2,
                      self.bounds.size.height * HeightRate);
}


@end
