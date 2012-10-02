//
//  MainPageController.m
//  GlacierApplication
//
//  Created by chang liang on 12-9-12.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "MainPageController.h"
#import "PLI_PDT_M.h"
#import "PK_CLASS.h"
#import "PLI_PDTRATE.h"
#import "PLI_PDTYEAR.h"
#import "UIView+SKLCurrentImage.h"
#import "ResultModel.h"
#import "CALCSETTING.h"
#import "PLI_PDTAMTRANGE.h"
#import "PLI_PDTRATEDIFF.h"

@interface MainPageController ()
- (void)displayMailComposerSheet;
- (void)showAlertMsg:(NSString *)msg;

@property (retain, nonatomic) IBOutlet UILabel *jobTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *versionNOLabel;
@property (retain, nonatomic) IBOutlet UIButton *birthdayButton;
@property (retain, nonatomic) IBOutlet UILabel *sexLabel;
@property (retain, nonatomic) IBOutlet UILabel *codeLabel;
@property (retain, nonatomic) IBOutlet UILabel *tipLabel;
@property (retain, nonatomic) IBOutlet UITableView *tableListView;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *pdKindButtonArr;
@property (retain, nonatomic) IBOutlet UILabel *yearsOldLabel;
@property (retain, nonatomic) IBOutlet UILabel *insuranceNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *pdtYearButton;
@property (retain, nonatomic) IBOutlet UIButton *maleButton;
@property (retain, nonatomic) IBOutlet UIButton *femaleButton;
@property (retain, nonatomic) IBOutlet UITextField *amountTextField;
@property (retain, nonatomic) IBOutlet UILabel *yearAmountLabel;
@property (retain, nonatomic) IBOutlet UILabel *halfYearAmountLabel;
@property (retain, nonatomic) IBOutlet UILabel *quarterAmountLabel;
@property (retain, nonatomic) IBOutlet UILabel *monthAmountLabel;
@property (retain, nonatomic) IBOutlet UILabel *onePayAmountLabel;
@property (retain, nonatomic) IBOutlet UIButton *jobTypeButton;
@property (strong, nonatomic) IBOutlet UIButton *UnitButton;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UILabel *resultTipLabel1;
@property (strong, nonatomic) IBOutlet UILabel *resultTipLabel2;

@property (nonatomic, readonly) NSDateFormatter *twDateFormatter;
@property (nonatomic,retain) NSArray * plipdtm_list;
@property (nonatomic,retain) NSArray * pkclass_list;
@property (nonatomic,retain) NSArray * plipdtrate_list;
@property (nonatomic,retain) NSArray * plipdtyear_list; //当前年期的列表
@property (nonatomic,readonly) PLI_PDTYEAR * currentPLI_PDTYEAR ;
@property (nonatomic,retain) UIAlertView * alertView;

@property (nonatomic,retain) PopDateController * popDateController;
@property (retain, nonatomic) UIPopoverController * popOverController;
@property (nonatomic,retain) PopComboController * popComboController;
@property (nonatomic,retain) NSDate * maxAgeDate;
@property (nonatomic,retain) NSDate * minAgeDate;
@property (nonatomic,retain) ComboModel * comboModel;
@property (nonatomic,retain) NSDate * currentSelectedBirthday;

@property (nonatomic,retain) NSArray * currentPkClass_list;
@property (nonatomic,retain) PLI_PDT_M * currentPli_pdt_m;
@property (nonatomic,retain) CALCSETTING * currentCALCSETTING;
@property (nonatomic,retain) PLI_PDTAMTRANGE * currentPLI_PDTAMTRANGE;
@end

