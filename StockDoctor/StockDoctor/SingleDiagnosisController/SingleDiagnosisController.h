//
//  SingleDiagnosisController.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-20.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "GlacierController.h"
#import "DetailController.h"

@interface SingleDiagnosisController : GlacierController
@property (nonatomic,assign) DetailController * detailController;
@property (nonatomic,assign) bool isStock;
@end
