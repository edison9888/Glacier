//
//  plipdtm.h
//  GlacierApplication
//
//  Created by chang liang on 12-9-14.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface plipdtm : SQLitePersistentObject
@property (nonatomic,copy) NSString * pdpdtcode;
@property (nonatomic,copy) NSString * pdpdtname;
@property (nonatomic,copy) NSString * pkclass;
@property (nonatomic,copy) NSString * pdkind;
@property (nonatomic,copy) NSString * pdonepay;
@end
