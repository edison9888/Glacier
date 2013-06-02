//
//  ShopDetailController.m
//  TaxiSeeker
//
//  Created by cnzhao on 13-6-2.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "ShopDetailController.h"
#import "FiveStarView.h"
#import "ShopDetailModel.h"

@interface ShopDetailController ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollBgView;
@property (strong, nonatomic) IBOutlet EGOImageView *shopImgView;
@property (strong, nonatomic) IBOutlet FiveStarView *starView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) ShopDetailModel * shopDetailModel;
@property (strong, nonatomic) IBOutlet UILabel *featureLabel;
@end

@implementation ShopDetailController

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
    self.title = self.shopModel.name;
    [self.scrollBgView addSubview:self.contentView];
    [self.scrollBgView fixContentHeight:CGRectGetHeight(self.contentView.bounds)];
    _shopImgView.imageURL = strToURL(self.shopModel.icon);
    _starView.rank = self.shopModel.star.floatValue;
    
    [self requestForDetailModel];
}

- (void)refreshViews
{
    self.featureLabel.text = self.shopDetailModel.featureText;
}

#pragma mark WebRequest

- (void)requestForDetailModel
{
    NSString * url = [NSString stringWithFormat:@"http://www.down01.net/dirshanghai/getInfo.php?infoId=%@",self.shopModel.gid];
    [self doHttpRequest:url];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    self.shopDetailModel = [ShopDetailModel parseJson:request.responseString];
    [self refreshViews];
}

- (void)viewDidUnload {
    [self setContentView:nil];
    [self setScrollBgView:nil];
    [self setShopImgView:nil];
    [self setStarView:nil];
    [self setFeatureLabel:nil];
    [self setPriceLabel:nil];
    [super viewDidUnload];
}
@end
