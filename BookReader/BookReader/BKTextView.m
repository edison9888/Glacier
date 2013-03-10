//
//  BKTextView.m
//  BookReader
//
//  Created by cnzhao on 13-3-9.
//  Copyright (c) 2013年 cnzhao. All rights reserved.
//

#import "BKTextView.h"
#import <CoreText/CoreText.h>
@interface BKTextView()
{
    int _numberOfLines;
    CGFloat _lineHeight;
    CGFloat _textHeight;
}
@end

@implementation BKTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
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
                                nil];
    __block CGFloat y = self.bounds.origin.y + self.bounds.size.height - self.textFont.ascender + self.scrollOffset;
    
    [self.textList enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        
        NSAttributedString *attributedString = [[[NSAttributedString alloc]
                                                 initWithString:obj
                                                 attributes:attributes] autorelease];
        
        //Create a TypeSetter object with the attributed text created earlier on
        CTTypesetterRef typeSetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
        
        
        //Create a new line with from current index to line-break index
        CFRange lineRange = CFRangeMake(0, obj.length);
        CTLineRef line = CTTypesetterCreateLine(typeSetter, lineRange);
        
        //Setup the line position
        CGContextSetTextPosition(context, 0, y);
        CTLineDraw(line, context);
        
        CFRelease(line);
        y -= _lineHeight;
        
        CFRelease(typeSetter);
    }];
    
    CFRelease(font);
    [super drawRect:rect];
}


@end
