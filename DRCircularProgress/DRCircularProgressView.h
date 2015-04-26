//
// Created by Dariusz Rybicki on 25/04/15.
// Copyright (c) 2015 Darrarski. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface DRCircularProgressView : UIView

@property (nonatomic, assign) IBInspectable CGFloat progressValue;
@property (nonatomic, strong) IBInspectable UIColor *progressColor;
@property (nonatomic, strong) IBInspectable UIColor *alternativeColor;
@property (nonatomic, assign) IBInspectable CGFloat thickness;

@end
