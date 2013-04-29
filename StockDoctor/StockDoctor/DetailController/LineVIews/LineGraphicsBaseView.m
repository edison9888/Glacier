//
//  LineGraphicsBaseView.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-14.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "LineGraphicsBaseView.h"

#define WidthRate (24/30.0)
#define HeightRate (26/30.0)

#define data_start (1/20.0f)
#define data_end (13/20.0f)
#define buttom_string_start (13/20.0f)
#define buttom_string_end (14/20.0f)
#define volume_start (15/20.0f)
#define volume_end (19/20.0f)
#define string_padding 2

@implementation LineGraphicsBaseView

#pragma mark 绘图区域

//网格区域区域
- (CGRect)gridRect
{
    return CGRectMake(self.bounds.size.width * (1 - WidthRate) / 2 ,
                      self.bounds.size.height * data_start,
                      self.bounds.size.width * WidthRate,
                      self.bounds.size.height * (data_end - data_start));
}

//数据区域
- (CGRect)dataRect
{
    CGFloat lineWidth = 1;
    return CGRectMake(self.bounds.size.width * (1 - WidthRate) / 2 + lineWidth,
                      self.bounds.size.height * data_start + lineWidth,
                      self.bounds.size.width * WidthRate - lineWidth * 2,
                      self.bounds.size.height * (data_end - data_start) - lineWidth * 2);
}

//左边文本区域
- (CGRect)leftStringRect
{
    return CGRectMake(0 ,
                      self.bounds.size.height * data_start,
                      self.bounds.size.width * (1 - WidthRate) / 2 - string_padding,
                      self.bounds.size.height * (data_end - data_start));
}

//右边文本区域
- (CGRect)rightStringRect
{
    return CGRectMake(self.bounds.size.width * (1 + WidthRate) / 2 + string_padding,
                      self.bounds.size.height * data_start,
                      self.bounds.size.width * (1 - WidthRate) / 2 - string_padding,
                      self.bounds.size.height * (data_end - data_start));
}

//下部文本区域
- (CGRect)buttomStringRect
{
    return CGRectMake(self.bounds.size.width * (1 - WidthRate) / 2 ,
                      self.bounds.size.height * buttom_string_start,
                      self.bounds.size.width * WidthRate,
                      self.bounds.size.height * (buttom_string_end - buttom_string_start));
}

//量线网格区域
- (CGRect)volumeGridRect
{
    return CGRectMake(self.bounds.size.width * (1 - WidthRate) / 2 ,
                      self.bounds.size.height * volume_start,
                      self.bounds.size.width * WidthRate,
                      self.bounds.size.height * (volume_end - volume_start));
}

//量线数据区域
- (CGRect)volumeDataRect
{
    CGFloat lineWidth = 1;
    return CGRectMake(self.bounds.size.width * (1 - WidthRate) / 2 + lineWidth,
                      self.bounds.size.height * volume_start + lineWidth,
                      self.bounds.size.width * WidthRate - lineWidth * 2,
                      self.bounds.size.height * (volume_end - volume_start) - lineWidth * 2);
}

//左边量线文本区域
- (CGRect)leftStringVolumeRect
{
    return CGRectMake(0 ,
                      self.bounds.size.height * volume_start,
                      self.bounds.size.width * (1 - WidthRate) / 2 - string_padding,
                      self.bounds.size.height * (volume_end - volume_start));
}

//右边量线文本区域
- (CGRect)rightStringVolumeRect
{
    return CGRectMake(self.bounds.size.width * (1 + WidthRate) / 2 + string_padding,
                      self.bounds.size.height * volume_start,
                      self.bounds.size.width * (1 - WidthRate) / 2 - string_padding,
                      self.bounds.size.height * (volume_end - volume_start));
}


- (void)drawString:(CGRect)rect stringList:(NSArray *)list lOrR:(bool)lr
{
    if (list.count > 0)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        CGContextSetAllowsAntialiasing(ctx, true);
        CGFloat interval = CGRectGetHeight(rect) / (list.count - 1);
        
        [list enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop)
         {
             [[UIColor lightGrayColor] setFill];
             CGRect stringRect = CGRectMakeInt(CGRectGetMinX(rect) ,CGRectGetMinY(rect) + idx * interval - self.textFont.lineHeight / 2.0f, CGRectGetWidth(rect), interval);
             
             if (lr)
             {
                 if ([obj isEqualToString:@"万手"])
                 {
                     
                     [obj drawInRect:stringRect withFont:[UIFont boldSystemFontOfSize:8] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
                 }
                 else
                 {
                     [obj drawInRect:stringRect withFont:self.textFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
                 }
             }
             else
             {
                 if ([obj isEqualToString:@"万手"])
                 {
                     [obj drawInRect:stringRect withFont:[UIFont boldSystemFontOfSize:8] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentLeft];
                 }
                 else
                 {
                     [obj drawInRect:stringRect withFont:self.textFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentLeft];
                 }
             }
         }];
        CGContextRestoreGState(ctx);
    }
}

@end
