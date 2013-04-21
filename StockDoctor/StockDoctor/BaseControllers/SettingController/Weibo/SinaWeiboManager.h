//
//  SinaWeiboManager.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-21.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaWeibo.h"

@interface SinaWeiboManager : NSObject<SinaWeiboDelegate>
@property (nonatomic,assign) id<SinaWeiboDelegate> delegate;
+ (SinaWeiboManager * )instance;
- (bool)isAuth;
- (void)doLogin;
- (void)doLogout;
- (void)userInfo:(id<SinaWeiboRequestDelegate>)delegate;
@end