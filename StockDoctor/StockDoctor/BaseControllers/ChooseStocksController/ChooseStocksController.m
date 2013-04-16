//
//  ChooseStocksController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-16.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "ChooseStocksController.h"

@interface ChooseStocksController ()
@property (strong, nonatomic) IBOutlet UITableView *stockTableView;
@property (strong, nonatomic) NSArray * modelList;
@end

@implementation ChooseStocksController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"智能选股";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestForStocks:0];
}

- (void)requestForStocks:(int)index
{
    NSArray * suffix = @[@"huoyue",@"qianli",@"renqi"];
    NSString * url = @"http://www.9pxdesign.com/%@.php";
    
    url = [NSString stringWithFormat:url,suffix[index]];
    
    [self doHttpRequest:url tag:index];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSArray * arr = [request.responseString objectFromJSONString];
    self.modelList = arr;
    [self.stockTableView reloadData];
}

- (IBAction)onTabClick:(UISegmentedControl *)sender
{
    [self requestForStocks:sender.selectedSegmentIndex];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idStr = @"SearchCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idStr];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:idStr];
    }
    cell.textLabel.text = self.modelList[indexPath.row][@"name"];
    return cell;
}

@end
