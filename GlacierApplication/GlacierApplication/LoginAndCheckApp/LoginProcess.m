//
//  LoginProcess.m
//  SKLMAgent
//
//  Created by bqzhu on 12-9-25.
//  Copyright (c) 2012年 bqzhu. All rights reserved.
//

#import "LoginProcess.h"

#define kUserCode @"userCode"
#define kUserSid @"userSid"
#define kUserName @"userName"
#define kLastLoginDateTime @"lastLoginDateTime"

#define kHasLogin @"hasLogin"

static LoginProcess *shared = nil;

@implementation LoginProcess {
    LoginAlertView *_loginAlertView;
    DoLogin *_doLogin;
    CheckAppInfo *_checkApp;
    BOOL _sCancel;
    BOOL _hasLogin;
    BOOL _isShowLogin;
}
@synthesize _lastLogin;
@synthesize _usercode;
@synthesize _userSid;
@synthesize _userName;
@synthesize delegate;
@synthesize countDownLabel;
@synthesize userNameDownLabel;

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
        _userSid = [[NSUserDefaults standardUserDefaults] valueForKey:kUserSid];
        _userName = [[NSUserDefaults standardUserDefaults] valueForKey:kUserName];
        
        _hasLogin = [[NSUserDefaults standardUserDefaults] integerForKey:kHasLogin]==1?YES:NO;
        NSLog(@"%@",_hasLogin?@"YES":@"NO");
        
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
    if (_isShowLogin) {
        return NO;
    }
    if (!_hasLogin||![[NSUserDefaults standardUserDefaults] valueForKey:kLastLoginDateTime]) {
        return YES;
    }

    NSTimeInterval time=[[NSDate date] timeIntervalSinceDate:[[NSUserDefaults standardUserDefaults] valueForKey:kLastLoginDateTime]];
    
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    int minutes=((int)time)%(3600*24)%3600/60;
    
    NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时%i分",days,hours,minutes];
    NSLog(@"相距%@",dateContent);
    int count = days*24*60 + hours*60 + minutes;
    NSLog(@"共%d分钟",count);
    
    NSInteger Logon_expire_interval = 1440;
    
//    [dateContent release];
    return (count>Logon_expire_interval);
}

-(void) refreshCountDown {
    if (!_hasLogin) {
        if (self.countDownLabel) {
            [self.countDownLabel setText:@"登入有效期：0分鐘"];
        }
        return;
    }
    
    NSTimeInterval time=[[NSDate date] timeIntervalSinceDate:[[NSUserDefaults standardUserDefaults] valueForKey:kLastLoginDateTime]];
    
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    int minutes=((int)time)%(3600*24)%3600/60;
    
    NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时%i分",days,hours,minutes];
    NSLog(@"相距%@",dateContent);
    int count = days*24*60 + hours*60 + minutes;
    NSLog(@"共%d分钟",count);
    
    NSInteger Logon_expire_interval = 1440;
    
    NSInteger countDown = Logon_expire_interval - count;
    if (countDown < 0) countDown = 0;
    
    NSString *hour_down = countDown/60>0?[NSString stringWithFormat:@"%d小時",countDown/60]:@"";
    NSString *min_down = countDown%60>0?[NSString stringWithFormat:@"%d分鐘",countDown%60]:@"";
    
    if (self.countDownLabel) {
        [self.countDownLabel setText: [NSString stringWithFormat:@"登入有效期：%@%@",hour_down,min_down]];
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

-(void) setUserSid:(NSString*)usersid {
    _userSid = usersid;
    [[NSUserDefaults standardUserDefaults] setValue:usersid forKey:kUserSid];
}

-(void) setUserName:(NSString*)username {
    _userName = username;
    [[NSUserDefaults standardUserDefaults] setValue:username forKey:kUserName];
    if (self.userNameDownLabel&&_userName) {
        [self.userNameDownLabel setText:[NSString stringWithFormat:@"使用者：%@", _userName]];
    }
}

-(void) setHasLogin:(BOOL)bo {
    _hasLogin = bo;
    [[NSUserDefaults standardUserDefaults] setInteger:_hasLogin?1:0 forKey:kHasLogin];
}

-(void) doLogin:(BOOL)sCancel {
    _sCancel = sCancel;
//    [_loginAlertView release];
    if (sCancel) {
        _loginAlertView = [[LoginAlertView alloc]initWithTitle:@"登入" message:@"請輸入帳號和密碼" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
        [_loginAlertView show];
        [_loginAlertView refreshImage];
    } else {
        _loginAlertView = [[LoginAlertView alloc]initWithTitle:@"登入" message:@"請輸入帳號和密碼" delegate:self cancelButtonTitle:nil otherButtonTitles:@"確定",nil];
        [_loginAlertView show];
        [_loginAlertView refreshImage];
    }
    _isShowLogin = YES;
}
    

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView isKindOfClass:[LoginAlertView class]]) {
        //彈出登錄框進行登錄。
        LoginAlertView *tempAlertView = (LoginAlertView*)alertView;
//        NSLog(@"%d",buttonIndex);
        if (buttonIndex==1 || !_sCancel) {
            _doLogin = [[DoLogin alloc]initWithAccount:tempAlertView.account.text Password:tempAlertView.pwd.text ImageCode:tempAlertView.code.text];
            [_doLogin setProcessdelegate:self];
            [_doLogin request];

        } else if (buttonIndex==0) {
            [[self delegate] performSelector:@selector(loginCancel:) withObject:self];
        }
    } else {
        if ([alertView tag]==1) {
            
            _checkApp = [[CheckAppInfo alloc]init];
//            [checkApp setCheckAppInfoDelegate:self];
            [_checkApp request];
            _isShowLogin = NO;
//            [[self delegate] performSelector:@selector(loginSuccess:) withObject:self];
        } else  if ([alertView tag]==2){
            [self doLogin:_sCancel];
        }
    }
    
}

-(void) doLogout {
//    [self setUserCode:@""];
    [self setHasLogin:NO];
    [self setUserName:@""];
    [self setUserSid:@""];
    [self doLogin:NO];
    if (self.countDownLabel) {
        [self.countDownLabel setText:@"登入有效期：0分鐘"];
    }
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
        NSString *sid = [[[[document rootElement] elementsForName:@"sid"]objectAtIndex:0] stringValue];
        NSArray *datalist= [[[[[document rootElement] elementsForName:@"datalist"]objectAtIndex:0] stringValue] componentsSeparatedByString:@","];
        NSLog(@"sid = %@",sid);
        NSLog(@"userName = %@",[datalist objectAtIndex:1]);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"登錄成功！" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [alert setTag:1];
        [alert show];
//        [alert release];

        [self setLastLoginDateTime];
        [self setUserCode:_loginAlertView.account.text];
        [self setUserSid:sid];
        if (datalist.count>1) [self setUserName:[datalist objectAtIndex:1]];
        [self setHasLogin:YES];
        [self refreshCountDown];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:respmsg delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [alert setTag:2];
        [alert show];
//        [alert release];
    }
}

@end
