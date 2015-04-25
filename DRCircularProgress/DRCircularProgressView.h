//
// Created by Dariusz Rybicki on 25/04/15.
// Copyright (c) 2015 Darrarski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRCircularProgressView : UIView

@property (nonatomic, assign) CGFloat progressValue;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) UIColor *alternativeColor;
@property (nonatomic, assign) CGFloat thickness;

@end
