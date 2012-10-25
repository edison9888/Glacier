//
//  LoginProcess.h
//  SKLMAgent
//
//  Created by bqzhu on 12-9-25.
//  Copyright (c) 2012年 bqzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginAlertView.h"
#import "DoLogin.h"
#import "GDataXMLNode.h"
#import "CheckAppInfo.h"

@interface LoginProcess : NSObject {
    NSDate *_lastLogin;
    NSString *_usercode;
    NSString *_userSid;
    NSString *_userName;
}

@property (nonatomic, assign) id delegate;

@property(nonatomic,retain) NSDate *_lastLogin;
@property(nonatomic,retain) NSString *_usercode;
@property(nonatomic,retain) NSString *_userSid;
@property(nonatomic,retain) NSString *_userName;

@property(nonatomic,retain) UILabel *countDownLabel;
@property(nonatomic,retain) UILabel *userNameDownLabel;


+(LoginProcess *)sharedInstance;

-(BOOL) needLogin;

-(void) setLastLoginDateTime;
-(void) setUserCode:(NSString*)usercode;

-(void) doLogin:(BOOL)sCancel;

-(void) doLogout;

-(void) refreshCountDown;


@end
