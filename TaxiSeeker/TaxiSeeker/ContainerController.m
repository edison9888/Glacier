//
//  ContainerController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-7.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "ContainerController.h"
#import "GlaSegmentedControl.h"
#import "TabButton.h"
#import "HomePageController.h"
#define AnimationTime 0.35f
#define BarAniTime 0.2f

@interface ContainerController ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) UINavigationController * naviController;
@property (strong, nonatomic) IBOutlet GlaSegmentedControl *tabBarView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *defaultLeftBar;
@property (strong, nonatomic) UIViewController * presentController;
@property (strong, nonatomic) IBOutlet UIImageView *bgImg;
@property (strong, nonatomic) UIView * presentBgView;

@property (nonatomic, strong) NSArray * normalTabImgList;
@property (nonatomic, strong) NSArray * selectedTabImgList;
@property (nonatomic, strong) NSArray * tabTitleList;
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
        self.normalTabImgList = @[@"home.png",@"taxicard.png",@"taxicard.png",@"mydir.png",@"more.png",];
        self.selectedTabImgList = @[@"home2.png",@"taxicard2.png",@"taxicard2.png",@"mydir2.png",@"more2.png",];
        self.tabTitleList = @[@"Index",@"GroupBuy",@"TaxiCard",@"MyDir",@"More"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden = false;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    _tabBarView.delegate = self;
    [self initDatabase];
   
    UIImageView * tabBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navbg.png"]];
    _tabBarView.backgrondView = tabBG;
    [_tabBarView initButtons];
    [self switchViews:0];
}

#pragma mark Segments delegate

- (NSUInteger)numForSegments
{
    return 5;
}

- (UIControl *)buttonForIndex:(NSUInteger)index
{
    TabButton * btn = [[NSBundle mainBundle]loadNibNamed:@"TabButton" owner:nil options:nil][0];
    [btn.imgBar setImage:[UIImage imageNamed:self.normalTabImgList[index]]];
    [btn.imgBar setHighlightedImage:[UIImage imageNamed:self.selectedTabImgList[index]]];
    btn.textLabel.text = self.tabTitleList[index];
    return btn;
}

- (void)onChangeState:(id)button index:(NSUInteger)index selected:(BOOL)isSelected
{
    TabButton * btn = button;
    
    if (isSelected) {
        [btn.imgBar setImage:[UIImage imageNamed:self.selectedTabImgList[index]]];
        [btn.imgBar setHighlightedImage:[UIImage imageNamed:self.normalTabImgList[index]]];
        btn.textLabel.textColor = [UIColor whiteColor];
        btn.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    }
    else
    {
        [btn.imgBar setImage:[UIImage imageNamed:self.normalTabImgList[index]]];
        [btn.imgBar setHighlightedImage:[UIImage imageNamed:self.selectedTabImgList[index]]];
        btn.textLabel.textColor = [UIColor lightGrayColor];
        btn.textLabel.highlightedTextColor = [UIColor whiteColor];
    }
}

#pragma mark init Database

- (void)initDatabase
{
    
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
            contentController = [[HomePageController alloc]init];
            break;
//        case 1:
//            contentController = [[ChooseStocksController alloc]init];
//            break;
//        case 2:
//            contentController = [[SettingController alloc]init];
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

- (void)onSegmentChange:(NSUInteger)index
{
    if (_tabIndex != index)
    {
        [self switchViews:index];
        _tabIndex = index;
    }
    
}

- (void)viewDidUnload {
    [self setTabBarView:nil];
    [self setDefaultLeftBar:nil];
    [self setBgImg:nil];
    [super viewDidUnload];
}
@end

NSURL * strToURL(NSString * str)
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUEST_SHANGHAI_DIR_URL,str]];
}


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
