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
    if (![self.stockBaseInfoModel.currentPrice isEqualToString:@"--"]  && self.stockBaseInfoModel.currentPrice.floatValue == 0)
    {
        self.currentPriceLabel.text = @"停牌";
        self.currentPriceLabel.textColor = [UIColor lightGrayColor];
        self.currentPriceLabel.textAlignment = NSTextAlignmentCenter;
        self.preCloseLabel.text = self.stockBaseInfoModel.preClose;
    }
    else
    {
        self.currentPriceLabel.textAlignment = NSTextAlignmentLeft;
        self.currentPriceLabel.text = self.stockBaseInfoModel.currentPrice;
        self.preCloseLabel.text = self.stockBaseInfoModel.preClose;
        self.todayOpenLabel.text = self.stockBaseInfoModel.openPrice;
        self.todayHighLabel.text = self.stockBaseInfoModel.todayHigh;
        self.todayLowLabel.text = self.stockBaseInfoModel.todayLow;
        
        if (self.stockBaseInfoModel.turnoverRate.floatValue)
        {
            self.turnoverRateLabel.text = [NSString stringWithFormat:@"%.2f%%",self.stockBaseInfoModel.turnoverRate.floatValue * 100];
        }
        else
        {
             self.turnoverRateLabel.text = @"--";
        }
        
        
        
        self.changeValueLabel.text = self.stockBaseInfoModel.changeValue;
        self.changeRatioLabel.text = self.stockBaseInfoModel.changeRatio;
        UIColor * color = nil;
        if (self.stockBaseInfoModel.changeState > 0)
        {
            color = [UIColor colorWithRed:233/255.0f green:0 blue:0 alpha:1];
        }
        else if (self.stockBaseInfoModel.changeState < 0)
        {
            color = [UIColor colorWithRed:114/255.0f green:186/255.0f blue:0 alpha:1];
        }
        else
        {
            color = [UIColor lightGrayColor];
        }
        self.changeRatioLabel.textColor = self.changeValueLabel.textColor = self.currentPriceLabel.textColor = color;
    }
}
@end
