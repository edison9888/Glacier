//
//  SKLSlider.m
//  GlacierApplication
//
//  Created by yuwan wang on 12-9-13.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "SKLSlider.h"
@interface SKLSlider ()

- (void)innerInit;
- (void)valueChanged:(SKLSlider *)slider;
- (NSInteger)minDaysTo1970AtYearsOld:(NSInteger)yearsOld;
- (NSInteger)maxDaysTo1970AtYearsOld:(NSInteger)yearsOld;

@property (nonatomic, retain) NSDate *todayDate;
@property (nonatomic, retain) NSDateComponents *todayDateComponents;
@property (nonatomic, retain) NSDate *date1970;
@end

@implementation SKLSlider
@synthesize delegate = _delegate;
@synthesize todayDate = _todayDate;
@synthesize todayDateComponents = _todayDateComponents;
@synthesize date1970 = _date1970;
@synthesize birDay = _birDay;

//- (void)dealloc {
//    self.todayDate = nil;
//    self.todayDateComponents = nil;
//    self.date1970 = nil;
//    self.birDay = nil;
//    [super dealloc];
//}

#pragma mark - 

- (void)innerInit {
    
    [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self innerInit];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self innerInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self innerInit];
    }
    return self;
}

#pragma mark - 

- (void)valueChanged:(SKLSlider *)slider {
    if ([_delegate respondsToSelector:@selector(yearsOldChanged:birDay:)]) {
        NSDateComponents *wDateComponents = [[NSDateComponents alloc] init];
        wDateComponents.day = slider.maximumValue + slider.minimumValue - slider.value;
//        NSLog(@"%s, %d", __func__, wDateComponents.day);
        NSDate *wDate = [[NSCalendar currentCalendar] dateByAddingComponents:wDateComponents toDate:self.date1970 options:0];
//        [wDateComponents release];
        wDateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:wDate toDate:self.todayDate options:0];
        [_delegate yearsOldChanged:wDateComponents.year birDay:wDate];
    }
}

- (NSInteger)minDaysTo1970AtYearsOld:(NSInteger)yearsOld {
    NSDateComponents *wTmp = [self.todayDateComponents copy];
    wTmp.year -= yearsOld + 1;
    wTmp.day += 1;
    NSDate *wTmpDate = [[NSCalendar currentCalendar] dateFromComponents:wTmp];
//    [wTmp release];
    wTmp = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self.date1970 toDate:wTmpDate options:0];
//    NSLog(@"%s, %d", __func__, wTmp.day);
    return wTmp.day;
}

- (NSInteger)maxDaysTo1970AtYearsOld:(NSInteger)yearsOld {
    NSDateComponents *wTmp = [self.todayDateComponents copy];
    wTmp.year -= yearsOld;
    NSDate *wTmpDate = [[NSCalendar currentCalendar] dateFromComponents:wTmp];
//    [wTmp release];
    wTmp = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self.date1970 toDate:wTmpDate options:0];
//    NSLog(@"%s, %d", __func__, wTmp.day);
    return wTmp.day;
}

- (void)setYearsOldMin:(NSInteger)min max:(NSInteger)max 
{
    self.todayDateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    self.todayDate = [[NSCalendar currentCalendar] dateFromComponents:self.todayDateComponents];
    self.date1970 = [NSDate dateWithTimeIntervalSince1970:0];
    
    
    if (min >= 0 && max >= 0) {
        NSInteger wMinValue = MIN([self minDaysTo1970AtYearsOld:min], [self minDaysTo1970AtYearsOld:max]);
        NSInteger wMaxValue = MAX([self maxDaysTo1970AtYearsOld:min], [self maxDaysTo1970AtYearsOld:max]);
        self.minimumValue = wMinValue;
        self.maximumValue = wMaxValue;
//        NSLog(@"%s, %f - %f", __func__, self.minimumValue, self.maximumValue);
        [self setValue:self.minimumValue animated:false];
        [self valueChanged:self];
    }
}

- (void)setBirDay:(NSDate *)birDay {
//    [_birDay release];
    _birDay = nil;
//    _birDay = [birDay retain];
    if (_birDay) {
        NSDateComponents *wTmp = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self.date1970 toDate:birDay options:0];
        self.value = wTmp.day;
    }
}

- (NSInteger)yearsOldWithBirDay:(NSDate *)birDay {
    NSDateComponents *wDateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:birDay toDate:self.todayDate options:0];
    return wDateComponents.year;
}
@end
