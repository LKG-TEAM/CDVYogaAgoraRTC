
#import "YogaAgoraSender.h"
#import <Masonry/Masonry.h>
#import "YogaAgoraShared.h"

@interface YogaAgoraSender ()<YogaAgoraSenderViewDelegate, YogaAgoraSenderViewDatasource>

@end

@implementation YogaAgoraSender

- (instancetype)init
{
    if (self = [super init]) {
        _videoFrameRate = AgoraVideoFrameRateFps30;
        _videoDimension = AgoraVideoDimension320x240;
        _margin = UIEdgeInsetsMake(-0.01, -0.01, -0.01, -0.01);
        _width = -1;
        _height = -1;
        
        _videoEnabled = YES;
    }
    return self;
}

#pragma mark -- Public method

- (void)addSenderView
{
    if (!self.senderView) {
        self.senderView = [[YogaAgoraSenderView alloc] initWithDelegate:self datasource:self];
        [[[YogaAgoraShared shared] topViewController].view addSubview:self.senderView];
    }
    [self.senderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@([YogaAgoraShared shared].sender.margin));
    }];
    [self senderViewRemakeConstraints];
    self.senderView.title = self.title;
    self.senderView.viewClean = self.viewClean;
}

- (void)senderViewRemakeConstraints
{
    if (!self.senderView.superview) {
        [[[YogaAgoraShared shared] topViewController].view addSubview:_senderView];
    }
    UIView *superview = self.senderView.superview;
    CGSize size = [YogaAgoraShared shared].viewController.view.bounds.size;
    [self.senderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (_width >= 0) {
            if (_width <= 1) {
                make.width.equalTo(superview).multipliedBy(_width);
            }else {
                make.width.equalTo(@(_width));
            }
            
            if (_margin.right >= 0) {
                if (_margin.right > 0 && _margin.right < 1) {
                    make.right.equalTo(@(-size.width*(_margin.right)));
                }else {
                    make.right.equalTo(@(-_margin.right));
                }
            }else {
                if (_margin.left > 0 && _margin.left < 1) {
                    make.left.equalTo(@(size.width*(_margin.left)));
                }else {
                    make.left.equalTo(@(_margin.left));
                }
            }
        }else {
            if (_margin.right > 0 && _margin.right < 1) {
                make.right.equalTo(@(-size.width*(_margin.right)));
            }else {
                make.right.equalTo(@(-_margin.right));
            }
            if (_margin.left > 0 && _margin.left < 1) {
                make.left.equalTo(@(size.width*(_margin.left)));
            }else {
                make.left.equalTo(@(_margin.left));
            }
        }
        
        if (_height >= 0) {
            if (_height <= 0) {
                make.height.equalTo(superview).multipliedBy(_height);
            }else {
                make.height.equalTo(@(_height));
            }
            
            if (_margin.bottom >= 0) {
                if (_margin.bottom > 0 && _margin.bottom < 1) {
                    make.bottom.equalTo(@(-size.height*(_margin.bottom)));
                }else {
                    make.bottom.equalTo(@(-_margin.bottom));
                }
            }else {
                if (_margin.top > 0 && _margin.top < 1) {
                    make.top.equalTo(@(size.height*(_margin.top)));
                }else {
                    make.top.equalTo(@(_margin.top));
                }
            }
        }else {
            if (_margin.bottom > 0 && _margin.bottom < 1) {
                make.bottom.equalTo(@(-size.height*(_margin.bottom)));
            }else {
                make.bottom.equalTo(@(-_margin.bottom));
            }
            if (_margin.top > 0 && _margin.top < 1) {
                make.top.equalTo(@(size.height*(_margin.top)));
            }else {
                make.top.equalTo(@(_margin.top));
            }
        }
    }];
}

#pragma mark -- Setter

- (void)setMargin:(UIEdgeInsets)margin
{
    _margin = margin;
    [self senderViewRemakeConstraints];
}

- (void)setMarginTop:(CGFloat)marginTop
{
    _marginTop = marginTop;
    _margin = UIEdgeInsetsMake(marginTop, _margin.left, _margin.bottom, _margin.right);
    [self senderViewRemakeConstraints];
}

- (void)setMarginLeft:(CGFloat)marginLeft
{
    _marginLeft = marginLeft;
    _margin = UIEdgeInsetsMake(_margin.top, marginLeft, _margin.bottom, _margin.right);
    [self senderViewRemakeConstraints];
}

- (void)setMarginRight:(CGFloat)marginRight
{
    _marginRight = marginRight;
    _margin = UIEdgeInsetsMake(_margin.top, _margin.left, _margin.bottom, marginRight);
    [self senderViewRemakeConstraints];
}

- (void)setMarginBottom:(CGFloat)marginBottom
{
    _marginBottom = marginBottom;
    _margin = UIEdgeInsetsMake(_margin.top, _margin.left, marginBottom, _margin.right);
    [self senderViewRemakeConstraints];
}

- (void)setWidth:(CGFloat)width
{
    _width = width;
    [self senderViewRemakeConstraints];
}

- (void)setHeight:(CGFloat)height
{
    _height = height;
    [self senderViewRemakeConstraints];
}

- (void)setViewClean:(BOOL)viewClean
{
    _viewClean = viewClean;
    self.senderView.viewClean = viewClean;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.senderView.title = title;
}

#pragma mark -- YogaAgoraSenderViewDatasource

- (UIView *)containerView
{
    return [[YogaAgoraShared shared] topViewController].view;
}

#pragma mark -- YogaAgoraSenderViewDelegate

- (void)close
{
    [[YogaAgoraShared shared] leave];
    [self.senderView removeFromSuperview];
    self.senderView = nil;
    
    [[YogaAgoraShared shared].receiver.receiverView removeFromSuperview];
    [YogaAgoraShared shared].receiver.receiverView = nil;
}

@end
