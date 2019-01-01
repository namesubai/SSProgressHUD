//
//  SSProgressHUD.m
//  SSProgressHUD
//
//  Created by Shuqy on 2018/12/28.
//  Copyright © 2018 Shuqy. All rights reserved.
//

#import "SSProgressHUD.h"
#import <objc/runtime.h>
#define SSProgressHUDTextMaxWidth ([UIScreen mainScreen].bounds.size.width * 0.75)

static const CGFloat kDuration = 1.f; //圆圈动画的时间
static const CGFloat kLineWidth = 2.f;//圆圈动画线的宽度
static const CGFloat kTextLabelFont = 15.f;//提示文字的字体大小
static const CGFloat kArcRadius = 20.f;//圆圈的半径
static const CGFloat kTextArcRadius = 16.f;//有文字时，圆圈的半径
static const CGFloat kLoadAndTextSpace = 10.f; //圆圈和文字的间隔



@interface SSProgressArcView : UIView
{
    CABasicAnimation *_animation1, *_animation2;
}
@property(nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat progress;


- (instancetype)initWithMode:(SSProgressHUDMode)mode;

@end

@interface SSProgressArcView ()
@property(nonatomic, strong) UIBezierPath *bezierPath;
@property(nonatomic, strong) CAShapeLayer *arcLayer;
@property(nonatomic, assign) SSProgressHUDMode mode;
@property(nonatomic, strong) UIBezierPath *aboveBezierPath;
@property(nonatomic, strong) CAShapeLayer *aboveArcLayer;
@property(nonatomic, strong) UILabel *progressLabel;

@end

@implementation SSProgressArcView

- (instancetype)initWithMode:(SSProgressHUDMode)mode {
    if (self = [super init]) {
        self.mode = mode;
        _bezierPath = [UIBezierPath bezierPath];
        _arcLayer = [CAShapeLayer layer];
        _arcLayer.lineWidth = kLineWidth;
        _arcLayer.fillColor = [UIColor clearColor].CGColor;
        _arcLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:_arcLayer];
        if (mode == SSProgressHUDModeProgressValue) {
            _arcLayer.strokeColor = [[UIColor blackColor]colorWithAlphaComponent:0.2].CGColor;

            _aboveBezierPath = [UIBezierPath bezierPath];
            _aboveArcLayer = [CAShapeLayer layer];
            _aboveArcLayer.lineWidth = kLineWidth;
            _aboveArcLayer.fillColor = [UIColor clearColor].CGColor;
            _aboveArcLayer.strokeColor = [UIColor blackColor].CGColor;
            _aboveArcLayer.lineCap = kCALineCapRound;
            [self.layer addSublayer:_aboveArcLayer];
            
            _progressLabel = [UILabel new];
            _progressLabel.textAlignment = NSTextAlignmentCenter;
            _progressLabel.adjustsFontSizeToFitWidth = YES;
            [self addSubview:_progressLabel];
            
            
            
        }else{
            _arcLayer.strokeColor = [UIColor blackColor].CGColor;

            _animation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            _animation1.fromValue = @0;
            _animation1.toValue = @1;
            _animation1.duration = kDuration;
            _animation1.repeatCount = 1;
            _animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            _animation1.removedOnCompletion = NO;
            _animation1.fillMode = kCAFillModeBoth;
            
            _animation2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
            _animation2.fromValue = @0;
            _animation2.toValue = @1;
            _animation2.duration = kDuration;
            _animation2.repeatCount = 1;
            _animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            _animation2.removedOnCompletion = NO;
            _animation2.fillMode = kCAFillModeBoth;
        }
    }
    return self;
}


- (void)didMoveToSuperview{
    
    if (self.mode != SSProgressHUDModeProgressValue) {
        [self startAnimated1];
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bezierPath removeAllPoints];
    [self.bezierPath addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.f) radius:CGRectGetWidth(self.frame)/2.0 startAngle:-M_PI/2 endAngle:M_PI*1.5 clockwise:YES];
    self.arcLayer.path = self.bezierPath.CGPath;
    _progressLabel.frame = CGRectMake(kLineWidth, 0, CGRectGetWidth(self.frame)-kLineWidth*2, CGRectGetHeight(self.frame)-kLineWidth*2);
}


