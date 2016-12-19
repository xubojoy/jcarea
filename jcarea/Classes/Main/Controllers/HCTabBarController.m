//
//  HCTabBarController.m
//  jcarea
//
//  Created by 王文 on 2016/12/13.
//  Copyright © 2016年 com.jcarea. All rights reserved.
//

#import "HCTabBarController.h"
#import "HCNavigationController.h"
#import "HCtest1ViewController.h"



@interface HCTabBarController ()<HCTabBarDelegate>
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;

@end

@implementation HCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController];
    HCTabBar *tabBar = [[HCTabBar alloc] init];
    tabBar.centerDelegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
    
}
//MARK:代理
- (void)clTabBarCenterButtonClickStart:(HCTabBar *)tabBar centerMenu:(AwesomeMenu *)centerMenu {
    //毛玻璃
    UIBlurEffect *blurEffect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView=[[UIVisualEffectView alloc]initWithEffect:blurEffect];
    self.visualEffectView = visualEffectView;
    [visualEffectView setFrame:self.view.bounds];
    [self.view insertSubview:visualEffectView belowSubview:tabBar];
    
//    UIView *coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    coverView.backgroundColor = [UIColor blackColor];
//    [self.view insertSubview:coverView belowSubview:tabBar];
}

- (void)clTabBarCenterButtonClickClose:(HCTabBar *)tabBar centerMenu:(AwesomeMenu *)centerMenu {
    [self.visualEffectView removeFromSuperview];
}


-(void)addChildViewController:(UIViewController *)childController
                        title:(NSString *)title
                        image:(NSString *)image
                  selectImage:(NSString *)selectImage
{
    childController.title = title;
    childController.tabBarItem.image = [UIImage imageNamed:image];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    HCNavigationController *nav = [[HCNavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
}
- (void)addChildViewController {
    HCHomeViewController *home = [[HCHomeViewController alloc] init];
    HCCategoryViewController *cate = [[HCCategoryViewController alloc] init];
    HCOrderViewController *order = [[HCOrderViewController alloc] init];
    HCMeViewController *me = [[HCMeViewController alloc] init];
    home.view.backgroundColor = [UIColor whiteColor];
    cate.view.backgroundColor = [UIColor whiteColor];
    order.view.backgroundColor = [UIColor whiteColor];
    me.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewController:home title:@"首页" image:@"home_normal" selectImage:@"home_highlight"];
    [self addChildViewController:cate title:@"分类" image:@"fish_normal" selectImage:@"fish_highlight"];
    [self addChildViewController:order title:@"订单" image:@"message_normal" selectImage:@"message_highlight"];
    [self addChildViewController:me title:@"我的" image:@"account_normal" selectImage:@"account_highlight"];
    
   
     
    
}

@end
