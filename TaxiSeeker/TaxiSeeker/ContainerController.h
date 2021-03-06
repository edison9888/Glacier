//
//  ContainerController.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-7.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "GlacierController.h"
#define REQUEST_SHANGHAI_DIR_URL @"http://www.down01.net/dirshanghai/"
@interface ContainerController : GlacierController<GlaSegmentedControlDelegate>
+ (ContainerController *)instance;
- (void)pushController:(UIViewController *)controller animated:(BOOL)animated;
- (void)pushControllerHideTab:(UIViewController *)controller animated:(BOOL)animated;
- (void)presentControllerFromButtom:(UIViewController *)controller;
- (void)dismissControllerFromButtom;
- (void)hideTabAndPresentView:(UIView *)view;
- (void)dissmisViewAndShowTab:(UIView *)view;
@end

NSURL* strToURL(NSString * str);