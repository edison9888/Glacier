//
//  ContainerController.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-7.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "GlacierController.h"

@interface ContainerController : GlacierController<UITabBarDelegate>
+ (ContainerController *)instance;
- (void)pushController:(UIViewController *)controller animated:(BOOL)animated;
- (void)pushControllerHideTab:(UIViewController *)controller animated:(BOOL)animated;
@end
