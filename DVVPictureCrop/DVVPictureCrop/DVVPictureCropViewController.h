//
//  DVVPictureCropViewController.h
//  DVVPictureCrop
//
//  Created by David on 2019/5/7.
//  Copyright © 2019 devdawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVVPictureCropView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DVVPictureCropViewControllerDelegate;

@interface DVVPictureCropViewController : UIViewController <DVVPictureCropViewDelegate>

@property (nonatomic, strong) DVVPictureCropView *pictureCropView;

@property (nonatomic, weak) id<DVVPictureCropViewControllerDelegate> delegate;

@end

@protocol DVVPictureCropViewControllerDelegate <NSObject>

- (void)pictureCropViewController:(DVVPictureCropViewController *)pictureCropViewController completedCropImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
