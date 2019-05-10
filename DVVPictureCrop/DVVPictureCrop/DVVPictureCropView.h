//
//  DVVPictureCropView.h
//  DVVPictureCrop
//
//  Created by David on 2019/4/28.
//  Copyright © 2019 devdawei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DVVPictureCropViewDelegate;

@interface DVVPictureCropView : UIView

/// 需要裁剪的图像
@property (nonatomic, copy) UIImage *image;
/// 默认裁剪区域
@property (nonatomic, assign) CGRect cropRect;

@property (nonatomic, weak) id<DVVPictureCropViewDelegate> delegate;

/// 完成按钮
@property (nonatomic, strong) UIButton *doneButton;
/// 完成按钮的点击事件
- (void)doneButtonClickAction;

/// 按照指定的矩形区域裁剪图片
+ (UIImage *)cropImage:(UIImage *)image rect:(CGRect)rect;

/// 调整图片的方向
+ (UIImage *)fixOrientation:(UIImage *)aImage;

@end

@protocol DVVPictureCropViewDelegate <NSObject>

- (void)pictureCropView:(DVVPictureCropView *)pictureCropView completedCropImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
