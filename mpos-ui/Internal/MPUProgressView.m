/*
 * mpos-ui : http://www.payworks.com
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Payworks GmbH
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MPUProgressView.h"


static NSString *const MRActivityIndicatorViewSpinAnimationKey = @"MRActivityIndicatorViewSpinAnimationKey";

@interface MPUProgressView()

@property (nonatomic, weak) CAShapeLayer *shapeLayer;

@end

@implementation MPUProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initProgressView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initProgressView];
    }
    return self;
}

- (void)initProgressView {
    self.isAccessibilityElement = YES;
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.borderWidth = 0;
    shapeLayer.fillColor = UIColor.clearColor.CGColor;
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer.lineWidth = 1;

    [self.layer addSublayer:shapeLayer];
    self.shapeLayer = shapeLayer;
    [self tintColorDidChange];
}

#pragma mark  - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.bounds;
    if (ABS(frame.size.width - frame.size.height) < CGFLOAT_MIN) {
        // Ensure that we have a square frame
        CGFloat s = MIN(frame.size.width, frame.size.height);
        frame.size.width = s;
        frame.size.height = s;
    }
    self.shapeLayer.frame = frame;
    self.shapeLayer.path = [self layoutPath].CGPath;
}

- (UIBezierPath *)layoutPath {
    const double TWO_M_PI = 2.0*M_PI;
    double startAngle = 0.98 * TWO_M_PI;
    double endAngle = startAngle + TWO_M_PI * 0.98;
    CGFloat width = self.bounds.size.width;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f)
                                          radius:width/2.2f
                                      startAngle:startAngle
                                        endAngle:endAngle
                                       clockwise:YES];
}

- (void)setAnimating:(BOOL)animating {
    if (self.animating == animating) {
        return;
    }
    
    if (animating) {
        [self addAnimation];
        self.hidden = NO;
    } else {
        [self removeAnimation];
        self.hidden = YES;
    }
    
    _animating = animating;
}

- (void)addAnimation {
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = @(1*2*M_PI);
    spinAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    spinAnimation.duration = 2.3;
    spinAnimation.repeatCount = INFINITY;
    [self.shapeLayer addAnimation:spinAnimation forKey:MRActivityIndicatorViewSpinAnimationKey];
}

- (void)removeAnimation {
    [self.shapeLayer removeAnimationForKey:MRActivityIndicatorViewSpinAnimationKey];
}

@end