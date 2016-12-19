//
//  HCTabBar.h
//  jcarea
//
//  Created by 王文 on 2016/12/13.
//  Copyright © 2016年 com.jcarea. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AwesomeMenu;

@class HCTabBar;

@protocol HCTabBarDelegate <NSObject>

@optional
- (void)clTabBarCenterButtonClick:(HCTabBar *)tabBar centerButton:(UIButton *)centerBtn;
- (void)clTabBarCenterButtonClickStart:(HCTabBar *)tabBar centerMenu:(AwesomeMenu *)centerMenu;
- (void)clTabBarCenterButtonClickClose:(HCTabBar *)tabBar centerMenu:(AwesomeMenu *)centerMenu;
- (void)awseMenuIteamClick :(AwesomeMenu *)menu SelectIndex:(NSInteger)idx;
@end

@interface HCTabBar : UITabBar
@property (weak, nonatomic) id<HCTabBarDelegate> centerDelegate;
@end
