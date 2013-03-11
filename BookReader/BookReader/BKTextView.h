//
//  BKTextView.h
//  BookReader
//
//  Created by cnzhao on 13-3-9.
//  Copyright (c) 2013年 cnzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKTextView : UIScrollView<UIScrollViewDelegate>
@property (retain,nonatomic) NSString * bookText;
@property (retain,nonatomic) UIFont * textFont;
@property (retain,nonatomic) UIColor * textColor;
@property (assign,nonatomic) CGFloat scrollOffset;
@property (retain,nonatomic) NSMutableArray * textList;
@end
