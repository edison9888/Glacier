//
//  MainPageController.m
//  GlacierApplication
//
//  Created by chang liang on 12-9-12.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "MainPageController.h"
#import "plipdtm.h"
#import "pkclass.h"
#import "plipdtrate.h"
#import "plipdtyear.h"
#import "UIView+SKLCurrentImage.h"
#import "ResultModel.h"
#import "ProductCell.h"
#import "ProductSectionView.h"

@interface MainPageController ()
@property (retain, nonatomic) IBOutlet UITextView *cautionTextView;
@property (retain, nonatomic) IBOutlet UITextField *minAgeTextField;
@property (retain, nonatomic) IBOutlet UITextField *maxAgeTextField;

- (void)displayMailComposerSheet;
- (void)showAlertMsg:(NSString *)msg;

@property (nonatomic, readonly) NSDateFormatter *twDateFormatter;
@property (nonatomic,retain) NSArray * plipdtm_list;
@property (nonatomic,retain) NSArray * pkclass_list;
@property (nonatomic,retain) NSArray * currentPkClass_list;
@property (nonatomic,retain) NSArray * plipdtrate_list;
@property (nonatomic,retain) NSArray * plipdtyear_list; //当前年期的列表
@property (nonatomic,retain) plipdtm * currentPli_pdt_m;
@property (nonatomic,retain) UIAlertView * alertView;
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
@synthesize cautionTextView = _cautionTextView;
@synthesize minAgeTextField = _minAgeTextField;
@synthesize maxAgeTextField = _maxAgeTextField;
@synthesize amountTextField = _amountTextField;
@synthesize yearAmountLabel = _yearAmountLabel;
@synthesize halfYearAmountLabel = _halfYearAmountLabel;
@synthesize quarterAmountLabel = _quarterAmountLabel;
@synthesize monthAmountLabel = _monthAmountLabel;
@synthesize onePayAmountLabel = _onePayAmountLabel;
@synthesize tableListView = _tableListView;
@synthesize pdKindButtonArr = _pdKindButtonArr;
@synthesize slider = _slider;
@synthesize birDayLabel = _birDayLabel;
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

- (void)dealloc {
    [_slider release];
    [_birDayLabel release];
    [_yearsOldLabel release];
    [_twDateFormatter release];
    [_insuranceNameLabel release];
    [_maleButton release];
    [_femaleButton release];
    [_amountTextField release];
    [_pdtYearButton release];
    [_pdKindButtonArr release];
    [_tableListView release];
    [_cautionTextView release];
    [_minAgeTextField release];
    [_maxAgeTextField release];
    [_yearAmountLabel release];
    [_halfYearAmountLabel release];
    [_quarterAmountLabel release];
    [_monthAmountLabel release];
    [_onePayAmountLabel release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _twDateFormatter = [[NSDateFormatter alloc] init];
        NSCalendar *wRepublicOfChinaCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSRepublicOfChinaCalendar];
        _twDateFormatter.calendar = wRepublicOfChinaCalendar;
        [wRepublicOfChinaCalendar release];
        
        NSLocale *wLocale  = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
        _twDateFormatter.locale = wLocale;
        [wLocale release];
        
        _twDateFormatter.dateFormat = @"G yyy年MM月dd日";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _slider.delegate = self;
    mCurrentJobType = 1;
    self.plipdtm_list = [plipdtm findByCriteria:@"group by pdpdtcode"];
    self.pkclass_list = [pkclass findByCriteria:@"order by pk"];
    [self adjustCurrentPkClassList];
}


