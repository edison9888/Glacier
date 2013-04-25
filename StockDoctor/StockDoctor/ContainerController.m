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
#define AnimationTime 0.35f

@interface ContainerController ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) UINavigationController * naviController;
@property (strong, nonatomic) IBOutlet UITabBar *tabBarView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *defaultLeftBar;
@property (strong, nonatomic) UIViewController * presentController;
@end

@implementation ContainerController
{
    int _tabIndex;
}

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
    [SearchModel checkOrCreateTable];
    [SearchModel checkOrCreateTableForSearch];
    self.tabBarView.selectedItem = self.tabBarView.items[0];
    [self switchViews:0];
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
//    [self.view bringSubviewToFront:self.tabBarView];
    [UIView animateWithDuration:AnimationTime animations:^{
        [self.tabBarView fixY:CGRectGetHeight(self.view.bounds)];
    } completion:^(BOOL finished) {
        self.tabBarView.hidden = true;
    }];
}

- (void)presentControllerFromButtom:(UIViewController *)controller
{
    self.presentController = controller;
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
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (_tabIndex != item.tag)
    {
        [self switchViews:item
         .tag];
        _tabIndex = item.tag;
    }
    
}

- (void)viewDidUnload {
    [self setTabBarView:nil];
    [self setDefaultLeftBar:nil];
    [super viewDidUnload];
}
@end
