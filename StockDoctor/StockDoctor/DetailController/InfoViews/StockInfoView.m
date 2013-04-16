//
//  StockInfoView.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-11.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "StockInfoView.h"
@interface StockInfoView()
@property (strong, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *changeValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *changeRatioLabel;
@property (strong, nonatomic) IBOutlet UILabel *todayOpenLabel;
@property (strong, nonatomic) IBOutlet UILabel *preCloseLabel;
@property (strong, nonatomic) IBOutlet UILabel *todayHighLabel;
@property (strong, nonatomic) IBOutlet UILabel *todayLowLabel;
@property (strong, nonatomic) IBOutlet UILabel *turnoverRateLabel;
@end

@implementation StockInfoView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        UIView * view = [[NSBundle mainBundle]loadNibNamed:@"StockInfoView" owner:self options:nil][0];
        view.frame = self.bounds;
        [self addSubview:view];
    }
    return self;
}

- (void)reloadData
{
    self.currentPriceLabel.text = self.stockBaseInfoModel.currentPrice;
    self.preCloseLabel.text = self.stockBaseInfoModel.preClose;
    self.todayOpenLabel.text = self.stockBaseInfoModel.openPrice;
    self.todayHighLabel.text = self.stockBaseInfoModel.todayHigh;
    self.todayLowLabel.text = self.stockBaseInfoModel.todayLow;
    self.turnoverRateLabel.text = [NSString stringWithFormat:@"%.2f%%",self.stockBaseInfoModel.turnoverRate.floatValue * 100];
    self.changeValueLabel.text = self.stockBaseInfoModel.changeValue;
    self.changeRatioLabel.text = self.stockBaseInfoModel.changeRatio;
    UIColor * color = nil;
    if (self.stockBaseInfoModel.changeState > 0)
    {
        color = [UIColor redColor];
    }
    else if (self.stockBaseInfoModel.changeState < 0)
    {
        color = [UIColor greenColor];
    }
    else
    {
        color = [UIColor darkGrayColor];
    }
    self.changeRatioLabel.textColor = self.changeValueLabel.textColor = self.currentPriceLabel.textColor = color;
}
@end
