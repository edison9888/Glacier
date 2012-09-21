//
//  PopDateController.m
//  GlacierApplication
//
//  Created by chang liang on 12-9-20.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "PopDateController.h"

@interface PopDateController ()

@end

@implementation PopDateController
@synthesize picker;
@synthesize popDateDelegate;
@synthesize maxDate;
@synthesize minDate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    picker.minimumDate = self.minDate;
    picker.maximumDate = self.maxDate;
}

- (IBAction)onOkClick:(id)sender 
{
    if (self.popDateDelegate && [self.popDateDelegate respondsToSelector:@selector(onOkClick:)])
    {
        [self.popDateDelegate onOkClick:self.picker.date];
    }
}

- (IBAction)onCancelClick:(id)sender 
{
    if (self.popDateDelegate && [self.popDateDelegate respondsToSelector:@selector(onCancelClick)])
    {
        [self.popDateDelegate onCancelClick];
    }
}



- (void)viewDidUnload
{
    [self setPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
} 

//- (void)dealloc 
//{
//    [picker release];
//    self.maxDate = nil;
//    self.minDate = nil;
//    [super dealloc];
//}
@end
