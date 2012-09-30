//
//  MainPageController.h
//  GlacierApplication
//
//  Created by chang liang on 12-9-12.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "GlacierController.h"
#import <MessageUI/MessageUI.h>
#import "SKLSlider.h"
#import "PopDateController.h"
#import "PopComboController.h"

@interface MainPageController : GlacierController <MFMailComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UITabBarDelegate,PopDateDelegate,PopComboDelegate>
@property (retain, nonatomic) IBOutlet UILabel *jobTypeLabel;
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
- (IBAction)onCalculateClick:(UIButton *)sender;
- (IBAction)onBirthdayClick:(UIButton *)sender;
- (IBAction)onPdkindClick:(UIButton *)sender;
- (IBAction)onPdtYearClick:(UIButton *)sender;
- (IBAction)onSexClick:(UIButton *)sender;
- (IBAction)onJobTypeClick:(UIButton *)sender;
@end
