//
//  HsConfigBrowerPlistPage.m
//  HsTestTool
//
//  Created by handsome on 2020/7/13.
//  Copyright © 2020 Hundsun. All rights reserved.
//

#import "HsConfigBrowerPlistPage.h"
#import "HsPlistBrowerTableView.h"

@interface HsConfigBrowerPlistPage () <HsPlistBrowerTableViewDelegate>

@property (nonatomic, strong) HsPlistBrowerTableView *browerTableView;

@end

@implementation HsConfigBrowerPlistPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (HsPlistBrowerTableView *)browerTableView {
    if (_browerTableView) {
        return _browerTableView;
    }
    _browerTableView = [[HsPlistBrowerTableView alloc] init];
    _browerTableView.delegate = self;
    return _browerTableView;
}


@end
