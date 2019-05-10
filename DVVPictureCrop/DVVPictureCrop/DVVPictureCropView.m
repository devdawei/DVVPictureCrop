//
//  DVVPictureCropView.m
//  DVVPictureCrop
//
//  Created by David on 2019/4/28.
//  Copyright © 2019 devdawei. All rights reserved.
//

#import "DVVPictureCropView.h"

@interface DVVPictureCropTickView : UIView

@property (nonatomic, strong) UIView *tickView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation DVVPictureCropTickView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self drawTick];
    }
    return self;
}

- (void)drawTick {
    if (!_tickView) {
        _tickView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_tickView];
    }
    CGSize selfSize = self.bounds.size;
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 起始点
    CGPoint startPoint = CGPointMake(selfSize.width/10*3.1, selfSize.width/10*5.1);
    [path moveToPoint:startPoint];
    // 交点
    CGPoint joinPoint = CGPointMake(selfSize.width/10*4.5, selfSize.width/10*6.5);
    [path addLineToPoint:joinPoint];
    // 结束点
    CGPoint endPoint = CGPointMake(selfSize.width/10*7.1, selfSize.width/10*3.9);
    [path addLineToPoint:endPoint];
    
    if (!_shapeLayer) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor colorWithRed:0 green:200/255.0 blue:125/255.0 alpha:1].CGColor;
        _shapeLayer.lineWidth = 4;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineJoin = kCALineCapRound;
        [_tickView.layer addSublayer:_shapeLayer];
    }
    _shapeLayer.path = path.CGPath;
}

@end

@interface DVVPictureCropView () <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat padding;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *topCoverView;
@property (nonatomic, strong) UIView *leftCoverView;
@property (nonatomic, strong) UIView *bottomCoverView;
@property (nonatomic, strong) UIView *rightCoverView;

@property (nonatomic, strong) UIView *cropContentView;

@property (nonatomic, strong) UIView *cropContentHorizontalOneView;
@property (nonatomic, strong) UIView *cropContentHorizontalTwoView;
@property (nonatomic, strong) UIView *cropContentVerticalOneView;
@property (nonatomic, strong) UIView *cropContentVerticalTwoView;

@property (nonatomic, strong) UIButton *cropTopLeftButton;
@property (nonatomic, strong) UIView *cropTopLeftHorizontalView;
@property (nonatomic, strong) UIView *cropTopLeftVerticalView;
@property (nonatomic, strong) UIButton *cropTopRightButton;
@property (nonatomic, strong) UIView *cropTopRightHorizontalView;
@property (nonatomic, strong) UIView *cropTopRightVerticalView;
@property (nonatomic, strong) UIButton *cropBottomLeftButton;
@property (nonatomic, strong) UIView *cropBottomLeftHorizontalView;
@property (nonatomic, strong) UIView *cropBottomLeftVerticalView;
@property (nonatomic, strong) UIButton *cropBottomRightButton;
@property (nonatomic, strong) UIView *cropBottomRightHorizontalView;
@property (nonatomic, strong) UIView *cropBottomRightVerticalView;

@property (nonatomic, strong) UIButton *cropTopLineButton;
@property (nonatomic, strong) UIView *cropTopLine;
@property (nonatomic, strong) UIButton *cropLeftLineButton;
@property (nonatomic, strong) UIView *cropLeftLine;
@property (nonatomic, strong) UIButton *cropBottomLineButton;
@property (nonatomic, strong) UIView *cropBottomLine;
@property (nonatomic, strong) UIButton *cropRightLineButton;
@property (nonatomic, strong) UIView *cropRightLine;

@property (nonatomic, assign) CGFloat doneButtonWidth;
@property (nonatomic, assign) CGFloat doneButtonHeight;

@property (nonatomic, assign) CGSize lastSize;

@property (nonatomic, assign) BOOL resetImageViewFrame;

@property (nonatomic, assign) CGPoint pinchPoint;
@property (nonatomic, assign) CGRect pinchFrame;

@property (nonatomic, assign) CGRect imageViewDefaultFrame;
@property (nonatomic, assign) CGRect cropContentViewDefaultFrame;

@end

