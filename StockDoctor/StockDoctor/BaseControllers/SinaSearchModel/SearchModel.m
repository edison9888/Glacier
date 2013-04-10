//
//  SearchModel.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-7.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel
+ (NSArray *) extractModelList:(NSString *)inputStr
{
    NSMutableArray * output = [NSMutableArray array];
    NSArray * arr = [inputStr componentsSeparatedByString:@"\""];
    if (arr.count > 1)
    {
        NSString * contentStr = arr[1];
        NSArray * contentArr = [contentStr componentsSeparatedByString:@";"];
        
        [contentArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
            NSArray * cellArr = [obj componentsSeparatedByString:@","];
            
            if (cellArr.count > 5)
            {
                SearchModel * model = [[SearchModel alloc]init];
                model.keyword1 = cellArr[0];
                model.type = cellArr[1];
                model.shortCode = cellArr[2];
                model.fullCode = cellArr[3];
                model.shortName = cellArr[4];
                model.keyword2 = cellArr[5];
                if ([model.type isEqualToString:@"11"]) //只显示AB股和指数
                {
                    [output addObject:model];
                }
            }
        }];
    }
    
    return output;
}

+ (NSString *)composeUrlForCodes:(NSArray *)codes
{
    if (codes.count == 0)
    {
        return nil;
    }
    else
    {
        NSMutableString * codesUrl = [NSMutableString string];
        [codes enumerateObjectsUsingBlock:^(SearchModel * obj, NSUInteger idx, BOOL *stop){
            if (idx == codes.count - 1)
            {
                [codesUrl appendString:obj.fullCode];
            }
            else
            {
                [codesUrl appendFormat:@"%@,",obj.fullCode];
            }
        }];
        return codesUrl;
    }
}
@end

@implementation SearchModel (db)

+ (void)checkOrCreateTable
{
    FMDatabaseQueue * queue = [SharedApp FMDatabaseQueue];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db tableExists:@"SelfStock"])
        {
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS SelfStock(PK INTEGER PRIMARY KEY AUTOINCREMENT, keyword1 text,keyword2 text,shortName text,type text, shortCode text,fullCode text)"];
        }
    }];
}

+ (NSArray *)selectAll
{
    NSMutableArray * allArr = [NSMutableArray array];
    FMDatabaseQueue * queue = [SharedApp FMDatabaseQueue];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet * query = [db executeQuery:@"select * from SelfStock"];
        while ([query next])
        {
            SearchModel * model = [[SearchModel alloc]init];
            model.keyword1 = [query stringForColumn:@"keyword1"];
            model.keyword2 = [query stringForColumn:@"keyword2"];
            model.shortName = [query stringForColumn:@"shortName"];
            model.type = [query stringForColumn:@"type"];
            model.shortCode = [query stringForColumn:@"shortCode"];
            model.fullCode = [query stringForColumn:@"fullCode"];
            [allArr addObject:model];
        };
    }];
    return allArr;
}


- (void)insertSelf
{
    FMDatabaseQueue * queue = [SharedApp FMDatabaseQueue];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet * query = [db executeQuery:@"select count(1) from SelfStock where fullCode = ?",self.fullCode];
        [query next];
        int count = [query intForColumnIndex:0];
        if (!count)
        {
            [db executeUpdate:@"insert into SelfStock (keyword1,keyword2,shortName,type,shortCode,fullCode) values (?,?,?,?,?,?)"
             ,self.keyword1,self.keyword2,self.shortName,self.type,self.shortCode,self.fullCode];
        }
    }];
}

- (void)deleteSelf
{
    FMDatabaseQueue * queue = [SharedApp FMDatabaseQueue];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"delete from SelfStock where fullCode = ?",self.fullCode];
    }];
}
@end




