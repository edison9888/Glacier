//
//  DistrictDetailController.m
//  TaxiSeeker
//
//  Created by cnzhao on 13-6-1.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "DistrictDetailController.h"

@interface DistrictDetailController ()

@end

@implementation DistrictDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.model.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
