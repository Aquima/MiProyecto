//
//  AppDelegate.m
//  Home Center
//
//  Created by Jonathan Fajardo Roa on 20/05/14.
//  Copyright (c) 2014 Jonathan Fajardo Roa. All rights reserved.
//

#import "AppDelegate.h"
#import "tabBViewController.h"
#import "EscanearViewController.h"

@implementation AppDelegate
@synthesize ConexionBD;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ConexionBD = [[bd alloc]init];
    // Nos registramos para recibir las notificaciones Push de los tipos especificados
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [ConexionBD eliminaToken];
    
    NSMutableString * str = [[NSMutableString alloc]init];
    @try {
        for (int i = 0; i < [NSString stringWithFormat:@"%@", [[NSString stringWithFormat:@"%@", deviceToken] substringWithRange:NSMakeRange(1, [NSString stringWithFormat:@"%@", deviceToken].length - 2)]].length; i++) {
            if (![[[NSString stringWithFormat:@"%@", [[NSString stringWithFormat:@"%@", deviceToken] substringWithRange:NSMakeRange(1, [NSString stringWithFormat:@"%@", deviceToken].length - 2)]] substringWithRange:NSMakeRange(i,  1)] isEqualToString:@" "]) {
                [str appendString:[[NSString stringWithFormat:@"%@", [[NSString stringWithFormat:@"%@", deviceToken] substringWithRange:NSMakeRange(1, [NSString stringWithFormat:@"%@", deviceToken].length - 2)]] substringWithRange:NSMakeRange(i,  1)]];
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    
    [ConexionBD registroToken:str];
    
    NSLog(@"Mi device token es %@", str);
}

// Lo podemos comprobar en el simulador ya que en este no podemos probar las notificaciones Push
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error al obtener el token. Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [ConexionBD eliminaNotificacion];
    [ConexionBD registroNotificacion:@"Mis Compras"];
    NSLog(@"CONSULTA NOTIFICACION %@",[ConexionBD consultaNotificacion]);
    NSLog(@"Contenido del JSON: %@", userInfo);
    NSLog(@"Noti");
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [ConexionBD eliminaNotificacion];
    [ConexionBD registroNotificacion:@"Mis Compras"];
    NSLog(@"Noti 1");
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
{
    [viewController.view setNeedsDisplay];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
