//
//  SingleDiagnosisController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-20.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "SingleDiagnosisController.h"

@interface SingleDiagnosisController ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *probabilityLabel;
@end

static float gIndexValue;

@implementation SingleDiagnosisController

- (void)dealloc
{
    self.detailController = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",self.detailController.searchModel.shortName,self.detailController.searchModel.shortCode];
    
    if (self.isStock)
    {
        
    }
    else
    {
        if (gIndexValue)
        {
            [self calculateIndex];
        }
        else
        {
            [self requestForIndexValue];
        }
    }
}

- (void)requestForIndexValue
{
    [self doHttpRequest:@"http://www.9pxdesign.com/indexvar.php" tag:0];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 0)
    {
        NSDictionary * dict = [request.responseString objectFromJSONString];
        NSString * value = dict[@"bianliang"];
        gIndexValue = value.floatValue;
        [self calculateIndex];
    }
}

- (void)calculateIndex
{
    KLineModel * klineModel = self.detailController.trendKLineModelDict[@(1)];
    StockBaseInfoModel * baseInfoModel = self.detailController.stockBaseInfoModel;
    
    float ave30 = [klineModel todayAvePrice:30];
    float ave72 = [klineModel todayAvePrice:72];
    
    float expectation =  (ave30 + ave72) / 2;
    
    float currentPrice = baseInfoModel.currentPrice.floatValue;
    
    float tempRatio = (currentPrice - expectation) / expectation;
    
    if (tempRatio > 0.1)
    {
        tempRatio = 0.1;
    }
    else if(tempRatio < - 0.1)
    {
        tempRatio = - 0.1;
    }
    
    //数字越大 上涨几率越小
    tempRatio = -tempRatio;
    
    int score = 50 * (1 + tempRatio) * gIndexValue;
    
    self.probabilityLabel.text = [NSString stringWithFormat:@"%d%%",score];
}

- (IBAction)onFinishClick:(UIButton *)sender
{
    [[ContainerController instance] dismissControllerFromButtom];
}


- (void)viewDidUnload {
    [self setNameLabel:nil];
    [self setTimeLabel:nil];
    [self setProbabilityLabel:nil];
    [super viewDidUnload];
}
@end
