//
//  ChooseStockModel.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-18.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchModel.h"

@interface ChooseStockModel : NSObject
@property (nonatomic,strong) NSString * fullCode;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * indicator;
@property (nonatomic,readonly) NSString * shortCode;
+ (NSArray *) parseChooseStockModels:(NSArray *)json tag:(int)tag;
- (SearchModel *) generateSearchModel;
@end
