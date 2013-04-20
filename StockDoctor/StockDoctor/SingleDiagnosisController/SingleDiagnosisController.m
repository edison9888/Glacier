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
@property (nonatomic,readonly) bool isStock;
@end

static float gIndexValue; //指数上涨常数
static float gStockValue; //股票上涨中指数的比例

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
    
    if ([self isStock])
    {
        if (gStockValue)
        {
            [self calculate];
        }
        else
        {
            [self requestForStockValue];
        }
    }
    else
    {
        if (gIndexValue)
        {
            [self calculate];
        }
        else
        {
            [self requestForIndexValue];
        }
    }
}

- (bool)isStock
{
    SearchModel * model = self.detailController.searchModel;
    NSString * prefix = [model.fullCode substringToIndex:2];
    NSString * code = [model.fullCode substringFromIndex:2];
    int codeValue = code.intValue;
    if ([prefix isEqualToString:@"sh"])
    {
        if ( codeValue <= 999 && codeValue >= 1)
        {
            //上证指数
            return false;
        }
    }
    else if([prefix isEqualToString:@"sz"])
    {
        if ( codeValue <= 399999 && codeValue >= 399001)
        {
            //深证指数
            return false;
        }
    }
    //其余为股票
    return true;
}

- (void)requestForStockValue
{
    [self doHttpRequest:@"http://www.9pxdesign.com/indexgailv.php" tag:1];
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
        [self calculate];
    }
    else if(request.tag == 1)
    {
        NSDictionary * dict = [request.responseString objectFromJSONString];
        NSString * value = dict[@"gailv"];
        gStockValue = value.floatValue;
        [self calculate];
    }
}

- (void)calculate
{
    KLineModel * klineModel = self.detailController.trendKLineModelDict[@(1)];
    StockBaseInfoModel * baseInfoModel = self.detailController.stockBaseInfoModel;
    
    float ave30 = [klineModel todayAvePrice:30];
    float ave72 = [klineModel todayAvePrice:72];
    
    float expectation =  (ave30 + ave72) / 2;
    
    float currentPrice = baseInfoModel.currentPrice.floatValue;
    
    float tempRatio = (currentPrice - expectation) / expectation;
    
    float maxRatio;
    
    if ([self isStock])
    {
        maxRatio = 0.2f;
    }
    else
    {
        maxRatio = 0.1f;
    }
    
    if (tempRatio > maxRatio)
    {
        tempRatio = maxRatio;
    }
    else if(tempRatio < - maxRatio)
    {
        tempRatio = - maxRatio;
    }
    
    tempRatio = -tempRatio;
    
    tempRatio = tempRatio / (maxRatio * 2) * 100 + 50;
    
    int score = 0;
    
    if ([self isStock])
    {
        score = tempRatio * 0.6 + gStockValue * 0.4;
    }
    else
    {
        score = tempRatio * gIndexValue;
    }
    
    //score不能为极值
    if (score == 0)
    {
        score = 1;
    }
    else if(score == 100)
    {
        score = 99;
    }
    
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