@implementation DVVPictureCropView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _padding = 20;
        _doneButtonWidth = 50 + 8*2;
        _doneButtonHeight = _doneButtonWidth;
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        [self.contentView addSubview:self.topCoverView];
        [self.contentView addSubview:self.leftCoverView];
        [self.contentView addSubview:self.bottomCoverView];
        [self.contentView addSubview:self.rightCoverView];
        [self.contentView addSubview:self.cropContentView];
        
        [self.cropContentView addSubview:self.cropContentHorizontalOneView];
        [self.cropContentView addSubview:self.cropContentHorizontalTwoView];
        [self.cropContentView addSubview:self.cropContentVerticalOneView];
        [self.cropContentView addSubview:self.cropContentVerticalTwoView];
        
        [self.contentView addSubview:self.cropTopLeftButton];
        [self.cropTopLeftButton addSubview:self.cropTopLeftHorizontalView];
        [self.cropTopLeftButton addSubview:self.cropTopLeftVerticalView];
        [self.contentView addSubview:self.cropTopRightButton];
        [self.cropTopRightButton addSubview:self.cropTopRightHorizontalView];
        [self.cropTopRightButton addSubview:self.cropTopRightVerticalView];
        [self.contentView addSubview:self.cropBottomLeftButton];
        [self.cropBottomLeftButton addSubview:self.cropBottomLeftHorizontalView];
        [self.cropBottomLeftButton addSubview:self.cropBottomLeftVerticalView];
        [self.contentView addSubview:self.cropBottomRightButton];
        [self.cropBottomRightButton addSubview:self.cropBottomRightHorizontalView];
        [self.cropBottomRightButton addSubview:self.cropBottomRightVerticalView];
        
        [self.contentView addSubview:self.cropTopLineButton];
        [self.cropTopLineButton addSubview:self.cropTopLine];
        [self.contentView addSubview:self.cropLeftLineButton];
        [self.cropLeftLineButton addSubview:self.cropLeftLine];
        [self.contentView addSubview:self.cropBottomLineButton];
        [self.cropBottomLineButton addSubview:self.cropBottomLine];
        [self.contentView addSubview:self.cropRightLineButton];
        [self.cropRightLineButton addSubview:self.cropRightLine];
        
        [self.contentView addSubview:self.doneButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize selfSize = self.bounds.size;
    if ((selfSize.width == 0 && selfSize.height == 0) ||
        (selfSize.width == self.lastSize.width && selfSize.height == self.lastSize.height)) {
        return;
    }
    CGSize contentSize = CGSizeMake(selfSize.width - self.padding*2, selfSize.height - self.padding*2);
    self.contentView.frame = CGRectMake(self.padding, self.padding, contentSize.width, contentSize.height);
    self.scrollView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.width);
    CGFloat imageViewX = 0;
    CGFloat imageViewY = 0;
    CGFloat imageViewWidth = contentSize.width;
    CGFloat imageViewHeight = imageViewWidth*(self.image.size.height/self.image.size.width);
    if (self.image.size.width/self.image.size.height > contentSize.width/contentSize.height) {
        imageViewWidth = contentSize.width;
        CGFloat ratio = imageViewWidth/self.image.size.width;
        imageViewHeight = self.image.size.height*ratio;
        imageViewX = 0;
        imageViewY = (contentSize.height - imageViewHeight)/2.0;
    } else {
        imageViewHeight = contentSize.height;
        CGFloat ratio = imageViewHeight/self.image.size.height;
        imageViewWidth = self.image.size.width*ratio;
        imageViewY = 0;
        imageViewX = (contentSize.width - imageViewWidth)/2.0;
    }
    self.imageView.frame = self.imageViewDefaultFrame = CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight);
    if (self.cropRect.size.width <= 0 || self.cropRect.size.height <= 0) {
        CGRect newCropRect = self.cropRect;
        newCropRect.size = CGSizeMake(self.cropRect.size.width <= 0 ? self.image.size.width : self.cropRect.size.width,
                                      self.cropRect.size.height <= 0 ? self.image.size.height : self.cropRect.size.height);
        self.cropRect = newCropRect;
    }
    self.cropContentViewDefaultFrame = CGRectMake(imageViewX + imageViewWidth*(self.cropRect.origin.x/self.image.size.width),
                                                  imageViewY + imageViewHeight*(self.cropRect.origin.y/self.image.size.height),
                                                  imageViewWidth*(self.cropRect.size.width/self.image.size.width),
                                                  imageViewHeight*(self.cropRect.size.height/self.image.size.height));
    self.cropContentView.frame = self.cropContentViewDefaultFrame;
    [self changeCropButtonFrame];
    
    self.doneButton.frame = CGRectMake((contentSize.width - self.doneButtonWidth)/2.0,
                                       contentSize.height - self.doneButtonHeight - self.padding,
                                       self.doneButtonWidth,
                                       self.doneButtonHeight);
    
    self.lastSize = selfSize;
}

