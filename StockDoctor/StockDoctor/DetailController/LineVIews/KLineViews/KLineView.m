//
//  KLineView.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-12.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "KLineView.h"
#define LineCount 50

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
    long _topVolume;
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
        if (count < LineCount && !(obj.open.floatValue == obj.close.floatValue && obj.volume.floatValue == 0))
        {
            [arr addObject:obj];
            count++;
        }
    }];
    copyModel.cellDataList = arr;
    
    self.MA5DataList = [model generateMAData:5 WithCount:LineCount];
    self.MA10DataList = [model generateMAData:10 WithCount:LineCount];
    self.MA20DataList = [model generateMAData:20 WithCount:LineCount];
    self.kLineModel = copyModel;
    
    
    [self calcTopAndButtomPrice];
    
    self.verSepList = [self.kLineModel generateVerSepIndexList];
    [self setNeedsDisplay];
}



- (UIBezierPath *) pathForData:(CGRect)rect data:(NSArray *)dataList
{
#define yPoint(price) (ABS(_topPrice - price) / (_topPrice - _buttomPrice) * rect.size.height)    
    
    //每个横轴间隔的距离
    float xStep = CGRectGetWidth(rect) / LineCount;
    
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
    _topVolume = LONG_MIN;
    
    [self.kLineModel.cellDataList enumerateObjectsUsingBlock:^(KLineCellData * obj, NSUInteger idx, BOOL *stop) {
    
        if (obj.high.floatValue > _topPrice)
        {
            _topPrice = obj.high.floatValue;
        }
        
        if (obj.volume.longLongValue > _topVolume)
        {
            _topVolume = obj.volume.longLongValue;
        }
        
        _topPrice = [self adjustValue:self.MA5DataList idx:idx val:_topPrice topOrButtom:true];
        _topPrice = [self adjustValue:self.MA10DataList idx:idx val:_topPrice topOrButtom:true];
        _topPrice = [self adjustValue:self.MA20DataList idx:idx val:_topPrice topOrButtom:true];
        
        if (obj.low.floatValue < _buttomPrice)
        {
            _buttomPrice = obj.low.floatValue;
        }
        
        _buttomPrice = [self adjustValue:self.MA5DataList idx:idx val:_buttomPrice topOrButtom:false];
        _buttomPrice = [self adjustValue:self.MA10DataList idx:idx val:_buttomPrice topOrButtom:false];
        _buttomPrice = [self adjustValue:self.MA20DataList idx:idx val:_buttomPrice topOrButtom:false];
    }];
    
    _halfPrice = (_topPrice - _buttomPrice) / 2;
}


- (float)adjustValue:(NSArray *)arr idx:(int)idx val:(float)value topOrButtom:(bool)tOb
{
    if (arr.count > idx)
    {
        NSNumber * num = arr[idx];
        if (tOb)
        {
            if (num.floatValue > value)
            {
                return num.floatValue;
            }
        }
        else
        {
            if (num.floatValue < value)
            {
                return num.floatValue;
            }
        }
    }
    
    return value;
}

#pragma mark 绘图区域

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.kLineModel)
    {
        [self drawHorizontalGridInRect:[self gridRect] lineCount:4];
        [self drawVerticalGridInRect:[self gridRect]];
        [self drawBarSeries:[self dataRect]];
        
        if (self.MA5DataList.count > 0)
        {
            [self drawDataLine:[self dataRect] data:self.MA5DataList color:[UIColor colorWithRed:0xf2/ 255.0 green:0x5d/255.0 blue:0xb5/255.0 alpha:1]];
        }
        
        if (self.MA10DataList.count > 0)
        {
             [self drawDataLine:[self dataRect] data:self.MA10DataList color:[UIColor colorWithRed:0xff/ 255.0 green:0x80/255.0 blue:0x00/255.0 alpha:1]];
        }
       
        if (self.MA20DataList.count > 0)
        {
            [self drawDataLine:[self dataRect] data:self.MA20DataList color:[UIColor colorWithRed:0x00/ 255.0 green:0xff/255.0 blue:0xff/255.0 alpha:1]];
        }
        
        [self drawLeftString:[self leftStringRect]];
        [self drawRightString:[self rightStringRect]];
        [self drawButtomString:[self buttomStringRect]];
        
        
        [self drawHorizontalGridInRect:[self volumeGridRect] lineCount:3];
        [self drawVerticalGridInRect:[self volumeGridRect]];
        [self drawVolumeBarSeries:[self volumeDataRect]];
        [self drawLeftVolumeString:[self leftStringVolumeRect]];
        [self drawRightVolumeString:[self rightStringVolumeRect]];
    }
}

