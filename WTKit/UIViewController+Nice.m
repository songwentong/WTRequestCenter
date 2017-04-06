//
//  UIViewController+Nice.m
//  WTRequestCenter
//
//  Created by SongWentong on 3/2/16.
//  Copyright © 2016 song. All rights reserved.
//

#import "UIViewController+Nice.h"
#import "WTNetWorkManager.h"
#import "NSObject+Nice.h"
@import StoreKit;
@implementation UIViewController (Alert)
-(void)showAlertWithMessage:(NSString*)message
{
    [self showAlertWithTitle:nil message:message duration:1.0 completion:nil];
}
-(void)showAlertWithTitle:(NSString*)title message:(NSString*)message duration:(NSTimeInterval)time completion: (void (^ __nullable)(void))completion
{
    if ([UIAlertController class]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        [WTNetWorkManager performBlock:^{
            [alert dismissViewControllerAnimated:YES completion:completion];
        } afterDelay:time];
    }
}
@end


@implementation UIViewController(Nice)
+(instancetype)instanceWithName:(NSString*)name
{
    Class className = NSClassFromString(name);
    id instance = [[className alloc] init];
    return instance;
}


/*!
    打开appstore中的页面
 */
-(id)showAppStoreWithAppID:(NSString*)appId inapp:(BOOL)inApp
{
    
    if (inApp) {
        SKStoreProductViewController *storeVC = [SKStoreProductViewController new];
        [storeVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appId} completionBlock:^(BOOL result, NSError * _Nullable error) {
            [self presentViewController:storeVC animated:YES completion:^{
                
            }];
        }];
        return storeVC;
    }else{
        NSString *string = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/%@",appId];
        NSURL *url = [NSURL URLWithString:string];
        if ([UIDevice currentDevice].systemVersion.floatValue>=10) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string] options:[NSDictionary dictionary] completionHandler:^(BOOL success) {
                
            }];
        }else{
            //这么做是为了防止报警
#if DEBUG
            [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:url afterDelay:0];
#else
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
#endif
        }
        
        
    }
    
    return nil;
}


@end

@implementation UIViewController (IBHelper)

+(instancetype)instanceFromIB
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString *name = NSStringFromClass(self);
    return [self instanceFromStoryBoard:sb name:name];
}

+(instancetype)instanceFromStoryBoardName:(NSString*)storyBoardName
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    NSString *name = NSStringFromClass(self);
    return [self instanceFromStoryBoard:sb name:name];
}

+(instancetype)instanceFromStoryBoard:(UIStoryboard*)sb
{
    NSString *name = NSStringFromClass(self);
    return [self instanceFromStoryBoard:sb name:name];
}

+(instancetype)instanceFromStoryBoard:(UIStoryboard*)sb name:(NSString*)name
{
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:name];
    return vc;
}
@end


