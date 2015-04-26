//
// Created by Dariusz Rybicki on 25/04/15.
// Copyright (c) 2015 Darrarski. All rights reserved.
//

#import "DRCircularProgressView.h"

@interface DRCircularProgressView ()

@property (nonatomic, weak) CAShapeLayer *backgroundOvalLayer;
@property (nonatomic, weak) CAShapeLayer *progressOvalLayer;

@end

@implementation DRCircularProgressView

#pragma mark - Initialization

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
    _progressColor = [UIColor blueColor];
    _alternativeColor = [UIColor lightGrayColor];
    _thickness = 10.f;
    [self progressOvalLayer];
    [self backgroundOvalLayer];
}

#pragma mark - Public properties

- (void)setProgressValue:(CGFloat)progressValue
{
    _progressValue = progressValue;
    self.progressOvalLayer.strokeEnd = MIN(1, MAX(0, progressValue));
    self.backgroundOvalLayer.strokeEnd = MIN(1, MAX(0, 1 - progressValue));
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    self.progressOvalLayer.strokeColor = progressColor.CGColor;
}

- (void)setAlternativeColor:(UIColor *)alternativeColor
{
    _alternativeColor = alternativeColor;
    self.backgroundOvalLayer.strokeColor = alternativeColor.CGColor;
}

- (void)setThickness:(CGFloat)thickness
{
    _thickness = thickness;
    self.progressOvalLayer.lineWidth = thickness;
    self.backgroundOvalLayer.lineWidth = thickness;
}

#pragma mark - Internals

- (CAShapeLayer *)backgroundOvalLayer
{
    if (!_backgroundOvalLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.bounds;
        layer.fillColor = nil;
        layer.strokeColor = self.alternativeColor.CGColor;
        layer.lineWidth = self.thickness;
        layer.path = [[self class] ovalPathInRect:CGRectInset(self.bounds, self.thickness / 2.f, self.thickness / 2.f)
                                       startAngle:270
                                         endAngle:-90
                                        clockwise:NO].CGPath;
        layer.strokeStart = 0;
        layer.strokeEnd = MIN(1, MAX(0, 1 - self.progressValue));
        [self.layer addSublayer:layer];
        _backgroundOvalLayer = layer;
    }
    return _backgroundOvalLayer;
}

- (CAShapeLayer *)progressOvalLayer
{
    if (!_progressOvalLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.bounds;
        layer.fillColor = nil;
        layer.strokeColor = self.progressColor.CGColor;
        layer.lineWidth = self.thickness;
        layer.path = [[self class] ovalPathInRect:CGRectInset(self.bounds, self.thickness / 2.f, self.thickness / 2.f)
                                       startAngle:-90
                                         endAngle:270
                                        clockwise:YES].CGPath;
        layer.strokeStart = 0;
        layer.strokeEnd = MIN(1, MAX(0, self.progressValue));
        [self.layer addSublayer:layer];
        _progressOvalLayer = layer;
    }
    return _progressOvalLayer;
}

+ (UIBezierPath *)ovalPathInRect:(CGRect)rect startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise
{
    BOOL isCircle = rect.size.width == rect.size.height;
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    [ovalPath addArcWithCenter:isCircle ? CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)) : CGPointZero
                        radius:CGRectGetWidth(rect) / 2.f
                    startAngle:startAngle * (CGFloat) M_PI / 180.f
                      endAngle:endAngle * (CGFloat) M_PI / 180.f
                     clockwise:clockwise];
    if (!isCircle) {
        CGAffineTransform ovalTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(rect), CGRectGetMidY(rect));
        ovalTransform = CGAffineTransformScale(ovalTransform, 1, CGRectGetHeight(rect) / CGRectGetWidth(rect));
        [ovalPath applyTransform:ovalTransform];
    }
    return ovalPath;
}

@end
