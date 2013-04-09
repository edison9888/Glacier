//
//  TrendView.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-8.
//  Copyright (c) 2013年 glacier. All rights reserved.
//


#import "TrendView.h"
#import "TrendGraphView.h"

@interface TrendView ()
@property (strong, nonatomic) IBOutlet TrendGraphView *trendGraphView;
@end

@implementation TrendView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        UIView * view = [[NSBundle mainBundle]loadNibNamed:@"TrendView" owner:self options:nil][0];
        view.frame = self.bounds;
        [self addSubview:view];
    }
    return self;
}

-(void)setTrendModel:(TrendModel *)trendModel
{
    _trendModel = trendModel;
    self.trendGraphView.trendModel = trendModel;
    [self.trendGraphView setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
