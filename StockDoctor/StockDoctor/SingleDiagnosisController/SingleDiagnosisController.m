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

@interface SingleDiagnosisController ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *probabilityLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) NSTimer * progressTimer;
@property (strong, nonatomic) IBOutlet UIView *activityBgView;
@property (strong, nonatomic) IBOutlet UILabel *activityLabel;
@property (nonatomic, copy) NSString * probabilityText;

@end

static float gIndexValue; //指数上涨常数
static float gStockValue; //股票上涨中指数的比例

@implementation SingleDiagnosisController
{
    int _timerCount;
}

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
    self.view.userInteractionEnabled = false;
    self.probabilityLabel.text = @"--";
    self.progressView.progress = 0;
    self.activityBgView.hidden = false;
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTimer:) userInfo:nil repeats:true];
}


- (void) onTimer:(NSTimer *)timer
{
    _timerCount++;
    self.progressView.progress = _timerCount / 5.0f;
    if (_timerCount == 1)
    {
        self.activityLabel.text = @"正在分析大盘走势";
    }
    else if (_timerCount == 3)
    {
        self.activityLabel.text = @"正在分析板块联动";
    }
    
    if (_timerCount == 5)
    {
        self.view.userInteractionEnabled = true;
        _timerCount = 0;
        self.activityBgView.hidden = true;
        [self.progressTimer invalidate];
        self.progressTimer = nil;

        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
        
        self.timeLabel.text = [formatter stringFromDate:[NSDate date]];
        
        if ([self.detailController.searchModel isStock])
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
    
    self.probabilityText = [NSString stringWithFormat:@"%d%%",score];
    self.probabilityLabel.text = self.probabilityText;
}

- (IBAction)onShareToWeiboClick:(UIButton *)sender
{
    NSString * text = @"我通过#股票医生#诊断了%@，上涨概率为%@，你也赶快诊断下你的股票吧。http://itunes.apple.com/cn/app/id517609453（分享自@股票医生手机版";
    
    text = [NSString stringWithFormat:text,self.detailController.searchModel.shortName,self.probabilityText];
    
    
    if ([[SinaWeiboManager instance] isAuth])
    {
        [[SinaWeiboManager instance] postImageWeibo:text image:self.view.currentImage receiver:self];
    }
    else
    {
        [[SinaWeiboManager instance] doLogin];
    }
}

- (IBAction)onDiagnosis:(UIButton *)sender
{
    [self doDiagnosis];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    [[MTStatusBarOverlay sharedInstance] postFinishMessage:@"转发微博成功!" duration:2];
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
    [super viewDidUnload];
}
@end
