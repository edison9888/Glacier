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
#import "LoginProcess.h"

@interface MainPageController ()
- (void)displayMailComposerSheet;
- (void)showAlertMsg:(NSString *)msg;

@property (strong, nonatomic) IBOutlet UILabel *amoutRestrLabel;
@property (strong, nonatomic) IBOutlet UIButton *ageButton;
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
@property (strong, nonatomic) IBOutlet UILabel *countDownLabel;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
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
@property (strong, nonatomic) IBOutlet UIButton *UnitButton;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UILabel *resultTipLabel1;
@property (strong, nonatomic) IBOutlet UILabel *resultTipLabel2;

@property (nonatomic, readonly) NSDateFormatter *twDateFormatter;
@property (nonatomic,retain) NSArray * plipdtm_list;
@property (nonatomic,retain) NSArray * pkclass_list;
@property (nonatomic,retain) NSArray * plipdtrate_list;
@property (nonatomic,retain) NSArray * currentPlipdtyear_list; //当前年期的列表
@property (nonatomic,retain) NSArray * allPliPdtYear_list; //全部年期列表
@property (nonatomic,readonly) PLI_PDTYEAR * currentPLI_PDTYEAR ;
@property (nonatomic,retain) UIAlertView * alertView;

@property (strong, nonatomic) IBOutlet UILabel *calcTimeLabel;
@property (retain, nonatomic) UIPopoverController * popOverController;
@property (nonatomic,retain) PopDateController * popDateController;
@property (nonatomic,retain) PopComboController * popComboController;
@property (nonatomic,retain) PopPickerController * popPickerController;

@property (nonatomic,retain) NSDate * maxAgeDate;
@property (nonatomic,retain) NSDate * minAgeDate;
@property (nonatomic,retain) ComboModel * comboModel;
@property (nonatomic,retain) NSDate * currentSelectedBirthday;

@property (nonatomic,retain) NSArray * currentAge_list;
@property (nonatomic,retain) NSArray * currentPkClass_list;
@property (nonatomic,retain) PLI_PDT_M * currentPli_pdt_m;
@property (nonatomic,retain) CALCSETTING * currentCALCSETTING;
@property (nonatomic,retain) PLI_PDTAMTRANGE * currentPLI_PDTAMTRANGE;
@property (nonatomic,copy) NSString * lastAmount;
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
    
    double mMinAge;
    double mMaxAge;
    double mMinAmount;
    double mMaxAmount;
}
@synthesize jobTypeLabel;
@synthesize versionNOLabel;
@synthesize birthdayButton;
@synthesize sexLabel;
@synthesize codeLabel;
@synthesize tipLabel;
@synthesize tableListView;
@synthesize pdKindButtonArr;
@synthesize amoutRestrLabel;
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
@synthesize lastAmount;

@synthesize twDateFormatter;
@synthesize  plipdtm_list;
@synthesize  pkclass_list;
@synthesize  plipdtrate_list;
@synthesize  currentPlipdtyear_list; //当前年期的列表
@synthesize allPliPdtYear_list;
@synthesize  currentPLI_PDTYEAR ;
@synthesize  alertView;

@synthesize  popDateController;
@synthesize  popOverController;
@synthesize  popComboController;
@synthesize  maxAgeDate;
@synthesize  minAgeDate;
@synthesize  comboModel;
@synthesize  currentSelectedBirthday;

@synthesize currentAge_list;
@synthesize  currentPkClass_list;
@synthesize  currentPli_pdt_m;
@synthesize  currentCALCSETTING;
@synthesize  currentPLI_PDTAMTRANGE;
@synthesize  appVersionLabel;
@synthesize  updateTimeLabel;
@synthesize countDownLabel;
@synthesize logoutButton;
@synthesize calcTimeLabel;
@synthesize ageButton;