- (void)changeCropButtonFrame {
    CGFloat cropButtonWidth = 3 + 27;
    CGFloat cropButtonHeight = cropButtonWidth;
    CGFloat lineW = 3;
    CGFloat lineL = 20;
    CGRect cropContentViewFrame = self.cropContentView.frame;
    self.cropTopLeftButton.frame = CGRectMake(CGRectGetMinX(cropContentViewFrame) - lineW,
                                              CGRectGetMinY(cropContentViewFrame) - lineW,
                                              cropButtonWidth,
                                              cropButtonHeight);
    self.cropTopLeftHorizontalView.frame = CGRectMake(0, 0, lineL, lineW);
    self.cropTopLeftVerticalView.frame = CGRectMake(0, 0, lineW, lineL);
    self.cropTopRightButton.frame = CGRectMake(CGRectGetMaxX(cropContentViewFrame) - cropButtonWidth + lineW,
                                               CGRectGetMinY(cropContentViewFrame) - lineW,
                                               cropButtonWidth,
                                               cropButtonHeight);
    self.cropTopRightHorizontalView.frame = CGRectMake(cropButtonWidth - lineL, 0, lineL, lineW);
    self.cropTopRightVerticalView.frame = CGRectMake(cropButtonWidth - lineW, 0, lineW, lineL);
    self.cropBottomLeftButton.frame = CGRectMake(CGRectGetMinX(cropContentViewFrame) - lineW,
                                                 CGRectGetMaxY(cropContentViewFrame) - cropButtonHeight + lineW,
                                                 cropButtonWidth,
                                                 cropButtonHeight);
    self.cropBottomLeftHorizontalView.frame = CGRectMake(0, cropButtonHeight - lineW, lineL, lineW);
    self.cropBottomLeftVerticalView.frame = CGRectMake(0, cropButtonHeight - lineL, lineW, lineL);
    self.cropBottomRightButton.frame = CGRectMake(CGRectGetMaxX(cropContentViewFrame) - cropButtonWidth + lineW,
                                                  CGRectGetMaxY(cropContentViewFrame) - cropButtonHeight + lineW,
                                                  cropButtonWidth,
                                                  cropButtonHeight);
    self.cropBottomRightHorizontalView.frame = CGRectMake(cropButtonWidth - lineL, cropButtonHeight - lineW, lineL, lineW);
    self.cropBottomRightVerticalView.frame = CGRectMake(cropButtonWidth - lineW, cropButtonHeight - lineL, lineW, lineL);
    
    CGFloat add = cropButtonWidth - lineL;
    self.cropTopLineButton.frame = CGRectMake(CGRectGetMaxX(self.cropTopLeftButton.frame),
                                              CGRectGetMinY(self.cropTopLeftButton.frame),
                                              CGRectGetMinX(self.cropTopRightButton.frame) - CGRectGetMaxX(self.cropTopLeftButton.frame),
                                              cropButtonHeight);
    self.cropTopLine.frame = CGRectMake(-add, lineW - 1, CGRectGetWidth(self.cropTopLineButton.frame) + add*2, 1);
    self.cropLeftLineButton.frame = CGRectMake(CGRectGetMinX(self.cropTopLeftButton.frame),
                                              CGRectGetMaxY(self.cropTopLeftButton.frame),
                                              cropButtonWidth,
                                              CGRectGetMinY(self.cropBottomLeftButton.frame) - CGRectGetMaxY(self.cropTopLeftButton.frame));
    self.cropLeftLine.frame = CGRectMake(lineW - 1, -add, 1, CGRectGetHeight(self.cropLeftLineButton.frame) + add*2);
    self.cropBottomLineButton.frame = CGRectMake(CGRectGetMaxX(self.cropBottomLeftButton.frame),
                                              CGRectGetMinY(self.cropBottomLeftButton.frame),
                                              CGRectGetMinX(self.cropBottomRightButton.frame) - CGRectGetMaxX(self.cropBottomLeftButton.frame),
                                              cropButtonHeight);
    self.cropBottomLine.frame = CGRectMake(-add, cropButtonHeight - lineW, CGRectGetWidth(self.cropBottomLineButton.frame) + add*2, 1);
    self.cropRightLineButton.frame = CGRectMake(CGRectGetMinX(self.cropTopRightButton.frame),
                                               CGRectGetMaxY(self.cropTopRightButton.frame),
                                               cropButtonWidth,
                                               CGRectGetMinY(self.cropBottomRightButton.frame) - CGRectGetMaxY(self.cropTopRightButton.frame));
    self.cropRightLine.frame = CGRectMake(cropButtonWidth - lineW, -add, 1, CGRectGetHeight(self.cropRightLineButton.frame) + add*2);
    
    CGFloat ws = cropContentViewFrame.size.width/3.0;
    CGFloat hs = cropContentViewFrame.size.height/3.0;
    CGFloat onePixel = 1.0/[UIScreen mainScreen].scale;
    self.cropContentHorizontalOneView.frame = CGRectMake(0, hs, cropContentViewFrame.size.width, onePixel);
    self.cropContentHorizontalTwoView.frame = CGRectMake(0, hs*2, cropContentViewFrame.size.width, onePixel);
    self.cropContentVerticalOneView.frame = CGRectMake(ws, 0, onePixel, cropContentViewFrame.size.height);
    self.cropContentVerticalTwoView.frame = CGRectMake(ws*2, 0, onePixel, cropContentViewFrame.size.height);
    
    [self changeCoverViewFrame];
}

- (void)changeCoverViewFrame {
    CGSize contentSize = self.contentView.bounds.size;
    CGRect cropContentViewFrame = self.cropContentView.frame;
    self.topCoverView.frame = CGRectMake(0, 0, contentSize.width, CGRectGetMinY(cropContentViewFrame));
    self.leftCoverView.frame = CGRectMake(0, CGRectGetMinY(cropContentViewFrame), CGRectGetMinX(cropContentViewFrame), cropContentViewFrame.size.height);
    self.bottomCoverView.frame = CGRectMake(0, CGRectGetMaxY(cropContentViewFrame), contentSize.width, contentSize.height - CGRectGetMaxY(cropContentViewFrame));
    self.rightCoverView.frame = CGRectMake(CGRectGetMaxX(cropContentViewFrame), CGRectGetMinY(cropContentViewFrame), contentSize.width - CGRectGetMaxX(cropContentViewFrame), cropContentViewFrame.size.height);
}

#pragma mark -

- (void)cropButtonTouchDown {
    // NSLog(@"按下");
    [self showContentLine];
}

- (void)cropButtonTouchUp {
    // NSLog(@"抬起");
    [self hideContentLine];
}

- (void)showContentLine {
    [UIView animateWithDuration:0.3 animations:^{
        self.cropContentHorizontalOneView.alpha = 1;
        self.cropContentHorizontalTwoView.alpha = 1;
        self.cropContentVerticalOneView.alpha = 1;
        self.cropContentVerticalTwoView.alpha = 1;
    }];
}

- (void)hideContentLine {
    [UIView animateWithDuration:0.3 animations:^{
        self.cropContentHorizontalOneView.alpha = 0;
        self.cropContentHorizontalTwoView.alpha = 0;
        self.cropContentVerticalOneView.alpha = 0;
        self.cropContentVerticalTwoView.alpha = 0;
    }];
}

#pragma mark - 拖动裁剪区域的处理

- (void)handleCropTopLeftButtonPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 获取偏移量，返回的是相对于最原始的手指的偏移量
    CGPoint changedPoint = [panGestureRecognizer translationInView:self.cropTopLeftButton];
    if (panGestureRecognizer.view == self.cropTopLineButton) {
        changedPoint.x = 0;
    } else if (panGestureRecognizer.view == self.cropLeftLineButton) {
        changedPoint.y = 0;
    }
    // NSLog(@"changedPoint: %@", NSStringFromCGPoint(changedPoint));
    // 移动
    CGRect frame = self.cropContentView.frame;
    CGFloat minW = 60;
    CGFloat minH = minW;
    CGFloat minX = 0;
    CGFloat minY = 0;
    CGFloat maxX = CGRectGetMaxX(frame) - minW;
    CGFloat maxY = CGRectGetMaxY(frame) - minH;
    CGFloat maxW = CGRectGetMaxX(frame);
    CGFloat maxH = CGRectGetMaxY(frame);
    CGFloat x = frame.origin.x + changedPoint.x;
    if (x > minX && x < maxX) {
        frame.origin.x = x;
        frame.size.width += -changedPoint.x;
    } else if (x <= minX) {
        frame.origin.x = minX;
        frame.size.width = maxW;
    }
    CGFloat y = frame.origin.y + changedPoint.y;
    if (y > minY && y < maxY) {
        frame.origin.y = y;
        frame.size.height += -changedPoint.y;
    } else if (y <= minY) {
        frame.origin.y = minY;
        frame.size.height = maxH;
    }
    self.cropContentView.frame = frame;
    [self changeCropButtonFrame];
    // 复位，表示相对上一次
    [panGestureRecognizer setTranslation:CGPointZero inView:self.cropTopLeftButton];
    // 放大选中区域
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self hideContentLine];
        [self changeCrop];
    }
}

- (void)handleCropTopRightButtonPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 获取偏移量，返回的是相对于最原始的手指的偏移量
    CGPoint changedPoint = [panGestureRecognizer translationInView:self.cropTopRightButton];
    // NSLog(@"changedPoint: %@", NSStringFromCGPoint(changedPoint));
    // 移动
    CGRect frame = self.cropContentView.frame;
    CGSize contentSize = self.contentView.bounds.size;
    CGFloat minW = 60;
    CGFloat minH = minW;
//    CGFloat minX = ;
    CGFloat minY = 0;
//    CGFloat maxX = ;
    CGFloat maxY = CGRectGetMaxY(frame) - minH;
    CGFloat maxW = contentSize.width - frame.origin.x;
    CGFloat maxH = CGRectGetMaxY(frame);
    CGFloat w = frame.size.width + changedPoint.x;
    if (w > minW && w < maxW) {
        frame.size.width = w;
    } else if (w >= maxW) {
        frame.size.width = maxW;
    }
    CGFloat y = frame.origin.y + changedPoint.y;
    if (y > minY && y < maxY) {
        frame.origin.y = y;
        frame.size.height += -changedPoint.y;
    } else if (y <= minY) {
        frame.origin.y = minY;
        frame.size.height = maxH;
    }
    self.cropContentView.frame = frame;
    [self changeCropButtonFrame];
    // 复位，表示相对上一次
    [panGestureRecognizer setTranslation:CGPointZero inView:self.cropTopRightButton];
    // 放大选中区域
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self hideContentLine];
        [self changeCrop];
    }
}

- (void)handleCropBottomLeftButtonPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 获取偏移量，返回的是相对于最原始的手指的偏移量
    CGPoint changedPoint = [panGestureRecognizer translationInView:self.cropBottomLeftButton];
    // NSLog(@"changedPoint: %@", NSStringFromCGPoint(changedPoint));
    // 移动
    CGRect frame = self.cropContentView.frame;
    CGSize contentSize = self.contentView.bounds.size;
    CGFloat minW = 60;
    CGFloat minH = minW;
    CGFloat minX = 0;
//    CGFloat minY = ;
    CGFloat maxX = CGRectGetMaxX(frame) - minW;
//    CGFloat maxY = ;
    CGFloat maxW = CGRectGetMaxX(frame);
    CGFloat maxH = contentSize.height - frame.origin.y;
    CGFloat x = frame.origin.x + changedPoint.x;
    if (x > minX && x < maxX) {
        frame.origin.x = x;
        frame.size.width += -changedPoint.x;
    } else if (x <= minX) {
        frame.origin.x = minX;
        frame.size.width = maxW;
    }
    CGFloat h = frame.size.height + changedPoint.y;
    if (h > minH && h < maxH) {
        frame.size.height = h;
    } else if (h >= maxH) {
        frame.size.height = maxH;
    }
    self.cropContentView.frame = frame;
    [self changeCropButtonFrame];
    // 复位，表示相对上一次
    [panGestureRecognizer setTranslation:CGPointZero inView:self.cropBottomLeftButton];
    // 放大选中区域
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self hideContentLine];
        [self changeCrop];
    }
}

- (void)handleCropBottomRightButtonPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 获取偏移量，返回的是相对于最原始的手指的偏移量
    CGPoint changedPoint = [panGestureRecognizer translationInView:self.cropBottomRightButton];
    if (panGestureRecognizer.view == self.cropBottomLineButton) {
        changedPoint.x = 0;
    } else if (panGestureRecognizer.view == self.cropRightLineButton) {
        changedPoint.y = 0;
    }
    // NSLog(@"changedPoint: %@", NSStringFromCGPoint(changedPoint));
    // 移动
    CGRect frame = self.cropContentView.frame;
    CGSize contentSize = self.contentView.bounds.size;
    CGFloat minW = 60;
    CGFloat minH = minW;
