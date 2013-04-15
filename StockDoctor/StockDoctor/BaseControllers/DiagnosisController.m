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
@property (strong, nonatomic) NSMutableArray * modelList;
@property (strong, nonatomic) NSArray * sinaDataList;
@property (strong, nonatomic) IBOutlet UITableView *stockTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftBarButtonItem;
@property (strong, nonatomic) NSMutableArray * deleteList;
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
    self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
    self.deleteList = [NSMutableArray array];
}



- (void)viewWillAppear:(BOOL)animated
{
    [self refreshData];
}

- (void)refreshData
{
    self.modelList = [NSMutableArray arrayWithArray:[SearchModel selectAll]];
     [self.stockTableView reloadData];
    if (self.modelList.count > 0)
    {
        NSString * url = @"http://hq.sinajs.cn/list=%@";
        [self doHttpRequest:[NSString stringWithFormat:url,[SearchModel composeUrlForCodes:self.modelList]]];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSArray * respArr = [SinaBaseDataModel extractModelList:request.responseString];
    self.sinaDataList = respArr;
    [self.stockTableView reloadData];
}

- (IBAction)onAddStock:(UIButton *)sender
{
    [self.stockTableView setEditing:false];
    SearchStockController * searchController = [[SearchStockController alloc]init];
    [[ContainerController instance]pushController:searchController animated:true];
}

- (IBAction)onEditSelfStock:(UIButton *)sender
{
   
    if (self.stockTableView.editing)
    {
        [sender setTitle:@"编辑" forState:(UIControlStateNormal)];
        [self deleteStocks];
        [self.stockTableView setEditing:false animated:true];
    }
    else
    {
        [self.deleteList removeAllObjects];
        [sender setTitle:@"完成" forState:(UIControlStateNormal)];
        [self.stockTableView setEditing:true animated:true];
    }
    
}

- (void)deleteStocks
{
    NSMutableArray * deleteArr = [NSMutableArray array];
    for (int i = 0; i < self.deleteList.count; i++)
    {
        NSIndexPath * index = self.deleteList[i];
        SearchModel * model = self.modelList[index.row];
        [model deleteSelf];
        [deleteArr addObject:model];
    }
    
    [self.modelList removeObjectsInArray:deleteArr];
    
    [self.stockTableView deleteRowsAtIndexPaths:self.deleteList withRowAnimation:(UITableViewRowAnimationLeft)];
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
    if (self.stockTableView.editing)
    {
        [self.deleteList addObject:indexPath];
    }
    else
    {
        DetailController * detailController = [[DetailController alloc]init];
        SearchModel * model = self.modelList[indexPath.row];
        detailController.searchModel = model;
        [[ContainerController instance]pushController:detailController animated:true];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.stockTableView.editing)
    {
        for (int i = self.deleteList.count - 1; i>= 0; i--)
        {
            NSIndexPath * path = self.deleteList[i];
            if (path.row == indexPath.row)
            {
                [self.deleteList removeObject:path];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    SearchModel * from = self.modelList[sourceIndexPath.row];
    SearchModel * to = self.modelList[destinationIndexPath.row];
    int temp = to.sortIndex;
    to.sortIndex = from.sortIndex;
    from.sortIndex = temp;
    [[SharedApp FMDatabaseQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [from updateSortIndex:db];
        [to updateSortIndex:db];
    }];
}
@end
