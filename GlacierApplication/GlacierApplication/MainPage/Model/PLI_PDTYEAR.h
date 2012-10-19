//
//  PLI_PDTYEAR.h
//  GlacierApplication
//
//  Created by cnzhao on 12-9-29.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface PLI_PDTYEAR : SQLitePersistentObject
@property (nonatomic,copy) NSString * PD_PDTCODE;
@property (nonatomic,assign) double PY_PDTYEAR;
@property (nonatomic,copy) NSString * PY_PDTYEARTYPE;
@property (nonatomic,copy) NSString * PY_PDTYEARNA;
@property (nonatomic,copy) NSString * PY_RATECODE;
@property (nonatomic,assign) double PY_MINAMT;
@property (nonatomic,assign) double PY_MAXAMT;
@property (nonatomic,assign) double PY_AMTUNIT;
@property (nonatomic,assign) double PY_MINAGE;
@property (nonatomic,assign) double PY_MAXAGE;
@property (nonatomic,assign) double PY_INSUREYEAR;
@property (nonatomic,copy) NSString * PY_INSUREYEARTYPE;
@property (nonatomic,copy) NSString * PY_INSUREYEARNA;
@property (nonatomic,copy) NSString * PY_WPCODE;
@property (nonatomic,copy) NSString * PY_WP;
@property (nonatomic,copy) NSString * PY_MINPREM;
@property (nonatomic,assign) double PY_FYCITEM;
@property (nonatomic,copy) NSString * PY_MINAGE_IND;
@property (nonatomic,copy) NSString * PY_MAXAGE_IND;
@property (nonatomic,copy) NSString * MODIDATE;
@property (nonatomic,copy) NSString * MODISTATE;
@end
