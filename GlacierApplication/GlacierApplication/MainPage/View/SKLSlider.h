//
//  SKLSlider.h
//  GlacierApplication
//
//  Created by yuwan wang on 12-9-13.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKLSliderDelegate <NSObject>

- (void)yearsOldChanged:(NSInteger)yearsOld birDay:(NSDate *)birDayDate;

@end

@interface SKLSlider : UISlider

- (void)setYearsOldMin:(NSInteger)min max:(NSInteger)max;
@property (nonatomic, assign) id <SKLSliderDelegate> delegate;
@property (nonatomic, retain) NSDate *birDay;

- (NSInteger)yearsOldWithBirDay:(NSDate *)birDay;

@end
