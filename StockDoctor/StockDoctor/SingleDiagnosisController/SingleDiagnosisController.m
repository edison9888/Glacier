//
//  SingleDiagnosisController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-20.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "SingleDiagnosisController.h"
#import "UIView+CurrentScreen.h"
#import <QuartzCore/QuartzCore.h>
#import "YLProgressBar.h"

@interface SingleDiagnosisController ()
@property (strong, nonatomic) IBOutlet UILabel *tipTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *tipFirstLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *probabilityLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) NSTimer * progressTimer;
@property (strong, nonatomic) IBOutlet UIView *activityBgView;
@property (strong, nonatomic) IBOutlet UILabel *activityLabel;
@property (nonatomic, copy) NSString * probabilityText;
@property (nonatomic, assign) int probability;
@property (strong, nonatomic) IBOutlet UIImageView *weiboSuccessView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) NSArray * tipsContentList;
@property (strong, nonatomic) NSArray * tipsProbList;
@end

@implementation SingleDiagnosisController
{
    float _timerCount;
}

- (void)dealloc
{
    self.detailController = nil;
}

//1～20分     风险过高，退出为宜
//21～40分   谨慎持股，适度减仓
//41～60分   持股观望，关注动能
//61～80分   风险不高，持股待涨
//81～99分   风险释放，买入为佳

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tipsProbList = @[@(20),
                              @(40),
                              @(60),
                              @(80),
                              @(100)];
        
        self.tipsContentList = @[@"风险过高，退出为宜",
                                 @"谨慎持股，适度减仓",
                                 @"持股观望，关注动能",
                                 @"风险不高，持股待涨",
                                 @"风险释放，买入为佳",
                                 ];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.activityBgView.layer.cornerRadius = 10;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",self.detailController.searchModel.shortName,self.detailController.searchModel.shortCode];
    
   
    
    [self doDiagnosis];
    
}

- (void)doDiagnosis
{
    KLineModel * klineModel = self.detailController.trendKLineModelDict[@(1)];
    StockBaseInfoModel * baseInfoModel = self.detailController.stockBaseInfoModel;
    if (!klineModel  || !baseInfoModel || klineModel.cellDataList.count < 72)
    {
        [self showProgressView:true content:@"数据不完整，诊断失败，请稍后再试"];
    }
    else
    {
        self.view.userInteractionEnabled = false;
        self.probabilityText = nil;
        self.probabilityLabel.text = @"--";
        self.progressView.progress = 0;
        [self showProgressView:false content:@"开始分析"];
        self.progressView.hidden = false;
        self.probabilityLabel.hidden = true;
        self.tipFirstLabel.hidden = true;
        self.tipTextLabel.hidden = true;
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(onTimer:) userInfo:nil repeats:true];
        if ([self.detailController.searchModel isStock])
        {
            [self requestForStockValue];
            
        }
        else
        {
            [self requestForIndexValue];
        }
    }
}

- (void) onTimer:(NSTimer *)timer
{
    _timerCount +=  0.5f;
    self.progressView.progress = _timerCount / 100.0f;
    if (_timerCount == 20)
    {
        [self showProgressView:false content:@"正在分析大盘走势"];
    }
    else if (_timerCount == 50)
    {
        [self showProgressView:false content:@"正在分析板块联动"];
    }
    else if (_timerCount == 99)
    {
        if (!self.probabilityText)
        {
            [self showProgressView:false content:@"正在等待处理"];
            _timerCount -= 0.5f;
        }
    }
    else if (_timerCount >= 100)
    {
        [self showProgressView:true content:@"分析完成"];
        self.view.userInteractionEnabled = true;
        _timerCount = 0;
        self.probabilityLabel.hidden = false;
        self.progressView.hidden = true;
        [self hideProgressView];
        [self.progressTimer invalidate];
        self.progressTimer = nil;
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        
        self.timeLabel.text = [formatter stringFromDate:[NSDate date]];
        self.probabilityLabel.text = self.probabilityText;
        self.tipFirstLabel.hidden = false;
        self.tipTextLabel.hidden = false;
        
        [self.tipsProbList enumerateObjectsUsingBlock:^(NSNumber * prob, NSUInteger idx, BOOL *stop) {
            NSString * text = self.tipsContentList[idx];
            if (self.probability <= prob.intValue)
            {
                self.tipTextLabel.text = text;
                * stop = true;
            }
        }];
    }
}

- (void)requestForStockValue
{
    [self doHttpRequest:@"http://www.9pxdesign.com/indexgailv.php" tag:1];
}

