//
//  TrendGraphView.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-8.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "TrendGraphView.h"

#define WidthRate (24/30.0)
#define HeightRate (26/30.0)


#define yPoint(price) (ABS(_topPrice - price) / (2 * _halfHeightPrice) * rect.size.height)

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
    }];
    
    _topPrice = _preClose + _halfHeightPrice;
    _buttomPrice = _preClose - _halfHeightPrice;
}


- (UIBezierPath *) pathForData:(CGRect)rect
{
    //每个横轴间隔的距离
    float xStep = rect.size.width / self.trendModel.trendCellDataList.count;
    
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
    
    float xStep = rect.size.width / self.aveList.count;
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    
    _firstPoint = CGPointMake(rect.origin.x, rect.origin.y + yPoint(first.floatValue));
    [bezierPath moveToPoint:_firstPoint];
    
    [self.aveList enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x + idx * xStep, rect.origin.y + yPoint(obj.floatValue))];
    }];
    return bezierPath;
}

- (void)reloadData
{
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
        
        double ave = totalVolumn / totalAmount;
        [arr addObject:@(ave)];
    }];
    self.aveList = arr;
}

#pragma mark 绘图区域

//数据区域
- (CGRect)dataRect
{

   return CGRectMake(self.bounds.size.width * (1 - WidthRate) / 2 ,
                     self.bounds.size.height * (1 - HeightRate) / 2,
                     self.bounds.size.width * WidthRate,
                     self.bounds.size.height * HeightRate);
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

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self generateAverageData];
    [self calcTopAndButtomPrice];
    [self drawHorizontalGridInRect:[self dataRect]];
    [self drawVerticalGridInRect:[self dataRect]];
    
    if (self.trendModel.trendCellDataList.count > 0)
    {
        [self drawLinePatternUnderClosingData:[self dataRect] clip:true];
        [self drawAveDataLine:[self dataRect]];
        [self drawDataLine:[self dataRect]];
        [self drawLeftString:[self leftStringRect]];
        [self drawRightString:[self rightStringRect]];
        [self drawButtomString:[self buttomStringRect]];
    }
}

#pragma mark 绘图方法

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
    [[UIColor colorWithWhite:0.75 alpha:1] setFill];
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
    [path setLineWidth:1.0];
    [path moveToPoint:CGPointMake(rint(CGRectGetMinX(rect)),
                                  rint(CGRectGetMinY(rect)) + 0.5)];
    [path addLineToPoint:CGPointMake(rint(CGRectGetMaxX(rect)),
                                     rint(CGRectGetMinY(rect))+ 0.5)];
    UIColor * gridColor = [UIColor colorWithWhite:0.25f alpha:1];
    [gridColor setStroke];
    
    CGContextSaveGState(context);
    [path stroke];
    for(int i = 0;i < lineCount;i++) {
        CGContextTranslateCTM(context, 0.0, rint(CGRectGetHeight(rect) / (float)(lineCount )));
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
    [[UIColor colorWithRed:128/255.0 green:189/255.0 blue:151/255.0 alpha:1] setStroke];
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
        CGPoint lastPoint = clipPath.currentPoint;
        [clipPath addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y +  lastPoint.y)];
        [clipPath addLineToPoint:CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height)];
        [clipPath addLineToPoint:CGPointMake(rect.origin.x ,rect.origin.y +  rect.size.height)];
        [clipPath addLineToPoint:CGPointMake(rect.origin.x,rect.origin.y +  _firstPoint.y)];
        [clipPath closePath];
        [clipPath addClip];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat lineWidth = 1.0;
    [path setLineWidth:lineWidth];
    // because the line width is odd, offset the horizontal lines by 0.5 points
    [path moveToPoint:CGPointMake(0.0, rint(CGRectGetMinY(rect)) + 0.5)];
    [path addLineToPoint:CGPointMake(rint(CGRectGetMaxX(rect)), rint(CGRectGetMinY(rect)) + 0.5)];
    CGFloat alpha = 0.8;
    UIColor *startColor = [UIColor colorWithWhite:0.5 alpha:alpha];
    [startColor setStroke];
    CGFloat step = 2.0;
    CGFloat stepCount = CGRectGetHeight(rect) / step;
    // alpha starts at 0.8, ends at 0.2
    CGFloat alphaStep = (0.8 - 0.2) / stepCount;
    CGContextSaveGState(ctx);
    CGFloat translation = CGRectGetMinY(rect);
    while(translation < CGRectGetMaxY(rect)) {
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