- (void)startAnimated1{
    [self.arcLayer removeAllAnimations];
    [self.arcLayer addAnimation:_animation1 forKey:@"strokeEndAnimation"];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf startAnimated2];
    });
}

- (void)startAnimated2{
    
    [self.arcLayer removeAllAnimations];
    [self.arcLayer addAnimation:_animation2 forKey:@"strokeStartAnimation"];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf startAnimated1];
    });
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    if (self.mode == SSProgressHUDModeProgressValue) {
        self.aboveArcLayer.strokeColor = lineColor.CGColor;
        self.arcLayer.strokeColor = [lineColor colorWithAlphaComponent:0.2].CGColor;
    }else{
        self.arcLayer.strokeColor = lineColor.CGColor;
    }
    
}

- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    if (_progress>=1) {
        _progress = 1;
    }
    if (_progress<=0) {
        _progress = 0;
    }
    [_aboveBezierPath removeAllPoints];
    [_aboveBezierPath addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.f) radius:CGRectGetWidth(self.frame)/2.0 startAngle:-M_PI/2 endAngle:M_PI*1.5*_progress clockwise:YES];
    _aboveArcLayer.path = _aboveBezierPath.CGPath;
}


@end


@interface SSProgressCustomView ()

@end

@implementation SSProgressCustomView

@end


@interface SSProgressLoadTextView ()
@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) SSProgressArcView *arcView;
@property(nonatomic, assign) SSProgressHUDMode mode;

@end

@implementation SSProgressLoadTextView

