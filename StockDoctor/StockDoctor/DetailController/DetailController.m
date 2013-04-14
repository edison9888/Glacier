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
}

- (void)requestForKLine:(int)index
{
    NSArray * freqs = @[@"day",@"week",@"month"];
    
    NSString * freq = freqs[index - 1];
    
    int lineCount = 100;
    
    NSString * url = @"http://ifzq.gtimg.cn/stock/kline/kline/kline?param=%@,%@,,,%d";
    
    //月和日不正确时，会请求到所有的数据，速度很慢，暂时写死1月1日
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
    NSLog(@"request failed tag:%d",request.tag);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 0)
    {
        [self processTrendData:request];
    }
    else
    {
        [self processKLineData:request];
    }
}

- (void)processKLineData:(ASIHTTPRequest *)request
{
    self.kLineModel = [KLineModel parseData:request.responseString];
    NSLog(@"%@",request.responseString);
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