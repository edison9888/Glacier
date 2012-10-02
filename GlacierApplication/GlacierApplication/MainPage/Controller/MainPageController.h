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
#import "ProductCell.h"
#import "ProductSectionView.h"

@interface MainPageController : GlacierController <MFMailComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UITabBarDelegate,PopDateDelegate,PopComboDelegate,SectionClickDelegate>

- (IBAction)onCalculateClick:(UIButton *)sender;
- (IBAction)onBirthdayClick:(UIButton *)sender;
- (IBAction)onPdkindClick:(UIButton *)sender;
- (IBAction)onPdtYearClick:(UIButton *)sender;
- (IBAction)onSexClick:(UIButton *)sender;
- (IBAction)onJobTypeClick:(UIButton *)sender;
@end
