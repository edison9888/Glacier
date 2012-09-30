//
//  CALCSETTING.h
//  GlacierApplication
//
//  Created by cnzhao on 12-9-29.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface CALCSETTING : SQLitePersistentObject
@property (nonatomic,copy) NSString * PD_PDTCODE;
@property (nonatomic,assign) int AMTPOINTER;
@property (nonatomic,assign) int FEEPOINTER;
@property (nonatomic,assign) int CALCTYPE;
@property (nonatomic,assign) int USEROUND;
@property (nonatomic,assign) int USEROUNDDOWN;
@property (nonatomic,assign) int AMTRANGE;
@property (nonatomic,assign) int CALCRANGE;
@end
