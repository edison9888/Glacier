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

@interface SearchCell:UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation SearchCell

@end


@interface SearchStockController ()
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (nonatomic,strong) NSArray * modelList;
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
}

- (IBAction)onSearchTextChanged:(UITextField *)sender
{
    [self doHttpRequest:[NSString stringWithFormat:@"http://suggest3.sinajs.cn/suggest/type=&key=%@&name=stock",sender.text]];
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
