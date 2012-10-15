//
//  PopDateController.m
//  GlacierApplication
//
//  Created by chang liang on 12-9-20.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "PopDateController.h"

@interface PopDateController ()
@property (nonatomic,retain) NSDateFormatter * twDateFormatter;
@end

@implementation PopDateController
{

    IBOutlet UINavigationItem *mNavItem;
}
@synthesize picker;
@synthesize popDateDelegate;
@synthesize maxDate;
@synthesize minDate;
@synthesize selectedDate;
@synthesize twDateFormatter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        NSDateFormatter * wTwDateFormatter = [[NSDateFormatter alloc] init];
        twDateFormatter = wTwDateFormatter;
        NSCalendar *wRepublicOfChinaCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSRepublicOfChinaCalendar];
        self.twDateFormatter.calendar = wRepublicOfChinaCalendar;
        
        NSLocale *wLocale  = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
        self.twDateFormatter.locale = wLocale;
        
        self.twDateFormatter.dateFormat = @"G yyy年MM月dd日";
    }
    return self;
}

- (IBAction)onDateChanged:(UIDatePicker *)sender
{
    [mNavItem setTitle:[self.twDateFormatter stringFromDate:sender.date]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.selectedDate)
    {
        picker.date = self.selectedDate;
        [mNavItem setTitle:[self.twDateFormatter stringFromDate:picker.date]];
    }
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
    mNavItem = nil;
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
