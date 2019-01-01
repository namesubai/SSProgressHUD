//
//  ViewController.m
//  SSProgressHUD
//
//  Created by Shuqy on 2018/12/28.
//  Copyright © 2018 Shuqy. All rights reserved.
//

#import "ViewController.h"
#import "SSProgressHUD.h"


@interface CustomView : SSProgressCustomView

@end


@implementation CustomView



@end


@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_cellTexts;
    NSMutableArray *_cellTitleTexts;

    NSTimer *_timer;
    
}
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"SSProgressHUD";
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];

    _cellTexts = @[@[@[@"没有文字",NSStringFromSelector(@selector(showLoad))],
                     @[@"有文字",NSStringFromSelector(@selector(showLoadText))],
                     @[@"有文字,有背景图层",NSStringFromSelector(@selector(showLoadWithMask))],
                     @[@"多个loading同时出现时，通过标记 tag移除",NSStringFromSelector(@selector(showLoadWithTag))]],
                   @[@[@"文字提示",NSStringFromSelector(@selector(showText))],
                     @[@"文字提示,消失回调",NSStringFromSelector(@selector(showTextHasFinish))],
                     @[@"文字提示，有背景图层",NSStringFromSelector(@selector(showTextHasMask))]
                     ],
                   @[@[@"有文字",NSStringFromSelector(@selector(showImage))],
                     @[@"没有文字",NSStringFromSelector(@selector(showImage1))]],
                   @[@[@"有文字",NSStringFromSelector(@selector(showProgressValue))],
                     @[@"没有文字",NSStringFromSelector(@selector(showProgressValue1))]],
                   @[@[@"自定义一个视图",NSStringFromSelector(@selector(showCustom))]]
                   ]
                   .mutableCopy;
    
    _cellTitleTexts = @[@"loading+文字",@"文字提示",@"图标+文字",@"进度",@"自定义视图"].mutableCopy;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)showLoad{
    
    [self showLoading];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf hideHUD];
    });
}

- (void)showLoadWithMask{
    [self showLoadingWithMaskType:SSProgressHUDMaskTypeBlack];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf hideHUD];
    });
}
- (void)showLoadText{
    [self showLoadingText:@"正在加载"];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf hideHUD];
    });
}

- (void)showLoadWithTag {
    for (NSInteger i=1; i<4; i++) {
        [self showLoadingWithTag:i];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf hideHUDWithTag:i];
        });
    }
    
}

- (void)showText{
    
    [self showText:@"提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示"];
}
- (void)showTextHasMask{
    
    [self showText:@"提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示" maskType:SSProgressHUDMaskTypeBlack finished:nil];
}

- (void)showTextHasFinish{
    __weak typeof(self) weakSelf = self;
    [self showText:@"提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示提示" finished:^{
        [weakSelf showText:@"消失时的回调"];
    }];
}

- (void)showImage{
    [self showHUDWithImageName:@"sq_success" text:@"操作成功"];
}

- (void)showImage1{
    [self showHUDWithImageName:@"sq_success" text:nil];
}

- (void)showProgressValue {
    

    if (_timer) {
        return;
    }
    
    __block CGFloat progress = 0;
    _timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        progress += 0.01;
        [self showProgress:progress text:@"正在下载" finished:^{
            [timer invalidate];
            self->_timer = nil;
        }];

    }];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)showProgressValue1{
    if (_timer) {
        return;
    }
    
    __block CGFloat progress = 0;
    _timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        progress += 0.01;
        [self showProgress:progress text:nil finished:^{
            [timer invalidate];
            self->_timer = nil;
        }];
        
    }];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)showCustom{
    
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 200)];
    customView.backgroundColor = [UIColor redColor];
    
    SSProgressHUD *hud = [[SSProgressHUD alloc]initWithCustomView:customView];
    [hud showOnView:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideViewAnimated:YES];
    });
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _cellTexts[indexPath.section][indexPath.row][0];
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cellTexts[section]count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _cellTexts.count;;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _cellTitleTexts[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SEL seletor = NSSelectorFromString(_cellTexts[indexPath.section][indexPath.row][1]);
    
    [self performSelector:seletor withObject:nil afterDelay:0];
}



@end

