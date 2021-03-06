//
//  ViewController.m
//  UBISEcall
//
//  Created by youngseok Kim on 2015. 5. 7..
//  Copyright (c) 2015년 youngseok Kim. All rights reserved.
//

#import "ViewController.h"
#import "CAllServer.h"
#import "authViewController.h"
#import "GlobalData.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

BOOL navigateYN;
NSString* idForVendor;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.main = self;
    UIDevice *device = [UIDevice currentDevice];
    idForVendor = [device.identifierForVendor UUIDString];
    
    NSLog(@">>>>>%@",idForVendor);
    //서버에서 결과 리턴받기
    CAllServer* res = [CAllServer alloc];
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    
    //[param setValue:@"" forKey:@"hp"];
    
    [param setValue:@"L" forKey:@"gubun"];
    [param setValue:@"RL01" forKey:@"code"];
    
    [param setObject:idForVendor forKey:@"deviceId"];
    
    //deviceId
    
    //R 수신
    
    NSString* str = [res stringWithUrl:@"getEmcUserInfo.do" VAL:param];
    
    //regEmcAppInstInfo.do
    
    //
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSLog(@" ,login?? %@",str);
    
    if([str  isEqual: @"{}"]){
       
        NSLog(@">>>>>%@",idForVendor);
       
        navigateYN = YES;
       
    }else{
        navigateYN = NO;
        
    }
    NSLog(@"@@@@@@@@@@@@@@ 123 call viewDidAppear %@",idForVendor);

    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (navigateYN) {
        [self performSegueWithIdentifier:@"authviewTrans" sender:self];
    } else {
        //정상 인증을 받았으므로 WebView Display
        NSString *serverUrl = [NSString stringWithFormat:@"%@/emcListPage.do?deviceId=%@",[GlobalData getServerIp],idForVendor] ;
        
        NSURL *url=[NSURL URLWithString:serverUrl];
        NSURLRequest *requestURL=[NSURLRequest requestWithURL:url];
        [self.site loadRequest:requestURL];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"@@@@@@@@@@@@@@  call viewWillAppear");
}

- (void)viewDidUnload {
    NSLog(@"@@@@@@@@@@@@@@  call viewDidunload");

    if (navigateYN) {
            NSLog(@"@@@@@@@@@@@@@@  load authViewController ~~~~~~~");
    } else {
        exit(0);
    }
}



@end
