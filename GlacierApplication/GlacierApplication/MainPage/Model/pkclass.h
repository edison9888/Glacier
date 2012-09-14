//
//  pkclass.h
//  GlacierApplication
//
//  Created by chang liang on 12-9-14.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface pkclass : SQLitePersistentObject
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * code;
@end
