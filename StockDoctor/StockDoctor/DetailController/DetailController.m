//
//  DetailController.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-8.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "DetailController.h"
#import "TrendModel.h"
#import "TrendView.h"

@interface DetailController ()
@property (strong, nonatomic) IBOutlet TrendView *trendView;

@end

@implementation DetailController

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
    self.title = self.searchModel.shortName;
    [self requestForStock];
}

- (void)requestForStock
{
    NSString * url = @"http://flashquote.stock.hexun.com/Stock_Combo.ASPX?mc=%@_%@&dt=q,MI";
    NSString * type = nil;
    if ([self.searchModel.fullCode hasPrefix:@"sh"])
    {
        type = @"1";
    }
    else if ([self.searchModel.fullCode hasPrefix:@"sz"])
    {
        type = @"2";
    }
    
    NSString * requestStr = [NSString stringWithFormat:url,type,self.searchModel.shortCode];
    [self doHttpRequest:requestStr];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSArray * respArr = [request.responseString componentsSeparatedByString:@";"];
    TrendModel * trendModel = [[TrendModel alloc]init];
    
    [respArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        if (idx < 2)
        {
            NSString * json = [obj stringByReplacingOccurrencesOfString:@"refreshData(" withString:@"["];
            json = [json stringByReplacingOccurrencesOfString:@")" withString:@"]"];
            json = [json stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
            NSArray * arr = [json objectFromJSONString];
            
            if(idx == 0)
            {
                trendModel.preClosePrice = arr[3][1];
            }
            else if (idx == 1)
            {
                
                NSMutableArray * cellList = [NSMutableArray array];
                NSArray * listArr = arr[3];
                for (NSArray * cellArr in listArr)
                {
                    TrendCellData * cell = [[TrendCellData alloc]init];
                    cell.price = cellArr[0];
                    cell.volume = cellArr[1];
                    cell.amount = cellArr[2];
                    [cellList addObject:cell];
                }
                trendModel.trendCellDataList = cellList;
            }
        }
    }];
    
    self.trendView.trendModel = trendModel;
}



@end
