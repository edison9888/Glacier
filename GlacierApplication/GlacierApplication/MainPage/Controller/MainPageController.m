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
@property (retain, nonatomic) IBOutlet UILabel *insuranceNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *currencyUnitLabel;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *currencyLabel;
@property (retain, nonatomic) IBOutlet UIButton *pdtYearButton;
@property (retain, nonatomic) IBOutlet UIButton *maleButton;
@property (strong, nonatomic) IBOutlet UILabel *appVersionLabel;
@property (retain, nonatomic) IBOutlet UIButton *femaleButton;
@property (retain, nonatomic) IBOutlet UITextField *amountTextField;
@property (retain, nonatomic) IBOutlet UILabel *yearAmountLabel;
@property (retain, nonatomic) IBOutlet UILabel *halfYearAmountLabel;
@property (retain, nonatomic) IBOutlet UILabel *quarterAmountLabel;
@property (retain, nonatomic) IBOutlet UILabel *monthAmountLabel;
@property (retain, nonatomic) IBOutlet UILabel *onePayAmountLabel;
@property (retain, nonatomic) IBOutlet UIButton *jobTypeButton;
@property (strong, nonatomic) IBOutlet UITextField *ageTextField;
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
    double mTypeThreeMinAmount;
    double mTypeThreeMaxAmount;
}
@synthesize jobTypeLabel;
@synthesize versionNOLabel;
@synthesize birthdayButton;
@synthesize sexLabel;
@synthesize codeLabel;
@synthesize tipLabel;
@synthesize tableListView;
@synthesize pdKindButtonArr;
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

@synthesize twDateFormatter;
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
@synthesize  appVersionLabel;
@synthesize  updateTimeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSDateFormatter * wTwDateFormatter = [[NSDateFormatter alloc] init];
        twDateFormatter = wTwDateFormatter;
        NSCalendar *wRepublicOfChinaCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSRepublicOfChinaCalendar];
        self.twDateFormatter.calendar = wRepublicOfChinaCalendar;
        
        NSLocale *wLocale  = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
        self.twDateFormatter.locale = wLocale;
        
        self.twDateFormatter.dateFormat = @"G yyy年MM月dd日";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mCurrentJobType = 1;
    NSString * appVersion = @"v1.0.1.0";
    NSString * updateTime = @"2012年10月1日";
    self.appVersionLabel.text = [NSString stringWithFormat:@"APP版本：%@",appVersion];
    self.updateTimeLabel.text = [NSString stringWithFormat:@"最近更新：%@",updateTime];
    self.plipdtm_list = [PLI_PDT_M findByCriteria:@"group by PD_PDTCODE"];
    self.pkclass_list = [PK_CLASS findByCriteria:@"order by pk"];
    mCurrentPdKind = 1;
    [self adjustCurrentPkClassList];
    [self.tableListView reloadData];
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

- (NSArray *) getCurrentPliInPKClassArray:(NSInteger) section
{
    PK_CLASS * wClass = [self.currentPkClass_list objectAtIndex:section];
    
    NSString * predicateStr;
    
    if (mCurrentPdKind != 0)
    {
//        predicateStr = [NSString stringWithFormat:@"SELF.PK_CLASS == %@ and self.PD_KIND == %d",wClass.PK_CLASS_CODE, mCurrentPdKind];
        if (mCurrentPdKind == 1) {
            predicateStr = [NSString stringWithFormat:@"SELF.PK_CLASS == %@ and self.PD_KIND == %d",wClass.PK_CLASS_CODE, mCurrentPdKind];
        } else if (mCurrentPdKind == 2) {
            predicateStr = [NSString stringWithFormat:@"SELF.PK_CLASS == %@ and self.PD_KIND <> %d",wClass.PK_CLASS_CODE, 1];
        }
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
        return [self getCurrentPliInPKClassArray:section].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"PliCell";
    ProductCell * wCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!wCell) {
        wCell = [[[NSBundle mainBundle]loadNibNamed:@"ProductCell" owner:nil options:nil] objectAtIndex:0];
    }
    wCell.nameLabel.text = [self trimShortName:((PLI_PDT_M *)[[self getCurrentPliInPKClassArray:indexPath.section] objectAtIndex:indexPath.row]).PD_PDTNAME];
    return wCell;
}

