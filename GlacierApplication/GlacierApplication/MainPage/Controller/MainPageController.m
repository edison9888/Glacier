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
#import "UIView+SKLCurrentImage.h"

@interface MainPageController ()

- (void)displayMailComposerSheet;
- (void)showAlertMsg:(NSString *)msg;

@property (nonatomic, readonly) NSDateFormatter *twDateFormatter;
@property (nonatomic,retain) NSMutableArray * plipdtm_list;
@property (nonatomic,retain) NSMutableArray * pkclass_list;
@end

@implementation MainPageController
{
    
}
@synthesize slider = _slider;
@synthesize birDayLabel = _birDayLabel;
@synthesize yearsOldLabel = _yearsOldLabel;
@synthesize twDateFormatter = _twDateFormatter;
@synthesize plipdtm_list = _plipdtm_list;
@synthesize pkclass_list = _pkclass_list;

- (void)dealloc {
    [_slider release];
    [_birDayLabel release];
    [_yearsOldLabel release];
    [_twDateFormatter release];
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

    self.plipdtm_list = [plipdtm findByCriteria:@""];
    self.pkclass_list = [pkclass findByCriteria:@""];
}

- (void)viewDidUnload
{
    [self setSlider:nil];
    [self setBirDayLabel:nil];
    [self setYearsOldLabel:nil];
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
@end
