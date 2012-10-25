//
//  LoginAlertView.m
//  SKLMAgent
//
//  Created by bqzhu on 12-9-20.
//  Copyright (c) 2012年 bqzhu. All rights reserved.
//

#import "LoginAlertView.h"


@implementation LoginAlertView {
    DownloadRequest *_dr;
}
@synthesize account,pwd,code,codeImage,codeButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@.%@",[SKLUtility getPathOfDocuments],IMAGECODE_NAME,@"png"] error:nil];
    }
    return self;
}

//-(void)dealloc{
//    [account release], account  = nil;
//    [pwd release], pwd = nil;
//    [code release], code = nil;
//    [codeImage release], codeImage = nil;
//    [codeButton release], codeButton = nil;
//    [_dr release], _dr = nil;
//    [super dealloc];
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self != nil)
    {
        NSString *lastUserCode = [[NSUserDefaults standardUserDefaults]stringForKey:@"userCode"];
        
        // 初始化自定义控件，注意摆放的位置，可以多试几次位置参数直到满意为止
        // createTextField函数用来初始化UITextField控件，在文件末尾附上
        self.account = [self createTextField:@"帳號"                                   withFrame:CGRectMake(22, 85, 240, 36) isSecure:NO KeyboardType:UIKeyboardTypeDefault ReturnKeyType:UIReturnKeyNext];
        if (lastUserCode) [self.account setText:lastUserCode];
        [self addSubview:self.account];
        self.pwd = [self createTextField:@"密碼"                                   withFrame:CGRectMake(22, 130, 240, 36)isSecure:YES KeyboardType:UIKeyboardTypeDefault ReturnKeyType:UIReturnKeyNext];
        [self addSubview:self.pwd];
        self.code = [self createTextField:@"驗證碼"                                   withFrame:CGRectMake(22, 175, 125, 36)isSecure:NO KeyboardType:UIKeyboardTypeNumberPad ReturnKeyType:UIReturnKeyDone];
        [self addSubview:self.code];
        
        codeImage = [[UIImageView alloc]initWithFrame:CGRectMake(155, 177, 105, 30)];
        
        [self addSubview:self.codeImage];
        
        
        
        codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[codeButton setFrame:CGRectMake(155, 177, 105, 30)];
        [codeButton setTag:1234];
        [codeButton addTarget:self action:@selector(refreshImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:codeButton];
        
    }
    return self;
}

- (void)refreshImage {
    _dr = [[DownloadRequest alloc] initWithURL:IMAGECODE_URL Name:IMAGECODE_NAME FileType:@"png" SavePath:[SKLUtility getPathOfDocuments] Progress:nil DownloadDelegate:self];
    [_dr start];
//    [[DownloadHandler sharedInstance]addRequest:_dr];
}

- (void)requestStarted:(ASIHTTPRequest *)request{
    
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    [codeImage setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Imagecode.png",[SKLUtility getPathOfDocuments]]]];
    
    //    [codeButton setBackgroundImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Imagecode.png",[SKLUtility getPathOfDocuments]]]];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    
}

// Override父类的layoutSubviews方法
- (void)layoutSubviews {
    [super layoutSubviews];
    // 当override父类的方法时，要注意一下是否需要调用父类的该方法
    for (UIView* view in self.subviews) {
        // 搜索AlertView底部的按钮，然后将其位置下移
        // ios5以前按钮类是UIButton, IOS5里该按钮类是UIThreePartButton
        if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
            UIButton *tempButton = (UIButton*)view;
            if ([tempButton tag]!=1234) {
                CGRect btnBounds = view.frame;
                btnBounds.origin.y = self.code.frame.origin.y + self.code.frame.size.height + 7;
                view.frame = btnBounds;
            }        }
    }
    // 定义AlertView的大小
    CGRect bounds = self.frame;
    bounds.size.height = 320;
    self.frame = bounds;
}

- (UITextField*)createTextField:(NSString*)placeholder withFrame:(CGRect)frame isSecure:(BOOL)iss KeyboardType:(UIKeyboardType)type ReturnKeyType:(UIReturnKeyType)rtype{
    UITextField* field = [[UITextField alloc] initWithFrame:frame];
    field.placeholder = placeholder;
    field.secureTextEntry = iss;
    field.backgroundColor = [UIColor whiteColor];
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.keyboardType = type;
    field.borderStyle = UITextBorderStyleRoundedRect;
    field.returnKeyType = rtype;
    return field;
}

@end
