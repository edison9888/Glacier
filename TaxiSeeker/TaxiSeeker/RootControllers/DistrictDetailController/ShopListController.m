//
//  DistrictDetailController.m
//  TaxiSeeker
//
//  Created by cnzhao on 13-6-1.
//  Copyright (c) 2013年 glacier. All rights reserved.
//
#define Service_Tag 0
#define Price_Tag 1
#define Room_Tag 2

#import "ShopListController.h"
#import "IndicatorTab.h"
#import "DistrictDetailCell.h"
#import "ShopModel.h"

@interface ShopListController ()
@property (strong, nonatomic) IBOutlet GlaSegmentedControl *segTab;
@property (nonatomic, strong) NSArray * tabTitleList;
@property (strong, nonatomic) IBOutlet UIImageView *indicatorView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightBar;
@property (nonatomic,strong) NSMutableArray * communityModelList;
@property (strong, nonatomic) IBOutlet UITableView *tableListView;
@property (nonatomic,assign) NSUInteger selectedSortType;
@end

@implementation ShopListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabTitleList = @[@"By Service",@"By Price",@"By Room"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.model.name;
    self.navigationItem.rightBarButtonItem = self.rightBar;
//    _segTab.showIndicator = true;
    [_segTab initButtons];
    [self changeStage:Service_Tag];
}

#pragma mark Segments delegate

- (NSUInteger)numForSegments
{
    return 3;
}

- (UIControl *)buttonForIndex:(NSUInteger)index
{
    IndicatorTab * btn = [[NSBundle mainBundle]loadNibNamed:@"IndicatorTab" owner:nil options:nil][0];
    btn.textLabel.text = self.tabTitleList[index];
    return btn;
}

- (void)onSegmentChange:(NSUInteger)index
{
    [self changeStage:index];
}

- (void)onChangeState:(id)button index:(NSUInteger)index selected:(BOOL)isSelected
{
    IndicatorTab * btn = button;
    if (isSelected)
    {
        [btn.textLabel setTextColor:[UIColor lightGrayColor]];
    }
    else
    {
        [btn.textLabel setTextColor:[UIColor grayColor]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.communityModelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * idStr = @"DistrictDetailCell";
    DistrictDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:idStr];
    if (!cell)
    {
        cell = [[NSBundle mainBundle]loadNibNamed:@"DistrictDetailCell" owner:nil options:nil][0];
    }
    
    ShopModel * model = self.communityModelList[indexPath.row];
    cell.titleLabel.text = model.name;
    cell.addressLabel.text = model.address;
    cell.railLabel.text = model.neardy;
    cell.imgBar.imageURL = strToURL(model.icon);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)changeStage:(NSUInteger)index
{
    _selectedSortType = index;
    [self requestForCommunityList];
}


#pragma mark WebRequest

- (void)requestForCommunityList
{
    NSString * url = [NSString stringWithFormat:@"http://www.down01.net/dirshanghai/getSortlist.php?sort=%d&page=1&search=&serviceId=%@",_selectedSortType,self.model.gid];
    [self doHttpRequest:url tag:_selectedSortType];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    self.communityModelList = [ShopModel parseJson:request.responseString key:@"shops"];
    [_tableListView reloadData];
}


- (void)viewDidUnload {
    [self setTableListView:nil];
    [super viewDidUnload];
}
@end