@implementation MainPageController
{
    bool mCurrentSex; //1为男性 0为女性
    int mCurrentJobType;
    int mCurrentAge;
    int mCurrentPdtYearIndex;
    int mCurrentPdKind;
    int mCurrentCalcMode;//当前计算模式
    float mTypeThreeMinAmount;
    float mTypeThreeMaxAmount;
}
@synthesize jobTypeLabel;
@synthesize versionNOLabel;
@synthesize birthdayButton;
@synthesize sexLabel;
@synthesize codeLabel;
@synthesize tipLabel;
@synthesize tableListView;
@synthesize pdKindButtonArr;
@synthesize yearsOldLabel;
@synthesize insuranceNameLabel;
@synthesize pdtYearButton;
@synthesize maleButton;
@synthesize femaleButton;
@synthesize amountTextField;
@synthesize yearAmountLabel;
@synthesize halfYearAmountLabel;
@synthesize quarterAmountLabel;
@synthesize monthAmountLabel;
@synthesize onePayAmountLabel;
@synthesize jobTypeButton;
@synthesize UnitButton;
@synthesize userNameTextField;
@synthesize resultTipLabel1;
@synthesize resultTipLabel2;

@synthesize twDateFormatter = _twDateFormatter;
@synthesize  plipdtm_list;
@synthesize  pkclass_list;
@synthesize  plipdtrate_list;
@synthesize  plipdtyear_list; //当前年期的列表
@synthesize  currentPLI_PDTYEAR ;
@synthesize  alertView;

@synthesize  popDateController;
@synthesize  popOverController;
@synthesize  popComboController;
@synthesize  maxAgeDate;
@synthesize  minAgeDate;
@synthesize  comboModel;
@synthesize  currentSelectedBirthday;

@synthesize  currentPkClass_list;
@synthesize  currentPli_pdt_m;
@synthesize  currentCALCSETTING;
@synthesize  currentPLI_PDTAMTRANGE;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _twDateFormatter = [[NSDateFormatter alloc] init];
        NSCalendar *wRepublicOfChinaCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSRepublicOfChinaCalendar];
        _twDateFormatter.calendar = wRepublicOfChinaCalendar;
//        [wRepublicOfChinaCalendar release];
        
        NSLocale *wLocale  = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
        _twDateFormatter.locale = wLocale;
//        [wLocale release];
        
        _twDateFormatter.dateFormat = @"G yyy年MM月dd日";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mCurrentJobType = 1;
    self.plipdtm_list = [PLI_PDT_M findByCriteria:@"group by PD_PDTCODE"];
    self.pkclass_list = [PK_CLASS findByCriteria:@"order by pk"];
    [self adjustCurrentPkClassList];
}

- (PLI_PDTYEAR *)currentPLI_PDTYEAR
{
    if (self.plipdtyear_list.count > 0)
    {
        return [self.plipdtyear_list objectAtIndex:mCurrentPdtYearIndex];
    }
    else
    {
        return nil;
    }
}


#pragma marks tableview 相关函数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.currentPkClass_list.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ProductSectionView * wView = [[[NSBundle mainBundle]loadNibNamed:@"ProductSectionView" owner:nil options:nil] objectAtIndex:0];
    wView.tag = section;
    wView.delegate = self;
    wView.nameLabel.text = ((PK_CLASS *) [self.currentPkClass_list objectAtIndex:section]).PK_CLASS_NAME;
    return wView;
}

- (NSArray *) getCurrentPKClassArray:(NSInteger) section
{
    PK_CLASS * wClass = [self.currentPkClass_list objectAtIndex:section];
    
    NSString * predicateStr;
    
    if (mCurrentPdKind != 0)
    {
        predicateStr = [NSString stringWithFormat:@"SELF.PK_CLASS == %@ and self.PD_KIND == %d",wClass.PK_CLASS_CODE, mCurrentPdKind];
    }
    else
    {
        predicateStr = [NSString stringWithFormat:@"SELF.PK_CLASS == %@",wClass.PK_CLASS_CODE];
    }
    
    
    return [self.plipdtm_list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateStr]];
}

