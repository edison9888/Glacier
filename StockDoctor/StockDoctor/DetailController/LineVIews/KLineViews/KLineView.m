//
//  KLineView.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-12.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "KLineView.h"
#define WidthRate (24/30.0)
#define HeightRate (26/30.0)

@interface KLineView()
@property (nonatomic,strong) UIFont * textFont;
@property (nonatomic,strong) KLineModel * kLineModel;
@property (nonatomic,strong) NSArray * MA5DataList;
@property (nonatomic,strong) NSArray * MA10DataList;
@property (nonatomic,strong) NSArray * MA20DataList;
@property (nonatomic,strong) NSArray * verSepList;
@end

@implementation KLineView
{
    float _topPrice;
    float _buttomPrice;
    float _halfPrice;
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




- (void)reloadData:(KLineModel *)model
{
    KLineModel * copyModel = [[KLineModel alloc]init];
    
    copyModel.freq = model.freq;
    
    NSMutableArray * arr = [NSMutableArray array];
    __block int count = 0;
    
    [model.cellDataList enumerateObjectsUsingBlock:^(KLineCellData * obj, NSUInteger idx, BOOL *stop) {
        //只保留后50个数据，如果有节假日等无效数据也删除
        if (count < 50 && !(obj.open.floatValue == obj.close.floatValue && obj.volume.floatValue == 0))
        {
            [arr addObject:obj];
            count++;
        }
    }];
    copyModel.cellDataList = arr;
    
    self.MA5DataList = [model generateMAData:5 WithCount:50];
    self.MA10DataList = [model generateMAData:10 WithCount:50];
    self.MA20DataList = [model generateMAData:20 WithCount:50];
    self.kLineModel = copyModel;
    
    
    [self calcTopAndButtomPrice];
    
    self.verSepList = [self.kLineModel generateVerSepIndexList];
    [self setNeedsDisplay];
}



- (UIBezierPath *) pathForData:(CGRect)rect data:(NSArray *)dataList
{
#define yPoint(price) (ABS(_topPrice - price) / (_topPrice - _buttomPrice) * rect.size.height)    
    
    //每个横轴间隔的距离
    float xStep = CGRectGetWidth(rect) / dataList.count;
    
    NSNumber * first = dataList[0];
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    
    CGPoint fistPoint = CGPointMake(CGRectGetMaxX(rect) -  xStep / 2, rect.origin.y + yPoint(first.floatValue));
    [bezierPath moveToPoint:fistPoint];
    
    [dataList enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        [bezierPath addLineToPoint:CGPointMake(fistPoint.x - idx * xStep, rect.origin.y + yPoint(obj.floatValue))];
    }];
    return bezierPath;
}


- (void)calcTopAndButtomPrice
{
    _topPrice = FLT_MIN;
    _buttomPrice = FLT_MAX;
    
    [self.kLineModel.cellDataList enumerateObjectsUsingBlock:^(KLineCellData * obj, NSUInteger idx, BOOL *stop) {
        if (obj.high.floatValue > _topPrice)
        {
            _topPrice = obj.high.floatValue;
        }
        
        if (obj.low.floatValue < _buttomPrice)
        {
            _buttomPrice = obj.low.floatValue;
        }
    }];
    
    _halfPrice = (_topPrice - _buttomPrice) / 2;
}

#pragma mark 绘图区域

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.kLineModel)
    {
        [self drawHorizontalGridInRect:[self gridRect]];
        [self drawVerticalGridInRect:[self gridRect]];
        [self drawBarSeries:[self dataRect]];
        
        [self drawDataLine:[self dataRect] data:self.MA5DataList color:[UIColor colorWithRed:0xf2/ 255.0 green:0x5d/255.0 blue:0xb5/255.0 alpha:1]];
        
        [self drawDataLine:[self dataRect] data:self.MA10DataList color:[UIColor colorWithRed:0xff/ 255.0 green:0x80/255.0 blue:0x00/255.0 alpha:1]];
        
        [self drawDataLine:[self dataRect] data:self.MA20DataList color:[UIColor colorWithRed:0x00/ 255.0 green:0xff/255.0 blue:0xff/255.0 alpha:1]];
        
        [self drawLeftString:[self leftStringRect]];
        [self drawRightString:[self rightStringRect]];
        [self drawButtomString:[self buttomStringRect]];
    }
}

