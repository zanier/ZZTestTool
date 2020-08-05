//
//  ZZTestToolBaseViewController.m
//  ZZTestTool
//
//  Created by zanier on 2020/7/1.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZTestBaseViewController.h"

@interface ZZTestBaseViewController ()

@end

@implementation ZZTestBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}

/// MARK: - alert

- (void)alertWithTitle:(NSString *)title message:(NSString *)massage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:massage preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *weakAlert = alert;
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)massage confirmAction:(void(^)(void))confirmAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:massage preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *weakAlert = alert;
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
        if (confirmAction) confirmAction();
    }];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
