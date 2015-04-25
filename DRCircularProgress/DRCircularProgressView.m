//
// Created by Dariusz Rybicki on 25/04/15.
// Copyright (c) 2015 Darrarski. All rights reserved.
//

#import "DRCircularProgressView.h"

@implementation DRCircularProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _progressValue = 0.f;
    _progressColor = [UIColor greenColor];
    _alternativeColor = [UIColor grayColor];
    _thickness = 10.f;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGFloat progressAngle = -self.progressValue * 360.f + 90.f;

    [self drawOvalInRect:rect
              startAngle:-90.f
                endAngle:-progressAngle
               thicsness:self.thickness
                   color:self.progressColor];

    [self drawOvalInRect:rect
              startAngle:-progressAngle
                endAngle:270.f
               thicsness:self.thickness
                   color:self.alternativeColor];
}

- (void)drawOvalInRect:(CGRect)rect startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle thicsness:(CGFloat)thickness color:(UIColor *)color
{
    CGRect ovalRect = CGRectInset(rect, thickness / 2.f, thickness / 2.f);
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    [ovalPath addArcWithCenter:CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect))
                        radius:CGRectGetWidth(ovalRect) / 2.f
                    startAngle:startAngle * (CGFloat) M_PI / 180.f
                      endAngle:endAngle * (CGFloat) M_PI / 180.f
                     clockwise:YES];
    [color setStroke];
    ovalPath.lineWidth = thickness;
    [ovalPath stroke];
}

@end