- (void)requestForIndexValue
{
    [self doHttpRequest:@"http://www.9pxdesign.com/indexvar.php" tag:0];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.tag == 0 || request.tag == 1)
    {
        [self showProgressView:true content:@"网络处理失败"];
     
        self.view.userInteractionEnabled = true;
        _timerCount = 0;
        self.probabilityLabel.hidden = false;
        self.progressView.hidden = true;
        [self hideProgressView];
        [self.progressTimer invalidate];
        self.progressTimer = nil;
        self.timeLabel.text = @"--";
        self.probabilityLabel.text = @"--";
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 0)
    {
        NSDictionary * dict = [request.responseString objectFromJSONString];
        NSString * value = dict[@"bianliang"];
        [self calculate:value.floatValue];
    }
    else if(request.tag == 1)
    {
        NSDictionary * dict = [request.responseString objectFromJSONString];
        NSString * value = dict[@"gailv"];
        [self calculate:value.floatValue];
    }
}

- (void)calculate:(float)stockValue
{
    KLineModel * klineModel = self.detailController.trendKLineModelDict[@(1)];
    StockBaseInfoModel * baseInfoModel = self.detailController.stockBaseInfoModel;
    
    float ave30 = [klineModel todayAvePrice:30];
    float ave72 = [klineModel todayAvePrice:72];
    
    float expectation =  (ave30 + ave72) / 2;
    
    float currentPrice = baseInfoModel.currentPrice.floatValue;
    
    float tempRatio = (currentPrice - expectation) / expectation;
    
    float maxRatio;
    
    if ([self.detailController.searchModel isStock])
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
    
    if ([self.detailController.searchModel isStock])
    {
        score = tempRatio * 0.6 + stockValue * 0.4;
    }
    else
    {
        score = tempRatio * stockValue;
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
    
    self.probability = score;
    [self writeToServer];
    
    self.probabilityText = [NSString stringWithFormat:@"%d%%",score];
}

- (void)writeToServer
{
    NSString * name = [self.detailController.searchModel.shortName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * code = self.detailController.searchModel.fullCode;
    NSString * indexOrNo = [NSString stringWithFormat:@"%d",![self.detailController.searchModel isStock]];
    NSString * score = [NSString stringWithFormat:@"%d",self.probability];
    
    NSString * huanshou = [NSString stringWithFormat:@"%.2f",self.detailController.stockBaseInfoModel.turnoverRate.floatValue * 100];
    huanshou = [huanshou stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * zhangfu = [self.detailController.stockBaseInfoModel.changeRatio stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * writeToServer = @"http://www.9pxdesign.com/writestock.php?name=%@&code=%@&indexYesOrNo=%@&gailv=%@&huanshou=%@&zhangfu=%@";
    writeToServer = [NSString stringWithFormat:writeToServer,name,code,indexOrNo,score,huanshou,zhangfu];
    [self doHttpRequest:writeToServer tag:100];
}

- (IBAction)onShareToWeiboClick:(UIButton *)sender
{
    [[MTStatusBarOverlay sharedInstance] postMessage:@"正在分享微博..."];
    [self postWeibo:true];
}

- (void)postWeibo:(bool)needLogin
{
    self.activityBgView.hidden = true;
    self.shareButton.highlighted = false;
    
    NSString * text = @"我通过#股票医生#诊断了%@，上涨概率为%@，你也赶快诊断下你的股票吧。http://itunes.apple.com/cn/app/id517609453（分享自@股票医生手机版)";
    
    text = [NSString stringWithFormat:text,self.detailController.searchModel.shortName,self.probabilityText];
    [SinaWeiboManager instance].delegate = self;
    if (!needLogin || [[SinaWeiboManager instance] isAuth])
    {
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [[SinaWeiboManager instance] postImageWeibo:text image:window.currentImage receiver:self];
    }
    else
    {
        [[SinaWeiboManager instance] doLogin];
    }
}

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self postWeibo:false];
}

- (IBAction)onDiagnosis:(UIButton *)sender
{
    [self doDiagnosis];
}

- (void)showProgressView:(bool)isWeibo content:(NSString *)text 
{
    self.activityBgView.hidden = false;
    self.activityView.hidden = isWeibo;
    self.activityLabel.text = text;
    self.weiboSuccessView.hidden = !isWeibo;
    if (isWeibo)
    {
        [self hideProgressView];
    }
}

- (void)hideProgressView
{
    double delayInSeconds = 1.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.activityBgView.hidden = true;
    });
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSDictionary * dict = result;
    if (dict[@"error_code"])
    {
        [self showProgressView:true content:@"微博分享失败，请稍后重试"];
    }
    else
    {
        [[MTStatusBarOverlay sharedInstance]postFinishMessage:@"分享完成" duration:1];
        double delayInSeconds = 0.2f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self showProgressView:true content:@"微博分享成功"];
        });
    }
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (IBAction)onFinishClick:(UIButton *)sender
{
    [[ContainerController instance] dismissControllerFromButtom];
}


- (void)viewDidUnload {
    [self setNameLabel:nil];
    [self setTimeLabel:nil];
    [self setProbabilityLabel:nil];
    [self setProgressView:nil];
    [self setActivityBgView:nil];
    [self setActivityLabel:nil];
    [self setWeiboSuccessView:nil];
    [self setActivityView:nil];
    [self setShareButton:nil];
    [self setTipFirstLabel:nil];
    [self setTipTextLabel:nil];
    [super viewDidUnload];
}
@end
