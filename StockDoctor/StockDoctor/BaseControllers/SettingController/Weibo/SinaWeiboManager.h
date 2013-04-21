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

@end

@interface SinaWeiboManager(post)
- (void)userInfo:(id<SinaWeiboRequestDelegate>)delegate;
- (void)followUser:(NSString *)userID receiver:(id<SinaWeiboRequestDelegate>)delegate;
- (void)postWeibo:(NSString *)text receiver:(id<SinaWeiboRequestDelegate>)delegate;
- (void)postImageWeibo:(NSString *)text image:(UIImage *)image receiver:(id<SinaWeiboRequestDelegate>)delegate;
@end