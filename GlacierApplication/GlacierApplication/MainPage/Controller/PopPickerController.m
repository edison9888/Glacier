//
//  PopPickerController.m
//  GlacierApplication
//
//  Created by cnzhao on 12-10-11.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "PopPickerController.h"

@interface PopPickerController ()

@end

@implementation PopPickerController
{
    IBOutlet UIPickerView *pickView;
}
@synthesize pickerDataSource;
@synthesize popPickerDelegate;
@synthesize tag;
@synthesize selectedIndex;

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
    [pickView selectRow:self.selectedIndex inComponent:0 animated:false];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerDataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
     return [self.pickerDataSource objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
}


- (IBAction)onOkClick:(id)sender
{
    if (self.popPickerDelegate && [self.popPickerDelegate respondsToSelector:@selector(onPopPickerOKClick:viewTag:)])
    {
        [self.popPickerDelegate onPopPickerOKClick:self.selectedIndex viewTag:self.tag];
    }
    
}

- (IBAction)onCancelClick:(id)sender
{
    if (self.popPickerDelegate && [self.popPickerDelegate respondsToSelector:@selector(onPopPickerCancelClick)])
    {
        [self.popPickerDelegate onPopPickerCancelClick];
    }
}

- (void)viewDidUnload {
    pickView = nil;
    [super viewDidUnload];
}
@end
