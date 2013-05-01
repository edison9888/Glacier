//
//  SearchModel.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-7.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

@interface SearchModel : NSObject
@property (nonatomic,strong) NSString * keyword1;
@property (nonatomic,strong) NSString * keyword2;
@property (nonatomic,strong) NSString * shortName;
@property (nonatomic,strong) NSString * type;
@property (nonatomic,strong) NSString * shortCode;
@property (nonatomic,strong) NSString * fullCode;
@property (nonatomic,assign) int sortIndex;
+ (NSArray *) extractModelList:(NSString *)inputStr;
+ (NSString *) composeUrlForCodes:(NSArray *)codes;

//是否是股票，false为指数
- (bool)isStock;

- (void)addSelfStock;
- (void)deleteSelfStock;
@end

@interface SearchModel (db)
+ (void)checkOrCreateTable;
- (void)insertSelfIntoFirst; //按sortIndex 逆序排列
- (void)deleteSelf;
- (void)updateSortIndex:(FMDatabase *)db;
+ (NSArray *)selectAll;
@end

@interface SearchModel (searchRecode)
+ (void)checkOrCreateTableForSearch;
- (void)insertSelfIntoFirstForSearch; //按sortIndex 逆序排列
- (void)deleteSelfForSearch;
- (void)updateSortIndexForSearch:(FMDatabase *)db;
+ (NSArray *)selectAllForSearch;
@end
