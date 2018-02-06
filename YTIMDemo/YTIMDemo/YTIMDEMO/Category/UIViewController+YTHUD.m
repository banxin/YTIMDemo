//
//  UIViewController+YTHUD.m
//  ytmallApp
//
//  Created by yanl on 2017/9/20.
//  Copyright © 2017年 ios. All rights reserved.
//

#import "UIViewController+YTHUD.h"
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"
#import "AppMacro.h"
#import <YYKit.h>

@implementation UIViewController (YTHUD)

- (void)showTips:(NSString *)tips
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.bezelView.backgroundColor = [UIColor blackColor];
    [hud setContentColor:HexColor(@"ffffff")];
    
    hud.mode                      = MBProgressHUDModeText;
    hud.label.text                = tips;
    hud.label.font                = [UIFont systemFontOfSize:14.f];
    hud.margin                    = 8.f;
    hud.offset                    = CGPointMake(hud.offset.x, MBProgressMaxOffset);
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES afterDelay:1.5f];
}

/**
 显示动画hud
 */
- (void)showAnimationHud
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    
    UIImage *image = [[UIImage imageNamed:@"loadingnew"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anima.toValue = @(M_PI * 2);
    anima.duration = 0.7f;
    anima.repeatCount = MAXFLOAT;
    [imgView.layer addAnimation:anima forKey:nil];
    hud.customView = imgView;
}

/**
 隐藏hud
 */
- (void)hideHUD
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}

@end
