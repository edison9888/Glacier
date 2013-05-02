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

- (bool)isStock
{
    NSString * prefix = [self.fullCode substringToIndex:2];
    NSString * code = [self.fullCode substringFromIndex:2];
    int codeValue = code.intValue;
    if ([prefix isEqualToString:@"sh"])
    {
        if ( codeValue <= 999 && codeValue >= 1)
        {
            //上证指数
            return false;
        }
    }
    else if([prefix isEqualToString:@"sz"])
    {
        if ( codeValue <= 399999 && codeValue >= 399001)
        {
            //深证指数
            return false;
        }
    }
    //其余为股票
    return true;
}


- (void)addSelfStock
{
    [self insertSelfIntoFirst];
    
    [[MTStatusBarOverlay sharedInstance] postFinishMessage:@"添加自选完成" duration:2];
    
    NSString * requestUrl = @"http://www.9pxdesign.com/zixuan1.php?name=%@&code=%@&indexYesOrNo=%d";
    
    NSString * escapedUrlString =[self.shortName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    requestUrl = [NSString stringWithFormat:requestUrl,escapedUrlString,self.fullCode,![self isStock]];
    
    ASIHTTPRequest * request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:escapedUrlString]];
    [[SharedApp instance] doASIHttpRequest:request];
}

- (void)deleteSelfStock
{
    [self deleteSelf];
    
    [[MTStatusBarOverlay sharedInstance] postFinishMessage:@"删除自选完成" duration:2];
    
    NSString * requestUrl = @"http://www.9pxdesign.com/zixuan2.php?name=%@&code=%@&indexYesOrNo=%d";
    
    NSString * escapedUrlString =[self.shortName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    requestUrl = [NSString stringWithFormat:requestUrl,escapedUrlString,self.fullCode,![self isStock]];
    
    ASIHTTPRequest * request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:requestUrl]];
    [[SharedApp instance] doASIHttpRequest:request];
}
@end

@implementation SearchModel (db)

+ (void)checkOrCreateTable
{
    FMDatabaseQueue * queue = [SharedApp FMDatabaseQueue];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db tableExists:@"SelfStock"])
        {
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS SelfStock(PK INTEGER PRIMARY KEY AUTOINCREMENT, keyword1 text,keyword2 text,shortName text,type text, shortCode text,fullCode text,sortIndex INTEGER)"];
        }
    }];
}

+ (NSArray *)selectAll
{
    NSMutableArray * allArr = [NSMutableArray array];
    FMDatabaseQueue * queue = [SharedApp FMDatabaseQueue];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet * query = [db executeQuery:@"select * from SelfStock order by sortIndex desc"];
        while ([query next])
        {
            SearchModel * model = [[SearchModel alloc]init];
            model.keyword1 = [query stringForColumn:@"keyword1"];
            model.keyword2 = [query stringForColumn:@"keyword2"];
            model.shortName = [query stringForColumn:@"shortName"];
            model.type = [query stringForColumn:@"type"];
            model.shortCode = [query stringForColumn:@"shortCode"];
            model.fullCode = [query stringForColumn:@"fullCode"];
            model.sortIndex = [query intForColumn:@"sortIndex"];
            [allArr addObject:model];
        };
    }];
    return allArr;
}


- (void)insertSelfIntoFirst
{
    FMDatabaseQueue * queue = [SharedApp FMDatabaseQueue];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet * query = [db executeQuery:@"select count(1) from SelfStock where fullCode = ?",self.fullCode];
        [query next];
        int count = [query intForColumnIndex:0];
        if (!count)
        {
            [db executeUpdate:@"insert into SelfStock (keyword1,keyword2,shortName,type,shortCode,fullCode,sortIndex) values (?,?,?,?,?,?,(SELECT count(1) FROM SelfStock))"
             ,self.keyword1,self.keyword2,self.shortName,self.type,self.shortCode,self.fullCode];
        }
    }];
    
    
}

- (void)updateSortIndex:(FMDatabase *)db
{
    [db executeUpdate:@"update SelfStock set sortIndex = ? where fullCode = ?",@(self.sortIndex),self.fullCode];
}

- (void)deleteSelf
{
    FMDatabaseQueue * queue = [SharedApp FMDatabaseQueue];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"delete from SelfStock where fullCode = ?",self.fullCode];
    }];
}
@end


@implementation SearchModel (searchRecode)

+ (void)checkOrCreateTableForSearch
{
    FMDatabaseQueue * queue = [SharedApp FMDatabaseQueue];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db tableExists:@"SearchStock"])
        {
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS SearchStock(PK INTEGER PRIMARY KEY AUTOINCREMENT, keyword1 text,keyword2 text,shortName text,type text, shortCode text,fullCode text,sortIndex INTEGER)"];
        }
    }];
}

+ (NSArray *)selectAllForSearch
{
    NSMutableArray * allArr = [NSMutableArray array];
    FMDatabaseQueue * queue = [SharedApp FMDatabaseQueue];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet * query = [db executeQuery:@"select * from SearchStock order by sortIndex desc limit 20"];
        while ([query next])
        {
            SearchModel * model = [[SearchModel alloc]init];
            model.keyword1 = [query stringForColumn:@"keyword1"];
            model.keyword2 = [query stringForColumn:@"keyword2"];
            model.shortName = [query stringForColumn:@"shortName"];
            model.type = [query stringForColumn:@"type"];
            model.shortCode = [query stringForColumn:@"shortCode"];
            model.fullCode = [query stringForColumn:@"fullCode"];
            model.sortIndex = [query intForColumn:@"sortIndex"];
            [allArr addObject:model];
        };
    }];
    return allArr;
}


- (void)insertSelfIntoFirstForSearch
{
    FMDatabaseQueue * queue = [SharedApp FMDatabaseQueue];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet * query = [db executeQuery:@"select count(1) from SearchStock where fullCode = ?",self.fullCode];
        [query next];
        int count = [query intForColumnIndex:0];
        if (!count)
        {
            [db executeUpdate:@"insert into SearchStock (keyword1,keyword2,shortName,type,shortCode,fullCode,sortIndex) values (?,?,?,?,?,?,(SELECT count(1) FROM SearchStock))"
             ,self.keyword1,self.keyword2,self.shortName,self.type,self.shortCode,self.fullCode];
        }
    }];
}

- (void)updateSortIndexForSearch:(FMDatabase *)db
{
    [db executeUpdate:@"update SearchStock set sortIndex = ? where fullCode = ?",@(self.sortIndex),self.fullCode];
}

- (void)deleteSelfForSearch
{
    FMDatabaseQueue * queue = [SharedApp FMDatabaseQueue];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"delete from SearchStock where fullCode = ?",self.fullCode];
    }];
}
@end




