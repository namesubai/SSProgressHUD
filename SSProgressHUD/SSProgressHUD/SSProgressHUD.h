//
//  SSProgressHUD.h
//  SSProgressHUD
//
//  Created by Shuqy on 2018/12/28.
//  Copyright © 2018 Shuqy. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,SSProgressHUDMode) {
    ///默认loading,不带文字
    SSProgressHUDModeLoading,
    ///loading&文字
    SSProgressHUDModeLoadingAndText,
    ///文字提示
    SSProgressHUDModeText,
    ///进度条
    SSProgressHUDModeProgressValue,
    ///图标
    SSProgressHUDModeImage
};


/**
 遮罩的类型，有遮罩不能点击遮罩下的事件
 */
typedef NS_ENUM(NSInteger, SSProgressHUDMaskType) {
    ///没有遮罩
    SSProgressHUDMaskTypeNone,
    ///黑色遮罩
    SSProgressHUDMaskTypeBlack,
    ///透明遮罩
    SSProgressHUDMaskTypeClear
};
/**
 颜色风格
 */
typedef NS_ENUM(NSInteger, SSProgressHUDColorType) {
    ///默认风格
    SSProgressHUDColorTypeDefault,
    ///黑色调风格
    SSProgressHUDColorTypeBlack,
} ;


NS_ASSUME_NONNULL_BEGIN

@interface SSProgressHUD : UIView
///改变颜色风格
@property(nonatomic, assign) SSProgressHUDColorType colorType;
///hud的中心偏移量,x:大于零向右，小于0向左  y:大于零向下，小于0向上
@property(nonatomic, assign) CGPoint viewCenterOffet;
///自定义视图的边距,top,left,bottom,right
@property(nonatomic, assign) UIEdgeInsets customViewEdgeInsets;
///改变内容的颜色
@property (nonatomic, strong) UIColor *customContentColor;
///文字
@property(nonatomic, copy) NSString *customText;
///文字颜色
@property(nonatomic, strong) UIColor *customTextColor;
///文字大小
@property(nonatomic, strong) UIFont *customTextFont;
///进度
@property(nonatomic, assign) CGFloat customProgress;
///图片
@property(nonatomic, strong) UIImage *customImage;


///初始化方法
- (instancetype)initWithMode:(SSProgressHUDMode)mode;
- (instancetype)initWithCustomView:(UIView *)customView;

/**
 开始展示

 @param view 显示的父视图
 @param animated 是否动画，默认yes
 */

- (void)showOnView:(UIView *)view animated:(BOOL)animated;
- (void)showOnView:(UIView *)view animated:(BOOL)animated maskType:(SSProgressHUDMaskType)maskType;

/**
 隐藏

 @param animated 是否动画，默认yes
 */
- (void)hideViewAnimated:(BOOL)animated;
- (void)hideViewAnimated:(BOOL)animated completion:(void(^__nullable)(void))completion;


/**
 设置进度

 @param progress 进度数值
 @param finished 100%的回调
 */
- (void)setCustomProgress:(CGFloat)progress finished:(void(^__nullable)(void))finished;

@end

///自定义视图
@interface SSProgressCustomView : UIView

///改变内容的颜色
@property (nonatomic, strong) UIColor *contentColor;
///文字
@property(nonatomic, copy) NSString *text;
///文字颜色
@property(nonatomic, strong) UIColor *textColor;
///文字大小
@property(nonatomic, strong) UIFont *textFont;


@end

////loading,text,loading and text
@interface SSProgressLoadTextView : SSProgressCustomView
- (instancetype)initWithMode:(SSProgressHUDMode)mode;
@end


///进度条
@interface SSProgressValueView:SSProgressCustomView
///进度
@property (nonatomic, assign) CGFloat progress;
@end


@interface SSProgressImageView:SSProgressCustomView
///图片
@property (nonatomic, strong) UIImage *image;
@end


@interface NSObject (SSProgressHUD)

/*
 *tag参数的说明：
 1、当tag等于-1或者大于0的时候，每个tag对应一个hud。
 2、如果展示的是文字提示的tag为0,不会缓存hud。
 3、loading的时候默认tag为-1；
 
 */


///loading,没文字
- (void)showLoading;
- (void)showLoadingWithMaskType:(SSProgressHUDMaskType)maskType;

- (void)showLoadingWithTag:(NSInteger)tag;
- (void)showLoadingWithTag:(NSInteger)tag maskType:(SSProgressHUDMaskType)maskType;

///loading,有文字
- (void)showLoadingText:(NSString * _Nullable )text;
- (void)showLoadingText:(NSString * _Nullable )text maskType:(SSProgressHUDMaskType)maskType;

- (void)showLoadingText:(NSString * _Nullable )text tag:(NSInteger)tag;
- (void)showLoadingText:(NSString * _Nullable )text tag:(NSInteger)tag maskType:(SSProgressHUDMaskType)maskType;

///文字提示
- (void)showText:(NSString *)text;
///文字提示，有消失时回调
- (void)showText:(NSString *)text finished:(void(^ __nullable)(void))finished;
- (void)showText:(NSString *)text maskType:(SSProgressHUDMaskType)maskType finished:(void(^ __nullable)(void))finished;

///进度条
- (void)showProgress:(CGFloat)progress finished:(void(^ __nullable)(void))finished;
- (void)showProgress:(CGFloat)progress maskType:(SSProgressHUDMaskType)maskType finished:(void(^ __nullable)(void))finished;

- (void)showProgress:(CGFloat)progress text:(NSString * _Nullable)text finished:(void(^ __nullable)(void))finished;
- (void)showProgress:(CGFloat)progress text:(NSString * _Nullable)text maskType:(SSProgressHUDMaskType)maskType finished:(void(^ __nullable)(void))finished;


///图片
- (void)showHUDWithImageName:(NSString *)imageName;
- (void)showHUDWithImageName:(NSString *)imageName text:(NSString * _Nullable)text;
- (void)showHUDWithImageName:(NSString *)imageName text:(NSString * _Nullable)text finished:(void(^__nullable)(void))finished;
- (void)showHUDWithImageName:(NSString *)imageName text:(NSString * _Nullable)text maskType:(SSProgressHUDMaskType)maskType finished:(void(^__nullable)(void))finished;


///隐藏
- (void)hideHUD;
- (void)hideHUDWithTag:(NSInteger)tag;

- (void)hideHUDAnimated:(BOOL)animated;
- (void)hideHUDAnimated:(BOOL)animated tag:(NSInteger)tag;

- (void)hideHUDAnimated:(BOOL)animated finished:(void(^ __nullable)(void))finished;
- (void)hideHUDAnimated:(BOOL)animated tag:(NSInteger)tag finished:(void(^ __nullable)(void))finished;

@end


NS_ASSUME_NONNULL_END
