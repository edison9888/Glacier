//
//  AboutUsController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-21.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "AboutUsController.h"

static bool isFollowed;

@interface AboutUsController ()
@property (strong, nonatomic) IBOutlet UIButton *followButton;

@end

@implementation AboutUsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"关于股票医生";
    if (isFollowed)
    {
        [self changeButton];
    }
}

- (IBAction)onFollowUs:(UIButton *)sender
{
    if ([[SinaWeiboManager instance] isAuth])
    {
        [[SinaWeiboManager instance] followUser:@"2176714680" receiver:self]; //关注股票医生
    }
    else
    {
         [[SinaWeiboManager instance] doLogin];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
    
    NSDictionary * dict = result;
    NSNumber * errorCode = dict[@"error_code"];
    if (!errorCode)
    {
        [[MTStatusBarOverlay sharedInstance] postFinishMessage:@"关注成功" duration:3];
        isFollowed = true;
        [self changeButton];
    }
    else if(errorCode.intValue == 20506)
    {
        [[MTStatusBarOverlay sharedInstance] postErrorMessage:@"关注失败，可能已经添加关注" duration:3];
         isFollowed = true;
        [self changeButton];
    }
    else
    {
         [[MTStatusBarOverlay sharedInstance] postErrorMessage:@"关注失败" duration:3];
    }
}

- (void)changeButton
{
    self.followButton.enabled = false;
    [self.followButton setBackgroundImage:[UIImage imageNamed:@"button2"] forState:(UIControlStateNormal)];
    [self.followButton setTitle:@"已关注股票医生微博" forState:(UIControlStateNormal)];
}

- (void)viewDidUnload {
    [self setFollowButton:nil];
    [super viewDidUnload];
}
@end
