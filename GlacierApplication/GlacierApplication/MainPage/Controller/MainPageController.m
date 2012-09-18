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

@interface MainPageController ()

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
}
@synthesize amountTextField = _amountTextField;
@synthesize tableListView = _tableListView;
@synthesize pdKindButtonArr = _pdKindButtonArr;
@synthesize slider = _slider;
@synthesize birDayLabel = _birDayLabel;
@synthesize yearsOldLabel = _yearsOldLabel;
@synthesize insuranceNameLabel = _insuranceNameLabel;
@synthesize pdtYearButton = _pdtYearButton;
@synthesize resultWebView = _resultWebView;
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
    [_resultWebView release];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.currentPkClass_list.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return ((pkclass *) [self.currentPkClass_list objectAtIndex:section]).name;
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
    UITableViewCell * wCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!wCell) {
        wCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
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

    wCell.textLabel.text = ((plipdtm *)[[self.plipdtm_list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateStr]] objectAtIndex:indexPath.row]).pdpdtname;
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
    plipdtyear * pdtyear = ((plipdtyear *)[self.plipdtyear_list objectAtIndex:mCurrentPdtYearIndex]);
    
    long long amount = self.amountTextField.text.longLongValue;
    
    if ((pdtyear.pyminamt != 0 && amount < pdtyear.pyminamt)||(pdtyear.pymaxamt!=0 && amount > pdtyear.pymaxamt))
    {
        [self showAlertMsg:[NSString stringWithFormat:@"保额应在%d-%d之间",pdtyear.pyminamt,pdtyear.pymaxamt]];
        return;
    }
    if(!self.currentPli_pdt_m)
    {
        [self showAlertMsg:[NSString stringWithFormat:@"请选择先品种",pdtyear.pyminamt,pdtyear.pymaxamt]];
        return;
    }
    
    //获得年期
    int pdtYear = pdtyear.pypdtyear;
    NSString * query = [NSString stringWithFormat:@"where prpdtcode = '%@' and prage = '%d' and prpdtyear = %d and(prsales = 0 or prsales = %d) ",self.currentPli_pdt_m.pdpdtcode,mCurrentAge,pdtYear,mCurrentJobType];
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
        [self generateOutput:rate];
    }
    else 
    {
         [self.resultWebView loadHTMLString:@"无相关记录" baseURL:nil] ;
    }
    
}


- (void) generateOutput:(NSString *) rate
{
    long long resultAmount = self.amountTextField.text.intValue * rate.floatValue; 
    NSString * yearStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount] numberStyle:NSNumberFormatterDecimalStyle];
    NSString * halfYearStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount * 0.52] numberStyle:NSNumberFormatterDecimalStyle];
    NSString * quarterStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount * 0.262] numberStyle:NSNumberFormatterDecimalStyle];
    NSString * monthStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount * 0.088] numberStyle:NSNumberFormatterDecimalStyle];
     NSString * dayStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount / 365.0f] numberStyle:NSNumberFormatterDecimalStyle];
    NSString * output;
    if ([self.currentPli_pdt_m.pdonepay isEqualToString:@"1"]) 
    {
        output = [NSString stringWithFormat:@"每月应缴：%@ 元<br/>每季应缴：%@ 元<br/>每半年应缴：%@ 元<br/>每年应缴：%@ 元<br/>每日应缴：%@ 元<br/>躉繳保费：%@ 元",monthStr,quarterStr,halfYearStr,yearStr,yearStr,dayStr];
    }
    else 
    {
        output = [NSString stringWithFormat:@"每月应缴：%@ 元<br/>每季应缴：%@ 元<br/>每半年应缴：%@ 元<br/>每年应缴：%@ 元<br/>每日应缴：%@ 元",monthStr,quarterStr,halfYearStr,yearStr,dayStr];
    }
    
    [self.resultWebView loadHTMLString:output baseURL:nil];
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

-(NSString *) generateTD:(NSArray *) td_list
{
    NSMutableString * wMutStr = [NSMutableString stringWithCapacity:0];
    for (NSString * wStr in td_list)
    {
        [wMutStr appendFormat:@"<td>%@</td>",wStr];
    }
    return wMutStr;
}

-(NSString *) generateTR:(NSArray *) tr_list
{
    NSMutableString * wMutStr = [NSMutableString stringWithCapacity:0];
    for (NSString * wStr in tr_list)
    {
        [wMutStr appendFormat:@"<tr>%@</tr>",wStr];
    }
    return wMutStr;
}

@end
