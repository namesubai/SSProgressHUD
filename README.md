# SSProgressHUDDemo
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

其他功能具体请看Demo的用法