- (instancetype)initWithMode:(SSProgressHUDMode)mode {
    if (self = [super init]) {
        self.mode = mode;
        if (mode == SSProgressHUDModeLoadingAndText) {
            _arcView = [[SSProgressArcView alloc]initWithMode:mode];
            [self addSubview:_arcView];
            _arcView.translatesAutoresizingMaskIntoConstraints = NO;
            
            _textLabel = [UILabel new];
            _textLabel.numberOfLines = 0;
            _textLabel.textAlignment = NSTextAlignmentCenter;
            _textLabel.font = [UIFont systemFontOfSize:kTextLabelFont];
            _textLabel.preferredMaxLayoutWidth = SSProgressHUDTextMaxWidth;
            [self addSubview:_textLabel];
            _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        }
        if (mode == SSProgressHUDModeLoading) {
            _arcView = [[SSProgressArcView alloc]initWithMode:mode];
            [self addSubview:_arcView];
            _arcView.translatesAutoresizingMaskIntoConstraints = NO;
        }
        if (mode == SSProgressHUDModeText) {
            _textLabel = [UILabel new];
            _textLabel.numberOfLines = 0;
            _textLabel.textAlignment = NSTextAlignmentCenter;
            _textLabel.font = [UIFont systemFontOfSize:kTextLabelFont];
            _textLabel.preferredMaxLayoutWidth = SSProgressHUDTextMaxWidth;
            [self addSubview:_textLabel];
            _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        
    }
    return self;
}

- (void)updateConstraints {
    
    
    if (self.mode == SSProgressHUDModeText) {
        NSLayoutConstraint *textTop = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *textleft = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *textRight = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        NSLayoutConstraint *textBottom = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        
        [self addConstraints:@[textTop,textleft,textRight,textBottom]];
    }
    
    if (self.mode == SSProgressHUDModeLoadingAndText) {
        if (self.text.length) {
            NSLayoutConstraint *loadTop = [NSLayoutConstraint constraintWithItem:self.arcView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
            NSLayoutConstraint *loadCenterX = [NSLayoutConstraint constraintWithItem:self.arcView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
            NSLayoutConstraint *loadWidth = [NSLayoutConstraint constraintWithItem:self.arcView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kTextArcRadius*2];
            NSLayoutConstraint *loadHeight = [NSLayoutConstraint constraintWithItem:self.arcView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kTextArcRadius*2];
            [self addConstraints:@[loadTop,loadCenterX,loadWidth,loadHeight]];
            
            
            NSLayoutConstraint *textTop = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:kTextArcRadius*2 + kLoadAndTextSpace];
            NSLayoutConstraint *textleft = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
            NSLayoutConstraint *textRight = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
            NSLayoutConstraint *textBottom = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
            NSLayoutConstraint *textWidth = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kTextArcRadius*2];
            
            [self addConstraints:@[textTop,textleft,textRight,textBottom,textWidth,textWidth]];
        }else {
            NSLayoutConstraint *loadWidth = [NSLayoutConstraint constraintWithItem:self.arcView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kArcRadius*2];
            NSLayoutConstraint *loadHeight = [NSLayoutConstraint constraintWithItem:self.arcView  attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kArcRadius*2];
            NSLayoutConstraint *loadTop = [NSLayoutConstraint constraintWithItem:self.arcView   attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
            NSLayoutConstraint *loadLeft = [NSLayoutConstraint constraintWithItem:self.arcView   attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
            NSLayoutConstraint *loadBottom = [NSLayoutConstraint constraintWithItem:self.arcView   attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
            NSLayoutConstraint *loadRight = [NSLayoutConstraint constraintWithItem:self.arcView   attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
            
            [self addConstraints:@[loadWidth,loadHeight,loadTop,loadLeft,loadBottom,loadRight]];
        }
    }
    
    if (self.mode == SSProgressHUDModeLoading) {
        NSLayoutConstraint *loadWidth = [NSLayoutConstraint constraintWithItem:self.arcView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kArcRadius*2];
        NSLayoutConstraint *loadHeight = [NSLayoutConstraint constraintWithItem:self.arcView  attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kArcRadius*2];
        NSLayoutConstraint *loadTop = [NSLayoutConstraint constraintWithItem:self.arcView   attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *loadLeft = [NSLayoutConstraint constraintWithItem:self.arcView   attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *loadBottom = [NSLayoutConstraint constraintWithItem:self.arcView   attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *loadRight = [NSLayoutConstraint constraintWithItem:self.arcView   attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        
        [self addConstraints:@[loadWidth,loadHeight,loadTop,loadLeft,loadBottom,loadRight]];
    }
    
   
    [super updateConstraints];

}

- (void)setText:(NSString *)text
{
    [super setText:text];
    _textLabel.text = text;
    [self setNeedsUpdateConstraints];
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    _textLabel.textColor = textColor;
}

- (void)setContentColor:(UIColor *)contentColor {
    [super setContentColor:contentColor];
    _textLabel.textColor = contentColor;
    _arcView.lineColor = contentColor;
    _arcView.progressLabel.textColor = contentColor;
}

- (void)setTextFont:(UIFont *)textFont {
    [super setTextFont:textFont];
    _textLabel.font = textFont;
}

@end


@interface SSProgressValueView ()
@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) SSProgressArcView *arcView;
@end

@implementation SSProgressValueView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _arcView = [[SSProgressArcView alloc]initWithMode:SSProgressHUDModeProgressValue];
        [self addSubview:_arcView];
        _arcView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _textLabel = [UILabel new];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:kTextLabelFont];
        _textLabel.preferredMaxLayoutWidth = SSProgressHUDTextMaxWidth;
        [self addSubview:_textLabel];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (_progress>=1) {
        _progress = 1;
    }
    if (_progress<=0) {
        _progress = 0;
    }
    _arcView.progress = _progress;
    _arcView.progressLabel.text = [NSString stringWithFormat:@"%.f%%",_progress*100];
}

- (void)updateConstraints {
    if (self.text.length) {
        NSLayoutConstraint *loadTop = [NSLayoutConstraint constraintWithItem:self.arcView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *loadCenterX = [NSLayoutConstraint constraintWithItem:self.arcView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *loadWidth = [NSLayoutConstraint constraintWithItem:self.arcView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kTextArcRadius*2];
        NSLayoutConstraint *loadHeight = [NSLayoutConstraint constraintWithItem:self.arcView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kTextArcRadius*2];
        [self addConstraints:@[loadTop,loadCenterX,loadWidth,loadHeight]];
        
        
        NSLayoutConstraint *textTop = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:kTextArcRadius*2 + kLoadAndTextSpace];
        NSLayoutConstraint *textleft = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *textRight = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        NSLayoutConstraint *textBottom = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *textWidth = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kTextArcRadius*2];
        
        [self addConstraints:@[textTop,textleft,textRight,textBottom,textWidth,textWidth]];
    }else {
        NSLayoutConstraint *loadWidth = [NSLayoutConstraint constraintWithItem:self.arcView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kArcRadius*2];
        NSLayoutConstraint *loadHeight = [NSLayoutConstraint constraintWithItem:self.arcView  attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kArcRadius*2];
        NSLayoutConstraint *loadTop = [NSLayoutConstraint constraintWithItem:self.arcView   attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *loadLeft = [NSLayoutConstraint constraintWithItem:self.arcView   attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *loadBottom = [NSLayoutConstraint constraintWithItem:self.arcView   attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *loadRight = [NSLayoutConstraint constraintWithItem:self.arcView   attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        
        [self addConstraints:@[loadWidth,loadHeight,loadTop,loadLeft,loadBottom,loadRight]];
    }
    [super updateConstraints];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    _textLabel.text = text;
    [self setNeedsUpdateConstraints];
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    _textLabel.textColor = textColor;
}

- (void)setContentColor:(UIColor *)contentColor {
    [super setContentColor:contentColor];
    _textLabel.textColor = contentColor;
    _arcView.lineColor = contentColor;
}

- (void)setTextFont:(UIFont *)textFont {
    [super setTextFont:textFont];
    _textLabel.font = textFont;
}



@end


@interface SSProgressImageView ()
@property (nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *textLabel;

@end


@implementation SSProgressImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]init];
        [self addSubview:_imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        _textLabel = [UILabel new];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:kTextLabelFont];
        _textLabel.preferredMaxLayoutWidth = SSProgressHUDTextMaxWidth;
        [self addSubview:_textLabel];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if (self.text.length) {
        NSLayoutConstraint *loadTop = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *loadCenterX = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        CGFloat arcRadius = kArcRadius*0.7;
//        NSLayoutConstraint *loadWidth = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:arcRadius*2];
//        NSLayoutConstraint *loadHeight = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:arcRadius*2];
        [self addConstraints:@[loadTop,loadCenterX]];
        
        
        NSLayoutConstraint *textTop = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:kLoadAndTextSpace];
        NSLayoutConstraint *textleft = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *textRight = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        NSLayoutConstraint *textBottom = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *textWidth = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:arcRadius*2];
        
        [self addConstraints:@[textTop,textleft,textRight,textBottom,textWidth,textWidth]];
    }else {
    
        NSLayoutConstraint *loadTop = [NSLayoutConstraint constraintWithItem:self.imageView   attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *loadLeft = [NSLayoutConstraint constraintWithItem:self.imageView   attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *loadBottom = [NSLayoutConstraint constraintWithItem:self.imageView   attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *loadRight = [NSLayoutConstraint constraintWithItem:self.imageView   attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        
        [self addConstraints:@[loadTop,loadLeft,loadBottom,loadRight]];
    }
    [super updateConstraints];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    _textLabel.text = text;
    [self setNeedsUpdateConstraints];
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    _textLabel.textColor = textColor;
}

- (void)setContentColor:(UIColor *)contentColor {
    [super setContentColor:contentColor];
    _textLabel.textColor = contentColor;
}

- (void)setTextFont:(UIFont *)textFont {
    [super setTextFont:textFont];
    _textLabel.font = textFont;
}
@end



@interface SSProgressHUD()

@property(nonatomic, assign) SSProgressHUDMode mode;
@property(nonatomic, strong) UIView *customView;
@property(nonatomic, strong) UIView *maskView;

@end

@implementation SSProgressHUD

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.customViewEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        self.translatesAutoresizingMaskIntoConstraints = NO;

    }
    return self;
}

- (instancetype)initWithCustomView:(UIView *)customView{
    NSAssert(customView, @"customView不为nil");
    if (self = [self initWithFrame:CGRectZero]) {
        self.customView = customView;
        self.customView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.customView];
    }
    return self;
}

- (instancetype)initWithMode:(SSProgressHUDMode)mode{
    self.mode = mode;
    UIView *tempView;
    
    if (mode == SSProgressHUDModeLoading) {
        tempView = [[SSProgressLoadTextView alloc]initWithMode:SSProgressHUDModeLoading];
    }
    
    if (mode == SSProgressHUDModeLoadingAndText) {
       tempView = [[SSProgressLoadTextView alloc]initWithMode:SSProgressHUDModeLoadingAndText];
    }
    
    if (mode == SSProgressHUDModeText) {
        tempView = [[SSProgressLoadTextView alloc]initWithMode:SSProgressHUDModeText];

    }
    if (mode == SSProgressHUDModeProgressValue) {
        tempView = [[SSProgressValueView alloc]initWithFrame:CGRectZero];
    }
    if (mode == SSProgressHUDModeImage) {
        tempView = [[SSProgressImageView alloc]initWithFrame:CGRectZero];
    }
    
    self = [self initWithCustomView:tempView];

    return self;
}


- (void)updateConstraints {
    
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.customView  attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:self.customViewEdgeInsets.top];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.customView  attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:self.customViewEdgeInsets.left];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.customView  attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.customViewEdgeInsets.bottom];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.customView  attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-self.customViewEdgeInsets.right];
    if (self.customView.frame.size.width &&self.customView.frame.size.height) {
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.customView  attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.customView.frame.size.width];
         NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.customView  attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.customView.frame.size.height];
        [self addConstraint:width];
        [self addConstraint:height];

    }
    [self addConstraints:@[top,left,bottom,right]];
    

    NSLayoutConstraint *selfCenterX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:self.viewCenterOffet.x];
    NSLayoutConstraint *selfCenterY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:self.viewCenterOffet.y];
    [self.superview addConstraints:@[selfCenterX,selfCenterY]];
    
    
    
    [super updateConstraints];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.maskView.frame = CGRectMake(0, 0, CGRectGetWidth(self.maskView.superview.frame), CGRectGetHeight(self.maskView.superview.frame));
    CGRect selfFrame = self.frame;
    CGSize selfSize = selfFrame.size;
    selfSize.width = CGRectGetWidth(self.customView.frame)+self.customViewEdgeInsets.left+self.customViewEdgeInsets.right;
    selfSize.height = CGRectGetHeight(self.customView.frame)+self.customViewEdgeInsets.top+self.customViewEdgeInsets.bottom;
    selfFrame.size = selfSize;
    self.frame = selfFrame;
}

