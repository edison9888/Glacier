//
//  HomePageController.m
//  TaxiSeeker
//
//  Created by cnzhao on 13-6-1.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "HomePageController.h"
#import "IndicatorTab.h"
#import "DistrictCell.h"
#import "DistrictModel.h"
#import "DistrictDetailController.h"
#import "ShopListController.h"
#import "ServiceModel.h"
#import "NearByCell.h"

#define DistrictTable 0
#define NearByTable 1

@interface HomePageController ()
@property (strong, nonatomic) IBOutlet GlaSegmentedControl *segTab;
@property (nonatomic, strong) NSArray * tabTitleList;
@property (strong, nonatomic) IBOutlet UIImageView *indicatorView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftBar;
@property (strong, nonatomic) IBOutlet UIImageView *lineView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightBar;
@property (nonatomic, strong) NSMutableDictionary * subViewDictionary;
@property (strong, nonatomic) IBOutlet UIView *tableHolder;
@property (nonatomic,strong) NSMutableArray * districtModelList;
@property (nonatomic,strong) NSMutableArray * serviceModelList;
@end

@implementation HomePageController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabTitleList = @[@"By District",@"By Nearby"];
        self.subViewDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.leftBar;
    self.navigationItem.rightBarButtonItem = self.rightBar;
    
    _segTab.showIndicator = true;
    _segTab.buttomView = self.lineView;
    _segTab.indicatorViewTopPadding = CGRectGetHeight(_segTab.bounds) - CGRectGetHeight(_lineView.bounds) - CGRectGetHeight(_indicatorView.bounds);
    _segTab.indicatorView = self.indicatorView;
    [_segTab initButtons];
    [self changeStage:DistrictTable];
    
}

#pragma mark Segments delegate

- (NSUInteger)numForSegments
{
    return 2;
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

- (void)changeStage:(NSUInteger)index
{
    UITableView * table = self.subViewDictionary[@(index)];
    if (!table)
    {
        table = [[UITableView alloc]initWithFrame:self.tableHolder.bounds];
        table.tag = index;
        table.delegate = self;
        table.dataSource = self;
        table.autoresizingMask = 0x3f;
        table.backgroundColor = [UIColor clearColor];
        [self.tableHolder addSubview:table];
        [self.subViewDictionary setObject:table forKey:@(index)];
        if (index == DistrictTable)
        {
            [self requestForDistrictList];
        }
        else if(index == NearByTable)
        {
            [self requestForServiceList];
        }
    }
    
    [self.subViewDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber * key, UITableView * obj, BOOL *stop) {
        if (key.integerValue == index)
        {
            obj.hidden = false;
        }
        else
        {
            obj.hidden = true;
        }
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == DistrictTable)
    {
        return self.districtModelList.count;
    }
    else
    {
        return self.serviceModelList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == DistrictTable)
    {
        NSString * idStr = @"DistrictCell";
        DistrictCell * cell = [tableView dequeueReusableCellWithIdentifier:idStr];
        if (!cell)
        {
            cell = [[NSBundle mainBundle]loadNibNamed:@"DistrictCell" owner:nil options:nil][0];
        }
        
        DistrictModel * model = self.districtModelList[indexPath.row];
        cell.titleLabel.text = model.name;
        cell.imgBar.imageURL = strToURL(model.icon);
        return cell;
    }
    else if (tableView.tag == NearByTable)
    {
        NSString * idStr = @"NearByCell";
        DistrictCell * cell = [tableView dequeueReusableCellWithIdentifier:idStr];
        if (!cell)
        {
            cell = [[NSBundle mainBundle]loadNibNamed:@"NearByCell" owner:nil options:nil][0];
        }
        
        ServiceModel * model = self.serviceModelList[indexPath.row];
        cell.titleLabel.text = model.name;
        cell.imgBar.imageURL = strToURL(model.icon);
        return cell;
    }
    else
    {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == DistrictTable)
    {
        DistrictDetailController * controller = [[DistrictDetailController alloc]init];
        controller.model = self.districtModelList[indexPath.row];
        [[ContainerController instance] pushControllerHideTab:controller animated:true];
    }
    else if (tableView.tag == NearByTable)
    {
        ShopListController * controller = [[ShopListController alloc]init];
        controller.model = self.serviceModelList[indexPath.row];
        [[ContainerController instance] pushControllerHideTab:controller animated:true];
    }
}


#pragma mark WebRequest
//区域请求
- (void)requestForDistrictList
{
    [self doHttpRequest:@"http://www.down01.net/dirshanghai/getDistrict.php?cityid=021" tag:DistrictTable];
}

//附近服务请求
- (void)requestForServiceList
{
    [self doHttpRequest:@"http://www.down01.net/dirshanghai/getService.php?type=all&lat=0.000000&lon=0.000000&villageId=0" tag:NearByTable];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == DistrictTable)
    {
        self.districtModelList = [DistrictModel parseJson:request.responseString];
        UITableView * table = self.subViewDictionary[@(DistrictTable)];
        [table reloadData];
    }
    else if (request.tag == NearByTable)
    {
        self.serviceModelList = [ServiceModel parseJson:request.responseString];
        UITableView * table = self.subViewDictionary[@(NearByTable)];
        [table reloadData];
    }
}


#pragma mark TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}


- (void)viewDidUnload {
    [self setSegTab:nil];
    [self setIndicatorView:nil];
    [self setLineView:nil];
    [self setRightBar:nil];
    [self setLeftBar:nil];
    [self setTableHolder:nil];
    [super viewDidUnload];
}
@end