//    CGFloat minX = ;
//    CGFloat minY = ;
//    CGFloat maxX = ;
//    CGFloat maxY = ;
    CGFloat maxW = contentSize.width - frame.origin.x;
    CGFloat maxH = contentSize.height - frame.origin.y;
    CGFloat w = frame.size.width + changedPoint.x;
    if (w > minW && w < maxW) {
        frame.size.width = w;
    } else if (w >= maxW) {
        frame.size.width = maxW;
    }
    CGFloat h = frame.size.height + changedPoint.y;
    if (h > minH && h < maxH) {
        frame.size.height = h;
    } else if (h >= maxH) {
        frame.size.height = maxH;
    }
    self.cropContentView.frame = frame;
    [self changeCropButtonFrame];
    // 复位，表示相对上一次
    [panGestureRecognizer setTranslation:CGPointZero inView:self.cropBottomRightButton];
    // 放大选中区域
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self hideContentLine];
        [self changeCrop];
    }
}

#pragma mark - 拖动后的处理

- (void)changeCrop {
    // NSLog(@"放大选中");
    CGRect frame = self.cropContentView.frame;
    CGSize contentSize = self.contentView.bounds.size;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat zoomRatio = 0;
    if (frame.size.height/frame.size.width < contentSize.height/contentSize.width) {
        width = contentSize.width;
        CGFloat ratio = width/frame.size.width;
        height = frame.size.height*ratio;
        x = 0;
        y = (contentSize.height - height)/2.0;
        zoomRatio = ratio;
    } else {
        height = contentSize.height;
        CGFloat ratio = height/frame.size.height;
        width = frame.size.width*ratio;
        y = 0;
        x = (contentSize.width - width)/2.0;
        zoomRatio = ratio;
    }
    CGFloat xChangedToCenter = (contentSize.width - frame.size.width)/2.0 - frame.origin.x;
    CGFloat yChangedToCenter = (contentSize.height - frame.size.height)/2.0 - frame.origin.y;
    // NSLog(@"xChangedToCenter: %@, yChangedToCenter: %@, zoomRatio: %@", @(xChangedToCenter), @(yChangedToCenter), @(zoomRatio));
    CGRect imageViewFrame = self.imageView.frame;
    imageViewFrame.origin.x += xChangedToCenter;
    imageViewFrame.origin.y += yChangedToCenter;
    
    frame.origin.x += xChangedToCenter;
    frame.origin.y += yChangedToCenter;
    
    // 剪切区域映射到图片上的位置
    CGRect toImageFrame = [self getCropContentToImageViewFrame];
    // NSLog(@"toImageFrame: %@", NSStringFromCGRect(toImageFrame));
    // 寻找中心点
    CGFloat zoomXRatio = 1 - (imageViewFrame.size.width - (toImageFrame.origin.x + toImageFrame.size.width/2.0))/imageViewFrame.size.width;
    CGFloat zoomYRatio = 1 - (imageViewFrame.size.height - (toImageFrame.origin.y + toImageFrame.size.height/2.0))/imageViewFrame.size.height;
    // NSLog(@"zoomXRatio: %@, zoomYRatio: %@", @(zoomXRatio), @(zoomYRatio));
    CGFloat widthAdd = imageViewFrame.size.width*zoomRatio - imageViewFrame.size.width;
    CGFloat heightAdd = imageViewFrame.size.height*zoomRatio - imageViewFrame.size.height;
    imageViewFrame.size.width = imageViewFrame.size.width*zoomRatio;
    imageViewFrame.size.height = imageViewFrame.size.height*zoomRatio;
    CGFloat xAdd = -widthAdd*zoomXRatio;
    CGFloat yAdd = -heightAdd*zoomYRatio;
    imageViewFrame.origin.x += xAdd;
    imageViewFrame.origin.y += yAdd;
    
    frame.origin.x = x;
    frame.origin.y = y;
    frame.size.width = width;
    frame.size.height = height;
    // NSLog(@"cropContentView.frame: %@", NSStringFromCGRect(frame));
    [UIView animateWithDuration:0.3 animations:^{
        self.cropContentView.frame = frame;
        [self changeCropButtonFrame];
        self.imageView.frame = imageViewFrame;
    } completion:^(BOOL finished) {
        [self changeScrollViewContentOffsetAndSize];
    }];
}

// 剪切区域映射到图片上的位置
- (CGRect)getCropContentToImageViewFrame {
    CGRect toImageFrame = [self.cropContentView convertRect:self.imageView.bounds toView:self.imageView];
    toImageFrame.size = self.cropContentView.bounds.size;
    return toImageFrame;
}

