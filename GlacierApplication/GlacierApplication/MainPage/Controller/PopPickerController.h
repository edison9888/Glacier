//
//  PopPickerController.h
//  GlacierApplication
//
//  Created by cnzhao on 12-10-11.
//  Copyright (c) 2012年 Glacier. All rights reserved.
//

#import "GlacierController.h"

@protocol PopPickerDelegate <NSObject>
@required
- (void) onPopPickerOKClick:(int)index viewTag:(NSInteger)tag;
- (void) onPopPickerCancelClick;
@end


@interface PopPickerController : GlacierController<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,assign) int selectedIndex;
@property (nonatomic,assign) id<PopPickerDelegate> popPickerDelegate;
@property (nonatomic,retain) NSArray * pickerDataSource;
@property (nonatomic,assign) int tag;
@end
