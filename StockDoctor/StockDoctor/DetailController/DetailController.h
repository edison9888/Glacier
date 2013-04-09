//
//  DetailController.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-8.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "GlacierController.h"
#import "SearchModel.h"

@interface DetailController : GlacierController
@property (nonatomic,strong) SearchModel * searchModel;
@end