- (void)changeScrollViewContentOffsetAndSize {
    // NSLog(@"begin");
    CGPoint scrollViewOffset = self.scrollView.contentOffset;
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    CGSize scrollViewSize = self.scrollView.bounds.size;
    CGPoint imageViewOrigin = self.imageView.frame.origin;
    CGSize imageViewSize = self.imageView.bounds.size;
    
    CGSize scrollViewNewContentSize = scrollViewContentSize;
    CGPoint scrollViewNewOffset = scrollViewOffset;
    CGPoint imageViewNewOrigin = imageViewOrigin;
    // 判断顶部是否可见
    if (imageViewOrigin.y - scrollViewOffset.y >= 0) {
        // NSLog(@"顶部可见");
        scrollViewNewOffset.y = 0;
        imageViewNewOrigin.y = imageViewOrigin.y - scrollViewOffset.y;
    } else {
        // NSLog(@"顶部不可见");
        if (imageViewOrigin.y < 0) {
            scrollViewNewOffset.y += -imageViewOrigin.y;
            imageViewNewOrigin.y = 0;
        } else {
            scrollViewNewOffset.y = scrollViewOffset.y - imageViewOrigin.y;
            imageViewNewOrigin.y = 0;
        }
    }
    // 判断左侧是否可见
    if (imageViewOrigin.x - scrollViewOffset.x >= 0) {
        // NSLog(@"左侧可见");
        scrollViewNewOffset.x = 0;
        imageViewNewOrigin.x = imageViewOrigin.x - scrollViewOffset.x;
    } else {
        // NSLog(@"左侧不可见");
        if (imageViewOrigin.x < 0) {
            scrollViewNewOffset.x += -imageViewOrigin.x;
            imageViewNewOrigin.x = 0;
        } else {
            scrollViewNewOffset.x = scrollViewOffset.x - imageViewOrigin.x;
            imageViewNewOrigin.x = 0;
        }
    }
    // 判断底部是否可见
    if (imageViewOrigin.y - scrollViewOffset.y + imageViewSize.height <= scrollViewSize.height) {
        // NSLog(@"底部可见");
        CGFloat t = scrollViewSize.height - (imageViewOrigin.y - scrollViewOffset.y + imageViewSize.height);
        scrollViewNewContentSize.height = imageViewNewOrigin.y + imageViewSize.height + t;
    } else {
        // NSLog(@"底部不可见");
        scrollViewNewContentSize.height = imageViewNewOrigin.y + imageViewSize.height;
    }
    // 判断右侧是否可见
    if (imageViewOrigin.x - scrollViewOffset.x + imageViewSize.width <= scrollViewSize.width) {
        // NSLog(@"右侧可见");
        CGFloat t = scrollViewSize.width - (imageViewOrigin.x - scrollViewOffset.x + imageViewSize.width);
        scrollViewNewContentSize.width = imageViewNewOrigin.x + imageViewSize.width + t;
    } else {
        // NSLog(@"右侧不可见");
        scrollViewNewContentSize.width = imageViewNewOrigin.x + imageViewSize.width;
    }
    self.scrollView.contentOffset = scrollViewNewOffset;
    self.scrollView.contentSize = scrollViewNewContentSize;
    CGRect imageViewNewFrame = self.imageView.frame;
    imageViewNewFrame.origin = imageViewNewOrigin;
    self.imageView.frame = imageViewNewFrame;
    // NSLog(@"end");
}

#pragma mark - 图片缩放处理

- (void)handlePinchGestureRecognizer:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.pinchPoint = [pinchGestureRecognizer locationInView:self.imageView];
        self.pinchFrame = self.imageView.frame;
    }
    CGFloat zoomRatio = pinchGestureRecognizer.scale;
    CGRect imageViewFrame = self.pinchFrame;
    CGFloat zoomXRatio = self.pinchPoint.x/imageViewFrame.size.width;
    CGFloat zoomYRatio = self.pinchPoint.y/imageViewFrame.size.height;
    // NSLog(@"zoomXRatio: %@, zoomYRatio: %@", @(zoomXRatio), @(zoomYRatio));
    CGFloat widthAdd = imageViewFrame.size.width*zoomRatio - imageViewFrame.size.width;
    CGFloat heightAdd = imageViewFrame.size.height*zoomRatio - imageViewFrame.size.height;
    imageViewFrame.size.width = imageViewFrame.size.width*zoomRatio;
    imageViewFrame.size.height = imageViewFrame.size.height*zoomRatio;
    CGFloat xAdd = -widthAdd*zoomXRatio;
    CGFloat yAdd = -heightAdd*zoomYRatio;
    imageViewFrame.origin.x += xAdd;
    imageViewFrame.origin.y += yAdd;
    self.imageView.frame = imageViewFrame;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (imageViewFrame.size.width < self.imageViewDefaultFrame.size.width) {
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointZero;
                self.scrollView.contentSize = self.scrollView.bounds.size;
                self.imageView.frame = self.imageViewDefaultFrame;
                self.cropContentView.frame = self.cropContentViewDefaultFrame;
                [self changeCropButtonFrame];
            }];
        } else {
            [self changeScrollViewContentOffsetAndSize];
        }
    }
}

#pragma mark - 保存按钮事件

- (void)doneButtonClickAction {
    // 剪切区域映射到图片上的位置
    CGRect toImageFrame = [self getCropContentToImageViewFrame];
    CGRect cropFrame = CGRectZero;
    cropFrame.origin.x = self.image.size.width*(toImageFrame.origin.x/self.imageView.frame.size.width);
    cropFrame.origin.y = self.image.size.height*(toImageFrame.origin.y/self.imageView.frame.size.height);
    cropFrame.size.width = self.image.size.width*(toImageFrame.size.width/self.imageView.frame.size.width);
    cropFrame.size.height = self.image.size.height*(toImageFrame.size.height/self.imageView.frame.size.height);
    
    UIImage *img = [DVVPictureCropView cropImage:self.image rect:cropFrame];
    [self.delegate pictureCropView:self completedCropImage:img];
}

// 按照指定的矩形区域裁剪图片
+ (UIImage *)cropImage:(UIImage *)image rect:(CGRect)rect {
    
    if (rect.size.width <= 0 || rect.size.height <= 0) return nil;
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return img;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
//    return [self image:aImage rotation:UIImageOrientationRight];
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark -

- (void)setImage:(UIImage *)image {
    _image = image.copy;
    self.imageView.image = _image;
}

#pragma mark -

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.maximumZoomScale = CGFLOAT_MAX;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGestureRecognizer:)];
        [_imageView addGestureRecognizer:pinchGestureRecognizer];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIView *)topCoverView {
    if (!_topCoverView) {
        _topCoverView = [[UIView alloc] init];
        _topCoverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _topCoverView.userInteractionEnabled = NO;
    }
    return _topCoverView;
}

