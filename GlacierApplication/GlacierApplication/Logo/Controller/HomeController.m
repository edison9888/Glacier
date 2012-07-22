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
    for (int i = 0; i<1000; i++) 
    {
        [self doHttpRequest:@"http://www.baidu.com" userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:i] forKey:@"key"]];
        NSLog(@"start %d",i);
    }
}



- (void)dealloc
{
    NSLog(@"dealloc");
    [super dealloc];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString * str = [request responseString];
    NSLog(@"%@",str);
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
    [wCo release];
   
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
@end


