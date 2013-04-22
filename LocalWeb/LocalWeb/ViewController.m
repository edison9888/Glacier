//
//  ViewController.m
//  LocalWeb
//
//  Created by cnzhao on 13-4-22.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
    
    NSBundle* bundle = [NSBundle mainBundle];
    
    NSString* resPath = [bundle pathForResource:@"web" ofType:@"bundle"];
    
    NSBundle * web = [NSBundle bundleWithPath:resPath];
    
    NSString *path = [[web bundlePath] stringByAppendingString:@"/easyui/demo/datagrid/basic.html"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: path]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
