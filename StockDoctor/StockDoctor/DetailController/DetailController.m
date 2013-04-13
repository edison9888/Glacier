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
    NSArray * freqs = @[@"d",@"w",@"m"];
    
    NSString * freq = freqs[index - 1];
    
    NSDate * date = [NSDate date];
        
    NSString * url = @"http://ichart.yahoo.com/table.csv?s=%@.%@&g=%@&f=2013&d=4&e=10&c=2013&a=3&b=1&ignore=.csv&n=2";

    NSString * type = nil;
    if ([self.searchModel.fullCode hasPrefix:@"sh"])
    {
        type = @"ss";
    }
    else if ([self.searchModel.fullCode hasPrefix:@"sz"])
    {
        type = @"sz";
    }
    
    NSString * requestStr = [NSString stringWithFormat:url,self.searchModel.shortCode,type,freq];
    [self doHttpRequest:requestStr tag:1];
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
    else if (request.tag == 1)
    {
        [self processKLineData:request];
    }
}

- (void)processKLineData:(ASIHTTPRequest *)request
{
    self.kLineModel = [KLineModel parseData:request.responseString];
    NSLog(@"%@",request.responseString);
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
