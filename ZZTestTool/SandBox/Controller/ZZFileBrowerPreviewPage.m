//
//  ZZFileBrowerPreviewPage.m
//  ZZTestTool
//
//  Created by zanier on 2020/7/10.
//  Copyright © 2020 zanier. All rights reserved.
//

#import "ZZFileBrowerPreviewPage.h"
#import "ZZFileBrowerHeader.h"

@interface ZZFileBrowerPreviewPage () <ZZQLPreviewControllerDataSource>

@end

@implementation ZZFileBrowerPreviewPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#ifdef ZZTESTTOOL_NEED_QUICKLOOK

/// MARK: - <QLPreviewControllerDataSource>

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return nil;
}

#endif

@end
