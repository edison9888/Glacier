//
//  LoginProcess.m
//  SKLMAgent
//
//  Created by bqzhu on 12-9-25.
//  Copyright (c) 2012年 bqzhu. All rights reserved.
//

#import "LoginProcess.h"

#define kUserCode @"userCode"
#define kLastLoginDateTime @"lastLoginDateTime"

static LoginProcess *shared = nil;

@implementation LoginProcess {
    LoginAlertView *_loginAlertView;
    DoLogin *_doLogin;
    CheckAppInfo *_checkApp;
}
@synthesize _lastLogin;
@synthesize _usercode;
@synthesize delegate;
@synthesize countDownLabel;

+(LoginProcess *)sharedInstance{
    @synchronized(self) {
        if (!shared) {
            shared = [[LoginProcess alloc] init];
        }
        return shared;
    }
}
-(id)init{
    if (self = [super init]) {
        _lastLogin = [[NSUserDefaults standardUserDefaults] valueForKey:kLastLoginDateTime];
        _usercode = [[NSUserDefaults standardUserDefaults] valueForKey:kUserCode];
        
        [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(refreshCountDown) userInfo:nil repeats:YES];
    }
    return self;
}

//-(void)dealloc{
//    [_loginAlertView release], _loginAlertView = nil;
//    [_doLogin release], _doLogin = nil;
//    [super dealloc];
//}

- (BOOL) needLogin {
    if (![[NSUserDefaults standardUserDefaults] valueForKey:kLastLoginDateTime]) {
        return YES;
    }
    NSTimeInterval time=[[NSDate date] timeIntervalSinceDate:[[NSUserDefaults standardUserDefaults] valueForKey:kLastLoginDateTime]];
    
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    int minutes=((int)time)%(3600*24)%3600/60;
    
    NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时%i分",days,hours,minutes];
    NSLog(@"相距%@",dateContent);
    int count = days*24 + hours;
    NSLog(@"共%d小時",count);
    
    return (count>24);
}

-(void) refreshCountDown {
    NSTimeInterval time=[[NSDate date] timeIntervalSinceDate:[[NSUserDefaults standardUserDefaults] valueForKey:kLastLoginDateTime]];
    
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    int minutes=((int)time)%(3600*24)%3600/60;
    
    NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时%i分",days,hours,minutes];
    NSLog(@"相距%@",dateContent);
    int count = days*24 + hours;
    NSLog(@"共%d小時",count);
    
    NSInteger down = 24-count;
    if (down<0) down = 0;
    if (countDownLabel) {
        [countDownLabel setText:[NSString stringWithFormat:@"登入有效期：%d小時",down]];
    }
}

-(void) setLastLoginDateTime {
    _lastLogin = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setValue:_lastLogin forKey:kLastLoginDateTime];
}

-(void) setUserCode:(NSString*)usercode {
    _usercode = usercode;
     [[NSUserDefaults standardUserDefaults] setValue:usercode forKey:kUserCode];
}

-(void) doLogin {
//    [_loginAlertView release];
    _loginAlertView = [[LoginAlertView alloc]initWithTitle:@"登入" message:@"請輸入帳號和密碼" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
//    [_loginAlertView show];
    [_loginAlertView refreshImage];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView isKindOfClass:[LoginAlertView class]]) {
        //彈出登錄框進行登錄。
        LoginAlertView *tempAlertView = (LoginAlertView*)alertView;
        NSLog(@"%d",buttonIndex);
        if (buttonIndex==0) {
//            [[self delegate] performSelector:@selector(loginCancel:) withObject:self];
            [self doLogin];
        } else if (buttonIndex==1) {
            _doLogin = [[DoLogin alloc]initWithAccount:tempAlertView.account.text Password:tempAlertView.pwd.text ImageCode:tempAlertView.code.text];
            [_doLogin setProcessdelegate:self];
            [_doLogin request];

        }
    } else {
        if ([alertView tag]==1) {
            
            _checkApp = [[CheckAppInfo alloc]init];
            [_checkApp request];
            
//            [[self delegate] performSelector:@selector(loginSuccess:) withObject:self];
        } else  if ([alertView tag]==2){
            [self doLogin];
        }
    }
    
}

-(void) doLogout {
//    [self setUserCode:@""];
    [self doLogin];
}


- (void)requestStarted:(LoginProcess *)onh {
//    [[self delegate] performSelector:@selector(loginStart:) withObject:self];
}


- (void)requestFinished:(NSString *)returnString {
    GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithXMLString:returnString options:0 error:nil];
    
    NSString *respcode = [[[[document rootElement] elementsForName:@"respcode"]objectAtIndex:0] stringValue];
    NSString *respmsg = [[[[document rootElement] elementsForName:@"respmsg"]objectAtIndex:0] stringValue];
    NSLog(@"respcode = %@",respcode);
    NSLog(@"respcode = %@",respmsg);
//    [document release];
    
    if ([respcode isEqualToString:@"000"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"登錄成功！" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [alert setTag:1];
        [alert show];
//        [alert release];

        [self setLastLoginDateTime];
        [self setUserCode:_loginAlertView.account.text];
        [self refreshCountDown];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:respmsg delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [alert setTag:2];
        [alert show];
//        [alert release];
    }
}

@end
