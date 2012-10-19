//
//  LoginAlertView.h
//  SKLMAgent
//
//  Created by bqzhu on 12-9-20.
//  Copyright (c) 2012年 bqzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKLUtility.h"
#import "DownLoadDelegate.h"
//#import "DownloadHandler.h"
#import "DownloadRequest.h"

#define IMAGECODE_URL  @"https://einsurance.skl.com.tw/PTMService/Imagecode.aspx?type=IMG"
#define IMAGECODE_NAME  @"Imagecode"

@interface LoginAlertView : UIAlertView <DownLoadDelegate>

@property(nonatomic, retain) UITextField* account;
@property(nonatomic, retain) UITextField* pwd;
@property(nonatomic, retain) UITextField* code;
@property(nonatomic, retain) UIImageView* codeImage;
@property(nonatomic, retain) UIButton* codeButton;

- (void)refreshImage;

@end
