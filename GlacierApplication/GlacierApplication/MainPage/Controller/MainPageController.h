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

@interface MainPageController : GlacierController <MFMailComposeViewControllerDelegate, SKLSliderDelegate,UITableViewDataSource,UITableViewDelegate>
- (IBAction)onCalculateClick:(UIButton *)sender;

@property (retain, nonatomic) IBOutlet UITableView *tableListView;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *pdKindButtonArr;
@property (retain, nonatomic) IBOutlet SKLSlider *slider;
@property (retain, nonatomic) IBOutlet UILabel *birDayLabel;
@property (retain, nonatomic) IBOutlet UILabel *yearsOldLabel;
@property (retain, nonatomic) IBOutlet UILabel *insuranceNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *pdtYearButton;
- (IBAction)onPdkindClick:(UIButton *)sender;

@property (retain, nonatomic) IBOutlet UITextView *resultTextView;
@property (retain, nonatomic) IBOutlet UIButton *maleButton;
@property (retain, nonatomic) IBOutlet UIButton *femaleButton;
- (IBAction)onPdtYearClick:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UITextField *amountTextField;

- (IBAction)onSexClick:(UIButton *)sender;
- (IBAction)onJobTypeClick:(UIButton *)sender;
@end
