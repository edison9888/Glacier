//
//  plipdtrate.h
//  GlacierApplication
//
//  Created by chang liang on 12-9-15.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface plipdtrate : SQLitePersistentObject
@property (nonatomic,copy) NSString * prpdtcode;
@property (nonatomic,copy) NSString * prpdtyear;
@property (nonatomic,copy) NSString * prage;
@property (nonatomic,copy) NSString * prsales;
@property (nonatomic,copy) NSString * prmrate;
@property (nonatomic,copy) NSString * prfrate;
@end
