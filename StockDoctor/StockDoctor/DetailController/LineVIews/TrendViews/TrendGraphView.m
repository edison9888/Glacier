//
//  TrendGraphView.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-8.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "TrendGraphView.h"

#define yPoint(price) (ABS(_topPrice - price) / (2 * _halfHeightPrice) * rect.size.height)
#define CellCount 240

@interface TrendGraphView()
@property (nonatomic,strong)  NSMutableArray * aveList;
@property (nonatomic,strong) UIFont * textFont;
@end

@implementation TrendGraphView
{
    CGPoint _firstPoint;
    float _topPrice;
    float _buttomPrice;
    float _halfHeightPrice;
    float _preClose;
    int _dataStepCount;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.textFont = [UIFont systemFontOfSize:7];
    }
    return self;
}

- (void)calcTopAndButtomPrice
{
    _halfHeightPrice = FLT_MIN;
    
    _preClose = self.stockBaseInfoModel.preClose.floatValue;

    [self.trendModel.trendCellDataList enumerateObjectsUsingBlock:^(TrendCellData * obj, NSUInteger idx, BOOL *stop) {
        if (ABS(obj.price.floatValue - _preClose) > _halfHeightPrice)
        {
            _halfHeightPrice = ABS(obj.price.floatValue - _preClose);
        }
        NSNumber * ave = self.aveList[idx];
        if (ABS(ave.floatValue - _preClose) > _halfHeightPrice)
        {
            _halfHeightPrice = ABS(ave.floatValue - _preClose);
        }
    }];
    
    _topPrice = _preClose + _halfHeightPrice;
    _buttomPrice = _preClose - _halfHeightPrice;
}


- (UIBezierPath *) pathForData:(CGRect)rect
{
    //每个横轴间隔的距离
    float xStep = rect.size.width / CellCount;
    
    TrendCellData * first = self.trendModel.trendCellDataList[0];
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    
    _firstPoint = CGPointMake(rect.origin.x, rect.origin.y + yPoint(first.price.floatValue));
    [bezierPath moveToPoint:_firstPoint];
    
    [self.trendModel.trendCellDataList enumerateObjectsUsingBlock:^(TrendCellData * obj, NSUInteger idx, BOOL *stop) {
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x + idx * xStep, rect.origin.y + yPoint(obj.price.floatValue))];
    }];
    return bezierPath;
}

- (UIBezierPath *)pathForAveData:(CGRect)rect
{
    NSNumber * first = self.aveList[0];
    
    float xStep = rect.size.width / CellCount;
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    
    CGPoint  firstPoint = CGPointMake(rect.origin.x, rect.origin.y + yPoint(first.floatValue));
    [bezierPath moveToPoint:firstPoint];
    
    [self.aveList enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x + idx * xStep, rect.origin.y + yPoint(obj.floatValue))];
    }];
    return bezierPath;
}

- (void)reloadData:(TrendModel *)model
{
    self.trendModel = model;
    [self setNeedsDisplay];
}

- (void)generateAverageData
{
    NSMutableArray * arr = [NSMutableArray array];
    __block double totalVolumn = 0;
    __block double totalAmount = 0;
    
    [self.trendModel.trendCellDataList enumerateObjectsUsingBlock:^(TrendCellData * obj, NSUInteger idx, BOOL *stop) {
        
        totalVolumn += obj.amount.doubleValue * obj.price.doubleValue;
        totalAmount += obj.amount.doubleValue ;
        
        double ave = obj.price.floatValue;
        if (totalAmount > 0)
        {
            ave = totalVolumn / totalAmount;
        }
        [arr addObject:@(ave)];
    }];
    self.aveList = arr;
}

#pragma mark 绘图方法

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.trendModel)
    {
        [self generateAverageData];
        [self calcTopAndButtomPrice];
        [self drawHorizontalGridInRect:[self gridRect]];
        [self drawVerticalGridInRect:[self gridRect]];
        
        if (self.trendModel.trendCellDataList.count > 0)
        {
            [self drawLinePatternUnderClosingData:[self gridRect] clip:true];
            [self drawDataLine:[self dataRect]];
            [self drawAveDataLine:[self dataRect]];
            [self drawLeftString:[self leftStringRect]];
            [self drawRightString:[self rightStringRect]];
            [self drawButtomString:[self buttomStringRect]];
        }
    }
}