- (void)drawLeftString:(CGRect)rect
{
    int stringCount = 5;
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i< stringCount; i++)
    {
        float price = _topPrice - i * ((_topPrice - _buttomPrice) /(stringCount - 1));
        [arr addObject:[NSString stringWithFormat:@"%.2f",price]];
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGFloat interval = CGRectGetHeight(rect) / (stringCount - 1);
    
    [arr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop)
     {
         [[UIColor grayColor] setFill];
         CGFloat width = [obj sizeWithFont:self.textFont].width;
         

         
         CGRect stringRect = CGRectMake(CGRectGetMinX(rect)+ 9 / 10.0f * CGRectGetWidth(rect) - width  , CGRectGetMinY(rect) + idx * interval - self.textFont.lineHeight / 2.0f, width, interval);
         
          [obj drawInRect:stringRect withFont:self.textFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
     }];
    CGContextRestoreGState(ctx);
}

- (void)drawRightString:(CGRect)rect
{
    int stringCount = 5;
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i< stringCount; i++)
    {
        float price = _topPrice - i * ((_topPrice - _buttomPrice) /(stringCount - 1));
        [arr addObject:[NSString stringWithFormat:@"%.2f",price]];
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGFloat interval = CGRectGetHeight(rect) / (stringCount - 1);
    
    [arr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop)
     {
         [[UIColor grayColor] setFill];
         
         CGFloat width = [obj sizeWithFont:self.textFont].width;
         
         CGRect stringRect = CGRectMake(CGRectGetMinX(rect) + CGRectGetWidth(rect) * 1 / 10.0, CGRectGetMinY(rect) + idx * interval - self.textFont.lineHeight / 2.0f, width, self.textFont.lineHeight);
         
         
        [obj drawInRect:stringRect withFont:self.textFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentLeft];
     }];
    CGContextRestoreGState(ctx);
}

- (void)drawButtomString:(CGRect)rect
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    [[UIColor grayColor] setFill];
    
    CGFloat cellWidth = CGRectGetWidth(rect) / self.kLineModel.cellDataList.count;
    
    int count = self.verSepList.count;
    
    for (int i = 0; i < count; i++)
    {
        NSNumber * idx = self.verSepList[i];
        CGFloat xOffset = (idx.intValue + 0.5) * cellWidth;
        
        CGFloat xAxis = CGRectGetMaxX(rect) - xOffset;
        
        KLineCellData * data = self.kLineModel.cellDataList[idx.intValue];
        
        NSString * drawStr = nil;
        
        if ([self.kLineModel.freq isEqualToString:@"month"])
        {
            //月线只显示年
            drawStr = [data.date substringToIndex:4];
        }
        else
        {
            //其他显示年和月
            drawStr = [data.date substringToIndex:7];
        }

        
        
        CGFloat width = [drawStr sizeWithFont:self.textFont].width;
        
        CGFloat drawX = xAxis - width / 2;
        CGRect stringRect = CGRectMake(drawX, CGRectGetMinY(rect) , width, CGRectGetHeight(rect));
        
        [drawStr drawInRect:stringRect withFont:self.textFont];
    }
    CGContextRestoreGState(ctx);
}

