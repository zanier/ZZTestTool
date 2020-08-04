//
//  ZZConfigBrowerPlistPage.m
//  ZZTestTool
//
//  Created by zanier on 2020/7/13.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZConfigBrowerPlistPage.h"
#import "ZZPlistBrowerTableView.h"

@interface ZZConfigBrowerPlistPage () <ZZPlistBrowerTableViewDelegate>

@property (nonatomic, strong) ZZPlistBrowerTableView *browerTableView;

@end

@implementation ZZConfigBrowerPlistPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (ZZPlistBrowerTableView *)browerTableView {
    if (_browerTableView) {
        return _browerTableView;
    }
    _browerTableView = [[ZZPlistBrowerTableView alloc] init];
    _browerTableView.delegate = self;
    return _browerTableView;
}


@end