- (void)drawString:(CGRect)rect stringList:(NSArray *)list lOrR:(bool)lr
{
    if (list.count > 0)
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        CGFloat interval = CGRectGetHeight(rect) / (list.count - 1);
        
        [list enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop)
         {
             [[UIColor grayColor] setFill];
             CGRect stringRect = CGRectMake(CGRectGetMinX(rect) , CGRectGetMinY(rect) + idx * interval - self.textFont.lineHeight / 2.0f, CGRectGetWidth(rect), interval);
             
             if (lr)
             {
                 [obj drawInRect:stringRect withFont:self.textFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
             }
             else
             {
                 [obj drawInRect:stringRect withFont:self.textFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentLeft];
             }
         }];
        CGContextRestoreGState(ctx);
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
    
    [self drawString:rect stringList:arr lOrR:true];
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
    
    [self drawString:rect stringList:arr lOrR:false];
}


- (void)drawLeftVolumeString:(CGRect)rect
{
    NSMutableArray * arr = [NSMutableArray array];
    [arr addObject:[NSString stringWithFormat:@"%.2f",_topVolume / 10000.0f]];
    [arr addObject:@"万手"];
    
    [self drawString:rect stringList:arr lOrR:true];
}

- (void)drawRightVolumeString:(CGRect)rect
{
    NSMutableArray * arr = [NSMutableArray array];
    [arr addObject:[NSString stringWithFormat:@"%.2f",_topVolume / 10000.0f]];
    [arr addObject:@"万手"];
    
    [self drawString:rect stringList:arr lOrR:false];
}

- (void)drawButtomString:(CGRect)rect
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    [[UIColor grayColor] setFill];
    
    CGFloat cellWidth = CGRectGetWidth(rect) / LineCount;
    
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
- (void)drawHorizontalGridInRect:(CGRect)rect lineCount:(int)lineCount
{
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

- (void)drawVolumeBarSeries:(CGRect)rect
{
    CGFloat seriesWidth = CGRectGetWidth(rect) / LineCount;
    
    [self.kLineModel.cellDataList enumerateObjectsUsingBlock:^(KLineCellData * obj, NSUInteger idx, BOOL *stop) {
        CGRect seriesRect = CGRectMake(CGRectGetMaxX(rect) - (idx  + 1)* seriesWidth, CGRectGetMinY(rect), seriesWidth, CGRectGetHeight(rect));
        [self drawVolumeSeriesBar:seriesRect cellData:obj];
    }];
}

//绘制量线单元格
- (void)drawVolumeSeriesBar:(CGRect)rect cellData:(KLineCellData *)data
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
    
#define heightForVolume(volume) (_topVolume - volume) / (float)( _topVolume) * CGRectGetHeight(rect)
    
    
    CGFloat openPoint = heightForVolume(data.volume.longLongValue);
    CGFloat closePoint = heightForVolume(0);
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


//绘制蜡烛图序列
- (void)drawBarSeries:(CGRect)rect
{
    CGFloat seriesWidth = CGRectGetWidth(rect) / LineCount;
    
    [self.kLineModel.cellDataList enumerateObjectsUsingBlock:^(KLineCellData * obj, NSUInteger idx, BOOL *stop) {
        CGRect seriesRect = CGRectMake(CGRectGetMaxX(rect) - (idx  + 1)* seriesWidth, CGRectGetMinY(rect), seriesWidth, CGRectGetHeight(rect));
        [self drawSeriesBar:seriesRect cellData:obj];
    }];
}

//绘制蜡烛图单元格
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