- (void)drawLeftString:(CGRect)rect
{
    int stringCount = 5;
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i< stringCount; i++)
    {
        float price = _topPrice - i * (_halfHeightPrice / 2);
        [arr addObject:[NSString stringWithFormat:@"%.2f",price]];
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGFloat interval = CGRectGetHeight(rect) / (stringCount - 1);
    
    [arr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop)
    {
        if (idx < 2)
        {
            [[UIColor redColor] setFill];
        }
        else if(idx == 2)
        {
            [[UIColor grayColor] setFill];
        }
        else
        {
            [[UIColor greenColor] setFill];
        }
        CGFloat width = [obj sizeWithFont:self.textFont].width;
        
        CGRect stringRect = CGRectMake(CGRectGetMinX(rect)+ 9 / 10.0f * CGRectGetWidth(rect) - width  , CGRectGetMinY(rect) + idx * interval - self.textFont.lineHeight / 2.0f, CGRectGetWidth(rect), interval);
        [obj drawInRect:stringRect withFont:self.textFont];
    }];
    CGContextRestoreGState(ctx);
}

- (void)drawRightString:(CGRect)rect
{
    int stringCount = 5;
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i< stringCount; i++)
    {
        float price = _topPrice - i * (_halfHeightPrice / 2);
        float value = ABS(price - _preClose) / _preClose * 100;
        [arr addObject:[NSString stringWithFormat:@"%.2f%%",value]];
    }

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGFloat interval = CGRectGetHeight(rect) / (stringCount - 1);
    
    [arr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop)
     {
         if (idx < 2)
         {
             [[UIColor redColor] setFill];
         }
         else if(idx == 2)
         {
             [[UIColor grayColor] setFill];
         }
         else
         {
             [[UIColor greenColor] setFill];
         }
         CGRect stringRect = CGRectMake(CGRectGetMinX(rect) + CGRectGetWidth(rect) * 1 / 10.0, CGRectGetMinY(rect) + idx * interval - self.textFont.lineHeight / 2.0f, CGRectGetWidth(rect), interval);
         [obj drawInRect:stringRect withFont:self.textFont];
     }];
    CGContextRestoreGState(ctx);
}

- (void)drawButtomString:(CGRect)rect
{
    int stringCount = 5;
    NSArray * arr = @[@"09:00",@"10:30",@"11:30/13:00",@"14:00",@"15:00"];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGFloat interval = CGRectGetWidth(rect) / (stringCount - 1);
    [[UIColor grayColor] setFill];
    [arr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop)
     {
         CGFloat width = [obj sizeWithFont:self.textFont].width;
         
         CGFloat drawX = 0;
         
         if (idx == 0)
         {
             drawX = CGRectGetMinX(rect) + idx * interval;
         }
         else if (idx < stringCount - 1)
         {
             drawX = CGRectGetMinX(rect) + idx * interval - width /2;
         }
         else
         {
             drawX = CGRectGetMinX(rect) + idx * interval - width;
         }
         
         CGRect stringRect = CGRectMake(drawX, CGRectGetMinY(rect) , interval, CGRectGetHeight(rect));
         [obj drawInRect:stringRect withFont:self.textFont];
     }];
    CGContextRestoreGState(ctx);
}



//绘制横向网格线
- (void)drawHorizontalGridInRect:(CGRect)rect
{
    int lineCount = 4;
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:0.5];
    [path moveToPoint:CGPointMake(CGRectGetMinX(rect),
                                  CGRectGetMinY(rect))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect),
                                     CGRectGetMinY(rect))];
    UIColor * gridColor = [UIColor grayColor];
    [gridColor setStroke];
    
    CGContextSaveGState(context);
    [path stroke];
    for(int i = 0;i < lineCount;i++) {
        CGContextTranslateCTM(context, 0.0, CGRectGetHeight(rect) / lineCount);
        [path stroke];
    }
    CGContextRestoreGState(context);
}