@synthesize currencyUnitLabel;
@synthesize backButton;
@synthesize currencyLabel;
@synthesize popPickerController;

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
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString * appVersion =[infoDict objectForKey:@"CFBundleVersion"];
    NSString * updateTime = @"2012年10月1日";
    self.appVersionLabel.text = [NSString stringWithFormat:@"APP版本：%@",appVersion];
    self.updateTimeLabel.text = [NSString stringWithFormat:@"最近更新：%@",updateTime];
    self.plipdtm_list = [PLI_PDT_M findByCriteria:@"order by PD_KIND"];
    self.pkclass_list = [PK_CLASS findByCriteria:@"order by pk"];
    mCurrentPdKind = 1;
    [self adjustCurrentPkClassList];
    [self.tableListView reloadData];
    
    [[LoginProcess sharedInstance] setCountDownLabel:countDownLabel];
    [[LoginProcess sharedInstance] refreshCountDown];
}

- (PLI_PDTYEAR *)currentPLI_PDTYEAR
{
    if (self.currentPlipdtyear_list.count > 0)
    {
        return [self.currentPlipdtyear_list objectAtIndex:mCurrentPdtYearIndex];
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
    self.currentPlipdtyear_list = nil;
        
    self.versionNOLabel.text = [NSString stringWithFormat:@"版數：%.0f",self.currentPli_pdt_m.PD_VERSIONNO];
    self.currencyLabel.text = [NSString stringWithFormat:@"幣別：%@",[self getCurrencyString:self.currentPli_pdt_m.PD_CURRENCY]];
    self.currencyUnitLabel.text = [NSString stringWithFormat:@"單位：%@",[self getCurrencyUnitString:self.currentPli_pdt_m.PD_CURRENCY]];
    [self.UnitButton setTitle:self.currentPli_pdt_m.PD_UNIT forState:UIControlStateNormal];
//    self.plipdtyear_list = [PLI_PDTYEAR findByCriteria:@"where PD_PDTCODE = '%@' group by PY_PDTYEAR",self.currentPli_pdt_m.PD_PDTCODE];
//    mCurrentPdtYearIndex = 0;
    [self.birthdayButton setTitle:@"--" forState:UIControlStateNormal];
    self.insuranceNameLabel.text = [self trimShortName: self.currentPli_pdt_m.PD_PDTNAME];
    self.codeLabel.text = [@"商品代碼：" stringByAppendingString:self.currentPli_pdt_m.PD_PDTCODE];
    
    self.yearAmountLabel.text = self.halfYearAmountLabel.text = self.quarterAmountLabel.text = self.onePayAmountLabel.text = self.monthAmountLabel.text = @"--";
    [self.ageButton setTitle:@"--" forState:UIControlStateNormal];
    [self.pdtYearButton setTitle:@"--" forState:UIControlStateNormal];
    self.calcTimeLabel.text = @"";
    self.amountTextField.text = @"";
    [self adjustAgeRange];
    [self adjustAmount];
    mCurrentAge = -1;
    mCurrentPdtYearIndex = -1;
    self.lastAmount = nil;
}

//调整保额范围
- (void) adjustAmount
{
    if (self.currentCALCSETTING.CALCTYPE == 0 || self.currentCALCSETTING.CALCTYPE == 1  || self.currentCALCSETTING.CALCTYPE == 2)
    {
        mMinAmount = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MIN(PY_MINAMT) from PLI_PDTYEAR where PD_PDTCODE = '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
        mMaxAmount = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MAX(PY_MAXAMT) from PLI_PDTYEAR where PD_PDTCODE = '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
    }
    else if (self.currentCALCSETTING.CALCTYPE == 3)
    {
        mMinAmount = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MIN(PR_PDTYEAR) from PLI_PDTRATE where PR_PDTCODE =  '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
        
        mMaxAmount = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MAX(PR_PDTYEAR) from PLI_PDTRATE where PR_PDTCODE =  '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
    }
    [self adjustAmountRest];
}

//调整年龄范围
- (void) adjustAgeRange
{
    mMinAge = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MIN(PY_MINAGE) from PLI_PDTYEAR where PD_PDTCODE = '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
    
    mMaxAge = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MAX(PY_MAXAGE) from PLI_PDTYEAR where PD_PDTCODE = '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
    self.tipLabel.text = [NSString stringWithFormat:@"【投保年齡】：%.0f-%.0f歲",mMinAge,mMaxAge];

    [self adjustBirthComponent:mMinAge max:mMaxAge];
}




//- (void) adjustPdtYearRange //废弃
//{
//    if (self.currentCALCSETTING.CALCTYPE == 0 || self.currentCALCSETTING.CALCTYPE == 1  || self.currentCALCSETTING.CALCTYPE == 2)
//    {
//        [self adjustBirthComponent:self.currentPLI_PDTYEAR.PY_MINAGE max:self.currentPLI_PDTYEAR.PY_MAXAGE];
//        self.tipLabel.text = [NSString stringWithFormat:@"【投保年齡】：%d-%d歲",(int)self.currentPLI_PDTYEAR.PY_MINAGE,(int)self.currentPLI_PDTYEAR.PY_MAXAGE];
//        self.amoutRestrLabel.text = [NSString stringWithFormat:@"【保額】：無限制"];
//    }
//    else if (self.currentCALCSETTING.CALCTYPE == 3)
//    {
//        
//        double minAge = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MIN(PR_AGE) from PLI_PDTRATE where PR_PDTCODE =  '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
//        
//        double maxAge = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MAX(PR_AGE) from PLI_PDTRATE where PR_PDTCODE =  '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
//        
//        [self adjustBirthComponent:minAge max:maxAge];
//        
//        mTypeThreeMinAmount = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MIN(PR_PDTYEAR) from PLI_PDTRATE where PR_PDTCODE =  '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
//        
//        mTypeThreeMaxAmount = [[SQLiteInstanceManager sharedManager] executeSelectDoubleSQL:[NSString stringWithFormat: @"select MAX(PR_PDTYEAR) from PLI_PDTRATE where PR_PDTCODE =  '%@'",self.currentPli_pdt_m.PD_PDTCODE]];
//        
//        self.tipLabel.text = [NSString stringWithFormat:@"【投保年齡】：%.0f-%.0f歲       ",
//                              minAge,
//                              maxAge];
//        self.amoutRestrLabel.text =
//        [NSString stringWithFormat:@"【保額】：%.1f-%.1f%@",
//         mTypeThreeMinAmount,
//         mTypeThreeMaxAmount,
//         self.currentPli_pdt_m.PD_UNIT];
//    }
//    
//    [self adjustPdtYearText];
//}

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
//    self.ageTextField.text = [NSString stringWithFormat:@"%.0f",minAge];
}

