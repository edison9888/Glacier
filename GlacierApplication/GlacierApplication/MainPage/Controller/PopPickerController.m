//
//  PopPickerController.m
//  GlacierApplication
//
//  Created by cnzhao on 12-10-11.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "PopPickerController.h"

@interface PickerCell : UIView
@property (nonatomic,strong) UILabel * textLabel;
@end

@implementation PickerCell
@synthesize textLabel;
- (id)init
{
    self = [super init];
    if (self) {
        self.textLabel = [[UILabel alloc]init];
        self.textLabel.font = [UIFont boldSystemFontOfSize:19];
        self.textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:textLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.textLabel.frame = CGRectMake(7, 3, frame.size.width, frame.size.height - 3);
}

@end

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
@synthesize availDataSource;

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

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//     return [self.pickerDataSource objectAtIndex:row];
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    PickerCell * wCell = (PickerCell *)view;
    if (!wCell) {
        wCell = [[PickerCell alloc]init];
    }
    NSString * selectStr = [self.pickerDataSource objectAtIndex:row];
    if (self.availDataSource) {
        
        if ([self findStringInAvail:selectStr])
        {
            wCell.textLabel.textColor = [UIColor blackColor];
        }
        else
        {
            wCell.textLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        }
    }
    else
    {
        wCell.textLabel.textColor = [UIColor blackColor];
    }
    wCell.textLabel.text = selectStr;
    return wCell;
}


- (BOOL) findStringInAvail:(NSString *) str
{
    int index =[self.availDataSource indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if([((NSString *)obj) isEqualToString:str])
        {
            *stop = true;
            return true;
        }
        else
            return false;
    }];
    if (index == NSNotFound)
    {
        return false;
    }
    else
    {
        return true;
    }
}

- (int) findStringInDataSource:(NSString *) str
{
    int index =[self.pickerDataSource indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if([((NSString *)obj) isEqualToString:str])
        {
            *stop = true;
            return true;
        }
        else
            return false;
    }];
    return index;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString * selectStr = [self.pickerDataSource objectAtIndex:row];
    if ([self findStringInAvail:selectStr])
    {
        self.selectedIndex = row;
    }
    else
    {
        NSString * str = [self.availDataSource objectAtIndex:0];
        int index = [self findStringInDataSource:str];
        [pickerView selectRow:index inComponent:0 animated:true];
    }
}


- (IBAction)onOkClick:(id)sender
{
    if (self.selectedIndex < self.pickerDataSource.count && self.selectedIndex >= 0)
    {
        if (self.popPickerDelegate && [self.popPickerDelegate respondsToSelector:@selector(onPopPickerOKClick:viewTag:)])
        {
            [self.popPickerDelegate onPopPickerOKClick:self.selectedIndex viewTag:self.tag];
        }
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
