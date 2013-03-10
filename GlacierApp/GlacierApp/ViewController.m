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
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"insert test ('a','b',aaa) values (?,?,?)",i,@"bb",@"bbd"];
        
        NSLog(@"%@",[[db lastError] localizedDescription]);
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
