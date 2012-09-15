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
@property (nonatomic,retain) NSArray * plipdtrate_list;
@property (nonatomic,retain) NSArray * plipdtyear_list;
@property (nonatomic,retain) plipdtm * currentPli_pdt_m;
@end

@implementation MainPageController
{
    bool mCurrentSex;
    int mCurrentJobType;
    int mCurrentAge;
    int mCurrentPdtYear;
}
@synthesize amountTextField = _amountTextField;
@synthesize slider = _slider;
@synthesize birDayLabel = _birDayLabel;
@synthesize yearsOldLabel = _yearsOldLabel;
@synthesize insuranceNameLabel = _insuranceNameLabel;
@synthesize resultTextView = _resultTextView;
@synthesize maleButton = _maleButton;
@synthesize femaleButton = _femaleButton;
@synthesize twDateFormatter = _twDateFormatter;
@synthesize plipdtm_list = _plipdtm_list;
@synthesize pkclass_list = _pkclass_list;
@synthesize plipdtrate_list = _plipdtrate_list;
@synthesize plipdtyear_list = _plipdtyear_list;
@synthesize currentPli_pdt_m = _currentPli_pdt_m;

- (void)dealloc {
    [_slider release];
    [_birDayLabel release];
    [_yearsOldLabel release];
    [_twDateFormatter release];
    [_insuranceNameLabel release];
    [_maleButton release];
    [_femaleButton release];
    [_amountTextField release];
    [_resultTextView release];
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
    [_slider setYearsOldMin:0 max:150];
    NSLog(@"aaa");
    self.plipdtm_list = [plipdtm findByCriteria:@""];
    self.pkclass_list = [pkclass findByCriteria:@""];
    NSLog(@"bbb");
    NSLog(@"111");
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
    [self setResultTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.pkclass_list.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return ((pkclass *) [self.pkclass_list objectAtIndex:section]).name;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    pkclass * wClass = [self.pkclass_list objectAtIndex:section];
    
    return [self.plipdtm_list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.pkclass == %@",wClass.code]].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"PliCell";
    UITableViewCell * wCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!wCell) {
        wCell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    pkclass * wClass = [self.pkclass_list objectAtIndex:indexPath.section];
    
    wCell.textLabel.text = ((plipdtm *)[[self.plipdtm_list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.pkclass == %@",wClass.code]] objectAtIndex:indexPath.row]).pdpdtname;
    return wCell;
}

#pragma mark - 
#pragma mark SKLSliderDelegate

- (void)yearsOldChanged:(NSInteger)yearsOld birDay:(NSDate *)birDayDate {
    _birDayLabel.text = [self.twDateFormatter stringFromDate:birDayDate];
    mCurrentAge = yearsOld;
    _yearsOldLabel.text = [NSString stringWithFormat:@"%d", yearsOld];
}

#pragma mark - 
#pragma mark 界面操作相关

- (IBAction)userClickMail:(id)sender {
    [self displayMailComposerSheet];
}

#pragma mark - 
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
    
    pkclass * wClass = [self.pkclass_list objectAtIndex:indexPath.section];
    
    self.currentPli_pdt_m = ((plipdtm *)[[self.plipdtm_list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.pkclass == %@",wClass.code]] objectAtIndex:indexPath.row]);
    self.insuranceNameLabel.text = self.currentPli_pdt_m.pdpdtname; 
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

- (void)showAlertMsg:(NSString *)msg {
    
    UIAlertView *wAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [wAlertView show];
    [wAlertView release];
}

- (IBAction)onPdtYearClick:(UIButton *)sender 
{
    mCurrentPdtYear = (mCurrentPdtYear + 1) % 2;
    switch (mCurrentPdtYear)
    {
        case 0:
            [sender setTitle:@"五年期" forState:UIControlStateNormal];
            break;
        case 1:
            [sender setTitle:@"十五年期" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (IBAction)onSexClick:(UIButton *)sender
{
    mCurrentSex = (bool)sender.tag;
    self.maleButton.selected = !mCurrentSex;
    self.femaleButton.selected = mCurrentSex;
}

- (IBAction)onJobTypeClick:(UIButton *)sender 
{
    mCurrentJobType = (mCurrentJobType + 1) % 2;
    switch (mCurrentJobType)
    {
        case 0:
            [sender setTitle:@"第一类别" forState:UIControlStateNormal];
            break;
        case 1:
            [sender setTitle:@"第二类别" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (IBAction)onCalculateClick:(UIButton *)sender 
{
    NSString * query = [NSString stringWithFormat:@"where prpdtcode = '%@' and prage = '%d'",self.currentPli_pdt_m.pdpdtcode,mCurrentAge];
    NSArray * reslutArr = [plipdtrate findByCriteria:query];
    NSString * rate = nil;
    plipdtrate * plir = nil;
    if (reslutArr.count > 0) 
    {
       plir  = [reslutArr objectAtIndex:0];
    }
    
    if (plir)
    {
        if (mCurrentSex)
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
         self.resultTextView.text = @"无相关记录";
    }
    
}


- (void) generateOutput:(NSString *) rate
{
    long long resultAmount = self.amountTextField.text.intValue * rate.floatValue; 
    NSString * yearStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount] numberStyle:NSNumberFormatterDecimalStyle];
    NSString * halfYearStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount * 0.52] numberStyle:NSNumberFormatterDecimalStyle];
    NSString * quarterStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount * 0.262] numberStyle:NSNumberFormatterDecimalStyle];
    NSString * monthStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount * 0.088] numberStyle:NSNumberFormatterDecimalStyle];
    NSString * output = [NSString stringWithFormat:@"每月应缴：%@ 元\r\n每季应缴：%@ 元\r\n每半年应缴：%@ 元\r\n每年应缴：%@ 元\r\n",monthStr,quarterStr,halfYearStr,yearStr];
    self.resultTextView.text = output;
}
@end
