//
//  ViewController.m
//  GlacierApp
//
//  Created by cnzhao on 13-2-25.
//  Copyright (c) 2013年 cnzhao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)createTable
{
    for (int i = 0; i< 100; i++)
    {
        [self performSelectorInBackground:@selector(onss:) withObject:@(i)];
    }
    [[SharedApp FMDatabaseQueue] close];
}

- (void) onss:(NSNumber *)i
{
    NSLog(@"i: %d",i.intValue);
    FMDatabaseQueue * dbQueue = [SharedApp FMDatabaseQueue];
    [dbQueue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:@"create table if not exists test (a int,b int,c int)"];
         [db executeUpdate:@"insert into test ('a','b') values (?, ?)",i,@"bb"];
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
