//
//  HomeController.m
//  GlacierApplication
//
//  Created by chang liang on 12-7-15.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "HomeController.h"
@interface MyController : GlacierController

@end

@implementation MyController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end

@interface HomeController ()

@end

@implementation HomeController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.title = @"主页";
    MyController * wCo = [[MyController alloc]init];
    wCo.view.frame = self.view.bounds;
    wCo.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:wCo animated:false];
    [self doHttpRequest:@"http://www.baidu.com"];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request responseString]);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
@end


