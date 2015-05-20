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
    _startAngle = -90;
    _endAngle = 270;
    _clockwise = YES;

#if !TARGET_INTERFACE_BUILDER
    [self progressOvalLayer];
    [self backgroundOvalLayer];
#endif
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    if ([layer isEqual:self.layer]) {
        [self updateOvalPaths];
    }
}

#pragma mark - Public properties

- (void)setProgressValue:(CGFloat)progressValue
{
    _progressValue = progressValue;
    [self.layer setValue:@(progressValue) forKey:NSStringFromSelector(@selector(progressValue))];
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

- (void)setStartAngle:(CGFloat)startAngle
{
    _startAngle = startAngle;
    [self updateOvalPaths];
}

- (void)setEndAngle:(CGFloat)endAngle
{
    _endAngle = endAngle;
    [self updateOvalPaths];
}

- (void)setClockwise:(BOOL)clockwise
{
    _clockwise = clockwise;
    [self updateOvalPaths];
}

#pragma mark - CoreAnimation

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)key
{
    if ([key isEqualToString:NSStringFromSelector(@selector(progressValue))]) {
        CAAnimation *action = (CAAnimation *)[self actionForLayer:layer forKey:@"backgroundColor"];
        if (![action isKindOfClass:[NSNull class]]) {
            CGFloat currentProgress = [[layer valueForKey:NSStringFromSelector(@selector(progressValue))] floatValue];
            CGFloat targetProgress = self.progressValue;

            CABasicAnimation *progressOvalAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            progressOvalAnimation.fromValue = @([[self class] progressOvalStokeEndForProgress:currentProgress]);
            progressOvalAnimation.toValue = @([[self class] progressOvalStokeEndForProgress:targetProgress]);

            CABasicAnimation *backgroundOvalAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            backgroundOvalAnimation.fromValue = @([[self class] backgroundOvalStrokeEndForProgress:currentProgress]);
            backgroundOvalAnimation.toValue = @([[self class] backgroundOvalStrokeEndForProgress:targetProgress]);

            for (CABasicAnimation *animation in @[progressOvalAnimation, backgroundOvalAnimation]) {
                animation.beginTime = action.beginTime;
                animation.duration = action.duration;
                animation.speed = action.speed;
                animation.timeOffset = action.timeOffset;
                animation.repeatCount = action.repeatCount;
                animation.repeatDuration = action.repeatDuration;
                animation.autoreverses = action.autoreverses;
                animation.fillMode = action.fillMode;
                animation.timingFunction = action.timingFunction;
                animation.delegate = action.delegate;
            }

            [self.progressOvalLayer addAnimation:progressOvalAnimation forKey:@"strokeEnd"];
            [self.backgroundOvalLayer addAnimation:backgroundOvalAnimation forKey:@"strokeEnd"];
        }
        else {
            self.progressOvalLayer.strokeEnd = [[self class] progressOvalStokeEndForProgress:self.progressValue];
            self.backgroundOvalLayer.strokeEnd = [[self class] backgroundOvalStrokeEndForProgress:self.progressValue];
        }
    }
    return [super actionForLayer:layer forKey:key];
}

#pragma mark - Internals

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

#if TARGET_INTERFACE_BUILDER
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.backgroundOvalLayer drawInContext:ctx];
    [self.progressOvalLayer drawInContext:ctx];
#endif
}

- (void)updateOvalPaths
{
    self.progressOvalLayer.path = [self progressOvalLayerPath];
    self.backgroundOvalLayer.path = [self backgroundOvalLayerPath];
}

- (CAShapeLayer *)backgroundOvalLayer
{
    if (!_backgroundOvalLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.bounds;
        layer.fillColor = nil;
        layer.strokeColor = self.alternativeColor.CGColor;
        layer.lineWidth = self.thickness;
        layer.path = [self backgroundOvalLayerPath];
        layer.strokeStart = 0;
        layer.strokeEnd = [[self class] backgroundOvalStrokeEndForProgress:self.progressValue];
        [self.layer addSublayer:layer];
        _backgroundOvalLayer = layer;
    }
    return _backgroundOvalLayer;
}

- (CGPathRef)backgroundOvalLayerPath
{
    return [[self class] ovalPathInRect:CGRectInset(self.bounds, self.thickness / 2.f, self.thickness / 2.f)
                             startAngle:self.endAngle
                               endAngle:self.startAngle
                              clockwise:!self.clockwise].CGPath;
}

- (CAShapeLayer *)progressOvalLayer
{
    if (!_progressOvalLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.bounds;
        layer.fillColor = nil;
        layer.strokeColor = self.progressColor.CGColor;
        layer.lineWidth = self.thickness;
        layer.path = [self progressOvalLayerPath];
        layer.strokeStart = 0;
        layer.strokeEnd = [[self class] progressOvalStokeEndForProgress:self.progressValue];
        [self.layer addSublayer:layer];
        _progressOvalLayer = layer;
    }
    return _progressOvalLayer;
}

- (CGPathRef)progressOvalLayerPath
{
    return [[self class] ovalPathInRect:CGRectInset(self.bounds, self.thickness / 2.f, self.thickness / 2.f)
                             startAngle:self.startAngle
                               endAngle:self.endAngle
                              clockwise:self.clockwise].CGPath;
}

+ (UIBezierPath *)ovalPathInRect:(CGRect)rect startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise
{
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) return nil;

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

+ (CGFloat)progressOvalStokeEndForProgress:(CGFloat)progressValue
{
    return progressValue;
}

+ (CGFloat)backgroundOvalStrokeEndForProgress:(CGFloat)progressValue
{
    return 1 - progressValue;
}

@end
