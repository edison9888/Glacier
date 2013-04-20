//
//  DetailController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-8.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "DetailController.h"
#import "TrendGraphView.h"
#import "StockInfoView.h"
#import "KLineView.h"
#import "DateHelpers.h"
#import "SingleDiagnosisController.h"

@interface DetailController ()
@property (strong, nonatomic) IBOutlet StockInfoView *stockInfoView;
@property (strong, nonatomic) IBOutlet UIView *graphView;
@property (strong, nonatomic) IBOutlet UIButton *addBtN;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *trendKlineViewsList;

@end

@implementation DetailController
{
    int _selectedIndex;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.trendKLineModelDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.searchModel.shortName;
    
    if ([self checkIsInSelfStock])
    {
        [self.addBtN setTitle:@"删除" forState:(UIControlStateNormal)];
    }
    else
    {
        [self.addBtN setTitle:@"添加" forState:(UIControlStateNormal)];
    }
    [self.stockInfoView.diagnosisButton addTarget:self action:@selector(onDiagnosisClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self switchTab:0];
    
    //开始请求k线以便计算
    [self requestForKLine:1];
    [self requestForDiagCount];
}

- (void)onDiagnosisClick:(UIButton *)sender
{
    SingleDiagnosisController * controller = [[SingleDiagnosisController alloc]init];
    controller.detailController = self;
    [[ContainerController instance] presentControllerFromButtom:controller];
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
         NSLog(@"%@",request.responseString);
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
    KLineModel * model = [KLineModel parseData:request.responseString];
    
    NSArray * freqs = @[@"day",@"week",@"month"];
    model.freq = freqs[tag - 1];
    
    [self.trendKLineModelDict setObject:model forKey:@(tag)];
    
    [self refreshGraphView];
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
                TrendModel * model = [TrendModel parseJson:arr[3]];
                [self.trendKLineModelDict setObject:model forKey:@(0)];
            }
        }
    }];
    
    self.stockInfoView.stockBaseInfoModel = self.stockBaseInfoModel;
    [self.stockInfoView reloadData];
    
    [self refreshGraphView];
}

- (void)refreshGraphView
{
    if (_selectedIndex == 0)
    {
        TrendGraphView * view = self.trendKlineViewsList[_selectedIndex];
        view.stockBaseInfoModel = self.stockBaseInfoModel;
        view.trendModel = self.trendKLineModelDict[@(_selectedIndex)];
        [view reloadData];
    }
    else
    {
        KLineView * view = self.trendKlineViewsList[_selectedIndex];
        KLineModel * model = self.trendKLineModelDict[@(_selectedIndex)];
        [view reloadData:model];
    }
}

- (IBAction)onBarSwitch:(UISegmentedControl *)sender
{
    [self switchTab:sender.selectedSegmentIndex];
}

- (bool)checkIsInSelfStock
{
    NSArray * selfModelList = [SearchModel selectAll];
    
    return  [selfModelList any:^BOOL(SearchModel * obj) {
        if ([obj.fullCode isEqualToString:self.searchModel.fullCode])
        {
            return true;
        }
        else
        {
            return false;
        }
    }];
}

- (IBAction)onAddClick:(UIButton *)sender
{
    SearchModel * model = self.searchModel;
    if ([self checkIsInSelfStock])
    {
        
        [model deleteSelf];
        [self.addBtN setTitle:@"添加" forState:(UIControlStateNormal)];
        
    }
    else
    {
        [model insertSelfIntoFirst];
        [self.addBtN setTitle:@"删除" forState:(UIControlStateNormal)];
    }
    
}

- (void)switchTab:(int)index
{
    _selectedIndex = index;
    
    [self.trendKlineViewsList enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        if (obj.tag == index)
        {
            obj.hidden = false;
            obj.frame = self.graphView.bounds;
            [self.graphView addSubview:obj];
        }
        else
        {
            obj.hidden = true;
        }
    }];
    
    if (index == 0)
    {
        [self requestForStock];
    }
    else
    {
        [self requestForKLine:index];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