- (void)showOnView:(UIView *)view animated:(BOOL)animated{
   
    [self showOnView:view animated:animated maskType:SSProgressHUDMaskTypeNone];
  
}

- (void)showOnView:(UIView *)view animated:(BOOL)animated maskType:(SSProgressHUDMaskType)maskType {
    NSAssert(view, @"superView不为nil");
    if (maskType != SSProgressHUDMaskTypeNone) {
        self.maskView = [UIView new];
        if (maskType == SSProgressHUDMaskTypeBlack) {
            self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
        }
        [view addSubview:self.maskView];
    }

 
    [view addSubview:self];
    [self setNeedsUpdateConstraints];
    if (animated) {
        self.alpha = 0.f;
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)hideViewAnimated:(BOOL)animated{
    [self hideViewAnimated:animated completion:nil];

}
- (void)hideViewAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0.0f;
            if (self.maskView) {
                self.maskView.alpha = 0.0;
            }
        } completion:^(BOOL finished) {
            !completion?:completion();
            [self removeFromSuperview];
            if (self.maskView) {
                [self.maskView removeFromSuperview];
            }
        }];
    }else{
        !completion?:completion();
        [self removeFromSuperview];
        if (self.maskView) {
            [self.maskView removeFromSuperview];
        }
    }
}

