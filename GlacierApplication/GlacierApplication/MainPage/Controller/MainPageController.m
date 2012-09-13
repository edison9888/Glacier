//
//  MainPageController.m
//  GlacierApplication
//
//  Created by chang liang on 12-9-12.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "MainPageController.h"
#import "InsuranceProduct.h"


@interface MainPageController ()

@end

@implementation MainPageController

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
    
//    InsuranceProduct * wProduct = [[InsuranceProduct alloc]init];
//    wProduct.insuranceName = @"名字";
//    [wProduct save];
    
//    wProduct = nil;
    NSArray * wArr = [InsuranceProduct findByinsuranceName:@"名字"];
    
    
//    wProduct.product_name = @"你好";
//    [wProduct save];
    
    NSLog(@"11");
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
