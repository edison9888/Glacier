//
//  DetailController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-8.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "DetailController.h"
#import "TrendView.h"
#import "StockInfoView.h"
#import "KLineView.h"
#import "DateHelpers.h"
#import "SingleDiagnosisController.h"
#import "STSegmentedControl.h"
#define refresh_time 10.0f

@interface DetailController ()
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightBar;
@property (strong, nonatomic) IBOutlet StockInfoView *stockInfoView;
@property (strong, nonatomic) IBOutlet UIView *graphView;
@property (strong, nonatomic) IBOutlet STSegmentedControl *stTabView;
@property (strong, nonatomic) IBOutlet UIButton *addBtN;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *trendKlineViewsList;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) NSTimer * timer;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollBgView;
@property (strong, nonatomic) IBOutlet UIView *lineGraphicsBgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
@property (strong, nonatomic) IBOutlet UIButton *refreshButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *refreshActivityView;
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
    self.navigationItem.rightBarButtonItem = self.rightBar;
    self.navigationItem.titleView = self.titleView;
    self.titleLabel.text = self.searchModel.shortName;
    self.codeLabel.text = self.searchModel.shortCode;
    
    if ([self checkIsInSelfStock])
    {
        [self.addBtN setBackgroundImage:[UIImage imageNamed:@"detail_added.png"] forState:(UIControlStateNormal)];
        
    }
    else
    {
        [self.addBtN setBackgroundImage:[UIImage imageNamed:@"detail_add.png"] forState:(UIControlStateNormal)];
    }
    
    [self.stockInfoView.diagnosisButton addTarget:self action:@selector(onDiagnosisClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.scrollBgView fixContentHeight:CGRectGetMaxY(self.lineGraphicsBgView.frame)];
    
    [self initTab];
    
    [self requestForDiagCount];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(onTimer:) userInfo:nil repeats:true];
}

- (void)initTab
{
    self.stTabView.segments = [NSMutableArray arrayWithArray:@[@"分时",@"日K",@"周K",@"月K"]];
    [self.stTabView addTarget:self action:@selector(onSwitchTab:) forControlEvents:UIControlEventValueChanged];
    [self.stTabView setNormalImageLeft:[UIImage imageNamed:@"sTab1.png"]];
    [self.stTabView setSelectedImageLeft:[UIImage imageNamed:@"sTab2.png"]];
    [self.stTabView setNormalImageMiddle:[UIImage imageNamed:@"sTab1.png"]];
    [self.stTabView setSelectedImageMiddle:[UIImage imageNamed:@"sTab2.png"]];
    [self.stTabView setNormalImageRight:[UIImage imageNamed:@"sTab1.png"]];
    [self.stTabView setSelectedImageRight:[UIImage imageNamed:@"sTab2.png"]];
    self.stTabView.selectedSegmentIndex = 0;
}

- (void)onTimer:(NSTimer *)sender
{
    [self requestForStock];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)onDiagnosisClick:(UIButton *)sender
{
    SingleDiagnosisController * controller = [[SingleDiagnosisController alloc]init];
    controller.detailController = self;
    [[ContainerController instance] presentControllerFromButtom:controller];
}

//请求诊断人数
- (void)requestForDiagCount
{
    NSString * url = @"http://www.9pxdesign.com/cishu.php?code=%@";
    
    url = [NSString stringWithFormat:url,self.searchModel.fullCode];
    
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

- (void)requestForTrendAndInfo
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
//        NSLog(@"responseString:\n%@",request.responseString);
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
    if (model)
    {
        NSArray * freqs = @[@"day",@"week",@"month"];
        model.freq = freqs[tag - 1];
        
        [self.trendKLineModelDict setObject:model forKey:@(tag)];
        
        //每次收到K线请求后请求分时数据 以便计算最后的K线数据
        [self requestForTrendAndInfo];
        [self refreshGraphView];
    }
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
    
    for (int i = 1; i< 4; i++)
    {
        KLineModel * klineModel = self.trendKLineModelDict[@(i)];
        TrendModel * trendModel = self.trendKLineModelDict[@(0)];
        [self fixKlineData:trendModel klineModel:klineModel index:i];
    }
    
    [self reloadTime];
    [self refreshGraphView];
    
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(onTimer:) userInfo:nil repeats:true];
}