//绘制纵向网格线
- (void)drawVerticalGridInRect:(CGRect)rect
{
    int lineCount = 4;
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:1.0];
    [path moveToPoint:CGPointMake(rint(CGRectGetMinX(rect)),
                                  rint(CGRectGetMinY(rect)) + 0.5)];
    [path addLineToPoint:CGPointMake(rint(CGRectGetMinX(rect)) + 0.5,
                                     rint(CGRectGetMaxY(rect)))];
    CGFloat dashPatern[2] = {1.0, 1.0};
    [path setLineDash:dashPatern count:2 phase:0.0];
    UIColor * gridColor = [UIColor colorWithWhite:0.25f alpha:1];
    [gridColor setStroke];
    
    CGContextSaveGState(context);
    [path stroke];
    for(int i = 0;i < lineCount;i++) {
        CGContextTranslateCTM(context, (CGRectGetWidth(rect) / (float)(lineCount)), 0.0);
        [path stroke];
    }
    CGContextRestoreGState(context);
}

//绘制当日分时线
- (void)drawDataLine:(CGRect)rect
{
    UIBezierPath * path = [self pathForData:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [path setLineWidth:1];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineCapStyle:kCGLineCapRound];
    [[UIColor colorWithRed:0x95/255.0 green:0xd2/255.0 blue:0x64/255.0 alpha:1] setStroke];
    [path stroke];
    CGContextRestoreGState(context);
}

//绘制当日分时线
- (void)drawAveDataLine:(CGRect)rect
{
    UIBezierPath * path = [self pathForAveData:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [path setLineWidth:1];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineCapStyle:kCGLineCapRound];
    [[UIColor yellowColor] setStroke];
    [path stroke];
    CGContextRestoreGState(context);
}


- (void)drawLinePatternUnderClosingData:(CGRect)rect clip:(BOOL)shouldClip {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if(shouldClip) {
        CGContextSaveGState(ctx);
        UIBezierPath *clipPath = [self pathForData:rect];
        float xStep = rect.size.width / CellCount;
        CGFloat lastX = 0;
        
        if (self.trendModel.trendCellDataList.count >= CellCount)
        {
            lastX = CGRectGetMinX(rect) + xStep * CellCount;
        }
        else
        {
            lastX = CGRectGetMinX(rect) + xStep * self.trendModel.trendCellDataList.count;
        }
        
        [clipPath addLineToPoint:CGPointMake(lastX, CGRectGetMaxY(rect))];
        [clipPath addLineToPoint:CGPointMake(CGRectGetMinX(rect),CGRectGetMaxY(rect))];
        [clipPath addLineToPoint:CGPointMake(CGRectGetMinX(rect),CGRectGetMinY(rect) +  _firstPoint.y)];
        [clipPath closePath];
        [clipPath addClip];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat lineWidth = 1.0;
    [path setLineWidth:lineWidth];
    // because the line width is odd, offset the horizontal lines by 0.5 points
    [path moveToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
    CGFloat alpha = 0.8;
    UIColor *startColor = [UIColor colorWithWhite:0.5 alpha:alpha];
    [startColor setStroke];
    CGFloat step = 1.5f;
    CGFloat stepCount = CGRectGetHeight(rect) / step;
    // alpha starts at 0.8, ends at 0.2
    CGFloat alphaStep = (0.8 - 0.2) / stepCount;
    CGContextSaveGState(ctx);
    CGFloat translation = CGRectGetMinY(rect);
    while(translation < CGRectGetMaxY(rect))
    {
        [path stroke];
        CGContextTranslateCTM(ctx, 0.0, lineWidth * step);
        translation += lineWidth * step;
        alpha -= alphaStep;
        startColor = [startColor colorWithAlphaComponent:alpha];
        [startColor setStroke];
    }
    CGContextRestoreGState(ctx);
    if(shouldClip) {
        CGContextRestoreGState(ctx);
    }
}


@end