- (void)setCustomProgress:(CGFloat)customProgress finished:(void (^__nullable)(void))finished {
    self.customProgress = customProgress;
    if (customProgress>=1) {
        !finished?:finished();
    }
}


- (SSProgressCustomView *)getCustomView{
    
    if ([self.customView isKindOfClass:SSProgressCustomView.class]) {
        SSProgressCustomView *view = (SSProgressCustomView *)self.customView;
        return view;
    }
    return nil;
}




#pragma mark - Property



- (void)setViewCenterOffet:(CGPoint)viewCenterOffet{
    _viewCenterOffet = viewCenterOffet;
    [self setNeedsUpdateConstraints];
}

- (void)setCustomViewEdgeInsets:(UIEdgeInsets)customViewEdgeInsets{
    _customViewEdgeInsets = customViewEdgeInsets;
    [self setNeedsUpdateConstraints];
}

- (void)setCustomContentColor:(UIColor *)customContentColor {
    [self getCustomView].contentColor = customContentColor;
}
- (void)setCustomText:(NSString *)customText {
    [self getCustomView].text = customText;
}
- (void)setCustomTextColor:(UIColor *)customTextColor {
    [self getCustomView].textColor = customTextColor;
}
- (void)setCustomTextFont:(UIFont *)customTextFont {
    [self getCustomView].textFont = customTextFont;
}

