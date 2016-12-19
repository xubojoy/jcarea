//
//  HCTabBar.m
//  jcarea
//
//  Created by 王文 on 2016/12/13.
//  Copyright © 2016年 com.jcarea. All rights reserved.
//

#import "HCTabBar.h"
#import "HCTabBarController.h"
#import "HCtest1ViewController.h"


@interface HCTabBar ()<AwesomeMenuDelegate>
@property(nonatomic,strong)AwesomeMenu *menu;

@end

@implementation HCTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCenterButton];
    }
    return self;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden == NO) {
        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.menu];
        
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [self.menu pointInside:newP withEvent:event]) {
            
            CGPoint tempPoint = [self.menu.startButton convertPoint:newP fromView:self.menu];
            
            if (CGRectContainsPoint(self.menu.startButton.bounds, tempPoint)) {
                return self.menu.startButton;
            }
            
            for (AwesomeMenuItem *item in self.menu.menuItems) {
                tempPoint = [item convertPoint:newP fromView:self.menu];
                if (CGRectContainsPoint(item.bounds, tempPoint)) {
                    return item;
                }
            }
            
            return self.menu;
        }else{//如果点不在发布按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    }
    else {//tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

- (void)setupCenterButton {
    //1. 中间的startItem
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc]
                                  initWithImage:[UIImage imageNamed:@"post_normal"]
                                  highlightedImage:[UIImage imageNamed:@"post_normal"]
                                  ContentImage:[UIImage imageNamed:@"post_normal"]
                                  highlightedContentImage:nil];
    
    //2. 添加其他几个按钮
    AwesomeMenuItem *item0 = [[AwesomeMenuItem alloc]
                              initWithImage:[UIImage imageNamed:@"post_normal"]
                              highlightedImage:nil
                              ContentImage:[UIImage imageNamed:@"post_normal"]
                              highlightedContentImage:[UIImage imageNamed:@"post_normal"]];
//    UIButton *item0 = [[UIButton alloc] init];
//    [item0 setImage:[UIImage imageNamed:@"post_normal"] forState:(UIControlStateNormal)];
//    
    AwesomeMenuItem *item1 = [[AwesomeMenuItem alloc]
                              initWithImage:[UIImage imageNamed:@"post_normal"]
                              highlightedImage:nil
                              ContentImage:[UIImage imageNamed:@"post_normal"]
                              highlightedContentImage:[UIImage imageNamed:@"post_normal"]];
    NSArray *items = @[item0, item1];
    //3. 创建菜单按钮
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem menuItems:items];
    [self addSubview:menu];
    self.menu = menu;
    //4. 设置属性
    //4.1 禁止转动
    menu.rotateAddButton = YES;
    //发散范围
    menu.rotateAngle = -M_PI_4;
    //4.2 弹出范围
    menu.menuWholeAngle = M_PI_2;
    menu.closeRotation = 0;
  
    
    //4.3 设置位置
    menu.startPoint = CGPointMake(0, 0);
    
    [menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).mas_offset(-20);
    }];

    //4.4 设置代理
    menu.delegate = self;
    
}
#pragma mark 必须实现的方法
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
   
    switch (idx) {
        case 0: {
            NSLog(@"1");
            HCtest1ViewController *red = [[HCtest1ViewController alloc] init];
            red.view.backgroundColor = [UIColor redColor];
            HCTabBarController *tabVC = (HCTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabVC.selectedViewController;
            [nav pushViewController:red animated:YES];

            
        }           break;
        case 1:
            NSLog(@"2");
            break;
            default:
            return;
    }
    [self awesomeMenuDidFinishAnimationClose:menu];
}
- (void)item1Click {
    
}
#pragma mark 将要打开
- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu
{
    if ([self.centerDelegate respondsToSelector:@selector(clTabBarCenterButtonClickStart:centerMenu:)]) {
        [self.centerDelegate clTabBarCenterButtonClickStart:self centerMenu:menu];
    }
   
    
//    //1. 切换图像
//    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    
    //2. 更改透明度
    [UIView animateWithDuration:.25 animations:^{
        menu.alpha = 1;
    }];
}
//将要关闭
- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu
{
    
//    //1. 切换图像
//    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];

}
//已经关闭

- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu {
    if ([self.centerDelegate respondsToSelector:@selector(clTabBarCenterButtonClickClose:centerMenu:)]) {
        [self.centerDelegate clTabBarCenterButtonClickClose:self centerMenu:menu];
    }
}
-(void)layoutSubviews {
    [super layoutSubviews];
    Class class = NSClassFromString(@"UITabBarButton");
    self.menu.size = CGSizeMake(self.width / 5, self.height);
    int btnIndex = 0;
    for (UIView *btn in self.subviews) {//遍历tabbar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            //每一个按钮的宽度==tabbar的三分之一
            btn.width = self.width / 5;
            
            btn.x = btn.width * btnIndex;
            
            btnIndex++;
            //如果是索引是1(从0开始的)，直接让索引++，目的就是让消息按钮的位置向右移动，空出来发布按钮的位置
            if (btnIndex == 2) {
                btnIndex++;
            }
            
        }
    }

}

@end
