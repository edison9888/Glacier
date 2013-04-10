//
//  SinaBaseDataModel.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-10.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SinaBaseDataModel : NSObject
@property (nonatomic,strong) NSString * fullCode;
@property (nonatomic,strong) NSString * shortName;
@property (nonatomic,strong) NSString * preClosePrice;
@property (nonatomic,strong) NSString * currentPrice;
@property (nonatomic,readonly) NSString * change;
@property (nonatomic,readonly) int changeState;
+ (NSArray *) extractModelList:(NSString *)inputStr;
@end
