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
#import "ProductCell.h"
#import "ProductSectionView.h"


@interface MainPageController ()


- (void)displayMailComposerSheet;
- (void)showAlertMsg:(NSString *)msg;

@property (nonatomic, readonly) NSDateFormatter *twDateFormatter;
@property (nonatomic,retain) NSArray * plipdtm_list;
@property (nonatomic,retain) NSArray * pkclass_list;
@property (nonatomic,retain) NSArray * currentPkClass_list;
@property (nonatomic,retain) NSArray * plipdtrate_list;
@property (nonatomic,retain) NSArray * plipdtyear_list; //当前年期的列表
@property (nonatomic,retain) PLI_PDT_M * currentPli_pdt_m;
@property (nonatomic,retain) UIAlertView * alertView;
@property (retain, nonatomic) IBOutlet UITextField *minAgeTextField;
@property (retain, nonatomic) IBOutlet UITextField *maxAgeTextField;
@property (retain, nonatomic) IBOutlet UIButton *jobTypeButton;
@property (nonatomic,retain) PopDateController * popDateController;
@property (retain, nonatomic) UIPopoverController * popOverController;
@property (nonatomic,retain) PopComboController * popComboController;
@property (nonatomic,retain) NSDate * maxAgeDate;
@property (nonatomic,retain) NSDate * minAgeDate;
@property (nonatomic,retain) ComboModel * comboModel;
@end