- (NSString *) trimShortName:(NSString *)fullName
{
    NSMutableString * name = [NSMutableString string];
    [name setString:fullName];
    [name replaceOccurrencesOfString:@"新光人壽" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, name.length)];
    return name;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentPli_pdt_m = ((PLI_PDT_M *)[[self getCurrentPliInPKClassArray:indexPath.section] objectAtIndex:indexPath.row]);
    self.currentCALCSETTING = [CALCSETTING findFirstByCriteria:@"where PD_PDTCODE = '%@'",self.currentPli_pdt_m.PD_PDTCODE];
    [self initComponentAfterSelected];
}

#pragma mark 处理函数

-(void) initComponentAfterSelected
{
    self.currentSelectedBirthday = nil;
    self.currentPLI_PDTAMTRANGE = nil;
    
    self.versionNOLabel.text = [NSString stringWithFormat:@"版數：%.0f",self.currentPli_pdt_m.PD_VERSIONNO];
    self.currencyLabel.text = [NSString stringWithFormat:@"幣別：%@",[self getCurrencyString:self.currentPli_pdt_m.PD_CURRENCY]];
    self.currencyUnitLabel.text = [NSString stringWithFormat:@"單位：%@",[self getCurrencyUnitString:self.currentPli_pdt_m.PD_CURRENCY]];
    [self.UnitButton setTitle:self.currentPli_pdt_m.PD_UNIT forState:UIControlStateNormal];
    self.plipdtyear_list = [PLI_PDTYEAR findByCriteria:@"where PD_PDTCODE = '%@' group by PY_PDTYEAR",self.currentPli_pdt_m.PD_PDTCODE];
    mCurrentPdtYearIndex = 0;
    [self.birthdayButton setTitle:@"--" forState:UIControlStateNormal];
    self.insuranceNameLabel.text = [self trimShortName: self.currentPli_pdt_m.PD_PDTNAME];
    self.codeLabel.text = [@"商品代碼：" stringByAppendingString:self.currentPli_pdt_m.PD_PDTCODE];
    
    self.yearAmountLabel.text = self.halfYearAmountLabel.text = self.quarterAmountLabel.text = self.onePayAmountLabel.text = self.monthAmountLabel.text = @"--";
    self.amountTextField.text = @"";
    

    if (self.currentCALCSETTING.CALCTYPE == 0 || self.currentCALCSETTING.CALCTYPE == 1)
    {
        [self adjustBirthComponent:self.currentPLI_PDTYEAR.PY_MINAGE max:self.currentPLI_PDTYEAR.PY_MAXAGE];
        self.tipLabel.text = [NSString stringWithFormat:@"【投保年齡】：%d-%d歲       【保額】：無限制",(int)self.currentPLI_PDTYEAR.PY_MINAGE, (int)self.currentPLI_PDTYEAR.PY_MAXAGE];
    }
    else if (self.currentCALCSETTING.CALCTYPE == 3)
    {
        
        double minAge = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MIN(PR_AGE) from PLI_PDTRATE where PR_PDTCODE =  '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
        
        double maxAge = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MAX(PR_AGE) from PLI_PDTRATE where PR_PDTCODE =  '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
        
        [self adjustBirthComponent:minAge max:maxAge];
        
        mTypeThreeMinAmount = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MIN(PR_PDTYEAR) from PLI_PDTRATE where PR_PDTCODE =  '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
        
        mTypeThreeMaxAmount = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MAX(PR_PDTYEAR) from PLI_PDTRATE where PR_PDTCODE =  '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
        
        self.tipLabel.text = [NSString stringWithFormat:@"【投保年齡】：%.0f-%.0f歲       【保額】：%.0f-%.0f%@",
                              minAge,
                              maxAge,
                              mTypeThreeMinAmount,
                              mTypeThreeMaxAmount,
                              self.currentPli_pdt_m.PD_UNIT];
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
    self.ageTextField.text = [NSString stringWithFormat:@"%.0f",minAge];
}

- (void) adjustPdtYearText
{
    [self.pdtYearButton setTitle:((PLI_PDTYEAR *)[self.plipdtyear_list objectAtIndex:mCurrentPdtYearIndex]).PY_PDTYEARNA forState:UIControlStateNormal];
}

//调整当前保額范围
-(void) adjustCurrentAmountRange
{
    self.currentPLI_PDTAMTRANGE = [PLI_PDTAMTRANGE findFirstByCriteria:@"where PD_PDTCODE = '%@' and PY_PDTYEAR = %.1f and MINAGE <= %d and MAXAGE >= %d",self.currentPli_pdt_m.PD_PDTCODE, self.currentPLI_PDTYEAR.PY_PDTYEAR, mCurrentAge, mCurrentAge];
    if (self.currentPLI_PDTAMTRANGE)
    {
         self.tipLabel.text = [NSString stringWithFormat:@"【投保年齡區間】：%d-%d歲       【保額】：%.0f-%.0f%@",
           (int)self.currentPLI_PDTYEAR.PY_MINAGE,
           (int)self.currentPLI_PDTYEAR.PY_MAXAGE,
            self.currentPLI_PDTAMTRANGE.MINAMT,
            self.currentPLI_PDTAMTRANGE.MAXAMT,
            self.currentPli_pdt_m.PD_UNIT];
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
//            NSString * query = [NSString stringWithFormat:@"where pk_class = '%@' and pd_kind = '%d'",wClass.PK_CLASS_CODE,mCurrentPdKind];
//            NSLog(@"query = %@",query);
//            count = [PLI_PDT_M countByCriteria:query];
            if (mCurrentPdKind == 1) {
                NSString * query = [NSString stringWithFormat:@"where pk_class = '%@' and pd_kind = '%d'",wClass.PK_CLASS_CODE,mCurrentPdKind];
                NSLog(@"query = %@",query);
                count = [PLI_PDT_M countByCriteria:query];
            } else if (mCurrentPdKind == 2) {
                NSString * query = [NSString stringWithFormat:@"where pk_class = '%@' and pd_kind <> '%d'",wClass.PK_CLASS_CODE,1];
                NSLog(@"query = %@",query);
                count = [PLI_PDT_M countByCriteria:query];
            }
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
            [self.jobTypeButton setTitle:@"第一類別" forState:UIControlStateNormal];
            break;
        case 2:
            [self.jobTypeButton setTitle:@"第二類別" forState:UIControlStateNormal];
            break;
        case 3:
            [self.jobTypeButton setTitle:@"第三類別" forState:UIControlStateNormal];
            break;
        case 4:
            [self.jobTypeButton setTitle:@"第四類別" forState:UIControlStateNormal];
            break;
        case 5:
            [self.jobTypeButton setTitle:@"第五類別" forState:UIControlStateNormal];
            break;
        case 6:
            [self.jobTypeButton setTitle:@"第六類別" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

//处理type 0，1
- (void) processTypeZeroAndOne
{
    
    double amount = self.amountTextField.text.doubleValue;
    if(self.currentPLI_PDTAMTRANGE)
    {
        double minAmout = self.currentPLI_PDTAMTRANGE.MINAMT;
        double maxAmout = self.currentPLI_PDTAMTRANGE.MAXAMT;
        
//        if([self.currentPli_pdt_m.PD_UNIT isEqualToString:@"百元"])
//        {
//            minAmout *= 100;
//            maxAmout *= 100;
//        }
        if (amount < minAmout || amount > maxAmout )
        {

                [self showAlertMsg:[NSString stringWithFormat:@"保額應在%.1f-%.1f之間"
                                    ,minAmout
                                    ,maxAmout]];
            return;
        }
    }
    
    NSString * query = [NSString stringWithFormat:@"where pr_pdtcode = '%@'and pr_pdtyear = %.1f  ",self.currentPli_pdt_m.PD_PDTCODE,self.currentPLI_PDTYEAR.PY_PDTYEAR];
    
    if([PLI_PDTRATE checkNeedPR_AGE:self.currentPli_pdt_m.PD_PDTCODE pdtYear:self.currentPLI_PDTYEAR.PY_PDTYEAR])
    {
        query =  [query stringByAppendingFormat:@" and PR_AGE = %d ",mCurrentAge];
    }
    
    if ([PLI_PDTRATE checkNeedPR_SALES:self.currentPli_pdt_m.PD_PDTCODE pdtYear:self.currentPLI_PDTYEAR.PY_PDTYEAR])
    {
        query = [query stringByAppendingFormat:@"and pr_sales = %d",mCurrentJobType];
    }
    
    
    NSArray * reslutArr = [PLI_PDTRATE findByCriteria:query];
    double rate;
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
        [self showAlertMsg:@"不符核保條件"];
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
        [self showAlertMsg:@"不符核保條件"];
    }
}

//处理type 3
- (void) processTypeThree
{
    double amount = self.amountTextField.text.doubleValue;
    if(mTypeThreeMinAmount>= 0 || mTypeThreeMaxAmount>= 0)
    {
        double minAmout = mTypeThreeMinAmount;
        double maxAmout = mTypeThreeMaxAmount;
        
//        if([self.currentPli_pdt_m.PD_UNIT isEqualToString:@"百元"])
//        {
//            minAmout *= 100;
//            maxAmout *= 100;
//        }
        
        if (amount < minAmout || amount > maxAmout )
        {
            
            [self showAlertMsg:[NSString stringWithFormat:@"保額應在%.1f-%.1f之間"
                                ,minAmout
                                ,maxAmout]];
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
        [self showAlertMsg:@"不符核保條件"];
    }
}

double roundDown(double figure ,int precision)
{
    return floor(figure * pow(10, precision)) / pow(10, precision);
}

double roundPrec(double figure ,int precision)
{
    return round(figure * pow(10, precision) - 0.0000001) / pow(10, precision);//减去0.0000001为了和其他版本保持统一 0.5舍去
}

-(double) calcResult:(double)rate payAmount:(double) payAmount  payMode:(double)payMode calcType:(int)calcType diffRate:(double)diffRate
{
    NSLog(@"rate:%f payAmount:%f payMode:%f calcType:%i diffRate:%f",rate,payAmount,payMode,calcType,diffRate);
    
    if (calcType == 0)
    {
        
        int calcRange = self.currentCALCSETTING.CALCRANGE; //级距>0则使用级距
        
        if (self.currentCALCSETTING.USEROUNDDOWN)
        {
            return roundDown(roundPrec(rate * payMode * (calcRange > 0 ? calcRange: 1)  , self.currentCALCSETTING.USEROUND) * payAmount / (calcRange > 0 ? calcRange: 1),self.currentCALCSETTING.FEEPOINTER) ;
        }
        else
        {
            return roundPrec(roundPrec(rate * payMode * (calcRange > 0 ? calcRange: 1)  , self.currentCALCSETTING.USEROUND) * payAmount / (calcRange > 0 ? calcRange: 1),self.currentCALCSETTING.FEEPOINTER) ;
        }

    }
    else if(calcType == 1)
    {
        double value = rate * payMode * payAmount;
        double fee = roundPrec(value , self.currentCALCSETTING.USEROUND);
        if (self.currentCALCSETTING.USEROUNDDOWN)
        {
            return roundDown(fee, self.currentCALCSETTING.FEEPOINTER);
        }
        else
        {
            return roundPrec(fee, self.currentCALCSETTING.FEEPOINTER);
        }
    }
    else if(calcType == 2)
    {
        return roundDown(roundPrec(rate * payMode + diffRate,0) * payAmount,0);
    }
    else if(calcType == 3)
    {
        return roundPrec(rate * payMode,0);
    }
    else
    {
        NSLog(@"错误的类别");
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

- (void) generateOutput:(double) rate calcType:(int)calcType diffRate:(PLI_PDTRATEDIFF *) diffRate
{
    [self showResultTip];
#define caluValue(mode,diff) [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:[self calcResult:rate payAmount:amount payMode:mode calcType:calcType diffRate:diff]]numberStyle:NSNumberFormatterDecimalStyle] 
    
    double amount = self.amountTextField.text.doubleValue;
    
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
        self.yearAmountLabel.text = @"-- 元";
    }
    else
    {
        self.onePayAmountLabel.text = [@"--" stringByAppendingString:@" 元"];
    }
    
}

#pragma mark 点击事件

- (IBAction)userClickMail:(id)sender
{
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
    self.ageTextField.text = @"0";
    [self.pdtYearButton setTitle:@"--" forState:UIControlStateNormal];
    [self.birthdayButton setTitle:@"" forState:UIControlStateNormal];
    self.yearAmountLabel.text = self.halfYearAmountLabel.text = self.quarterAmountLabel.text = self.onePayAmountLabel.text = self.monthAmountLabel.text = @"--";
    self.amountTextField.text = @"";
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
        
        [self showAlertMsg:[NSString stringWithFormat:@"請先選擇品種"]];
        return;
    }
    
    if(self.amountTextField.text.length <=0 )
    {
        [self showAlertMsg:[NSString stringWithFormat:@"請先輸入金額"]];
        return;
    }
    
    if (self.currentCALCSETTING.AMTRANGE != 0)
    {
        if ((int)self.amountTextField.text.doubleValue % (int)self.currentCALCSETTING.AMTRANGE != 0 ) {
            [self showAlertMsg:[NSString stringWithFormat:@"保額必須為%d的倍數",(int)self.currentCALCSETTING.AMTRANGE]];
            return;
        }
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
    if(wDateComponents.month >= 6)
    {
        mCurrentAge = wDateComponents.year + 1;
    }
    else
    {
        mCurrentAge = wDateComponents.year;
    }
    
    self.ageTextField.text = [NSString stringWithFormat:@"%d", mCurrentAge];
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

#pragma mark textfield
- (IBAction)onBackClick:(UIButton *)sender
{
    [self.ageTextField resignFirstResponder];
    [self.amountTextField resignFirstResponder];
    [self.userNameTextField resignFirstResponder];
    self.backButton.hidden = true;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.backButton.hidden = false;
    [self.view bringSubviewToFront:self.backButton];
    return true;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == 2) // 年龄输入
    {
        double age = textField.text.doubleValue;
        
        if (age < self.currentPLI_PDTYEAR.PY_MINAGE || age > self.currentPLI_PDTYEAR.PY_MAXAGE)
        {
            [self showAlertMsg:[NSString stringWithFormat:@"【投保年齡區間】：%d-%d歲",
                               (int)self.currentPLI_PDTYEAR.PY_MINAGE,
                                (int)self.currentPLI_PDTYEAR.PY_MAXAGE]];
            textField.text = [NSString stringWithFormat:@"%d",(int)self.currentPLI_PDTYEAR.PY_MINAGE];
        }
        mCurrentAge = textField.text.doubleValue;
    }
    return true;
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

- (NSString *) getCurrencyUnitString:(NSString *)currency
{
    if ([currency isEqualToString:@"US"])
    {
        return @"美元";
    }
    else if ([currency isEqualToString:@"NT"])
    {
        return @"新台幣元";
    }
    else if ([currency isEqualToString:@"AUD"])
    {
        return @"澳元";
    }
    else
    {
        return @"未知";
    }
}


- (NSString *) getCurrencyString:(NSString *)currency
{
    if ([currency isEqualToString:@"US"])
    {
        return @"US美金";
    }
    else if ([currency isEqualToString:@"NT"])
    {
        return @"NT新臺幣";
    }
    else if ([currency isEqualToString:@"AUD"])
    {
        return @"AUD澳幣";
    }
    else
    {
        return @"未知";
    }
}

#pragma mark 邮件相关

- (void)displayMailComposerSheet
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *wMailComposeViewController = [[MFMailComposeViewController alloc] init];
        wMailComposeViewController.mailComposeDelegate = self;
        
        [wMailComposeViewController setSubject:self.currentPli_pdt_m.PD_PDTNAME];
        
        
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

        NSString * wBodyString = [NSString stringWithFormat:@"敬爱的%@%@,\r\n您於%@試算%@的結果",
                                  self.userNameTextField.text,sexString,dateString,self.currentPli_pdt_m.PD_PDTNAME];
        [wMailComposeViewController setMessageBody:wBodyString isHTML:false];
        
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
    [self setAppVersionLabel:nil];
    [self setUpdateTimeLabel:nil];
    [self setCurrencyLabel:nil];
    [self setCurrencyUnitLabel:nil];
    [self setAgeTextField:nil];
    [self setBackButton:nil];
    [super viewDidUnload];
}
@end