- (void)drawDataLine:(CGRect)rect data:(NSArray *)dataList color:(UIColor *)lineColor
{
    UIBezierPath * path = [self pathForData:rect data:dataList];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [path setLineWidth:1];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineCapStyle:kCGLineCapRound];
    [lineColor setStroke];
    [path stroke];
    CGContextRestoreGState(context);
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
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:1.0];
    [path moveToPoint:CGPointMake((CGRectGetMinX(rect)),
                                  (CGRectGetMinY(rect)))];
    [path addLineToPoint:CGPointMake((CGRectGetMinX(rect)),
                                     (CGRectGetMaxY(rect)))];
    
    [path moveToPoint:CGPointMake((CGRectGetMaxX(rect)),
                                  (CGRectGetMinY(rect)))];
    [path addLineToPoint:CGPointMake((CGRectGetMaxX(rect)),
                                     (CGRectGetMaxY(rect)))];
    
    CGFloat dashPatern[2] = {1.0, 1.0};
    [path setLineDash:dashPatern count:2 phase:0.0];
    UIColor * gridColor = [UIColor colorWithWhite:0.25f alpha:1];
    [gridColor setStroke];
    
    CGContextSaveGState(context);
    
    CGFloat cellWidth = CGRectGetWidth(rect) / self.kLineModel.cellDataList.count;
    
    int count = self.verSepList.count;
    
    for (int i = 0; i < count; i++)
    {
        NSNumber * idx = self.verSepList[i];
        CGFloat xOffset = (idx.intValue + 0.5) * cellWidth;
        
        [path moveToPoint:CGPointMake(CGRectGetMaxX(rect) - xOffset,
                                      CGRectGetMinY(rect))];
        [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect) - xOffset,
                                         CGRectGetMaxY(rect))];
    }
    [path stroke];
    
    CGContextRestoreGState(context);
}




- (void)drawBarSeries:(CGRect)rect
{
    int seriesCount = self.kLineModel.cellDataList.count;

    CGFloat seriesWidth = CGRectGetWidth(rect) / seriesCount;
    

    [self.kLineModel.cellDataList enumerateObjectsUsingBlock:^(KLineCellData * obj, NSUInteger idx, BOOL *stop) {
        CGRect seriesRect = CGRectMake(CGRectGetMaxX(rect) - (idx  + 1)* seriesWidth, CGRectGetMinY(rect), seriesWidth, CGRectGetHeight(rect));
        [self drawSeriesBar:seriesRect cellData:obj];
    }];
}

- (void)drawSeriesBar:(CGRect)rect cellData:(KLineCellData *)data
{
    UIColor * color;
    
    if (data.close.floatValue > data.open.floatValue)
    {
        color = [UIColor redColor];
    }
    else if (data.close.floatValue < data.open.floatValue)
    {
        color = [UIColor greenColor];
    }
    else
    {
        color = [UIColor grayColor];
    }
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    
#define heightForPrice(price) (_topPrice - price) / ( _topPrice - _buttomPrice) * CGRectGetHeight(rect)
    
    CGFloat highHeight = heightForPrice(data.high.floatValue);
    CGPoint highPoint = CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect) / 2 , CGRectGetMinY(rect) + highHeight);
    [path moveToPoint:highPoint];
    
    CGFloat lowHeight = heightForPrice(data.low.floatValue);
    CGPoint lowPoint = CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect) / 2 , CGRectGetMinY(rect) + lowHeight);
    [path addLineToPoint:lowPoint];
    [path setLineWidth:0.5];
    
    [color setStroke];
    
    [path stroke];
    CGFloat openPoint = heightForPrice(data.open.floatValue);
    CGFloat closePoint = heightForPrice(data.close.floatValue);
    if (ABS(closePoint - openPoint) < 0.5)
    {
        closePoint = openPoint + 0.5;
    }
    
    CGFloat sidePad = 0.5f;
    
    [path moveToPoint:CGPointMake(CGRectGetMinX(rect) + sidePad, CGRectGetMinY(rect) +openPoint)];
    
    [path addLineToPoint:CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect) - sidePad,CGRectGetMinY(rect) + openPoint)];
    
    [path addLineToPoint:CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect) - sidePad,CGRectGetMinY(rect) + closePoint)];
    
    [path addLineToPoint:CGPointMake(CGRectGetMinX(rect) + sidePad, CGRectGetMinY(rect) + closePoint)];
    [color setFill];
    [path fill];
}

@end