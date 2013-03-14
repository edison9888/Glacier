//
//  ViewController.m
//  BookReader
//
//  Created by cnzhao on 13-3-2.
//  Copyright (c) 2013年 cnzhao. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
#import "BKTextView.h"

#define viewHeight self.view.bounds.size.height

@interface ViewController ()
@end

@implementation ViewController
{
    UIFont * _font;
    UIColor *_fontColor;
    BKTextView * _BKTextView;
    CGFloat _lineHeight;
    int _lastIndex;
    float _currentOffset;
    int _currentIndex;
    int _pageLine;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _BKTextView = [[BKTextView alloc]initWithFrame:CGRectMake(10, 0, 300, viewHeight)];
    [self.view addSubview:_BKTextView];
    
    
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames ){
        printf( "Family: %s \n", [familyName UTF8String] );
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames ){
            printf( "\tFont: %s \n", [fontName UTF8String] );
        }
    }

}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//    [self processText];
//}

//- (void) processText
//{
//    _currentOffset = self.scrollBgView.contentOffset.y;
//    _currentIndex = _currentOffset / _lineHeight > 0 ? _currentOffset / _lineHeight :0;
//    CGFloat scrollOffset = _currentOffset - (_currentIndex * _lineHeight);
//    _BKTextView.scrollOffset = scrollOffset;
//    _BKTextView.frame = CGRectMake(10, _currentOffset, 300, viewHeight);
//    int begin =  _currentIndex > 0 ? _currentIndex: 0;
//    int end = _currentIndex + _pageLine + 1 > self.indexList.count - 1 ? self.indexList.count - 1 : _currentIndex + _pageLine + 1;
//    NSMutableArray * arr = [NSMutableArray array];
//    
//    for (int i = begin; i < end; i++)
//    {
//        int beginIndex =  ((NSNumber *)(self.indexList[i])).intValue;
//        int endInex = ((NSNumber *)(self.indexList[i + 1])).intValue;;
//        
//        [arr addObject:[self.fileStr substringWithRange:NSMakeRange(beginIndex, endInex - beginIndex)]];
//    }
//    
//    _BKTextView.textList = arr;
//    [_BKTextView setNeedsDisplay];
//
//}
//
//- (void)generateBookIndex
//{
//    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)_font.fontName ,
//                                          _font.pointSize,
//                                          NULL);
//    
//    //Setup the attributes dictionary with font and color
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                (__bridge id)font, (id)kCTFontAttributeName,
//                                _fontColor.CGColor, kCTForegroundColorAttributeName,
//                                nil];
//    
//    NSAttributedString *attributedString = [[NSAttributedString alloc]
//                                            initWithString:self.fileStr
//                                            attributes:attributes];
//    
//    CFRelease(font);
//    
//    //Create a TypeSetter object with the attributed text created earlier on
//    CTTypesetterRef typeSetter = CTTypesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
//    
//    CFIndex currentIndex = 0;
//    CFIndex lineLength = 0;
//    NSMutableArray * wArr = [NSMutableArray array];
//    [wArr addObject:@(0)];
//    while (lineLength + currentIndex < self.fileStr.length)
//    {
//        CFIndex lineLength = CTTypesetterSuggestLineBreak(typeSetter,
//                                                          currentIndex,
//                                                          _BKTextView.frame.size.width);
//        currentIndex += lineLength;
//        [wArr addObject:@(currentIndex)];
//    }
//    self.indexList = wArr;
//    CFRelease(typeSetter);
//}
//
//- (void)bookText
//{
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
////    NSData * reader = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"盗墓笔记全集（1-8）" ofType:@"txt" ]];
////    NSString * str;
////    str = [[NSString alloc]initWithData:[reader subdataWithRange:NSMakeRange(0, 1024)] encoding:enc];
//    
//   
//    NSString * str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"盗墓笔记全集（1-8）" ofType:@"txt" ]encoding:enc error:nil];
//    self.fileStr = str;
//}


@end
