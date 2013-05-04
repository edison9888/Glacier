//
//  ContainerController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-7.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "ContainerController.h"
#import "DiagnosisController.h"
#import "ChooseStocksController.h"
#import "SettingController.h"
#import "SearchModel.h"
#import "STSegmentedControl.h"
#define AnimationTime 0.35f
#define BarAniTime 0.2f

@interface UINavigationBar(Custom)

@end

@implementation UINavigationBar(Custom)

- (void)drawRect:(CGRect)rect {
    if (![self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [super drawRect:rect];
        UIImage *wImage = [UIImage imageNamed:@"topbar.png"];

        [wImage drawInRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
            [self setBackgroundImage:[UIImage imageNamed:@"topbar.png"] forBarMetrics:UIBarMetricsDefault];
    }
}

@end


@interface ContainerController ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) UINavigationController * naviController;
@property (strong, nonatomic) IBOutlet STSegmentedControl *tabBarView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *defaultLeftBar;
@property (strong, nonatomic) UIViewController * presentController;
@property (strong, nonatomic) IBOutlet UIImageView *bgImg;
@property (strong, nonatomic) UIView * presentBgView;
@end

@implementation ContainerController
{
    int _tabIndex;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tabIndex = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden = false;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    
    
    self.tabBarView.segments = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
    [self.tabBarView addTarget:self action:@selector(onSwitchTab:) forControlEvents:UIControlEventValueChanged];
    [self.tabBarView setNormalImageLeft:[UIImage imageNamed:@"zixuangu01.png"]];
    [self.tabBarView setSelectedImageLeft:[UIImage imageNamed:@"zixuangu02.png"]];
    [self.tabBarView setNormalImageMiddle:[UIImage imageNamed:@"xuangu01.png"]];
    [self.tabBarView setSelectedImageMiddle:[UIImage imageNamed:@"xuangu02.png"]];
    [self.tabBarView setNormalImageRight:[UIImage imageNamed:@"shezhi01.png"]];
    [self.tabBarView setSelectedImageRight:[UIImage imageNamed:@"shezhi02.png"]];
    self.tabBarView.selectedSegmentIndex = 0;
    [self initDatabase];
}

- (void)initDatabase
{
    [SearchModel checkOrCreateTable];
    [SearchModel checkOrCreateTableForSearch];
}

+ (ContainerController *)instance
{
    static ContainerController * _instance;
    if (!_instance)
    {
        _instance = [[ContainerController alloc]init];
    }
    return _instance;
}

- (IBAction)onBackClick:(UIButton *)sender
{
    if (self.tabBarView.hidden)
    {
        
        CGFloat contentHeight = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.tabBarView.bounds);
       
        self.tabBarView.hidden = false;
        
        [self.naviController popViewControllerAnimated:true];
        [UIView animateWithDuration:AnimationTime animations:^{
            [self.tabBarView fixY:contentHeight];
        } completion:^(BOOL finished) {
            [self.naviController.view fixHeight:contentHeight];
        }];
    }
    else
    {
        [self.naviController popViewControllerAnimated:true];
    }
}

- (void)hideTabAndPresentView:(UIView *)view
{
    if (!self.tabBarView.hidden)
    {
        CGFloat contentHeight = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.tabBarView.bounds);
        self.tabBarView.hidden = false;
        [UIView animateWithDuration:BarAniTime animations:^{
            [self.tabBarView fixY:CGRectGetHeight(self.view.bounds)];
        } completion:^(BOOL finished) {
            [self.view addSubview:view];
            self.tabBarView.hidden = true;
            view.frame = self.tabBarView.frame;
            [UIView animateWithDuration:BarAniTime animations:^{
                [view fixY:contentHeight];
            }];
        }];
    }
}

- (void)dissmisViewAndShowTab:(UIView *)view
{
    if (self.tabBarView.hidden)
    {
        CGFloat contentHeight = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.tabBarView.bounds);
        [UIView animateWithDuration:BarAniTime animations:^{
            [view fixY:CGRectGetHeight(self.view.bounds)];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            self.tabBarView.hidden = false;
            [self.tabBarView fixY:CGRectGetHeight(self.view.bounds)];
            [UIView animateWithDuration:BarAniTime animations:^{
                [self.tabBarView fixY:contentHeight];
            }];
        }];
    }
}

- (void)pushController:(UIViewController *)controller animated:(BOOL)animated
{
     [self.naviController pushViewController:controller animated:animated];
    [controller.navigationItem hidesBackButton];
    controller.navigationItem.leftBarButtonItem = self.defaultLeftBar;
}

- (void)pushControllerHideTab:(UIViewController *)controller animated:(BOOL)animated
{
    [self.naviController.view fixHeight:CGRectGetHeight(self.view.bounds)];
    [self.naviController pushViewController:controller animated:animated];
    [controller.navigationItem hidesBackButton];
    controller.navigationItem.leftBarButtonItem = self.defaultLeftBar;
    
    [UIView animateWithDuration:AnimationTime animations:^{
        [self.tabBarView fixY:CGRectGetHeight(self.view.bounds)];
    } completion:^(BOOL finished) {
        self.tabBarView.hidden = true;
    }];
}

- (void)presentControllerFromButtom:(UIViewController *)controller
{
    self.presentController = controller;
    UIView * view = [[UIView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:view];
    self.presentBgView = view;
    
    controller.view.frame = self.view.bounds;
    [controller.view fixY:CGRectGetHeight(self.view.bounds)];
    [self.view addSubview:controller.view];
    [UIView animateWithDuration:0.5 animations:^{
        [controller.view fixY:0];
    }];
}

- (void)dismissControllerFromButtom
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.presentController.view fixY:CGRectGetHeight(self.view.bounds)];
    } completion:^(BOOL finished) {
        [self.presentBgView removeFromSuperview];
        self.presentBgView = nil;
        [self.presentController.view removeFromSuperview];
        self.presentController = nil;
    }];
}

- (void)switchViews:(int)index
{
    [self.naviController.view removeFromSuperview];
    
    GlacierController * contentController = nil;
    
    switch (index) {
        case 0:
            contentController = [[DiagnosisController alloc]init];
            break;
        case 1:
            contentController = [[ChooseStocksController alloc]init];
            break;
        case 2:
            contentController = [[SettingController alloc]init];
            break;
        default:
            break;
    }
    
    UINavigationController * navigation = [[UINavigationController alloc] initWithRootViewController:contentController];
    self.naviController = navigation;
    self.naviController.view.frame = self.bgView.bounds;
    [self.view addSubview:self.naviController.view];
    [self.view sendSubviewToBack:self.naviController.view];
    [self.view sendSubviewToBack:self.bgImg];
}

- (void)onSwitchTab:(STSegmentedControl *)sender
{
    if (_tabIndex != sender.selectedSegmentIndex)
    {
        [self switchViews:sender.selectedSegmentIndex];
        _tabIndex = sender.selectedSegmentIndex;
    }
    
}

- (void)viewDidUnload {
    [self setTabBarView:nil];
    [self setDefaultLeftBar:nil];
    [self setBgImg:nil];
    [super viewDidUnload];
}
@end
