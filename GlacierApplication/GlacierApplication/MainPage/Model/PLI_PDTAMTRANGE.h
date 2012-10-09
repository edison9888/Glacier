//
//  PLI_PDTAMTRANGE.h
//  GlacierApplication
//
//  Created by cnzhao on 12-9-29.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface PLI_PDTAMTRANGE : SQLitePersistentObject
@property (nonatomic,copy) NSString * PD_PDTCODE;
@property (nonatomic,assign) double PY_PDTYEAR;
@property (nonatomic,assign) double MINAGE;
@property (nonatomic,assign) double MAXAGE;
@property (nonatomic,assign) double MINAMT;
@property (nonatomic,assign) double MAXAMT;
@property (nonatomic,copy) NSString * MODIDATE;
@property (nonatomic,copy) NSString * MODISTATE;
@property (nonatomic,copy) NSString * PC_Sex;
@end
