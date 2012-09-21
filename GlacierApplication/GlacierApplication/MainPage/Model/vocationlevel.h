//
//  vocationlevel.h
//  GlacierApplication
//
//  Created by chang liang on 12-9-21.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface vocationlevel : SQLitePersistentObject
@property (nonatomic,copy) NSString * codeid;
@property (nonatomic,copy) NSString * parentcodeid;
@property (nonatomic,copy) NSString * codecname;
@property (nonatomic,copy) NSString * value;
@end
