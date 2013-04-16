//
//  ContainerController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-7.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "ContainerController.h"
#import "DiagnosisController.h"
#import "SearchModel.h"

@interface ContainerController ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) UINavigationController * naviController;
@property (strong, nonatomic) IBOutlet UITabBar *tabBarView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *defaultLeftBar;
@end

@implementation ContainerController

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

- (void)hideTabBar:(bool)isHidden
{
    CGFloat yAxis = 0;
    CGFloat height = CGRectGetHeight(self.tabBarView.frame);
    
    if (isHidden)
    {
        yAxis = CGRectGetHeight(self.view.bounds) - height;
    }
    else
    {
        yAxis = CGRectGetHeight(self.view.bounds);
    }
    
    
    if (isHidden)
    {
        yAxis += height;
    }
    else
    {
        yAxis -= height;
    }

    self.tabBarView.hidden = isHidden;
    [self.bgView fixHeight:yAxis];
    [self.navigationController.view fixHeight:yAxis];

}

- (IBAction)onBackClick:(UIButton *)sender
{
    if (self.tabBarView.isHidden)
    {
        [self hideTabBar:false];
        [self.naviController popViewControllerAnimated:true];
        
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

- (void)switchViews:(int)index
{
    [self.naviController.view removeFromSuperview];
    
    GlacierController * contentController = nil;
    
    switch (index) {
        case 0:
            contentController = [[DiagnosisController alloc]init];
            break;
            
        default:
            break;
    }
    
    UINavigationController * navigation = [[UINavigationController alloc] initWithRootViewController:contentController];
    self.naviController = navigation;
    self.naviController.view.frame = self.bgView.bounds;
    [self.bgView addSubview:self.naviController.view];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 0)
    {
        
    }
}

- (void)viewDidUnload {
    [self setTabBarView:nil];
    [self setDefaultLeftBar:nil];
    [super viewDidUnload];
}
@end
