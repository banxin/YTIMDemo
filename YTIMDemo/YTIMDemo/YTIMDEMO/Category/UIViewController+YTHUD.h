//
//  UIViewController+YTHUD.h
//  ytmallApp
//
//  Created by yanl on 2017/9/20.
//  Copyright © 2017年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YTHUD)

/**
 显示提示
 
 @param tips 提示msg
 */
- (void)showTips:(NSString *)tips;

/**
 显示动画hud
 */
- (void)showAnimationHud;

/**
 隐藏hud
 */
- (void)hideHUD;

@end
