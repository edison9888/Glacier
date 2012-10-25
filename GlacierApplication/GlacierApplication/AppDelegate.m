//
//  AppDelegate.m
//  GlacierApplication
//
//  Created by chang liang on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MainPageController.h"
#import "SQLiteInstanceManager.h"
#import "PLI_PDT_M.h"
#import "LoginProcess.h"
@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString * dbFilePath = [[NSBundle mainBundle]pathForResource:@"glacierapplication" ofType:@"sqlite3"];
    
    NSFileManager * wFm = [NSFileManager defaultManager];
    NSError * wError = nil ;
    NSString * dest = ((SQLiteInstanceManager *)[SQLiteInstanceManager sharedManager]).databaseFilepath;
    if([wFm fileExistsAtPath:dest])
    {
        [wFm removeItemAtPath:dest error:&wError];
    }
    if (!wError)
    {
        [wFm copyItemAtPath:dbFilePath toPath:((SQLiteInstanceManager *)[SQLiteInstanceManager sharedManager]).databaseFilepath error:&wError];
    }
    if (wError)
    {
        NSLog(@"error %@",wError);
    }
    
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString * newVersion =[infoDict objectForKey:@"CFBundleVersion"];
    NSString * lastVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentVersion"];
    
    if (!lastVersion||![newVersion isEqualToString:lastVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:newVersion forKey:@"currentVersion"];
        [[NSUserDefaults standardUserDefaults] setObject:[SKLUtility getDateTimeStr:@"yyyy/MM/dd HH:mm"] forKey:@"lastUpDate"];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    self.viewController = [[MainPageController alloc] init];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([[LoginProcess sharedInstance]needLogin]) {
        [[LoginProcess sharedInstance] doLogin:NO];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