@implementation MainPageController
{
    bool mCurrentSex;
    int mCurrentJobType;
    int mCurrentAge;
    int mCurrentPdtYearIndex;
    int mCurrentPdKind;
    int mCurrentCalcMode;//当前计算模式
}
@synthesize jobTypeLabel = _jobTypeLabel;
@synthesize birthdayButton = _birthdayButton;
@synthesize sexLabel = _sexLabel;
@synthesize minAgeTextField = _minAgeTextField;
@synthesize maxAgeTextField = _maxAgeTextField;
@synthesize jobTypeButton = _jobTypeButton;
@synthesize amountTextField = _amountTextField;
@synthesize yearAmountLabel = _yearAmountLabel;
@synthesize halfYearAmountLabel = _halfYearAmountLabel;
@synthesize quarterAmountLabel = _quarterAmountLabel;
@synthesize monthAmountLabel = _monthAmountLabel;
@synthesize onePayAmountLabel = _onePayAmountLabel;
@synthesize codeLabel = _codeLabel;
@synthesize tipLabel = _tipLabel;
@synthesize tableListView = _tableListView;
@synthesize pdKindButtonArr = _pdKindButtonArr;
@synthesize yearsOldLabel = _yearsOldLabel;
@synthesize insuranceNameLabel = _insuranceNameLabel;
@synthesize pdtYearButton = _pdtYearButton;
@synthesize maleButton = _maleButton;
@synthesize femaleButton = _femaleButton;
@synthesize twDateFormatter = _twDateFormatter;
@synthesize plipdtm_list = _plipdtm_list;
@synthesize pkclass_list = _pkclass_list;
@synthesize plipdtrate_list = _plipdtrate_list;
@synthesize plipdtyear_list = _plipdtyear_list;
@synthesize currentPli_pdt_m = _currentPli_pdt_m;
@synthesize alertView;
@synthesize currentPkClass_list = _currentPkClass_list;
@synthesize popDateController = _popDateController;
@synthesize popOverController = _popOverController;
@synthesize popComboController = _popComboController;
@synthesize maxAgeDate;
@synthesize minAgeDate;
@synthesize comboModel;

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.currentPkClass_list.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ProductSectionView * wView = [[[NSBundle mainBundle]loadNibNamed:@"ProductSectionView" owner:nil options:nil] objectAtIndex:0];
    wView.nameLabel.text = ((PK_CLASS *) [self.currentPkClass_list objectAtIndex:section]).PK_CLASS_NAME;
    return wView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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

    
    return [self.plipdtm_list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateStr]].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"PliCell";
    ProductCell * wCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!wCell) {
        wCell = [[[NSBundle mainBundle]loadNibNamed:@"ProductCell" owner:nil options:nil] objectAtIndex:0];
    }
    PK_CLASS * wClass = [self.currentPkClass_list objectAtIndex:indexPath.section];
    
    NSString * predicateStr;
    
    if (mCurrentPdKind != 0)
    {
        predicateStr = [NSString stringWithFormat:@"SELF.PK_CLASS == %@ and self.PD_KIND == %d",wClass.PK_CLASS_CODE, mCurrentPdKind];
    }
    else 
    {
        predicateStr = [NSString stringWithFormat:@"SELF.PK_CLASS == %@",wClass.PK_CLASS_CODE];
    }

    wCell.nameLabel.text = ((PLI_PDT_M *)[[self.plipdtm_list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateStr]] objectAtIndex:indexPath.row]).PD_PDTNAME;
    return wCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PK_CLASS * wClass = [self.currentPkClass_list objectAtIndex:indexPath.section];
    self.currentPli_pdt_m = ((PLI_PDT_M *)[[self.plipdtm_list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.PK_CLASS == %d",wClass.PK_CLASS_CODE.intValue]] objectAtIndex:indexPath.row]);
    [self initComponent];
    
}

//#pragma mark SKLSliderDelegate
//
//- (void)yearsOldChanged:(NSInteger)yearsOld birDay:(NSDate *)birDayDate {
//    _birDayLabel.text = [self.twDateFormatter stringFromDate:birDayDate];
//    mCurrentAge = yearsOld;
//    _yearsOldLabel.text = [NSString stringWithFormat:@"%d", yearsOld];
//}

#pragma mark 界面操作相关



#pragma mark 邮件相关

- (void)displayMailComposerSheet {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *wMailComposeViewController = [[MFMailComposeViewController alloc] init];
        wMailComposeViewController.mailComposeDelegate = self;
        
        [wMailComposeViewController setSubject:@"屏幕截图"];
        
        
        // 收件人
//        NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"]; 
//        NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
//        NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
//        
//        [wMailComposeViewController setToRecipients:toRecipients];
//        [wMailComposeViewController setCcRecipients:ccRecipients];  
//        [wMailComposeViewController setBccRecipients:bccRecipients];
        
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


-(void) initComponent
{
    self.plipdtyear_list = [PLI_PDTYEAR findByCriteria:@"where PD_PDTCODE = '%@' group by PY_PDTYEAR",self.currentPli_pdt_m.PD_PDTCODE]; //等到修改
    mCurrentPdtYearIndex = 0;
    self.insuranceNameLabel.text = self.currentPli_pdt_m.PD_PDTNAME;
    self.codeLabel.text = [@"商品代码：" stringByAppendingString:self.currentPli_pdt_m.PD_PDTCODE];
    PLI_PDTYEAR * pdtyear;
    
    if(self.plipdtyear_list.count > 0)
    {
        pdtyear =  [self.plipdtyear_list objectAtIndex:0];
        
        NSDateComponents* minCom = [[NSDateComponents alloc] init];
        [minCom setYear:-pdtyear.PY_MINAGE];
        NSDate * wMinDate = [[NSCalendar currentCalendar] dateByAddingComponents:minCom toDate:[NSDate date] options:0];
        self.minAgeDate = wMinDate;
//        [minCom release];
        
        NSDateComponents* maxCom = [[NSDateComponents alloc] init];
        [maxCom setYear:-pdtyear.PY_MAXAGE];
        NSDate * wMaxDate = [[NSCalendar currentCalendar] dateByAddingComponents:maxCom toDate:[NSDate date] options:0];
        self.maxAgeDate = wMaxDate;
//        [maxCom release];
        
        mCurrentAge = pdtyear.PY_MINAGE;
//        [self.slider setYearsOldMin:pdtyear.pyminage max:pdtyear.pymaxage];
        self.yearsOldLabel.text = [NSString stringWithFormat:@"%.0f",pdtyear.PY_MINAGE];
    }
    
    self.tipLabel.text = [NSString stringWithFormat:@"【投保年龄】：%d-%d嵗       【保额】：%.0f-%.0f万元",(int)pdtyear.PY_MINAGE, (int)pdtyear.PY_MAXAGE,pdtyear.PY_MINAMT.floatValue ,pdtyear.PY_MAXAMT.floatValue];
    
    [self adjustPdtYearText];
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

#pragma mark util

- (void)showAlertMsg:(NSString *)msg 
{
    [self.amountTextField resignFirstResponder];
    UIAlertView *wAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    self.alertView = wAlertView;
    [wAlertView show];
//    [wAlertView release];
}

#pragma mark 处理函数

- (void) adjustPdtYearText
{
    [self.pdtYearButton setTitle:((PLI_PDTYEAR *)[self.plipdtyear_list objectAtIndex:mCurrentPdtYearIndex]).PY_PDTYEARNA forState:UIControlStateNormal];
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

- (float) findRate:(int) age pdtYearIndex:(int)pdtIndex showAlert:(bool) isShow
{
    PLI_PDTYEAR * pdtyear = ((PLI_PDTYEAR *)[self.plipdtyear_list objectAtIndex:pdtIndex]);
    
    long long amount = self.amountTextField.text.longLongValue;
    
    
    if ((pdtyear.PY_MINAMT != 0 && amount < pdtyear.PY_MINAMT.longLongValue)||(pdtyear.PY_MAXAMT!=0 && amount > pdtyear.PY_MAXAMT.longLongValue))
    {
        if (isShow)
        {
            [self showAlertMsg:[NSString stringWithFormat:@"保额应在%@-%@之间",pdtyear.PY_MINAMT,pdtyear.PY_MAXAMT]];
        }
        return  - 1;
    }
    
    
    //获得年期
    int pdt = pdtyear.PY_PDTYEAR;
    NSString * query = [NSString stringWithFormat:@"where pr_pdtcode = '%@' and pr_age = '%d' and pr_pdtyear = %d and(pr_sales = 0 or pr_sales = %d) ",self.currentPli_pdt_m.PD_PDTCODE,age,pdt,mCurrentJobType];
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
        return rate;
    }
    else
    {
        return  - 1;
    }
    
}


- (void) generateOutput:(float) rate
{
    long long resultAmount = self.amountTextField.text.longLongValue * rate;
    NSString * yearStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount] numberStyle:NSNumberFormatterDecimalStyle];
    NSString * halfYearStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount * 0.52] numberStyle:NSNumberFormatterDecimalStyle];
    NSString * quarterStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount * 0.262] numberStyle:NSNumberFormatterDecimalStyle];
    NSString * monthStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount * 0.088] numberStyle:NSNumberFormatterDecimalStyle];
    NSString * dayStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount / 365.0f] numberStyle:NSNumberFormatterDecimalStyle];
    
    
    self.yearAmountLabel.text = [yearStr stringByAppendingString:@" 元"];
    self.halfYearAmountLabel.text = [halfYearStr stringByAppendingString:@" 元"];
    self.quarterAmountLabel.text = [quarterStr stringByAppendingString:@" 元"];
    self.monthAmountLabel.text = [monthStr stringByAppendingString:@" 元"];
    
    if (self.currentPli_pdt_m.PD_ONEPAY == 1.0f)
    {
        
        self.onePayAmountLabel.text = [yearStr stringByAppendingString:@" 元"];
    }
    else
    {
        self.onePayAmountLabel.text = [@"--" stringByAppendingString:@" 元"];
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
}


