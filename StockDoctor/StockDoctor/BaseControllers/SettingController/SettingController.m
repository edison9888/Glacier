//
//  SettingController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-16.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "SettingController.h"

@interface SettingController ()
@property (strong, nonatomic) NSArray * modelList;
@end

@implementation SettingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
        self.modelList = @[@{@"分享设置": @[@"新浪微博"]} ,@{@"其他": @[@"关于股票医生",@"给个好评"]} ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.modelList.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary * dict = self.modelList[section];
    return dict.allKeys[0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary * dict = self.modelList[section];
    
    return [dict.allValues[0] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idStr = @"SearchCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idStr];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:idStr];
    }
    NSDictionary * dict = self.modelList[indexPath.section];
    cell.textLabel.text = dict.allValues[0][indexPath.row];
    return cell;
}


@end
