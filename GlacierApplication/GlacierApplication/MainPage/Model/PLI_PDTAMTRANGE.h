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
@property (nonatomic,assign) float PY_PDTYEAR;
@property (nonatomic,assign) float MINAGE;
@property (nonatomic,assign) float MAXAGE;
@property (nonatomic,assign) float MINAMT;
@property (nonatomic,assign) float MAXAMT;
@property (nonatomic,copy) NSString * MODIDATE;
@property (nonatomic,copy) NSString * MODISTATE;
@property (nonatomic,copy) NSString * PC_Sex;
@end
