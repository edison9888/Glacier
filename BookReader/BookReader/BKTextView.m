//
//  BKTextView.m
//  BookReader
//
//  Created by cnzhao on 13-3-9.
//  Copyright (c) 2013年 cnzhao. All rights reserved.
//

#import "BKTextView.h"
#import <CoreText/CoreText.h>

#define viewHeight self.bounds.size.height

@interface BKTextView()
{
    int _numberOfLines;
    CGFloat _lineHeight;
    CGFloat _textHeight;
    UIFont * _font;
    UIColor *_fontColor;
    int _lastIndex;
    int _currentIndex;
    int _pageLine;
    float mkCTKernAttributeName;
}
@property (strong, nonatomic) NSString * fileStr;
@property (strong, nonatomic) NSMutableArray * indexList;
@end

@implementation BKTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        mkCTKernAttributeName = 0.0f;
        _font = [UIFont fontWithName:@"Helvetica" size:20];
        _fontColor = [UIColor blackColor];
        _lineHeight = _font.lineHeight;
        _pageLine = viewHeight / _lineHeight + 1;
        _textFont = _font;
        _textColor = _fontColor;
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = false;
        [self fetchbookText];
        [self generateBookIndex];
        self.contentSize = CGSizeMake(1, _lineHeight * self.indexList.count);
        [self processText];
        
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self processText];
}

- (void) processText
{
    float offset = self.contentOffset.y;
    _currentIndex = offset / _lineHeight > 0 ? offset / _lineHeight :0;
    CGFloat scrollOffset = offset - (_currentIndex * _lineHeight);
    self.scrollOffset = scrollOffset;
    int begin =  _currentIndex > 0 ? _currentIndex: 0;
    int end = _currentIndex + _pageLine + 1 > self.indexList.count - 1 ? self.indexList.count - 1 : _currentIndex + _pageLine + 1;
    NSMutableArray * arr = [NSMutableArray array];
    
    for (int i = begin; i < end; i++)
    {
        int beginIndex =  ((NSNumber *)(self.indexList[i])).intValue;
        int endInex = ((NSNumber *)(self.indexList[i + 1])).intValue;;
        
        [arr addObject:[self.fileStr substringWithRange:NSMakeRange(beginIndex, endInex - beginIndex)]];
    }
    
//    NSLog(@"scrollOffset %f  begin %d end %d",self.scrollOffset,begin,end);
    self.textList = arr;
    [self setNeedsDisplay];
}

- (void)generateBookIndex
{
    CTFontRef font = CTFontCreateWithName((CFStringRef)_font.fontName ,
                                          _font.pointSize,
                                          NULL);
    
    //Setup the attributes dictionary with font and color
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                (id)font, (id)kCTFontAttributeName,
                                _fontColor.CGColor, kCTForegroundColorAttributeName,
//                                @(mkCTKernAttributeName),kCTKernAttributeName,
                                nil];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithString:self.fileStr
                                            attributes:attributes];
    
    CFRelease(font);
    
    //Create a TypeSetter object with the attributed text created earlier on
    CTTypesetterRef typeSetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    
    CFIndex currentIndex = 0;
    CFIndex lineLength = 0;
    NSMutableArray * wArr = [NSMutableArray array];
    [wArr addObject:@(0)];
    while (lineLength + currentIndex < self.fileStr.length)
    {
        CFIndex lineLength = CTTypesetterSuggestLineBreakWithOffset(typeSetter, currentIndex, self.frame.size.width, 10);
        currentIndex += lineLength;
        [wArr addObject:@(currentIndex)];
    }
    self.indexList = wArr;
    CFRelease(typeSetter);
}

- (void)fetchbookText
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //    NSData * reader = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"盗墓笔记全集（1-8）" ofType:@"txt" ]];
    //    NSString * str;
//    str = [[NSString alloc]initWithData:[reader subdataWithRange:NSMakeRange(0, 1024)] encoding:enc];
    
    
    NSString * str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"盗墓笔记全集（1-8）" ofType:@"txt" ]encoding:enc error:nil];
    self.fileStr = str;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    
    
     _lineHeight = self.textFont.lineHeight;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Grab the drawing context and flip it to prevent drawing upside-down
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
//    CGContextSaveGState(context);
    //Create a CoreText font object with name and size from the UIKit one
    CTFontRef font = CTFontCreateWithName((CFStringRef)self.textFont.fontName ,
                                          self.textFont.pointSize,
                                          NULL);
    
    //Setup the attributes dictionary with font and color
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                (id)font, (id)kCTFontAttributeName,
                                self.textColor.CGColor, kCTForegroundColorAttributeName,
//                                @(mkCTKernAttributeName),kCTKernAttributeName,
                                nil];
    CGFloat y = - rect.origin.y  - self.textFont.lineHeight + self.scrollOffset;
    
    NSMutableString * allStr = [[NSMutableString alloc]init];
    
    
    [self.textList enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        [allStr appendString:obj];
//        NSAttributedString *attributedString = [[[NSAttributedString alloc]
//                                                 initWithString:obj
//                                                 attributes:attributes] autorelease];
//        
//        //Create a TypeSetter object with the attributed text created earlier on
//        CTTypesetterRef typeSetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
//        
//        
//        //Create a new line with from current index to line-break index
//        CFRange lineRange = CFRangeMake(0, obj.length);
//        CTLineRef line = CTTypesetterCreateLine(typeSetter, lineRange);
//        
//        //Setup the line position
//        CGContextSetTextPosition(context, 0, y);
//        CTLineDraw(line, context);
//        
//        CFRelease(line);
//        y -= _lineHeight;
//        
//        CFRelease(typeSetter);
    }];
    CGMutablePathRef path = CGPathCreateMutable(); //1
    CGPathAddRect(path, NULL, CGRectMake(0, y, self.bounds.size.width, self.bounds.size.height));
    
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:allStr attributes:attributes]; //2
    //    [attString addAttribute:(id)kCTKernAttributeName value:@(6.0f) range:NSMakeRange(0, attString.length)];
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString); //3
    CTFrameRef frame =
    CTFramesetterCreateFrame(framesetter,
                             CFRangeMake(0, [attString length]), path, NULL);
    CTFrameDraw(frame, context); //4
//    
//    CFRelease(frame); //5
//    CFRelease(path);
//    CFRelease(framesetter);
//    
//    CFRelease(font);
    [super drawRect:rect];
    [allStr release];
    [attString release];
}


@end
