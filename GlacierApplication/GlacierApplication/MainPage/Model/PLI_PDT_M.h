//
//  PLI_PDT_M.h
//  GlacierApplication
//
//  Created by cnzhao on 12-9-29.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface PLI_PDT_M : SQLitePersistentObject
@property (nonatomic,copy) NSString * PD_PDTCODE;
@property (nonatomic,copy) NSString * PD_PDTNAME;
@property (nonatomic,assign) int PK_CLASS;
@property (nonatomic,assign) int PD_KIND;
@property (nonatomic,copy) NSString * PD_RATTABLETYPE;
@property (nonatomic,copy) NSString * PD_UNIT;
@property (nonatomic,assign) double PD_SELF;
@property (nonatomic,assign) double PD_COUPLE;
@property (nonatomic,assign) double PD_CHILD;
@property (nonatomic,assign) double PD_OWNER;
@property (nonatomic,copy) NSString * PD_FEETYPE;
@property (nonatomic,copy) NSString * PD_PREMCATEGORY;
@property (nonatomic,assign) double PD_HIGHPREM;
@property (nonatomic,assign) double PY_FULLYEAR;
@property (nonatomic,assign) double PD_ONEPAY;
@property (nonatomic,copy) NSString * PD_REPORT;
@property (nonatomic,copy) NSString * PD_INV;
@property (nonatomic,copy) NSString * PD_MAINFLAG;
@property (nonatomic,assign) double PD_MODELIMIT;
@property (nonatomic,copy) NSString * PD_PDTCONT;
@property (nonatomic,copy) NSString * PD_PDTCONT1;
@property (nonatomic,assign) double PD_VERSIONNO;
@property (nonatomic,copy) NSString * PD_ADDDENY;
@property (nonatomic,copy) NSString * PD_CURRENCY;
@property (nonatomic,copy) NSString * PD_LBENF;
@property (nonatomic,copy) NSString * PD_MBENF;
@property (nonatomic,copy) NSString * PD_DBENF;
@property (nonatomic,copy) NSString * PD_BBENF;
@property (nonatomic,copy) NSString * MODIDATE;
@property (nonatomic,copy) NSString * MODISTATE;
@end
