//
//  DistrictDetailController.h
//  TaxiSeeker
//
//  Created by cnzhao on 13-6-1.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "GlacierController.h"
#import "ServiceModel.h"

@interface ShopListController : GlacierController<GlaSegmentedControlDelegate, UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) ServiceModel * model;
@end
