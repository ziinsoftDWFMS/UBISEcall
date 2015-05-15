//
//  AppDelegate.m
//  UBISEcall
//
//  Created by youngseok Kim on 2015. 5. 7..
//  Copyright (c) 2015년 youngseok Kim. All rights reserved.
//

#import "AppDelegate.h"
#import "CAllServer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        NSLog(@"%@",@"등록완료");
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        NSLog(@"%@",@"등록완료");
    }
    
    
    if(launchOptions)
    {
        application.applicationIconBadgeNumber = 0;
        
        NSDictionary *launchDictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey ];
        NSDictionary *apsDictionary = [launchDictionary valueForKey:@"aps"];
        //NSString *message = (NSString *)[apsDictionary valueForKey:(id)@"alert"];
        
        NSInteger applicationIconBadgeNumber = [application applicationIconBadgeNumber];
        
        [application setApplicationIconBadgeNumber:applicationIconBadgeNumber];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        
        NSString *grpCd            = [launchDictionary valueForKey:@"GRP_CD"];
        NSString *emcId            = [launchDictionary valueForKey:@"EMC_ID"];
        NSString *emcMsg           = [launchDictionary valueForKey:@"CONF_MSG"];
        NSString *code              = [launchDictionary valueForKey:@"CODE"];
        NSLog(@"GRP_CD: %@",    grpCd);
        NSLog(@"EMC_ID: %@",    emcId);
        NSLog(@"CONF_MSG: %@",   emcMsg);
        NSLog(@"CODE: %@",      code);
        
        GRP_CD  = grpCd;
        EMC_ID  = emcId;
        EMC_MSG = emcMsg;
        CODE    = code;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:emcMsg delegate:self
                                              cancelButtonTitle:@"취소"
                                              otherButtonTitles:@"확인", nil];
        [alert show];
        
    }    
    return YES;
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSLog(@"My token is: %@", deviceToken);
    NSMutableString *deviceId = [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*) [deviceToken bytes];
    
    for(int i = 0 ; i < 32 ; i++)
    {
        [deviceId appendFormat:@"%02x", ptr[i]];
        //NSLog(@"deviceid  Token: %02x", ptr[i]);
    }
    
    NSLog(@"A6PNS Device Token: %@", deviceId);
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.DEVICE_TOK = deviceId;
    
    NSLog(@"APNS Device Tok: %@", app.DEVICE_TOK);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}



- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //NSString *sndPath = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"wav" inDirectory:@"/"];
    //CFURLRef sndURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:sndPath]);
    //AudioServicesCreateSystemSoundID(sndURL, &ssid);
    
    //AudioServicesPlaySystemSound(ssid);
    
    application.applicationIconBadgeNumber = 0;
    NSString *grpCd            = [userInfo valueForKey:@"GRP_CD"];
    NSString *emcId            = [userInfo valueForKey:@"EMC_ID"];
    NSString *emcMsg           = [userInfo valueForKey:@"CONF_MSG"];
    NSString *code             = [userInfo valueForKey:@"CODE"];
   
    NSLog(@"GRP_CD: %@",    grpCd);
    NSLog(@"EMC_ID: %@",    emcId);
    NSLog(@"CONF_MSG: %@",   emcMsg);
    NSLog(@"CODE: %@",      code);
    
    GRP_CD  = grpCd;
    EMC_ID  = emcId;
    EMC_MSG = emcMsg;
    CODE    = code;
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                              message:EMC_MSG delegate:self
                                              cancelButtonTitle:@"취소"
                                              otherButtonTitles:@"확인", nil];
    [alert show];
    
    if(application.applicationState == UIApplicationStateActive){
        NSString *sndPath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"wav" inDirectory:@"/"];
        CFURLRef sndURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:sndPath]);
        AudioServicesCreateSystemSoundID(sndURL, &ssid);
        
        AudioServicesPlaySystemSound(ssid);
        
    }
    
    NSInteger applicationIconBadgeNumber = [application applicationIconBadgeNumber];
    
    [application setApplicationIconBadgeNumber:applicationIconBadgeNumber];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Clicked");
    // OK 버튼을 눌렀을 때 버튼Index가 1로 들어감
    
    if (buttonIndex == 1) {
        NSLog(@"Clicked YES");
        
        
    }
    else {
        NSLog(@"Clicked NO");
        
        
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