- (void)viewDidUnload
{
    [self setSlider:nil];
    [self setBirDayLabel:nil];
    [self setYearsOldLabel:nil];
    [self setInsuranceNameLabel:nil];
    [self setMaleButton:nil];
    [self setFemaleButton:nil];
    [self setAmountTextField:nil];
    [self setPdtYearButton:nil];
    [self setPdKindButtonArr:nil];
    [self setTableListView:nil];
    [self setResultWebView:nil];
    [self setCautionTextView:nil];
    [self setMinAgeTextField:nil];
    [self setMaxAgeTextField:nil];
    [self setYearAmountLabel:nil];
    [self setHalfYearAmountLabel:nil];
    [self setQuarterAmountLabel:nil];
    [self setMonthAmountLabel:nil];
    [self setOnePayAmountLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.currentPkClass_list.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ProductSectionView * wView = [[[NSBundle mainBundle]loadNibNamed:@"ProductSectionView" owner:nil options:nil] objectAtIndex:0];
    wView.nameLabel.text = ((pkclass *) [self.currentPkClass_list objectAtIndex:section]).name;
    return wView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    pkclass * wClass = [self.currentPkClass_list objectAtIndex:section];
    
    NSString * predicateStr;
    
    if (mCurrentPdKind != 0)
    {
        predicateStr = [NSString stringWithFormat:@"SELF.pkclass == '%@' and self.pdkind == '%d'",wClass.code, mCurrentPdKind];
    }
    else 
    {
        predicateStr = [NSString stringWithFormat:@"SELF.pkclass == '%@'",wClass.code];
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
    pkclass * wClass = [self.currentPkClass_list objectAtIndex:indexPath.section];
    
    NSString * predicateStr;
    
    if (mCurrentPdKind != 0)
    {
        predicateStr = [NSString stringWithFormat:@"SELF.pkclass == '%@' and self.pdkind == '%d'",wClass.code, mCurrentPdKind];
    }
    else 
    {
        predicateStr = [NSString stringWithFormat:@"SELF.pkclass == '%@'",wClass.code];
    }

    wCell.nameLabel.text = ((plipdtm *)[[self.plipdtm_list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateStr]] objectAtIndex:indexPath.row]).pdpdtname;
    return wCell;
}

#pragma mark SKLSliderDelegate

- (void)yearsOldChanged:(NSInteger)yearsOld birDay:(NSDate *)birDayDate {
    _birDayLabel.text = [self.twDateFormatter stringFromDate:birDayDate];
    mCurrentAge = yearsOld;
    _yearsOldLabel.text = [NSString stringWithFormat:@"%d", yearsOld];
}

#pragma mark 界面操作相关

- (IBAction)userClickMail:(id)sender {
    [self displayMailComposerSheet];
}

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
        [wMailComposeViewController release];
    } else {
        [self showAlertMsg:@"邮箱暂未配置，请配置后再使用该功能。"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    pkclass * wClass = [self.currentPkClass_list objectAtIndex:indexPath.section];    
    self.currentPli_pdt_m = ((plipdtm *)[[self.plipdtm_list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.pkclass == %@",wClass.code]] objectAtIndex:indexPath.row]);
    [self initComponent];
    
}

-(void) initComponent
{
    self.plipdtyear_list = [plipdtyear findByCriteria:@"where pdpdtcode = '%@' group by pypdtyear order by pypdtyear",self.currentPli_pdt_m.pdpdtcode];
    mCurrentPdtYearIndex = 0;
    self.insuranceNameLabel.text = self.currentPli_pdt_m.pdpdtname; 
    plipdtyear * pdtyear;
    
    if(self.plipdtyear_list.count > 0)
    {
        pdtyear =  [self.plipdtyear_list objectAtIndex:0];
        [self.slider setYearsOldMin:pdtyear.pyminage max:pdtyear.pymaxage];
        self.yearsOldLabel.text = [NSString stringWithFormat:@"%d",pdtyear.pyminage];
    }
    
    self.cautionTextView.text = [NSString stringWithFormat:@"[投保年龄]：%d-%d嵗\r\n[核保限制]：被保人年龄介于：%d-%d嵗\r\n[保额]：%d-%d万元",pdtyear.pyminage,pdtyear.pymaxage,pdtyear.pyminage,pdtyear.pymaxage,pdtyear.pyminamt,pdtyear.pymaxamt];
    
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

#pragma mark - 
#pragma mark util

- (void)showAlertMsg:(NSString *)msg 
{
    [self.amountTextField resignFirstResponder];
    UIAlertView *wAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    self.alertView = wAlertView;
    [wAlertView show];
    [wAlertView release];
}


- (IBAction)onPdtYearClick:(UIButton *)sender 
{
    if(self.plipdtyear_list)
    {
        mCurrentPdtYearIndex = (mCurrentPdtYearIndex + 1) % self.plipdtyear_list.count;
        
        [self adjustPdtYearText];
    }
}

- (void) adjustPdtYearText
{
    [self.pdtYearButton setTitle:((plipdtyear *)[self.plipdtyear_list objectAtIndex:mCurrentPdtYearIndex]).pypdtyearna forState:UIControlStateNormal];
}


- (IBAction)onSexClick:(UIButton *)sender
{
    mCurrentSex = (bool)sender.tag;
    self.maleButton.selected = !mCurrentSex;
    self.femaleButton.selected = mCurrentSex;
}

- (IBAction)onJobTypeClick:(UIButton *)sender 
{
    mCurrentJobType = mCurrentJobType % 6 + 1;
    switch (mCurrentJobType)
    {
        case 1:
            [sender setTitle:@"第一类别" forState:UIControlStateNormal];
            break;
        case 2:
            [sender setTitle:@"第二类别" forState:UIControlStateNormal];
            break;
        case 3:
            [sender setTitle:@"第三类别" forState:UIControlStateNormal];
            break;
        case 4:
            [sender setTitle:@"第四类别" forState:UIControlStateNormal];
            break;
        case 5:
            [sender setTitle:@"第五类别" forState:UIControlStateNormal];
            break;
        case 6:
            [sender setTitle:@"第六类别" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (IBAction)onCalculateClick:(UIButton *)sender 
{
    
    NSString * rate =[self findRate:mCurrentAge pdtYearIndex:mCurrentPdtYearIndex showAlert:true];
 
    if(!self.currentPli_pdt_m)
    {

        [self showAlertMsg:[NSString stringWithFormat:@"请选择先品种"]];
        return;
    }
    
    if (rate)
    {
        [self generateOutput:rate];
    }
    else 
    {
        
    }
}


- (NSString *) findRate:(int) age pdtYearIndex:(int)pdtIndex showAlert:(bool) isShow
{
    plipdtyear * pdtyear = ((plipdtyear *)[self.plipdtyear_list objectAtIndex:pdtIndex]);
    
    long long amount = self.amountTextField.text.longLongValue;
    
   
    
    if ((pdtyear.pyminamt != 0 && amount < pdtyear.pyminamt)||(pdtyear.pymaxamt!=0 && amount > pdtyear.pymaxamt))
    {
        if (isShow) 
        {
            [self showAlertMsg:[NSString stringWithFormat:@"保额应在%d-%d之间",pdtyear.pyminamt,pdtyear.pymaxamt]];
        }
        return nil;
    }
   
    
    //获得年期
    int pdt = pdtyear.pypdtyear;
    NSString * query = [NSString stringWithFormat:@"where prpdtcode = '%@' and prage = '%d' and prpdtyear = %d and(prsales = 0 or prsales = %d) ",self.currentPli_pdt_m.pdpdtcode,age,pdt,mCurrentJobType];
    NSArray * reslutArr = [plipdtrate findByCriteria:query];
    NSString * rate = nil;
    plipdtrate * plir = nil;
    if (reslutArr.count > 0) 
    {
        plir  = [reslutArr objectAtIndex:0];
    }
    
    if (plir)
    {
        if (!mCurrentSex)
        {
            rate = plir.prmrate;
        }
        else 
        {
            rate = plir.prfrate;
        }
        return rate;
    }
    else 
    {
        return  nil;
    }

}


- (void) generateOutput:(NSString *) rate
{
    long long resultAmount = self.amountTextField.text.longLongValue * rate.floatValue; 
    NSString * yearStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount] numberStyle:NSNumberFormatterDecimalStyle];
    NSString * halfYearStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount * 0.52] numberStyle:NSNumberFormatterDecimalStyle];
    NSString * quarterStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount * 0.262] numberStyle:NSNumberFormatterDecimalStyle];
    NSString * monthStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount * 0.088] numberStyle:NSNumberFormatterDecimalStyle];
     NSString * dayStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount / 365.0f] numberStyle:NSNumberFormatterDecimalStyle];
    NSString * output;
    if ([self.currentPli_pdt_m.pdonepay isEqualToString:@"1"]) 
    {
        self.yearAmountLabel.text = yearStr;
        self.halfYearAmountLabel.text = halfYearStr;
        self.quarterAmountLabel.text = quarterStr;
        self.monthAmountLabel.text = monthStr;
        self.onePayAmountLabel.text = yearStr;
    }
    else 
    {
        self.yearAmountLabel.text = yearStr;
        self.halfYearAmountLabel.text = halfYearStr;
        self.quarterAmountLabel.text = quarterStr;
        self.monthAmountLabel.text = monthStr;
        self.onePayAmountLabel.text = @"--";
    }

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

