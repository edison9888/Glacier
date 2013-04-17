//
//  DetailController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-8.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "DetailController.h"
#import "TrendModel.h"
#import "TrendGraphView.h"
#import "StockInfoView.h"
#import "KLineView.h"
#import "KLineModel.h"
#import "DateHelpers.h"

@interface DetailController ()
@property (strong, nonatomic) IBOutlet TrendGraphView * trendGraphView;
@property (strong, nonatomic) IBOutlet StockInfoView *stockInfoView;
@property (strong, nonatomic) TrendModel * trendModel;
@property (strong, nonatomic) KLineModel * kLineModel;
@property (strong, nonatomic) StockBaseInfoModel * stockBaseInfoModel;
@property (strong, nonatomic) IBOutlet UIView *graphView;
@property (strong, nonatomic) IBOutlet KLineView *kLineView;
@end

@implementation DetailController

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
    self.title = self.searchModel.shortName;
    [self switchTab:0];
    [self requestForStock];
    [self requestForDiagCount];
}

- (void)requestForDiagCount
{
    NSString * url = @"http://www.9pxdesign.com/cishu.php?code=%@.%@";
    
    NSString * prefix = [self.searchModel.fullCode substringToIndex:2];
    
    url = [NSString stringWithFormat:url,self.searchModel.shortCode,prefix];
    
    [self doHttpRequest:url tag:10];
}

- (void)requestForKLine:(int)index
{
    NSArray * freqs = @[@"day",@"week",@"month"];
    
    NSString * freq = freqs[index - 1];
    
    int lineCount = 100;
    
    NSString * url = @"http://ifzq.gtimg.cn/stock/kline/kline/kline?param=%@,%@,,,%d";

    NSString * requestStr = [NSString stringWithFormat:url,self.searchModel.fullCode,freq,lineCount];
    
    [self doHttpRequest:requestStr tag:index];
}

- (void)requestForStock
{
    NSString * url = @"http://flashquote.stock.hexun.com/Stock_Combo.ASPX?mc=%@_%@&dt=q,MI";
    NSString * type = nil;
    if ([self.searchModel.fullCode hasPrefix:@"sh"])
    {
        type = @"1";
    }
    else if ([self.searchModel.fullCode hasPrefix:@"sz"])
    {
        type = @"2";
    }
    
    NSString * requestStr = [NSString stringWithFormat:url,type,self.searchModel.shortCode];
    [self doHttpRequest:requestStr tag:0];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
//    NSLog(@"request failed tag:%d",request.tag);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 0)
    {
        [self processTrendData:request];
    }
    else if(request.tag == 10)
    {
        [self processDiagCount:request];
    }
    else
    {
        [self processKLineData:request tag:request.tag];
    }
}

- (void)processDiagCount:(ASIHTTPRequest *)request
{
    NSDictionary * dict = [request.responseString objectFromJSONString];

    NSString * count = dict[@"cishu"];
    NSString * diagStr = [NSString stringWithFormat:@"现在已有%@人诊断",count ? count :@"0"];
    
    self.stockInfoView.diagnosisCountLabel.text = diagStr;
}

- (void)processKLineData:(ASIHTTPRequest *)request tag:(int)tag
{
    self.kLineModel = [KLineModel parseData:request.responseString];
    
    NSArray * freqs = @[@"day",@"week",@"month"];
    
    self.kLineModel.freq = freqs[tag - 1];
    [self.kLineView reloadData:self.kLineModel];
}

- (void)processTrendData:(ASIHTTPRequest *)request
{
    NSArray * respArr = [request.responseString componentsSeparatedByString:@";"];
    
    [respArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        if (idx < 2)
        {
            NSString * json = [obj stringByReplacingOccurrencesOfString:@"refreshData(" withString:@"["];
            json = [json stringByReplacingOccurrencesOfString:@")" withString:@"]"];
            json = [json stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
            NSArray * arr = [json objectFromJSONString];
            
            if(idx == 0)
            {
                self.stockBaseInfoModel = [StockBaseInfoModel parseJson:arr[3]];
            }
            else if (idx == 1)
            {
                self.trendModel = [TrendModel parseJson:arr[3]];
            }
        }
    }];
    
    self.trendGraphView.stockBaseInfoModel = self.stockBaseInfoModel;
    self.trendGraphView.trendModel = self.trendModel;
    self.stockInfoView.stockBaseInfoModel = self.stockBaseInfoModel;
    
    [self.trendGraphView reloadData];
    [self.stockInfoView reloadData];
}

- (IBAction)onBarSwitch:(UISegmentedControl *)sender
{
    [self switchTab:sender.selectedSegmentIndex];
}

- (void)switchTab:(int)index
{
    if (index == 0)
    {
        self.trendGraphView.frame = self.graphView.bounds;
        [self.graphView addSubview:self.trendGraphView];
        [self.kLineView removeFromSuperview];
    }
    else
    {
        self.kLineView.frame = self.graphView.bounds;
        [self.graphView addSubview:self.kLineView];
        [self.trendGraphView removeFromSuperview];
        [self requestForKLine:index];
    }
}
@end
