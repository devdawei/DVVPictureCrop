//
//  DVVPictureCropViewController.m
//  DVVPictureCrop
//
//  Created by David on 2019/5/7.
//  Copyright © 2019 devdawei. All rights reserved.
//

#import "DVVPictureCropViewController.h"

@interface DVVPictureCropViewController ()

@end

@implementation DVVPictureCropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    if (!self.navigationItem.title) {
        self.navigationItem.title = @"调整图片";
    }
    if (self.navigationController.viewControllers.count == 1) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonClickAction)];
        self.navigationItem.leftBarButtonItem = item;
    }
    
    [self.view addSubview:self.pictureCropView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize currentSize = self.view.bounds.size;
    CGFloat statusBarHeight = 0;
    CGFloat navigationBarContentHeight = 44;
    CGFloat dockBarHeight = 0;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = UIApplication.sharedApplication.delegate.window.safeAreaInsets;
        if (safeAreaInsets.top > 0) {
            statusBarHeight = safeAreaInsets.top;
        } else {
            statusBarHeight = 20;
        }
        if (safeAreaInsets.bottom > 0) {
            dockBarHeight = safeAreaInsets.bottom;
        }
    } else {
        statusBarHeight = 20;
    }
    CGFloat navigationBarHeight = statusBarHeight + navigationBarContentHeight;
    self.pictureCropView.frame = CGRectMake(0, navigationBarHeight, currentSize.width, currentSize.height - (navigationBarHeight + dockBarHeight));
}

- (void)closeButtonClickAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - DVVPictureCropViewDelegate

- (void)pictureCropView:(DVVPictureCropView *)pictureCropView completedCropImage:(UIImage *)image {
    [self.delegate pictureCropViewController:self completedCropImage:image];
}

#pragma mark -

- (DVVPictureCropView *)pictureCropView {
    if (!_pictureCropView) {
        _pictureCropView = [[DVVPictureCropView alloc] init];
        _pictureCropView.delegate = self;
    }
    return _pictureCropView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
