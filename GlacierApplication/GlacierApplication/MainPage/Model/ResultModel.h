//
//  ResultModel.h
//  GlacierApplication
//
//  Created by chang liang on 12-9-18.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultModel : NSObject
@property (nonatomic,copy) NSString * yearPay;
@property (nonatomic,copy) NSString * halfYearPay;
@property (nonatomic,copy) NSString * quarterPay;
@property (nonatomic,copy) NSString * monthPay;
@property (nonatomic,copy) NSString * dayPay;
+ (ResultModel *) resultModelwithRate:(NSString *) rate amount:(long long)amount;
@end