- (void)onSectionClcikDelegate:(NSInteger)section
{
    PK_CLASS * wClass = [self.currentPkClass_list objectAtIndex:section];
    wClass.isFolded = !wClass.isFolded;
    [self.tableListView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( ((PK_CLASS *)[self.currentPkClass_list objectAtIndex:section]).isFolded)
    {
        return 0;
    }
    else
    {
        return [self getCurrentPKClassArray:section].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"PliCell";
    ProductCell * wCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!wCell) {
        wCell = [[[NSBundle mainBundle]loadNibNamed:@"ProductCell" owner:nil options:nil] objectAtIndex:0];
    }

    wCell.nameLabel.text = ((PLI_PDT_M *)[[self getCurrentPKClassArray:indexPath.section] objectAtIndex:indexPath.row]).PD_PDTNAME;
    return wCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PK_CLASS * wClass = [self.currentPkClass_list objectAtIndex:indexPath.section];
    self.currentPli_pdt_m = ((PLI_PDT_M *)[[self.plipdtm_list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.PK_CLASS == %d",wClass.PK_CLASS_CODE.intValue]] objectAtIndex:indexPath.row]);
    self.currentCALCSETTING = [CALCSETTING findFirstByCriteria:@"where PD_PDTCODE = '%@'",self.currentPli_pdt_m.PD_PDTCODE];
    [self initComponentAfterSelected];
}

#pragma mark 处理函数

-(void) initComponentAfterSelected
{
    self.currentSelectedBirthday = nil;
    self.versionNOLabel.text = [NSString stringWithFormat:@"版数：%.0f",self.currentPli_pdt_m.PD_VERSIONNO];
    [self.UnitButton setTitle:self.currentPli_pdt_m.PD_UNIT forState:UIControlStateNormal];
    self.plipdtyear_list = [PLI_PDTYEAR findByCriteria:@"where PD_PDTCODE = '%@' group by PY_PDTYEAR",self.currentPli_pdt_m.PD_PDTCODE]; //等到修改
    mCurrentPdtYearIndex = 0;
    [self.birthdayButton setTitle:@"--" forState:UIControlStateNormal];
    self.insuranceNameLabel.text = self.currentPli_pdt_m.PD_PDTNAME;
    self.codeLabel.text = [@"商品代码：" stringByAppendingString:self.currentPli_pdt_m.PD_PDTCODE];
    

    if (self.currentCALCSETTING.CALCTYPE == 0 || self.currentCALCSETTING.CALCTYPE == 1)
    {
        [self adjustBirthComponent:self.currentPLI_PDTYEAR.PY_MINAGE max:self.currentPLI_PDTYEAR.PY_MAXAGE];
        self.tipLabel.text = [NSString stringWithFormat:@"【投保年龄】：%d-%d嵗       【保额】：无限制",(int)self.currentPLI_PDTYEAR.PY_MINAGE, (int)self.currentPLI_PDTYEAR.PY_MAXAGE];
    }
    else if (self.currentCALCSETTING.CALCTYPE == 3)
    {
        
        float minAge = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MIN(PR_AGE) from PLI_PDTRATE where PR_PDTCODE =  '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
        
        float maxAge = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MAX(PR_AGE) from PLI_PDTRATE where PR_PDTCODE =  '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
        
        [self adjustBirthComponent:minAge max:maxAge];
        
        mTypeThreeMinAmount = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MIN(PR_PDTYEAR) from PLI_PDTRATE where PR_PDTCODE =  '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
        
        mTypeThreeMaxAmount = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MAX(PR_PDTYEAR) from PLI_PDTRATE where PR_PDTCODE =  '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
        
        self.tipLabel.text = [NSString stringWithFormat:@"【投保年龄】：%.0f-%.0f嵗       【保额】：%.0f-%.0f万元",
                              minAge,
                              maxAge,
                              mTypeThreeMinAmount,
                              mTypeThreeMaxAmount];
    }
    
    [self adjustPdtYearText];
}

- (void) adjustBirthComponent:(double)minAge max:(double) maxAge
{
    NSDateComponents* minCom = [[NSDateComponents alloc] init];
    [minCom setYear: - minAge];
    NSDate * wMinDate = [[NSCalendar currentCalendar] dateByAddingComponents:minCom toDate:[NSDate date] options:0];
    self.minAgeDate = wMinDate;
    
    NSDateComponents* maxCom = [[NSDateComponents alloc] init];
    [maxCom setYear:- maxAge];
    NSDate * wMaxDate = [[NSCalendar currentCalendar] dateByAddingComponents:maxCom toDate:[NSDate date] options:0];
    self.maxAgeDate = wMaxDate;
    
    mCurrentAge = minAge;
    self.yearsOldLabel.text = [NSString stringWithFormat:@"%.0f",minAge];
}

- (void) adjustPdtYearText
{
    [self.pdtYearButton setTitle:((PLI_PDTYEAR *)[self.plipdtyear_list objectAtIndex:mCurrentPdtYearIndex]).PY_PDTYEARNA forState:UIControlStateNormal];
}

//调整当前保额范围
-(void) adjustCurrentAmountRange
{
    self.currentPLI_PDTAMTRANGE = [PLI_PDTAMTRANGE findFirstByCriteria:@"where PD_PDTCODE = '%@' and PY_PDTYEAR = %.1f and MINAGE <= %d and MAXAGE >= %d",self.currentPli_pdt_m.PD_PDTCODE, self.currentPLI_PDTYEAR.PY_PDTYEAR, mCurrentAge, mCurrentAge];
    if (self.currentPLI_PDTAMTRANGE)
    {
         self.tipLabel.text = [NSString stringWithFormat:@"【投保年龄区间】：%d-%d嵗       【保额】：%.0f-%.0f万元",
           (int)self.currentPLI_PDTYEAR.PY_MINAGE,
           (int)self.currentPLI_PDTYEAR.PY_MAXAGE,
            self.currentPLI_PDTAMTRANGE.MINAMT ,
            self.currentPLI_PDTAMTRANGE.MAXAMT];
    }
}

-(void)adjustCurrentPkClassList
{
    NSMutableArray * wArr = [self.pkclass_list mutableCopy];
    for (int i = wArr.count - 1; i>=0; i--)
    {
        PK_CLASS * wClass = [wArr objectAtIndex:i];
        int count = 0;
        if (mCurrentPdKind != 0)
        {
            NSString * query = [NSString stringWithFormat:@"where pk_class = '%@' and pd_kind = '%d'",wClass.PK_CLASS_CODE,mCurrentPdKind];
            count = [PLI_PDT_M countByCriteria:query];
        }
        else
        {
            NSString * query = [NSString stringWithFormat:@"where pk_class = '%@'",wClass.PK_CLASS_CODE];
            count = [PLI_PDT_M countByCriteria:query];
        }
        if(count == 0)
        {
            [wArr removeObject:wClass];
        }
    }
    self.currentPkClass_list = wArr;
    
    for (PK_CLASS * wClass in self.currentPkClass_list)
    {
        wClass.isFolded = false;
    }
}

- (void) changeJobType:(int) type
{
    mCurrentJobType = type;
    switch (mCurrentJobType)
    {
        case 1:
            [self.jobTypeButton setTitle:@"第一类别" forState:UIControlStateNormal];
            break;
        case 2:
            [self.jobTypeButton setTitle:@"第二类别" forState:UIControlStateNormal];
            break;
        case 3:
            [self.jobTypeButton setTitle:@"第三类别" forState:UIControlStateNormal];
            break;
        case 4:
            [self.jobTypeButton setTitle:@"第四类别" forState:UIControlStateNormal];
            break;
        case 5:
            [self.jobTypeButton setTitle:@"第五类别" forState:UIControlStateNormal];
            break;
        case 6:
            [self.jobTypeButton setTitle:@"第六类别" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

//处理type 0，1
- (void) processTypeZeroAndOne
{
    
    float amount = self.amountTextField.text.floatValue;
    if(self.currentPLI_PDTAMTRANGE)
    {
        if (amount < self.currentPLI_PDTAMTRANGE.MINAMT || amount > self.currentPLI_PDTAMTRANGE.MAXAMT )
        {

                [self showAlertMsg:[NSString stringWithFormat:@"保额应在%.1f-%.1f之间"
                                    ,self.currentPLI_PDTAMTRANGE.MINAMT
                                    ,self.currentPLI_PDTAMTRANGE.MAXAMT]];
            return;
        }
    }
    
    NSString * query = [NSString stringWithFormat:@"where pr_pdtcode = '%@' and (PR_AGE = %d or PR_AGE = 0) and pr_pdtyear = %.1f and(pr_sales = 0 or pr_sales = %d) ",self.currentPli_pdt_m.PD_PDTCODE, mCurrentAge ,self.currentPLI_PDTYEAR.PY_PDTYEAR ,mCurrentJobType];
    NSArray * reslutArr = [PLI_PDTRATE findByCriteria:query];
    float rate;
    PLI_PDTRATE * plir = nil;
    if (reslutArr.count > 0)
    {
        plir  = [reslutArr objectAtIndex:0];
    }
    
    if (plir)
    {
        if (!mCurrentSex)
        {
            rate = plir.PR_MRATE;
        }
        else
        {
            rate = plir.PR_FRATE;
        }
        [self generateOutput:rate calcType:self.currentCALCSETTING.CALCTYPE diffRate:nil];
    }
    else
    {
        [self showAlertMsg:@"未找到相关记录"];
    }
}

//处理type 2
- (void) processTypeTwo
{
    PLI_PDTRATE * wPLI_PDTRATE = [PLI_PDTRATE findFirstByCriteria:@"where PR_PDTCODE = '%@' and PR_AGE = %d",self.currentPli_pdt_m.PD_PDTCODE,mCurrentJobType];
    PLI_PDTRATEDIFF * wPLI_PDTRATEDIFF = [PLI_PDTRATEDIFF findFirstByCriteria:@"where PR_PDTCODE = '%@' and PR_AGE = %d and PR_SALES = 0",self.currentPli_pdt_m.PD_PDTCODE,mCurrentJobType];
    
    if (wPLI_PDTRATE && wPLI_PDTRATEDIFF)
    {
        
        if (!mCurrentSex)
        {
            [self generateOutput:wPLI_PDTRATE.PR_MRATE calcType:self.currentCALCSETTING.CALCTYPE diffRate:wPLI_PDTRATEDIFF];
        }
        else
        {
            [self generateOutput:wPLI_PDTRATE.PR_FRATE calcType:self.currentCALCSETTING.CALCTYPE diffRate:wPLI_PDTRATEDIFF];
        }
    }
    else
    {
        [self showAlertMsg:@"未找到相关记录"];
    }
}

//处理type 3
- (void) processTypeThree
{
    float amount = self.amountTextField.text.floatValue;
    if(mTypeThreeMinAmount>= 0 || mTypeThreeMaxAmount>= 0)
    {
        if (amount < mTypeThreeMinAmount || amount > mTypeThreeMaxAmount )
        {
            
            [self showAlertMsg:[NSString stringWithFormat:@"保额应在%.1f-%.1f之间"
                                ,mTypeThreeMinAmount
                                ,mTypeThreeMaxAmount]];
            return;
        }
    }
    
    
    PLI_PDTRATE * wPLI_PDTRATE = [PLI_PDTRATE findFirstByCriteria:@"where PR_PDTCODE = '%@' and PR_AGE = %d and PR_PDTYEAR = %.1f",self.currentPli_pdt_m.PD_PDTCODE, mCurrentAge, amount];
    if (wPLI_PDTRATE)
    {
        if (!mCurrentSex)
        {
            [self generateOutput:wPLI_PDTRATE.PR_MRATE calcType:self.currentCALCSETTING.CALCTYPE diffRate:nil];
        }
        else
        {
            [self generateOutput:wPLI_PDTRATE.PR_FRATE calcType:self.currentCALCSETTING.CALCTYPE diffRate:nil];
        }
    }
    else
    {
        [self showAlertMsg:@"未找到相关记录"];
    }
}

double roundDown(double figure ,int precision)
{
    return floor(figure * pow(10, precision)) / pow(10, precision);
}

-(double) calcResult:(float)rate payAmount:(float) payAmount  payMode:(float)payMode calcType:(int)calcType diffRate:(float)diffRate
{
//    if ([self.currentPli_pdt_m.PD_UNIT isEqualToString:@"百元"])
//    {
//        payAmount /= 10000;
//    }
    
    if (calcType == 0)
    {
        return roundDown(round(rate * payMode) * payAmount, 0) ;
    }
    else if(calcType == 1)
    {
        return roundDown(round(rate * payMode * payAmount) , 0) ;
    }
    else if(calcType == 2)
    {
        return roundDown(round(rate * payMode + diffRate) * payAmount,0);
    }
    else if(calcType == 3)
    {
        return round(rate * payMode);
    }
    else
    {
        return  -1;
    }
}

- (void) showResultTip
{
    NSString * dateString =  [self.twDateFormatter stringFromDate:[NSDate date]];
    NSString * sexString;
    
    if (!mCurrentSex)
    {
        sexString = @"先生";
    }
    else
    {
        sexString = @"女士";
    }
    self.resultTipLabel1.text = [NSString stringWithFormat:@"敬爱的%@%@ 您於%@",
                                 self.userNameTextField.text,sexString,dateString];
    
    self.resultTipLabel2.text = [NSString stringWithFormat:@"試算%@的結果",
                                 self.currentPli_pdt_m.PD_PDTNAME];
}

- (void) generateOutput:(float) rate calcType:(int)calcType diffRate:(PLI_PDTRATEDIFF *) diffRate
{
    [self showResultTip];
    
#define caluValue(mode,diff) [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:[self calcResult:rate payAmount:amount payMode:mode calcType:calcType diffRate:diff]]numberStyle:NSNumberFormatterDecimalStyle] 
    
    float amount = self.amountTextField.text.floatValue;
    
    NSString * yearStr;
    NSString * halfYearStr;
    NSString * quarterStr;
    NSString * monthStr;

    if(diffRate)
    {
        yearStr = caluValue(1.0f,0);
        halfYearStr = caluValue(0.52f,diffRate.PR_RATE6);
        quarterStr = caluValue(0.262f,diffRate.PR_RATE3);
        monthStr = caluValue(0.088f,diffRate.PR_RATE1 );
    }
    else
    {
        yearStr = caluValue(1.0f,-1);
        halfYearStr = caluValue(0.52f,-1);
        quarterStr = caluValue(0.262f,-1);
        monthStr = caluValue(0.088f,-1);
    }
    
    
    self.yearAmountLabel.text = [yearStr stringByAppendingString:@" 元"];
    if (self.currentPli_pdt_m.PD_MODELIMIT == 1)
    {
        self.halfYearAmountLabel.text = @"-- 元";
        self.quarterAmountLabel.text = @"-- 元";
        self.monthAmountLabel.text = @"-- 元";
    }
    else
    {
        self.halfYearAmountLabel.text = [halfYearStr stringByAppendingString:@" 元"];
        self.quarterAmountLabel.text = [quarterStr stringByAppendingString:@" 元"];
        self.monthAmountLabel.text = [monthStr stringByAppendingString:@" 元"];
    }
    
    if (self.currentPli_pdt_m.PD_ONEPAY == 1.0f)
    {
        
        self.onePayAmountLabel.text = [yearStr stringByAppendingString:@" 元"];
    }
    else
    {
        self.onePayAmountLabel.text = [@"--" stringByAppendingString:@" 元"];
    }
    
}

#pragma mark 点击事件

- (IBAction)userClickMail:(id)sender {
    [self displayMailComposerSheet];
}

- (IBAction)onCollectClick:(UIButton *)sender
{
    NSURL *appURL = [NSURL URLWithString:@"http://com.vit.SKLMAgent"];
    [[UIApplication sharedApplication] openURL:appURL];
}

- (IBAction)onResetClick:(UIButton *)sender
{
    self.currentSelectedBirthday = nil;
    self.insuranceNameLabel.text = @"";
    self.currentPli_pdt_m = nil;
    self.yearsOldLabel.text = @"0";
    [self.pdtYearButton setTitle:@"--" forState:UIControlStateNormal];
    [self.birthdayButton setTitle:@"" forState:UIControlStateNormal];
    self.yearAmountLabel.text = self.halfYearAmountLabel.text = self.quarterAmountLabel.text = self.onePayAmountLabel.text = self.monthAmountLabel.text = @"--";
    self.amountTextField.text = @"";
    self.codeLabel.text = @"商品代码";
    self.jobTypeLabel.text = @"";
    
}

- (IBAction)onPdtYearClick:(UIButton *)sender 
{
    if(self.plipdtyear_list)
    {
        mCurrentPdtYearIndex = (mCurrentPdtYearIndex + 1) % self.plipdtyear_list.count;
        
        [self adjustPdtYearText];
    }
}

- (IBAction)onSexClick:(UIButton *)sender
{
    mCurrentSex = (bool)sender.tag;
    self.maleButton.selected = !mCurrentSex;
    self.femaleButton.selected = mCurrentSex;
    if (!mCurrentSex) {
        self.sexLabel.text = @"先生";
    }
    else {
        self.sexLabel.text = @"女士";
    }
}

- (IBAction)onJobTypeClick:(UIButton *)sender 
{
    mCurrentJobType = mCurrentJobType % 6 + 1;
    [self changeJobType:mCurrentJobType];
}

- (IBAction)onCalculateClick:(UIButton *)sender 
{
    [self.amountTextField resignFirstResponder];
    if(!self.currentPli_pdt_m)
    {
        
        [self showAlertMsg:[NSString stringWithFormat:@"请选择先品种"]];
        return;
    }
    
    if(self.amountTextField.text.length <=0 )
    {
        [self showAlertMsg:[NSString stringWithFormat:@"请先填入金额"]];
        return;
    }
    
    if(self.currentCALCSETTING.CALCTYPE == 0 || self.currentCALCSETTING.CALCTYPE == 1)
    {
        [self processTypeZeroAndOne];
    }
    else if(self.currentCALCSETTING.CALCTYPE == 2)
    {
        [self processTypeTwo];
    }
    else if (self.currentCALCSETTING.CALCTYPE == 3)
    {
        [self processTypeThree];
    }
    
}

#pragma mark 弹出框点击以及回调

- (IBAction)onBirthdayClick:(UIButton *)sender 
{
    PopDateController * wDateController = [[PopDateController alloc]init];
    self.popDateController = wDateController;
    wDateController.popDateDelegate = self;
    wDateController.selectedDate = self.currentSelectedBirthday;
    wDateController.maxDate = self.minAgeDate;
    wDateController.minDate = self.maxAgeDate;
    UIPopoverController * wController = [[UIPopoverController alloc]initWithContentViewController:wDateController];
    wController.popoverContentSize = wDateController.view.frame.size;
    self.popOverController = wController;
    [wController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
    wDateController = nil;
    wController = nil;
}

- (IBAction)onJobTypePopClick:(UIButton *)sender 
{
    PopComboController * wComboController = [[PopComboController alloc]init];
    wComboController.selectedModel = self.comboModel;
    self.popComboController = wComboController;
    wComboController.popComboDelegate = self;
    UIPopoverController * wController = [[UIPopoverController alloc]initWithContentViewController:wComboController];
    wController.popoverContentSize = wComboController.view.frame.size;
    self.popOverController = wController;
    [wController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
    wComboController = nil;
    wController = nil;
}



//生日点击回调
-(void)onOkClick:(NSDate *)date
{
    NSString * birthday = [self.twDateFormatter stringFromDate:date];
    self.currentSelectedBirthday = date;
    NSDateComponents *wDateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date toDate:[NSDate date] options:0];
    mCurrentAge = wDateComponents.year;
    self.yearsOldLabel.text = [NSString stringWithFormat:@"%d", wDateComponents.year];
    [self.birthdayButton setTitle:birthday forState:UIControlStateNormal] ;
    [self.popOverController dismissPopoverAnimated:true];
    [self adjustCurrentAmountRange];
}

//生日点击取消
- (void)onCancelClick
{
    [self.popOverController dismissPopoverAnimated:true];
}

//职业类别点击回调
- (void)onComboOkClick:(ComboModel *)model
{
    self.comboModel = model;
    [self changeJobType: model.thirdLevel.VALUE.intValue];
    self.jobTypeLabel.text = [NSString stringWithFormat:@"%@/%@/%@",model.firstLevel.CODE_CNAME,model.secondLevel.CODE_CNAME,model.thirdLevel.CODE_CNAME];
    [self.popOverController dismissPopoverAnimated:true];
}

//职业类别点击取消
- (void)onComboCancelClick
{
    [self.popOverController dismissPopoverAnimated:true];
}

//主副约之间的切换
- (IBAction)onPdkindClick:(UIButton *)sender 
{
    for (UIButton * wButton in self.pdKindButtonArr) 
    {
        wButton.selected = false;
    }
    sender.selected = true;
    mCurrentPdKind = sender.tag;
    [self adjustCurrentPkClassList];
    
    [self.tableListView reloadData];
}


#pragma mark util

- (void)showAlertMsg:(NSString *)msg
{
    [self.amountTextField resignFirstResponder];
    UIAlertView *wAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    self.alertView = wAlertView;
    [wAlertView show];
    //    [wAlertView release];
}

#pragma mark 邮件相关

- (void)displayMailComposerSheet
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *wMailComposeViewController = [[MFMailComposeViewController alloc] init];
        wMailComposeViewController.mailComposeDelegate = self;
        
        [wMailComposeViewController setSubject:@"屏幕截图"];
        
        
        // 附件
        NSData *myData = UIImageJPEGRepresentation([UIApplication sharedApplication].keyWindow.currentImage, 1.0);
        [wMailComposeViewController addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"屏幕截图"];
        
        // 邮件正文
        //        NSString *emailBody = @"It is raining in sunny California!";
        //        [wMailComposeViewController setMessageBody:emailBody isHTML:NO];
        
        [self presentModalViewController:wMailComposeViewController animated:YES];
        //        [wMailComposeViewController release];
    } else {
        [self showAlertMsg:@"邮箱暂未配置，请配置后再使用该功能。"];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSString *wResultMsg;
    switch (result) {
        case MFMailComposeResultSent:
            wResultMsg = @"已发送";
            break;
            
        case MFMailComposeResultSaved:
            wResultMsg = @"已保存";
            break;
            
        case MFMailComposeResultCancelled:
            wResultMsg = @"已取消";
            break;
            
        case MFMailComposeResultFailed:
            wResultMsg = error.localizedDescription;
            break;
            
        default:
            wResultMsg = @"走不到啊走不到";
            break;
    }
    [self showAlertMsg:wResultMsg];
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setUnitButton:nil];
    [self setVersionNOLabel:nil];
    [self setResultTipLabel1:nil];
    [self setResultTipLabel2:nil];
    [self setUserNameTextField:nil];
    [super viewDidUnload];
}
@end
