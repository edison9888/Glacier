//
//  DiagnosisController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-7.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "DiagnosisController.h"
#import "SearchStockController.h"
#import "SearchModel.h"
#import "DetailController.h"
#import "SinaBaseDataModel.h"
#import "DiagnosisCell.h"

@interface DiagnosisController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@property (strong, nonatomic) NSArray * modelList;
@property (strong, nonatomic) NSArray * sinaDataList;
@property (strong, nonatomic) IBOutlet UITableView *stockTableView;
@end

@implementation DiagnosisController

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
    self.title = @"自选股诊断";
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
}



- (void)viewWillAppear:(BOOL)animated
{
    self.modelList = [SearchModel selectAll];
    NSString * url = @"http://hq.sinajs.cn/list=%@";
    [self doHttpRequest:[NSString stringWithFormat:url,[SearchModel composeUrlForCodes:self.modelList]]];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSArray * respArr = [SinaBaseDataModel extractModelList:request.responseString];
    self.sinaDataList = respArr;
    [self.stockTableView reloadData];
}

- (IBAction)onAddStock:(UIButton *)sender
{
    SearchStockController * searchController = [[SearchStockController alloc]init];
    [[ContainerController instance]pushController:searchController animated:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idStr = @"SearchCell";
    DiagnosisCell * cell = [tableView dequeueReusableCellWithIdentifier:idStr];
    if (!cell)
    {
        cell = [[NSBundle mainBundle]loadNibNamed:@"DiagnosisCell" owner:nil options:nil][0];
    }
    SearchModel * model = self.modelList[indexPath.row];
    cell.stockCodeLabel.text = model.shortCode;
    cell.stockNameLabel.text = model.shortName;
    
    [self.sinaDataList each:^(SinaBaseDataModel * sender)
    {
        if ([sender.fullCode isEqualToString:model.fullCode])
        {
            cell.priceLabel.text = sender.currentPrice;
            cell.changLabel.text = sender.change;
            if (sender.changeState > 0)
            {
                cell.changLabel.textColor = [UIColor redColor];
            }
            else if (sender.changeState < 0)
            {
                cell.changLabel.textColor = [UIColor greenColor];
            }
            else
            {
                cell.changLabel.textColor = [UIColor darkGrayColor];
            }
        }
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailController * detailController = [[DetailController alloc]init];
    SearchModel * model = self.modelList[indexPath.row];
    detailController.searchModel = model;
    [[ContainerController instance]pushController:detailController animated:true];
}

@end
