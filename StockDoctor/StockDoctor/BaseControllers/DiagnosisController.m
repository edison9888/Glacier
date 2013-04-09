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
#import "SearchCell.h"
#import "DetailController.h"

@interface DiagnosisController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@property (strong, nonatomic) NSArray * modelList;
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
    SearchCell * cell = [tableView dequeueReusableCellWithIdentifier:idStr];
    if (!cell)
    {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SearchCell" owner:nil options:nil][0];
    }
    SearchModel * model = self.modelList[indexPath.row];
    cell.codeLabel.text = model.shortCode;
    cell.nameLabel.text = model.shortName;
    cell.addButton.hidden = true;
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
