//
//  plipdtyear.h
//  GlacierApplication
//
//  Created by chang liang on 12-9-15.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface plipdtyear : SQLitePersistentObject
@property (nonatomic,copy) NSString * pdpdtcode;
@property (nonatomic,copy) NSString * pypdtyear;
@property (nonatomic,copy) NSString * pypdtyeartype;
@property (nonatomic,copy) NSString * pypdtyearna;
@property (nonatomic,copy) NSString * pyratecode;
@property (nonatomic,copy) NSString * pyminamt;
@end