-(void)adjustCurrentPkClassList
{
    NSMutableArray * wArr = [self.pkclass_list mutableCopy];
    for (int i = wArr.count - 1; i>=0; i--)
    {
        pkclass * wClass = [wArr objectAtIndex:i];
        int count = 0;
        if (mCurrentPdKind != 0)
        {
            NSString * query = [NSString stringWithFormat:@"where pkclass = '%@' and pdkind = '%d'",wClass.code,mCurrentPdKind];
            count = [plipdtm countByCriteria:query];
        }
        else 
        {
            NSString * query = [NSString stringWithFormat:@"where pkclass = '%@'",wClass.code];
            count = [plipdtm countByCriteria:query];
        }
        if(count == 0)
        {
            [wArr removeObject:wClass];
        }
    }
    self.currentPkClass_list = wArr;
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


@interface NSString(webTable)
-(NSString *) wrapTD;
-(NSString *) wrapTR;
-(NSString *) wrapTable;
@end

@implementation NSString (webTable)

-(NSString *) wrapTD
{
    return [NSString stringWithFormat:@"<td> %@ </td>",self];
}

-(NSString *) wrapTR
{
    return [NSString stringWithFormat:@"<td> %@ </td>",self];
}

- (NSString *)wrapTable
{
    return [NSString stringWithFormat:@"<table> %@ </table>",self];
}
@end
