//
//  SettingController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-16.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "SettingController.h"
#import "SinaWeiboManager.h"

@interface SettingController ()

@property (strong, nonatomic) IBOutlet UITableView *settingTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *weiboCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *aboutCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *commentCell;
@property (nonatomic,strong) NSArray * modelList;
@property (strong, nonatomic) IBOutlet UILabel *weiboLabel;
@property (strong, nonatomic) IBOutlet UIButton *weiboButton;
@end

@implementation SettingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
        self.modelList = @[@{@"分享设置": @[@"新浪微博"]} ,@{@"其他": @[@"关于股票医生",@"给个好评"]} ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [SinaWeiboManager instance].delegate = self;
}

- (void)dealloc
{
    if ([SinaWeiboManager instance].delegate == self)
    {
        [SinaWeiboManager instance].delegate = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.modelList.count;
}

- (IBAction)onWeiboClick:(UIButton *)sender
{
    if ([[SinaWeiboManager instance] isAuth])
    {
        [[SinaWeiboManager instance] doLogout];
    }
    else
    {
        [[SinaWeiboManager instance] doLogin];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary * dict = self.modelList[section];
    return dict.allKeys[0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary * dict = self.modelList[section];
    
    return [dict.allValues[0] count];
}

#define cellIn(s,r) (indexPath.section == s && indexPath.row == r)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (cellIn(0, 0))
    {
        if ([[SinaWeiboManager instance] isAuth])
        {
            self.weiboLabel.text = @"新浪微博已绑定";
            [self.weiboButton setTitle:@"解除绑定" forState:(UIControlStateNormal)];
        }
        else
        {
            self.weiboLabel.text = @"绑定微博";
            [self.weiboButton setTitle:@"绑定" forState:(UIControlStateNormal)];
        }
        return self.weiboCell;
    }
    else if (cellIn(1, 0))
    {
        return self.aboutCell;
    }
    else if(cellIn(1, 1))
    {
        return self.commentCell;
    }
    else
    {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (cellIn(0, 0))
    {
        [[SinaWeiboManager instance] doLogin];
    }
    else if (cellIn(1, 0))
    {
//        [[SinaWeiboManager instance] userInfo:self];
    }
}

#pragma marks weibo delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self.settingTableView reloadData];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
  [self.settingTableView reloadData];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    [self.settingTableView reloadData];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
   [self.settingTableView reloadData];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    [self.settingTableView reloadData];
}

- (void)viewDidUnload {
    [self setWeiboCell:nil];
    [self setAboutCell:nil];
    [self setCommentCell:nil];
    [self setWeiboLabel:nil];
    [self setWeiboButton:nil];
    [self setSettingTableView:nil];
    [super viewDidUnload];
}
@end