- (void)setCustomProgress:(CGFloat)customProgress {
    if (self.mode == SSProgressHUDModeProgressValue&&self.customView) {
        SSProgressValueView *view = (SSProgressValueView *)self.customView;
        view.progress = customProgress;
    }
}
- (void)setCustomImage:(UIImage *)customImage {
    if (self.mode == SSProgressHUDModeImage&&self.customView&&customImage) {
        SSProgressImageView *view = (SSProgressImageView *)self.customView;
        view.image = customImage;
    }
}

- (void)setColorType:(SSProgressHUDColorType)colorType {
    if (colorType == SSProgressHUDColorTypeBlack) {
        [self getCustomView].contentColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor blackColor];
    }
}

@end



@implementation NSObject (SSProgressHUD)

- (NSMutableDictionary *)hudDict {
    
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, @{}.mutableCopy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, _cmd);
}


#pragma mark - show loading
- (void)showLoading {
    [self showLoadingWithTag:-1];
}

- (void)showLoadingWithMaskType:(SSProgressHUDMaskType)maskType {
    [self showLoadingWithTag:-1 maskType:maskType];
}

- (void)showLoadingWithTag:(NSInteger)tag {
    [self showLoadingWithTag:tag maskType:SSProgressHUDMaskTypeNone];
}
- (void)showLoadingWithTag:(NSInteger)tag maskType:(SSProgressHUDMaskType)maskType {
    [self showHUDWithMode:SSProgressHUDModeLoading text:nil tag:tag maskType:maskType];
}

- (void)showLoadingText:( NSString *)text {
    [self showLoadingText:text tag:-1];
}
- (void)showLoadingText:(NSString * _Nullable )text maskType:(SSProgressHUDMaskType)maskType{
    [self showLoadingText:text tag:-1 maskType:maskType];
}

- (void)showLoadingText:( NSString *)text tag:(NSInteger)tag {

    [self showLoadingText:text tag:tag maskType:SSProgressHUDMaskTypeNone];
}
- (void)showLoadingText:(NSString *)text tag:(NSInteger)tag maskType:(SSProgressHUDMaskType)maskType {
     [self showHUDWithMode:SSProgressHUDModeLoadingAndText text:text tag:tag maskType:maskType];
}

#pragma mark - show text
- (void)showText:(NSString *)text {
    
    [self showText:text finished:nil];
    
}
- (void)showText:(NSString *)text finished:(void (^ __nullable)(void))finished {
    [self showText:text maskType:SSProgressHUDMaskTypeNone finished:finished];
}

- (void)showText:(NSString *)text maskType:(SSProgressHUDMaskType)maskType finished:(void(^ __nullable)(void))finished {
    SSProgressHUD *hud = [self showHUDWithMode:SSProgressHUDModeText text:text tag:0 maskType:maskType];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideViewAnimated:YES completion:finished];
    });
}

#pragma mark - progress

- (void)showProgress:(CGFloat)progress finished:(void (^ __nullable)(void))finished {
    [self showProgress:progress text:nil maskType:SSProgressHUDMaskTypeNone finished:finished];
}
- (void)showProgress:(CGFloat)progress maskType:(SSProgressHUDMaskType)maskType finished:(void(^ __nullable)(void))finished {
   [self showProgress:progress text:nil maskType:maskType finished:finished];
}

- (void)showProgress:(CGFloat)progress text:(NSString *)text finished:(void (^ __nullable)(void))finished {
    [self showProgress:progress text:text maskType:SSProgressHUDMaskTypeNone finished:finished];
}

