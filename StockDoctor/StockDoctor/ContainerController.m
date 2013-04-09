//
//  ContainerController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-7.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "ContainerController.h"
#import "DiagnosisController.h"

@interface ContainerController ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) UINavigationController * naviController;
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

- (void)pushController:(UIViewController *)controller animated:(BOOL)animated
{
    [self.naviController pushViewController:controller animated:animated];
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

@end