- (void) adjustPdtYearText
{
    if (mCurrentPdtYearIndex < 0)
    {
        [self.pdtYearButton setTitle:((PLI_PDTYEAR *)[self.currentPlipdtyear_list objectAtIndex:0]).PY_PDTYEARNA forState:UIControlStateNormal];
    }
    else
    {
        [self.pdtYearButton setTitle:((PLI_PDTYEAR *)[self.currentPlipdtyear_list objectAtIndex:mCurrentPdtYearIndex]).PY_PDTYEARNA forState:UIControlStateNormal];
    }
}


//调整年期范围
- (void) initPdtYear
{
    self.allPliPdtYear_list = [PLI_PDTYEAR findByCriteria:@"where PD_PDTCODE = '%@'",self.currentPli_pdt_m.PD_PDTCODE];
    self.currentPlipdtyear_list = [PLI_PDTYEAR findByCriteria:@"where PD_PDTCODE = '%@' and PY_MINAGE <= %d and PY_MAXAGE >= %d ",self.currentPli_pdt_m.PD_PDTCODE,(int)mCurrentAge, (int)mCurrentAge];
    mCurrentPdtYearIndex = -1;
    [self.pdtYearButton setTitle:@"--" forState:UIControlStateNormal];
    //    [self adjustPdtYearText];
}

- (void) adjustRestructAfterPdtYear
{
    if (self.currentCALCSETTING.CALCTYPE == 0 || self.currentCALCSETTING.CALCTYPE == 1  || self.currentCALCSETTING.CALCTYPE == 2) {
        self.currentPLI_PDTAMTRANGE = [PLI_PDTAMTRANGE findFirstByCriteria:@"where PD_PDTCODE = '%@' and PY_PDTYEAR = %.1f and MINAGE <= %d and MAXAGE >= %d",self.currentPli_pdt_m.PD_PDTCODE, self.currentPLI_PDTYEAR.PY_PDTYEAR, mCurrentAge, mCurrentAge];
        
        if (self.currentPLI_PDTAMTRANGE)
        {
            mMinAmount = self.currentPLI_PDTAMTRANGE.MINAMT;
            mMaxAmount = self.currentPLI_PDTAMTRANGE.MAXAMT;
        }
        else 
        {
            mMinAmount = self.currentPLI_PDTYEAR.PY_MINAMT;
            mMaxAmount = self.currentPLI_PDTYEAR.PY_MAXAMT;
        }
        [self adjustAmountRest];
    }
}

