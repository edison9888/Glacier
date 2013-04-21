//
//  SinaWeiboManager.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-21.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "SinaWeiboManager.h"
#define kAppKey             @"3595089389"
#define kAppSecret          @"4caf12978f7ef14b14d4bf689da236b6"
#define kAppRedirectURI     @"http://itunes.apple.com/cn/app/id517609453?mt=8"


@implementation SinaWeiboManager
{
    SinaWeibo * _sinaWeibo;
}

- (id)init
{
    self = [super init];
    if (self) {
        _sinaWeibo =  [[SinaWeibo alloc]initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    }
    return self;
}

+ (SinaWeiboManager *)instance
{
    static SinaWeiboManager * _instance;
    if (!_instance)
    {
        _instance = [[SinaWeiboManager alloc]init];
    }
    return _instance;
}

- (void)doLogin
{
    [_sinaWeibo logIn];
}

- (void)doLogout
{
    [_sinaWeibo logOut];
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              _sinaWeibo.accessToken, @"AccessTokenKey",
                              _sinaWeibo.expirationDate, @"ExpirationDateKey",
                              _sinaWeibo.userID, @"UserIDKey",
                              _sinaWeibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (bool)isAuth
{
    NSDictionary * dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"SinaWeiboAuthData"];
    return dict;
}

#pragma marks weibo delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sinaweiboDidLogIn:)])
    {
        [self.delegate sinaweiboDidLogIn:sinaweibo];
    }
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [self removeAuthData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sinaweiboDidLogOut:)])
    {
        [self.delegate sinaweiboDidLogOut:sinaweibo];
    }
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sinaweiboLogInDidCancel:)])
    {
        [self.delegate sinaweiboLogInDidCancel:sinaweibo];
    }
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sinaweibo:logInDidFailWithError:)])
    {
        [self.delegate sinaweibo:sinaweibo logInDidFailWithError:error];
    }
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    [self removeAuthData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sinaweibo:accessTokenInvalidOrExpired:)])
    {
        [self.delegate sinaweibo:sinaweibo accessTokenInvalidOrExpired:error];
    }
}


@end
