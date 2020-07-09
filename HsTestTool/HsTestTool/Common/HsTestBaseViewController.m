//
//  HsTestToolBaseViewController.m
//  HsTestTool
//
//  Created by handsome on 2020/7/1.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import "HsTestBaseViewController.h"

@interface HsTestBaseViewController ()

@end

@implementation HsTestBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/// MARK: - alert

- (void)alertWithTitle:(NSString *)title message:(NSString *)massage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:massage preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *weakAlert = alert;
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
