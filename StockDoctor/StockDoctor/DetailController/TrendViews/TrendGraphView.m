//
//  TrendGraphView.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-8.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "TrendGraphView.h"

@implementation TrendGraphView
{
    CGPoint _firstPoint;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
    }
    return self;
}

- (UIBezierPath *) pathForData:(CGRect)rect
{
    __block float halfHeight = FLT_MIN;
    
    float preClose = self.trendModel.preClosePrice.floatValue;
    
    [self.trendModel.trendCellDataList enumerateObjectsUsingBlock:^(TrendCellData * obj, NSUInteger idx, BOOL *stop) {
        if (ABS(obj.price.floatValue - preClose) > halfHeight)
        {
            halfHeight = ABS(obj.price.floatValue - preClose);
        }
    }];
    
    float topPrice = preClose + halfHeight;
    
#define yPoint(price) (ABS(topPrice - price) / (2 * halfHeight) * rect.size.height)
    
    //每个横轴间隔的距离
    float xStep = rect.size.width / self.trendModel.trendCellDataList.count;
    
    TrendCellData * first = self.trendModel.trendCellDataList[0];
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    
    _firstPoint = CGPointMake(0,yPoint(first.price.floatValue));
    [bezierPath moveToPoint:_firstPoint];
    
    [self.trendModel.trendCellDataList enumerateObjectsUsingBlock:^(TrendCellData * obj, NSUInteger idx, BOOL *stop) {
        [bezierPath addLineToPoint:CGPointMake(idx * xStep,yPoint(obj.price.floatValue))];
//        [bezierPath moveToPoint:CGPointMake(idx * xStep,yPoint(obj.price.floatValue))];
    }];
    return bezierPath;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawDataLine:rect];
    [self drawLinePatternUnderClosingData:rect clip:true];
}

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

- (void)drawLinePatternUnderClosingData:(CGRect)rect clip:(BOOL)shouldClip {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if(shouldClip) {
        CGContextSaveGState(ctx);
        UIBezierPath *clipPath = [self pathForData:rect];
        CGPoint lastPoint = clipPath.currentPoint;
        [clipPath addLineToPoint:CGPointMake(rect.size.width,lastPoint.y)];
        [clipPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
        [clipPath addLineToPoint:CGPointMake(0, rect.size.height)];
        [clipPath addLineToPoint:CGPointMake(0, _firstPoint.y)];
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
    UIColor *startColor = [UIColor colorWithWhite:1.0 alpha:alpha];
    [startColor setStroke];
    CGFloat step = 4.0;
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
