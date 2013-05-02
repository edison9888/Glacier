//
//  SearchStockController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-7.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "SearchStockController.h"
#import "SearchModel.h"
#import "DetailController.h"
#import "SearchCell.h"

@interface SearchStockController ()
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (nonatomic,strong) NSArray * modelList;
@property (nonatomic,strong) NSArray * selfStocksModelList;
@property (strong, nonatomic) IBOutlet UITextField *textFieldForSearch;
@end

@implementation SearchStockController

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
    self.title = @"添加股票";
    self.selfStocksModelList = [SearchModel selectAll];
    self.modelList = [SearchModel selectAllForSearch];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.textFieldForSearch becomeFirstResponder];
}

- (IBAction)onSearchTextChanged:(UITextField *)sender
{
    if (sender.text.length <= 0)
    {
        self.modelList = [SearchModel selectAllForSearch];
        [self.searchTableView reloadData];
    }
    else
    {
        [self doHttpRequest:[NSString stringWithFormat:@"http://suggest3.sinajs.cn/suggest/type=11,12,13,14,15&key=%@&name=stock",sender.text]];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    self.modelList = [SearchModel extractModelList:request.responseString];
    [self.searchTableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return false;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idStr = @"SearchCell";
    SearchCell * cell = [tableView dequeueReusableCellWithIdentifier:idStr];
    if (!cell)
    {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SearchCell" owner:nil options:nil][0];
    }
    SearchModel * model = self.modelList[indexPath.row];
    cell.codeLabel.text = model.shortCode;
    cell.nameLabel.text = model.shortName;
    cell.addButton.tag = indexPath.row;
    
    
    bool flag = [self.selfStocksModelList any:^BOOL(SearchModel * obj) {
        if ([obj.fullCode isEqualToString:model.fullCode])
        {
            return true;
        }
        else
        {
            return false;
        }
    }];
    
    if (flag)
    {
        [cell.addButton setBackgroundImage:[UIImage imageNamed:@"tianjia.png"] forState:(UIControlStateNormal)];
        cell.addButton.enabled = false;
    }
    else
    {
        [cell.addButton setBackgroundImage:[UIImage imageNamed:@"zixuan1.png"] forState:(UIControlStateNormal)];
        cell.addButton.enabled = true;
    }
    

    [cell.addButton addTarget:self action:@selector(onSearchAddBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)onSearchAddBtnClick:(UIButton *)button
{
    
    SearchModel * model = self.modelList[button.tag];
    
    bool flag = [self.selfStocksModelList any:^BOOL(SearchModel * obj) {
        if ([obj.fullCode isEqualToString:model.fullCode])
        {
            return true;
        }
        else
        {
            return false;
        }
    }];
    
    if (flag)
    {
//        [model deleteSelf];
    }
    else
    {
        [model addSelfStock];
    }
    
    self.selfStocksModelList = [SearchModel selectAll];
    [self.searchTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailController * detailController = [[DetailController alloc]init];
    SearchModel * model = self.modelList[indexPath.row];
    [model insertSelfIntoFirstForSearch];
    detailController.searchModel = model;
    [[ContainerController instance]pushControllerHideTab:detailController animated:true];
}

- (void)viewDidUnload {
    [self setTextFieldForSearch:nil];
    [super viewDidUnload];
}
@end
