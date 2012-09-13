//
//  InsuranceProduct.h
//  GlacierApplication
//
//  Created by chang liang on 12-9-13.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface InsuranceProduct : SQLitePersistentObject
@property (nonatomic,copy) NSString * insuranceName;
@end
