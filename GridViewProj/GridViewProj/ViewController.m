//
//  ViewController.m
//  GridViewProj
//
//  Created by cnzhao on 13-3-25.
//  Copyright (c) 2013年 cnzhao. All rights reserved.
//

#import "ViewController.h"
#import "MGridView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	MGridView * grid = [[NSBundle mainBundle]loadNibNamed:@"MGridView" owner:nil options:nil][0];
    grid.frame = self.view.bounds;
    [self.view addSubview:grid];
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < 6; i++)
    {
        NSMutableArray * column = [NSMutableArray array];
        for (int j = 0; j < 200; j++)
        {
            [column addObject:[NSString stringWithFormat:@"--r:%d--c:%d--",j,i]];
        }
        [arr addObject:column];
    }
    grid.dataSource = arr;
    [grid reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