- (void) adjustAmountRest
{
    self.amoutRestrLabel.text =
    [NSString stringWithFormat:@"【保額】：%@-%@%@",
     [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:mMinAmount]numberStyle:NSNumberFormatterDecimalStyle],
     [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble:mMaxAmount]numberStyle:NSNumberFormatterDecimalStyle],
     self.currentPli_pdt_m.PD_UNIT];
}

////调整当前保額范围
//-(void) adjustCurrentAmountRange
//{
//    self.currentPLI_PDTAMTRANGE = [PLI_PDTAMTRANGE findFirstByCriteria:@"where PD_PDTCODE = '%@' and PY_PDTYEAR = %.1f and MINAGE <= %d and MAXAGE >= %d",self.currentPli_pdt_m.PD_PDTCODE, self.currentPLI_PDTYEAR.PY_PDTYEAR, mCurrentAge, mCurrentAge];
//    if (self.currentPLI_PDTAMTRANGE)
//    {
//         self.tipLabel.text = [NSString stringWithFormat:@"【投保年齡區間】：%d-%d歲       【保額】：%.0f-%.0f%@",
//           (int)self.currentPLI_PDTYEAR.PY_MINAGE,
//           (int)self.currentPLI_PDTYEAR.PY_MAXAGE,
//            self.currentPLI_PDTAMTRANGE.MINAMT,
//            self.currentPLI_PDTAMTRANGE.MAXAMT,
//            self.currentPli_pdt_m.PD_UNIT];
//    }
//}

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
            [self.jobTypeButton setTitle:@"第一類" forState:UIControlStateNormal];
            break;
        case 2:
            [self.jobTypeButton setTitle:@"第二類" forState:UIControlStateNormal];
            break;
        case 3:
            [self.jobTypeButton setTitle:@"第三類" forState:UIControlStateNormal];
            break;
        case 4:
            [self.jobTypeButton setTitle:@"第四類" forState:UIControlStateNormal];
            break;
        case 5:
            [self.jobTypeButton setTitle:@"第五類" forState:UIControlStateNormal];
            break;
        case 6:
            [self.jobTypeButton setTitle:@"第六類" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

//处理type 0，1
- (void) processTypeZeroAndOne
{

    NSString * query = [NSString stringWithFormat:@"where pr_pdtcode = '%@' and pr_pdtyear = %.1f  ",self.currentPli_pdt_m.PD_PDTCODE,self.currentPLI_PDTYEAR.PY_PDTYEAR];
    
    if([PLI_PDTRATE checkNeedPR_AGE:self.currentPli_pdt_m.PD_PDTCODE pdtYear:self.currentPLI_PDTYEAR.PY_PDTYEAR])
    {
        query =  [query stringByAppendingFormat:@" and PR_AGE = %d ",mCurrentAge];
    }
    
    if ([PLI_PDTRATE checkNeedPR_SALES:self.currentPli_pdt_m.PD_PDTCODE pdtYear:self.currentPLI_PDTYEAR.PY_PDTYEAR])
    {
        query = [query stringByAppendingFormat:@" and pr_sales = %d",mCurrentJobType];
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
        
        
        if ([PLI_PDTRATEDIFF countByCriteria:query] == 2)
        {
            query = [query stringByAppendingFormat:@" and PR_SEX = '%@'",(!mCurrentSex ? @"男" : @"女")];
        }
        
        PLI_PDTRATEDIFF * diff = [PLI_PDTRATEDIFF findFirstByCriteria:query];
        
        [self generateOutput:rate calcType:self.currentCALCSETTING.CALCTYPE diffRate:diff];
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
    return floor(figure * pow(10, precision) + 0.0000005) / pow(10, precision);
}

double roundPrec(double figure ,int precision)
{
    return round(figure * pow(10, precision) - 0.0000001) / pow(10, precision);//减去0.0000001为了和其他版本保持统一 0.5舍去
}

-(double) calcResult:(double)rate payAmount:(double) payAmount  payMode:(double)payMode calcType:(int)calcType diffRate:(double)diffRate
{
    NSLog(@"rate:%f payAmount:%f payMode:%f calcType:%i diffRate:%f",rate,payAmount,payMode,calcType,diffRate);
    
    bool hasRange = self.currentCALCSETTING.CALCRANGE > 0;
    if (calcType == 0)
    {
        double wTemp = 0.0;
        int useRound = self.currentCALCSETTING.USEROUND;
        int calcRange = self.currentCALCSETTING.CALCRANGE; //级距>0则使用级距
        
        if((int)round == 4)
        {
            wTemp = rate * payMode * payAmount;
        }
        else
        {
            wTemp = roundPrec(rate * payMode * ( hasRange ? calcRange :1) + diffRate, useRound) * payAmount / ( hasRange ? calcRange :1);
        }
        
        if (self.currentCALCSETTING.USEROUNDDOWN)
        {
            return roundDown(wTemp,self.currentCALCSETTING.FEEPOINTER) ;
        }
        else
        {
            return roundPrec(wTemp,self.currentCALCSETTING.FEEPOINTER) ;
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
        double wTemp = 0.0f;
        if (self.currentCALCSETTING.USEROUND == 4)
        {
            wTemp = rate * payMode * payAmount;
        }
        else
        {
            wTemp = roundPrec(rate * payMode *  (hasRange ? self.currentCALCSETTING.CALCRANGE : 1 ) + diffRate, self.currentCALCSETTING.USEROUND) * payAmount / (hasRange ? self.currentCALCSETTING.CALCRANGE : 1 );
        }
        wTemp = roundPrec(wTemp, 4);
        
        if (self.currentCALCSETTING.USEROUNDDOWN)
        {
            return roundDown(wTemp, self.currentCALCSETTING.FEEPOINTER);
        }
        else
        {
            return roundPrec(wTemp, self.currentCALCSETTING.FEEPOINTER);
        }
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
    NSDateFormatter * wFormatter = [[NSDateFormatter alloc] init];
    wFormatter.dateFormat = @"yyyy年MM月dd日";
    NSString * dateString =  [wFormatter stringFromDate:[NSDate date]];
    
    
    self.calcTimeLabel.text = [NSString stringWithFormat:@"試算日期：%@",dateString];
    
//    NSString * sexString;
//    if (!mCurrentSex)
//    {
//        sexString = @"先生";
//    }
//    else
//    {
//        sexString = @"女士";
//    }
//    self.resultTipLabel1.text = [NSString stringWithFormat:@"敬爱的%@%@ 您於%@",
//                                 self.userNameTextField.text,sexString,dateString];
//    
//    self.resultTipLabel2.text = [NSString stringWithFormat:@"試算%@的結果",
//                                 self.currentPli_pdt_m.PD_PDTNAME];
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
        monthStr = caluValue(0.088f,diffRate.PR_RATE1);
    }
    else
    {
        yearStr = caluValue(1.0f,0);
        halfYearStr = caluValue(0.52f,0);
        quarterStr = caluValue(0.262f,0);
        monthStr = caluValue(0.088f,0);
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
    NSURL * appURL = [NSURL URLWithString:@"SKLMAgent://com.vit.SKLMAgent"];
    [[UIApplication sharedApplication] openURL:appURL];
}

- (IBAction)onResetClick:(UIButton *)sender
{
    self.currentSelectedBirthday = nil;
    [self.ageButton setTitle:@"0" forState:UIControlStateNormal];
//    self.ageTextField.text = @"0";
    [self.pdtYearButton setTitle:@"--" forState:UIControlStateNormal];
    [self.birthdayButton setTitle:@"--" forState:UIControlStateNormal];
    self.yearAmountLabel.text = self.halfYearAmountLabel.text = self.quarterAmountLabel.text = self.onePayAmountLabel.text = self.monthAmountLabel.text = @"--";
    self.amountTextField.text = @"";
    self.calcTimeLabel.text = @"";
    self.jobTypeLabel.text = @"";
    [self.ageButton setTitle:@"--" forState:UIControlStateNormal];
    [self.pdtYearButton setTitle:@"--" forState:UIControlStateNormal];
    self.currentPlipdtyear_list = nil;
    mCurrentPdtYearIndex = -1;
    mCurrentAge = -1;
    mCurrentJobType = 1;
    [self changeJobType:mCurrentJobType];
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


- (IBAction)onCalculateClick:(UIButton *)sender 
{
    [self.amountTextField resignFirstResponder];
    if(!self.currentPli_pdt_m)
    {
        
        [self showAlertMsg:[NSString stringWithFormat:@"請先選擇保險商品"]];
        return;
    }
    
    if(mCurrentAge < 0)
    {
        [self showAlertMsg:@"請先選擇出生年月日或保險年齡"];
        return;

    }
    
    if(mCurrentPdtYearIndex < 0)
    {
        [self showAlertMsg:@"請先選擇年期"];
        return;
    }
    
    if(self.amountTextField.text.length <=0 )
    {
        [self showAlertMsg:[NSString stringWithFormat:@"請先輸入金額"]];
        return;
    }
    
    double amount = self.amountTextField.text.doubleValue;
    
    if (amount < mMinAmount || amount > mMaxAmount)
    {
        
        [self showAlertMsg:[NSString stringWithFormat:@"保額應在%.1f-%.1f之間"
                            ,mMinAmount
                            ,mMaxAmount]];
        self.amountTextField.text = self.lastAmount;
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
    self.lastAmount = self.amountTextField.text;
}



#pragma mark 普通职业类别弹出框点击以及回调

- (IBAction)onJobTypeClick:(UIButton *)sender
{
    
    PopPickerController * wPopPickerController = [[PopPickerController alloc]init];
    wPopPickerController.tag = 100;
    self.popPickerController = wPopPickerController;
    wPopPickerController.selectedIndex = mCurrentJobType - 1;
    wPopPickerController.pickerDataSource = [NSArray arrayWithObjects:@"第一類" ,@"第二類" ,@"第三類" ,@"第四類" ,@"第五類",@"第六類",nil];
    wPopPickerController.popPickerDelegate = self;
    UIPopoverController * wController = [[UIPopoverController alloc]initWithContentViewController:wPopPickerController];
    wController.popoverContentSize = wPopPickerController.view.frame.size;
    self.popOverController = wController;
    [wController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
    wPopPickerController = nil;
    wController = nil;
}

#pragma mark 年期选择弹出框
- (IBAction)onPdtYearClick:(UIButton *)sender
{
    if(self.currentPlipdtyear_list)
    {
        PopPickerController * wPopPickerController = [[PopPickerController alloc]init];
        wPopPickerController.tag = 101;
        self.popPickerController = wPopPickerController;
        wPopPickerController.selectedIndex = mCurrentPdtYearIndex < 0 ? 0 :mCurrentPdtYearIndex;
        
        NSMutableArray * wArr = [NSMutableArray array];
        for (PLI_PDTYEAR * wYear in self.allPliPdtYear_list)
        {
            NSLog(@"all %@",wYear.PY_PDTYEARNA);
            [wArr addObject:wYear.PY_PDTYEARNA];
        }
        wPopPickerController.pickerDataSource = wArr;
        
        NSMutableArray * wAvaArr = [NSMutableArray array];
        for (PLI_PDTYEAR * wYear in self.currentPlipdtyear_list)
        {
            NSLog(@"ava %@",wYear.PY_PDTYEARNA);
            [wAvaArr addObject:wYear.PY_PDTYEARNA];
        }
        wPopPickerController.availDataSource = wAvaArr;
        
        
        wPopPickerController.popPickerDelegate = self;
        UIPopoverController * wController = [[UIPopoverController alloc]initWithContentViewController:wPopPickerController];
        wController.popoverContentSize = wPopPickerController.view.frame.size;
        self.popOverController = wController;
        [wController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
        wPopPickerController = nil;
        wController = nil;
    }
}

#pragma mark 年龄弹出框
- (IBAction)onAgePopClick:(UIButton *)sender
{
    if (self.currentPli_pdt_m)
    {
        PopPickerController * wPopPickerController = [[PopPickerController alloc]init];
        wPopPickerController.tag = 102;
        self.popPickerController = wPopPickerController;
        
        
        NSMutableArray * wAgeArr = [NSMutableArray array];
        
        for (int i = mMinAge; i<= mMaxAge ;i++)
        {
            [wAgeArr addObject:[NSString stringWithFormat:@"%d歲",i]];
        }
        
        wPopPickerController.selectedIndex = mCurrentAge >= 0 ? mCurrentAge - (int)mMinAge : 0;
        wPopPickerController.pickerDataSource = wAgeArr;
        self.currentAge_list = wAgeArr;
        wPopPickerController.popPickerDelegate = self;
        UIPopoverController * wController = [[UIPopoverController alloc]initWithContentViewController:wPopPickerController];
        wController.popoverContentSize = wPopPickerController.view.frame.size;
        self.popOverController = wController;
        [wController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
        wPopPickerController = nil;
        wController = nil;
    }
    
}

- (void)onPopPickerOKClick:(int)index viewTag:(NSInteger)tag
{
    if (tag == 100) //职业类别
    {
        mCurrentJobType = index + 1;
        [self changeJobType:mCurrentJobType];
        self.jobTypeLabel.text = @"";
    }
    else if (tag == 101) //年期
    {
        mCurrentPdtYearIndex = index;
        [self adjustPdtYearText];
        [self adjustRestructAfterPdtYear];
    }
    else if (tag == 102)//年龄弹出框
    {
        NSString * wStr = ((NSString *)[self.currentAge_list objectAtIndex:index]);
        mCurrentAge = [wStr substringToIndex:wStr.length - 1].intValue;
        [self.ageButton setTitle:[NSString stringWithFormat:@"%d",mCurrentAge] forState:UIControlStateNormal];
        [self.birthdayButton setTitle:@"--" forState:UIControlStateNormal];
        [self initPdtYear];
    }
    [self.popOverController dismissPopoverAnimated:true];
}

- (void)onPopPickerCancelClick
{
    [self.popOverController dismissPopoverAnimated:true];
}

#pragma mark 列表选择职业类别弹出框点击以及回调
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

#pragma mark 生日选择弹出框
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


//生日点击回调
-(void)onOkClick:(NSDate *)date
{
    NSString * birthday = [self.twDateFormatter stringFromDate:date];
    self.currentSelectedBirthday = date;
    NSDateComponents *wDateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date toDate:[NSDate date] options:0];
    if(wDateComponents.month > 6 || (wDateComponents.month == 6 && wDateComponents.day >= 0) )
    {
        mCurrentAge = wDateComponents.year + 1;
    }
    else
    {
        mCurrentAge = wDateComponents.year;
    }
    [self.ageButton setTitle:[NSString stringWithFormat:[NSString stringWithFormat:@"%d", mCurrentAge],mCurrentAge] forState:UIControlStateNormal];
    [self.birthdayButton setTitle:birthday forState:UIControlStateNormal] ;
    [self.popOverController dismissPopoverAnimated:true];
    [self initPdtYear];
}

//生日点击取消
- (void)onCancelClick
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

- (IBAction)onLogout:(UIButton *)sender {
    [[LoginProcess sharedInstance] doLogout];
}

#pragma mark textfield
- (IBAction)onBackClick:(UIButton *)sender
{
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
    UIAlertView *wAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil];
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

        NSString * wBodyString = [NSString stringWithFormat:@"敬愛的%@%@,\r\n您於%@試算%@的結果",
                                  self.userNameTextField.text,sexString,dateString,self.currentPli_pdt_m.PD_PDTNAME];
        [wMailComposeViewController setMessageBody:wBodyString isHTML:false];
        
        // 附件
        NSData *myData = UIImageJPEGRepresentation([UIApplication sharedApplication].keyWindow.currentImage, 1.0);
        
        [wMailComposeViewController addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"insurance calculate"];
        
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
            wResultMsg = @"已發送";
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
    [self setBackButton:nil];
    [self setAgeButton:nil];
    [self setAmoutRestrLabel:nil];
    [self setCalcTimeLabel:nil];
    [super viewDidUnload];
}
@end
