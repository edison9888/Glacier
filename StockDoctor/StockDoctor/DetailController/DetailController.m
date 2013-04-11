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

@interface DetailController ()
@property (strong, nonatomic) IBOutlet TrendGraphView * trendGraphView;
@property (strong, nonatomic) IBOutlet StockInfoView *stockInfoView;
@property (strong, nonatomic) TrendModel * trendModel;
@property (strong, nonatomic) StockBaseInfoModel * stockBaseInfoModel;

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
    [self requestForStock];
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
    [self doHttpRequest:requestStr];
}


- (void)requestFinished:(ASIHTTPRequest *)request
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



@end
