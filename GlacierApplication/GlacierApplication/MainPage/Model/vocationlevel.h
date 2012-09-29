//
//  VOCATIONLEVEL.h
//  GlacierApplication
//
//  Created by cnzhao on 12-9-29.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface VOCATIONLEVEL : SQLitePersistentObject
@property (nonatomic,copy) NSString * CODE_ID;
@property (nonatomic,copy) NSString * PARENT_CODE_ID;
@property (nonatomic,copy) NSString * CODE_CNAME;
@property (nonatomic,copy) NSString * VALUE;
@end
