# SSProgressHUD
加载动画提示、文字和图片提示、进度加载提示、可自定义


# 预览动画
<img src="https://github.com/namesubai/SSProgressHUDDemo/blob/master/loadingGif.gif" width = 20% height = 20% />
<img src="https://github.com/namesubai/SSProgressHUDDemo/blob/master/showTextGif.gif" width = 20% height = 20% />
<img src="https://github.com/namesubai/SSProgressHUDDemo/blob/master/showImage.gif" width = 20% height = 20% />
<img src="https://github.com/namesubai/SSProgressHUDDemo/blob/master/progressGif.gif" width = 20% height = 20% />

# 功能说明
- loading动画加文字自适应
- 文字提示，支持视图消失时回调
- 图片加文字提示自适应，支持视图消失时回调
- 进度加载，支持全部加载时回调
- 可自定义customView
- 多种属性设置，例如：颜色风格、遮罩类型、中心点偏移
- 提供分类API调用
- 可以同时显示多个hud,通过tag标记显示移除

# 具体使用

### 例如Loading加文字

```
SSProgressHUD *hud = [[SSProgressHUD alloc]initWithMode:SSProgressHUDModeLoadingAndText];
hud.customText = text;
[hud showOnView:self.view animated:YES];
```

### 通过中点偏移量自定义hud的位置
```
hud.viewCenterOffet = CGPointMake(0,-20);
```

### 设置自定义视图的内间距
```
hud.customViewEdgeInsets = UIEdgeInsetsMake(20,20,20,20);
```

### 自定义视图
```
UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 200)];
SSProgressHUD *hud = [[SSProgressHUD alloc]initWithCustomView:customView]
```

### 快捷调用API
```
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
```



其他功能具体请看Demo的用法