- (void)showProgress:(CGFloat)progress text:(NSString * _Nullable)text maskType:(SSProgressHUDMaskType)maskType finished:(void (^ _Nullable)(void))finished {
    SSProgressHUD *hud = [self progressValueHUDWithMaskType:maskType];
    hud.customText = text;
    __weak SSProgressHUD *weakHud = hud;
    [hud setCustomProgress:progress finished:^{
        [weakHud hideViewAnimated:YES completion:^{
            !finished?:finished();
            objc_setAssociatedObject(self, @selector(progressValueHUDWithMaskType:), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }];
    }];
}

#pragma mark - image

- (void)showHUDWithImageName:(NSString *)imageName {
    [self showHUDWithImageName:imageName text:nil];
}
- (void)showHUDWithImageName:(NSString *)imageName text:(NSString *)text {
    [self showHUDWithImageName:imageName text:text finished:nil];
}

- (void)showHUDWithImageName:(NSString *)imageName text:(NSString *)text finished:( void(^ __nullable)(void))finished {

    [self showHUDWithImageName:imageName text:text maskType:SSProgressHUDMaskTypeNone finished:finished];
}
- (void)showHUDWithImageName:(NSString *)imageName text:(NSString *)text maskType:(SSProgressHUDMaskType)maskType finished:(void (^ _Nullable)(void))finished {
    SSProgressHUD *hud = [self showHUDWithMode:SSProgressHUDModeImage text:text tag:0 maskType:maskType];
    hud.customImage = [UIImage imageNamed:imageName];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideViewAnimated:YES completion:finished];
    });
}

#pragma mark - hide
- (void)hideHUD {
    [self hideHUDAnimated:YES tag:-1];
}
- (void)hideHUDWithTag:(NSInteger)tag {
    [self hideHUDAnimated:YES tag:tag finished:nil];
}
- (void)hideHUDAnimated:(BOOL)animated {
    [self hideHUDAnimated:animated finished:nil];
}
- (void)hideHUDAnimated:(BOOL)animated tag:(NSInteger)tag {
    [self hideHUDAnimated:animated tag:tag finished:nil];

}
- (void)hideHUDAnimated:(BOOL)animated finished:(void(^ __nullable)(void))finished {
    [self hideHUDAnimated:animated tag:-1 finished:finished];
}
- (void)hideHUDAnimated:(BOOL)animated tag:(NSInteger)tag finished:(void (^ __nullable)(void))finished {
    SSProgressHUD *hud = [[self hudDict]objectForKey:[NSString stringWithFormat:@"%ld",tag]];
    [hud hideViewAnimated:animated completion:finished];
}

#pragma mark - method

- (SSProgressHUD *)showHUDWithMode:(SSProgressHUDMode)mode text:(NSString *)text tag:(NSInteger)tag maskType:(SSProgressHUDMaskType)maskType{
    if (![self getSuperView]) return nil;
    SSProgressHUD *hud = [[SSProgressHUD alloc]initWithMode:mode];
//    hud.colorType = SSProgressHUDColorTypeBlack;
    hud.customText = text;
    [hud showOnView:[self getSuperView] animated:YES maskType:maskType];
    NSString *tagKey = [NSString stringWithFormat:@"%ld",tag];
    ///如果已存在相同的就删除
 
    if (tag>0||tag==-1) {
        if ([[[self hudDict]allKeys]containsObject:tagKey]) {
            SSProgressHUD *t = [[self hudDict]objectForKey:tagKey];
            [t hideViewAnimated:NO];
            [[self hudDict]removeObjectForKey:tagKey];
        }
        [[self hudDict]setObject:hud forKey:[NSString stringWithFormat:@"%ld",tag]];
    }

    return hud;
}

- (SSProgressHUD *)progressValueHUDWithMaskType:(SSProgressHUDMaskType)maskType {
    if (!objc_getAssociatedObject(self, _cmd)) {
        SSProgressHUD *hud =  [[SSProgressHUD alloc]initWithMode:SSProgressHUDModeProgressValue];
        [hud showOnView:[self getSuperView] animated:YES maskType:maskType];
        objc_setAssociatedObject(self, _cmd, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return objc_getAssociatedObject(self, _cmd);
}



- (UIView *)getSuperView
{
    if ([self isKindOfClass:[UIView class]]) {
        return (UIView *)self;
    }else if ([self isKindOfClass:[UIViewController class]]){
        return [(UIViewController *)self view];
    }else if([UIApplication sharedApplication].keyWindow){
        return [UIApplication sharedApplication].keyWindow;
    }
    return nil;
}

@end