- (UIView *)leftCoverView {
    if (!_leftCoverView) {
        _leftCoverView = [[UIView alloc] init];
        _leftCoverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _leftCoverView.userInteractionEnabled = NO;
    }
    return _leftCoverView;
}

- (UIView *)bottomCoverView {
    if (!_bottomCoverView) {
        _bottomCoverView = [[UIView alloc] init];
        _bottomCoverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _bottomCoverView.userInteractionEnabled = NO;
    }
    return _bottomCoverView;
}

- (UIView *)rightCoverView {
    if (!_rightCoverView) {
        _rightCoverView = [[UIView alloc] init];
        _rightCoverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _rightCoverView.userInteractionEnabled = NO;
    }
    return _rightCoverView;
}

- (UIView *)cropContentView {
    if (!_cropContentView) {
        _cropContentView = [[UIView alloc] init];
        _cropContentView.userInteractionEnabled = NO;
    }
    return _cropContentView;
}

- (UIView *)cropContentHorizontalOneView {
    if (!_cropContentHorizontalOneView) {
        _cropContentHorizontalOneView = [[UIView alloc] init];
        _cropContentHorizontalOneView.backgroundColor = [UIColor whiteColor];
        _cropContentHorizontalOneView.alpha = 0;
    }
    return _cropContentHorizontalOneView;
}

- (UIView *)cropContentHorizontalTwoView {
    if (!_cropContentHorizontalTwoView) {
        _cropContentHorizontalTwoView = [[UIView alloc] init];
        _cropContentHorizontalTwoView.backgroundColor = [UIColor whiteColor];
        _cropContentHorizontalTwoView.alpha = 0;
    }
    return _cropContentHorizontalTwoView;
}

- (UIView *)cropContentVerticalOneView {
    if (!_cropContentVerticalOneView) {
        _cropContentVerticalOneView = [[UIView alloc] init];
        _cropContentVerticalOneView.backgroundColor = [UIColor whiteColor];
        _cropContentVerticalOneView.alpha = 0;
    }
    return _cropContentVerticalOneView;
}

- (UIView *)cropContentVerticalTwoView {
    if (!_cropContentVerticalTwoView) {
        _cropContentVerticalTwoView = [[UIView alloc] init];
        _cropContentVerticalTwoView.backgroundColor = [UIColor whiteColor];
        _cropContentVerticalTwoView.alpha = 0;
    }
    return _cropContentVerticalTwoView;
}

