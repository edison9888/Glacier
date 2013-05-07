//
//  GlacierController+BaiduSta.m
//  StockDoctor
//
//  Created by cnzhao on 13-5-7.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "GlacierController+BaiduSta.h"
#import "BaiduMobStat.h"

@implementation GlacierController (BaiduSta)

- (NSString *)chsNameForController:(NSString *)controller
{
    static NSDictionary * dict;
    
    if (!dict)
    {
        dict = @{@"DiagnosisController": @"自选股诊断",
                 @"ChooseStocksController": @"智能选股",
                 @"SettingController": @"设置",
                 @"AboutUsController": @"关于",
                 @"DetailController": @"详细",
                 @"SingleDiagnosisController": @"个股诊断"
                };
    }
    
    return dict[controller];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString * chsName = [self chsNameForController:[[self class] description]];
    if (chsName)
    {
        BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
        [statTracker pageviewStartWithName:chsName];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSString * chsName = [self chsNameForController:[[self class] description]];
    if (chsName)
    {
        BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
        [statTracker pageviewEndWithName:chsName];
    }
}
@end
