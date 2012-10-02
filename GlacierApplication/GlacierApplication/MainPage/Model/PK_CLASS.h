//
//  PK_CLASS.h
//  GlacierApplication
//
//  Created by cnzhao on 12-9-29.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface PK_CLASS : SQLitePersistentObject
@property (nonatomic,copy) NSString * PK_CLASS_NAME;
@property (nonatomic,copy) NSString * PK_CLASS_CODE;
@property (nonatomic,assign) bool isFolded;
@end
