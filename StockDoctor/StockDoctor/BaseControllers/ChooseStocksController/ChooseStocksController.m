//
//  ChooseStocksController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-16.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "ChooseStocksController.h"
#import "ChooseCell.h"
#import "ChooseStockModel.h"
#import "DetailController.h"

@interface ChooseStocksController ()
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UITableView *stockTableView;
@property (strong, nonatomic) NSMutableDictionary * modelDict;
@property (strong, nonatomic) NSArray * titlesList;
@property (strong, nonatomic) IBOutlet UILabel *indicatorName;
@property (strong, nonatomic) NSArray * nameList;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightBar;
@end

@implementation ChooseStocksController
{
    int mSelectedIndex;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"智能选股";
        self.titlesList = @[@"huoyue",@"qianli",@"renqi"];
        self.nameList = @[@"换手率",@"上涨概率",@"人气"];
        self.modelDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.rightBar;
    [self requestForStocks:0];
}

- (IBAction)onTabClick:(UISegmentedControl *)sender
{
    mSelectedIndex = sender.selectedSegmentIndex;
    [self.stockTableView reloadData];
    [self requestForStocks:mSelectedIndex];
    self.indicatorName.text = self.nameList[mSelectedIndex];
}

- (IBAction)onRefreshClick:(UIButton *)sender
{
    [self.stockTableView reloadData];
    [self requestForStocks:mSelectedIndex];
    self.indicatorName.text = self.nameList[mSelectedIndex];
}

- (NSArray *) selectedModel
{
    return self.modelDict[@(mSelectedIndex)];
}

- (void)requestForStocks:(int)index
{
    NSString * url = @"http://www.9pxdesign.com/%@.php";
    
    url = [NSString stringWithFormat:url,self.titlesList[index]];
    
    [self doHttpRequest:url tag:index];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == mSelectedIndex)
    {
        NSArray * arr = [request.responseString objectFromJSONString];
        
        NSArray * modelArr = [ChooseStockModel parseChooseStockModels:arr tag:mSelectedIndex];
        [self.modelDict setObject:modelArr forKey:@(mSelectedIndex)];
        
        [self.stockTableView reloadData];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self selectedModel].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGRectGetHeight(self.headerView.bounds);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idStr = @"ChooseCell";
    ChooseCell * cell = [tableView dequeueReusableCellWithIdentifier:idStr];
    if (!cell)
    {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ChooseCell" owner:nil options:nil][0];
    }
    
    ChooseStockModel * model = [self selectedModel][indexPath.row];
    
    cell.nameLabel.text = model.name;
    cell.codeLabel.text = model.shortCode;
    if (mSelectedIndex == 1) {
        cell.indicatorLabel.text = [NSString stringWithFormat:@"%@%%", model.indicator ];
    }
    else
    {
        cell.indicatorLabel.text = model.indicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseStockModel * model = [self selectedModel][indexPath.row];
    DetailController * detailController = [[DetailController alloc]init];
    detailController.searchModel = [model generateSearchModel];
    [[ContainerController instance] pushControllerHideTab:detailController animated:true];
}

- (void)viewDidUnload {
    [self setHeaderView:nil];
    [self setIndicatorName:nil];
    [self setRightBar:nil];
    [super viewDidUnload];
}
@end
