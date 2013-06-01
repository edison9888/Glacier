//
//  GlaSegmentedControl.m
//  GlacierFramework
//
//  Created by cnzhao on 13-6-1.
//  Copyright (c) 2013年 Glacier. All rights reserved.
//

#import "GlaSegmentedControl.h"

@implementation GlaSegmentedControl

- (void)initWithImages:(NSArray *)buttonImages buttonTintNormal:(UIColor *)backgroundColorNormal buttonTintPressed:(UIColor *)backgroundColorPressed actionHandler:(void (^)(int buttonIndex))actionHandler {
    buttons = [[NSMutableArray alloc] init];
    int numberOfButtons = [buttonImages count];
    for (int i = 0; i < numberOfButtons; i++) {
        UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
        newButton.frame = CGRectMake(i * (self.frame.size.width/numberOfButtons), 0, self.frame.size.width/numberOfButtons, self.frame.size.height);
        newButton.layer.bounds = CGRectMake(0, 0, self.frame.size.width/numberOfButtons, self.frame.size.height);
        newButton.layer.borderWidth = .5;
        newButton.layer.borderColor = [UIColor colorWithWhite:.6 alpha:1].CGColor;
        newButton.backgroundColor = backgroundColorNormal;
        newButton.clipsToBounds = YES;
        newButton.layer.masksToBounds = YES;
        
        CAGradientLayer *shineLayer = [CAGradientLayer layer];
        shineLayer.frame = newButton.layer.bounds;
        shineLayer.colors = [NSArray arrayWithObjects:
                             (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                             (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                             (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                             (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                             (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                             nil];
        shineLayer.locations = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.0f],
                                [NSNumber numberWithFloat:0.5f],
                                [NSNumber numberWithFloat:0.5f],
                                [NSNumber numberWithFloat:0.8f],
                                [NSNumber numberWithFloat:1.0f],
                                nil];
        [newButton.layer addSublayer:shineLayer];
        
        [newButton addTarget:self action:@selector(buttonUp:event:) forControlEvents:(UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchDragExit)];
        [newButton addTarget:self action:@selector(buttonDown:event:) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
        [newButton addTarget:self action:@selector(buttonPressed:event:) forControlEvents:UIControlEventTouchUpInside];
        [newButton setImage:[buttonImages objectAtIndex:i] forState:UIControlStateNormal];
        
        [self addSubview:newButton];
        [buttons addObject:newButton];
        buttonBackgroundColorForStateNormal = backgroundColorNormal;
        buttonBackgroundColorForStatePressed = backgroundColorPressed;
    }
    self.layer.cornerRadius = 10;
    self.layer.borderColor = [UIColor colorWithWhite:.6 alpha:1].CGColor;
    self.layer.borderWidth = 1;
    self.clipsToBounds = YES;
    buttonPressActionHandler = [actionHandler copy];
}


@end
