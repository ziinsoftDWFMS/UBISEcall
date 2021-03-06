//
//  authViewController.m
//  TEST_DWFMS_EMG
//
//  Created by youngseok Kim on 2015. 4. 29..
//  Copyright (c) 2015년 kimhyang. All rights reserved.
//

#import "authViewController.h"
#import "CAllServer.h"
#import "AppDelegate.h"
#import "ViewController.h"
@interface authViewController ()

@end

@implementation authViewController
@synthesize phoneText;
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)sendEvent:(id)sender {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"device Token is>>>%@", app.DEVICE_TOK);
        
    NSString *phone = self.phoneText.text;
    UIDevice *device = [UIDevice currentDevice];
    NSString* idForVendor = [device.identifierForVendor UUIDString];
    
    NSLog(@"idForVendor>>>%@",idForVendor);
    
    CAllServer* res = [CAllServer alloc];
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:phone forKey:@"hp"];
    [param setObject:idForVendor forKey:@"deviceId"];
    [param setValue:@"L" forKey:@"gubun"];
    [param setValue:@"RL01" forKey:@"code"];
    [param setValue:app.DEVICE_TOK forKey:@"gcm_id"];
    NSString* str = [res stringWithUrl:@"regEmcAppInstInfo.do" VAL:param];
    
    NSLog(@"result>>>%@",str);
    
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    NSArray* keys = jsonInfo.allKeys;
    
    for (int i=0; i<keys.count; i++) {
       
        
        if([@"RESULT" isEqual:[keys objectAtIndex:i]])
        {
            if([@"SUCCESS" isEqual:[jsonInfo objectForKey:[keys objectAtIndex:i]]])
            {
                NSLog(@"key %@  value %@",[keys objectAtIndex:i],[jsonInfo objectForKey:[keys objectAtIndex:i]] );

                [self performSegueWithIdentifier:@"webviewTrans" sender:self];
               
            }
        }
        
        if([@"ERR_MSG" isEqual:[keys objectAtIndex:i]])
        {
            self.infoText.text =  [jsonInfo objectForKey:[keys objectAtIndex:i]];
            
        }
    }
    
    
}
- (IBAction)cancelEvent:(id)sender {
    
    exit(0);
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"@@@@@@@@@@@@@@  call viewWillAppear");
}
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"@@@@@@@@@@@@@@  call viewDidAppear");
}


@end
