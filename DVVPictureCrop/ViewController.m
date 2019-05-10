//
//  ViewController.m
//  DVVPictureCrop
//
//  Created by David on 2019/4/28.
//  Copyright © 2019 devdawei. All rights reserved.
//

#import "ViewController.h"
#import "DVVPictureCropViewController.h"

#define TestPush

@interface ViewController () <DVVPictureCropViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)pictureCropViewController:(DVVPictureCropViewController *)pictureCropViewController completedCropImage:(UIImage *)image {
    self.imageView.image = image;
    
#ifdef TestPush
    [pictureCropViewController.navigationController popViewControllerAnimated:YES];
#else
    [pictureCropViewController.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
#endif
}

- (IBAction)cropButtonClickAction:(UIButton *)sender {
    DVVPictureCropViewController *cropVC = [[DVVPictureCropViewController alloc] init];
    UIImage *image = [UIImage imageNamed:@"test_img"];
    cropVC.pictureCropView.image = image;
    cropVC.pictureCropView.cropRect = CGRectMake(50, 100, 200, 200);
    cropVC.delegate = self;
    
#ifdef TestPush
    [self.navigationController pushViewController:cropVC animated:YES];
#else
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:cropVC];
    [self.navigationController presentViewController:navigationVC animated:YES completion:^{
        
    }];
#endif
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