#pragma mark 点击事件

- (IBAction)userClickMail:(id)sender {
    [self displayMailComposerSheet];
}

- (IBAction)onCollectClick:(UIButton *)sender
{
    NSURL *appURL = [NSURL URLWithString:@"SKLMAgent://com.vit.SKLMAgent"];
    [[UIApplication sharedApplication] openURL:appURL];
}

- (IBAction)onResetClick:(UIButton *)sender
{
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
    float rate =[self findRate:mCurrentAge pdtYearIndex:mCurrentPdtYearIndex showAlert:true];
 
    if(!self.currentPli_pdt_m)
    {

        [self showAlertMsg:[NSString stringWithFormat:@"请选择先品种"]];
        return;
    }
    
    if (rate > 0)
    {
        [self generateOutput:rate];
    }
    else 
    {
        
    }
}


- (IBAction)onBirthdayClick:(UIButton *)sender 
{
    PopDateController * wDateController = [[PopDateController alloc]init];
    self.popDateController = wDateController;
    wDateController.popDateDelegate = self;
    wDateController.maxDate = self.minAgeDate;
    wDateController.minDate = self.maxAgeDate;
    UIPopoverController * wController = [[UIPopoverController alloc]initWithContentViewController:wDateController];
    wController.popoverContentSize = wDateController.view.frame.size;
    self.popOverController = wController;
    [wController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
//    [wDateController release];
//    [wController release];
}

- (IBAction)onJobTypePopClick:(UIButton *)sender 
{
    if ( self.popComboController)
    {
        [self.popComboController.view removeFromSuperview];
    }
    PopComboController * wComboController = [[PopComboController alloc]init];
    wComboController.selectedModel = self.comboModel;
    self.popComboController = wComboController;
    wComboController.popComboDelegate = self;
    UIPopoverController * wController = [[UIPopoverController alloc]initWithContentViewController:wComboController];
    wController.popoverContentSize = wComboController.view.frame.size;
    self.popOverController = wController;
    [wController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:true];
//    [wComboController release];
//    [wController release];
}


-(void)onOkClick:(NSDate *)date
{
    NSString * birthday = [self.twDateFormatter stringFromDate:date];
    NSDateComponents *wDateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date toDate:[NSDate date] options:0];
    mCurrentAge = wDateComponents.year;
    self.yearsOldLabel.text = [NSString stringWithFormat:@"%d", wDateComponents.year];
    [self.birthdayButton setTitle:birthday forState:UIControlStateNormal] ;
    [self.popOverController dismissPopoverAnimated:true];
}

- (void)onCancelClick
{
    [self.popOverController dismissPopoverAnimated:true];
}

- (void)onComboOkClick:(ComboModel *)model
{
    self.comboModel = model;
    [self changeJobType: model.thirdLevel.VALUE.intValue];
    self.jobTypeLabel.text = [NSString stringWithFormat:@"%@/%@/%@",model.firstLevel.CODE_CNAME,model.secondLevel.CODE_CNAME,model.thirdLevel.CODE_CNAME];
    [self.popOverController dismissPopoverAnimated:true];
}

- (void)onComboCancelClick
{
    [self.popOverController dismissPopoverAnimated:true];
}

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

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    mCurrentCalcMode = item.tag;
    if (mCurrentCalcMode == 0)
    {
        [self.view viewWithTag:20].hidden = true;
    }
    else if (mCurrentCalcMode == 1) 
    {
        [self.view viewWithTag:20].hidden = false;
    }
}
@end

