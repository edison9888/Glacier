//
//  SingleDiagnosisController.h
//  StockDoctor
//  单券诊断
//  Created by cnzhao on 13-4-20.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "GlacierController.h"
#import "DetailController.h"
#import "SinaWeiboManager.h"

@interface SingleDiagnosisController : GlacierController<SinaWeiboRequestDelegate>
@property (nonatomic,assign) DetailController * detailController;
@end