- (UIButton *)cropTopLeftButton {
    if (!_cropTopLeftButton) {
        _cropTopLeftButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        _cropTopLeftButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCropTopLeftButtonPanGestureRecognizer:)];
        [_cropTopLeftButton addGestureRecognizer:panGestureRecognizer];
        
        [_cropTopLeftButton addTarget:self action:@selector(cropButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_cropTopLeftButton addTarget:self action:@selector(cropButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [_cropTopLeftButton addTarget:self action:@selector(cropButtonTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _cropTopLeftButton;
}

- (UIView *)cropTopLeftHorizontalView {
    if (!_cropTopLeftHorizontalView) {
        _cropTopLeftHorizontalView = [[UIView alloc] init];
        _cropTopLeftHorizontalView.backgroundColor = [UIColor whiteColor];
    }
    return _cropTopLeftHorizontalView;
}

- (UIView *)cropTopLeftVerticalView {
    if (!_cropTopLeftVerticalView) {
        _cropTopLeftVerticalView = [[UIView alloc] init];
        _cropTopLeftVerticalView.backgroundColor = [UIColor whiteColor];
    }
    return _cropTopLeftVerticalView;
}

- (UIButton *)cropTopRightButton {
    if (!_cropTopRightButton) {
        _cropTopRightButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        _cropTopRightButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCropTopRightButtonPanGestureRecognizer:)];
        [_cropTopRightButton addGestureRecognizer:panGestureRecognizer];
        
        [_cropTopRightButton addTarget:self action:@selector(cropButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_cropTopRightButton addTarget:self action:@selector(cropButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [_cropTopRightButton addTarget:self action:@selector(cropButtonTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _cropTopRightButton;
}

- (UIView *)cropTopRightHorizontalView {
    if (!_cropTopRightHorizontalView) {
        _cropTopRightHorizontalView = [[UIView alloc] init];
        _cropTopRightHorizontalView.backgroundColor = [UIColor whiteColor];
    }
    return _cropTopRightHorizontalView;
}

- (UIView *)cropTopRightVerticalView {
    if (!_cropTopRightVerticalView) {
        _cropTopRightVerticalView = [[UIView alloc] init];
        _cropTopRightVerticalView.backgroundColor = [UIColor whiteColor];
    }
    return _cropTopRightVerticalView;
}

- (UIButton *)cropBottomLeftButton {
    if (!_cropBottomLeftButton) {
        _cropBottomLeftButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        _cropBottomLeftButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCropBottomLeftButtonPanGestureRecognizer:)];
        [_cropBottomLeftButton addGestureRecognizer:panGestureRecognizer];
        
        [_cropBottomLeftButton addTarget:self action:@selector(cropButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_cropBottomLeftButton addTarget:self action:@selector(cropButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [_cropBottomLeftButton addTarget:self action:@selector(cropButtonTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _cropBottomLeftButton;
}

- (UIView *)cropBottomLeftHorizontalView {
    if (!_cropBottomLeftHorizontalView) {
        _cropBottomLeftHorizontalView = [[UIView alloc] init];
        _cropBottomLeftHorizontalView.backgroundColor = [UIColor whiteColor];
    }
    return _cropBottomLeftHorizontalView;
}

- (UIView *)cropBottomLeftVerticalView {
    if (!_cropBottomLeftVerticalView) {
        _cropBottomLeftVerticalView = [[UIView alloc] init];
        _cropBottomLeftVerticalView.backgroundColor = [UIColor whiteColor];
    }
    return _cropBottomLeftVerticalView;
}

- (UIButton *)cropBottomRightButton {
    if (!_cropBottomRightButton) {
        _cropBottomRightButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        _cropBottomRightButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCropBottomRightButtonPanGestureRecognizer:)];
        [_cropBottomRightButton addGestureRecognizer:panGestureRecognizer];
        
        [_cropBottomRightButton addTarget:self action:@selector(cropButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_cropBottomRightButton addTarget:self action:@selector(cropButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [_cropBottomRightButton addTarget:self action:@selector(cropButtonTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _cropBottomRightButton;
}

- (UIView *)cropBottomRightHorizontalView {
    if (!_cropBottomRightHorizontalView) {
        _cropBottomRightHorizontalView = [[UIView alloc] init];
        _cropBottomRightHorizontalView.backgroundColor = [UIColor whiteColor];
    }
    return _cropBottomRightHorizontalView;
}

- (UIView *)cropBottomRightVerticalView {
    if (!_cropBottomRightVerticalView) {
        _cropBottomRightVerticalView = [[UIView alloc] init];
        _cropBottomRightVerticalView.backgroundColor = [UIColor whiteColor];
    }
    return _cropBottomRightVerticalView;
}

- (UIButton *)cropTopLineButton {
    if (!_cropTopLineButton) {
        _cropTopLineButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        _cropTopLineButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCropTopLeftButtonPanGestureRecognizer:)];
        [_cropTopLineButton addGestureRecognizer:panGestureRecognizer];
        
        [_cropTopLineButton addTarget:self action:@selector(cropButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_cropTopLineButton addTarget:self action:@selector(cropButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [_cropTopLineButton addTarget:self action:@selector(cropButtonTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _cropTopLineButton;
}

- (UIView *)cropTopLine {
    if (!_cropTopLine) {
        _cropTopLine = [[UIView alloc] init];
        _cropTopLine.backgroundColor = [UIColor whiteColor];
    }
    return _cropTopLine;
}

- (UIButton *)cropLeftLineButton {
    if (!_cropLeftLineButton) {
        _cropLeftLineButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        _cropLeftLineButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCropTopLeftButtonPanGestureRecognizer:)];
        [_cropLeftLineButton addGestureRecognizer:panGestureRecognizer];
        
        [_cropLeftLineButton addTarget:self action:@selector(cropButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_cropLeftLineButton addTarget:self action:@selector(cropButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [_cropLeftLineButton addTarget:self action:@selector(cropButtonTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _cropLeftLineButton;
}

- (UIView *)cropLeftLine {
    if (!_cropLeftLine) {
        _cropLeftLine = [[UIView alloc] init];
        _cropLeftLine.backgroundColor = [UIColor whiteColor];
    }
    return _cropLeftLine;
}

- (UIButton *)cropBottomLineButton {
    if (!_cropBottomLineButton) {
        _cropBottomLineButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        _cropBottomLineButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCropBottomRightButtonPanGestureRecognizer:)];
        [_cropBottomLineButton addGestureRecognizer:panGestureRecognizer];
        
        [_cropBottomLineButton addTarget:self action:@selector(cropButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_cropBottomLineButton addTarget:self action:@selector(cropButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [_cropBottomLineButton addTarget:self action:@selector(cropButtonTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _cropBottomLineButton;
}

- (UIView *)cropBottomLine {
    if (!_cropBottomLine) {
        _cropBottomLine = [[UIView alloc] init];
        _cropBottomLine.backgroundColor = [UIColor whiteColor];
    }
    return _cropBottomLine;
}

- (UIButton *)cropRightLineButton {
    if (!_cropRightLineButton) {
        _cropRightLineButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        _cropRightLineButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCropBottomRightButtonPanGestureRecognizer:)];
        [_cropRightLineButton addGestureRecognizer:panGestureRecognizer];
        
        [_cropRightLineButton addTarget:self action:@selector(cropButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_cropRightLineButton addTarget:self action:@selector(cropButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [_cropRightLineButton addTarget:self action:@selector(cropButtonTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _cropRightLineButton;
}

- (UIView *)cropRightLine {
    if (!_cropRightLine) {
        _cropRightLine = [[UIView alloc] init];
        _cropRightLine.backgroundColor = [UIColor whiteColor];
    }
    return _cropRightLine;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _doneButton.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        _doneButton.layer.masksToBounds = NO;
        _doneButton.layer.cornerRadius = self.doneButtonWidth/2.0;
        [_doneButton addTarget:self action:@selector(doneButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
        
//        _doneButton.layer.shadowColor = [UIColor whiteColor].CGColor;
//        _doneButton.layer.shadowOffset = CGSizeMake(0, 0);
//        _doneButton.layer.shadowOpacity = 0.4;
//        _doneButton.layer.shadowRadius = 8;
        
        CGFloat margin = 8;
        DVVPictureCropTickView *tickView = [[DVVPictureCropTickView alloc] initWithFrame:CGRectMake(margin,
                                                                                                    margin,
                                                                                                    self.doneButtonWidth - margin*2,
                                                                                                    self.doneButtonHeight - margin*2)];
        tickView.userInteractionEnabled = NO;
        tickView.layer.masksToBounds = YES;
        tickView.layer.cornerRadius = (self.doneButtonWidth - margin*2)/2.0;
        [_doneButton addSubview:tickView];
    }
    return _doneButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