- (void)reloadTime
{
    self.refreshButton.hidden = false;
    [self.refreshActivityView stopAnimating];
    
    [[MTStatusBarOverlay sharedInstance] postFinishMessage:@"数据已经更新" duration:2];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSString * timeStr = [NSString stringWithFormat:@"最后更新于: %@",[formatter stringFromDate:[NSDate date]]];
    self.timerLabel.alpha = 1;
    [UIView beginAnimations:@"Label show" context:nil];
    [UIView setAnimationDuration:0.75f];
    self.timerLabel.alpha = 0.25;
    self.timerLabel.text = timeStr;
    self.timerLabel.alpha = 1;
    [UIView commitAnimations];
    
}

//通过分时修正k线数据
- (void)fixKlineData:(TrendModel *)trendModel klineModel:(KLineModel *)klineModel index:(int)index
{
    if (trendModel
        && trendModel.trendCellDataList.count > 0
        && klineModel
        && klineModel.cellDataList.count > 0
        )
    {
        NSString * trendDate = [self.stockBaseInfoModel.tradeDate substringToIndex:8];
        
        TrendCellData * trendCell = trendModel.trendCellDataList.lastObject;
        KLineCellData * klineCell = klineModel.cellDataList[0];
        
        NSString * klineDate = [klineCell.date stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        if (![trendDate isEqualToString:klineDate] && index == 1)
        {
            KLineCellData * todayKlineCell = [[KLineCellData alloc]init];
        
            NSDateFormatter * format = [[NSDateFormatter alloc]init];
            format.dateFormat = @"yyyyMMdd";
            NSDate * date = [format dateFromString:trendDate];
            
            NSDateFormatter * toFormat = [[NSDateFormatter alloc]init];
            toFormat.dateFormat = @"yyyy-MM-dd";
            
            todayKlineCell.date = [toFormat stringFromDate:date];
            
            float newPrice = trendCell.price.floatValue;
            todayKlineCell.open = self.stockBaseInfoModel.openPrice;
            todayKlineCell.close = trendCell.price;
            if (newPrice > todayKlineCell.high.floatValue)
            {
                todayKlineCell.high = trendCell.price;
            }
            
            if (newPrice < klineCell.low.floatValue)
            {
                todayKlineCell.low = trendCell.price;
            }
            [klineModel.cellDataList insertObject:todayKlineCell atIndex:0];
        }
        else
        {
            float newPrice = trendCell.price.floatValue;
            klineCell.close = trendCell.price;
            if (newPrice > klineCell.high.floatValue)
            {
                klineCell.high = trendCell.price;
            }
            
            if (newPrice < klineCell.low.floatValue)
            {
                klineCell.low = trendCell.price;
            }
        }
    }
}

- (void)refreshGraphView
{
    if (_selectedIndex == 0)
    {
        TrendView * view = self.trendKlineViewsList[_selectedIndex];
        view.stockBaseInfoModel = self.stockBaseInfoModel;
        TrendModel * model = self.trendKLineModelDict[@(_selectedIndex)];
        [view reloadData:model];
    }
    else
    {
        KLineView * view = self.trendKlineViewsList[_selectedIndex];
        KLineModel * model = self.trendKLineModelDict[@(_selectedIndex)];
        [view reloadData:model];
    }
}

- (void)onSwitchTab:(STSegmentedControl *)sender
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

- (IBAction)onRefreshClick:(UIButton *)sender
{
    [self requestForStock];
}

- (IBAction)onAddClick:(UIButton *)sender
{
    SearchModel * model = self.searchModel;
    if ([self checkIsInSelfStock])
    {
        [model deleteSelfStock];
        [self.addBtN setBackgroundImage:[UIImage imageNamed:@"detail_add.png"] forState:(UIControlStateNormal)];
    }
    else
    {
        [model addSelfStock];
        [self.addBtN setBackgroundImage:[UIImage imageNamed:@"detail_added.png"] forState:(UIControlStateNormal)];
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
    
    [self requestForStock];
}


//请求k线
- (void)requestForStock
{
    self.refreshButton.hidden = true;
    [self.refreshActivityView startAnimating];
    
    if (_selectedIndex == 0)
    {
        [self requestForKLine:1];
    }
    else
    {
        [self requestForKLine:_selectedIndex];
    }

}

- (void)viewDidUnload {
    [self setRightBar:nil];
    [self setStTabView:nil];
    [self setTimerLabel:nil];
    [self setScrollBgView:nil];
    [self setLineGraphicsBgView:nil];
    [self setTitleView:nil];
    [self setTitleLabel:nil];
    [self setCodeLabel:nil];
    [self setRefreshButton:nil];
    [self setRefreshActivityView:nil];
    [super viewDidUnload];
}
@end
