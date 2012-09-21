//
//  ResultModel.m
//  GlacierApplication
//
//  Created by chang liang on 12-9-18.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "ResultModel.h"

@implementation ResultModel
@synthesize yearPay;
@synthesize halfYearPay;
@synthesize quarterPay;
@synthesize monthPay;
@synthesize dayPay;

+ (ResultModel *) resultModelwithRate:(NSString *)rate amount:(long long)amount
{
    ResultModel * wModel = [[ResultModel alloc]init];
    long long resultAmount = amount * rate.floatValue; 
    wModel.yearPay = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount] numberStyle:NSNumberFormatterDecimalStyle];
    wModel.halfYearPay = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount * 0.52] numberStyle:NSNumberFormatterDecimalStyle];
    wModel.quarterPay = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount * 0.262] numberStyle:NSNumberFormatterDecimalStyle];
    wModel.monthPay = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount * 0.088] numberStyle:NSNumberFormatterDecimalStyle];
    wModel.dayPay = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:resultAmount / 365.0f] numberStyle:NSNumberFormatterDecimalStyle];
    return wModel;
}
@end
