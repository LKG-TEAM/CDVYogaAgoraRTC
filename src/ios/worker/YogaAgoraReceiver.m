
#import "YogaAgoraReceiver.h"
#import <Masonry/Masonry.h>
#import "YogaAgoraShared.h"

@interface YogaAgoraReceiver ()<YogaAgoraReceiverCollectionViewDelegate, YogaAgoraReceiverCollectionViewDatasource>

@end

@implementation YogaAgoraReceiver

- (instancetype)init
{
    if (self = [super init]) {
        _margin = UIEdgeInsetsMake(-0.01, -0.01, -0.01, -0.01);
        _width = -1;
        _height = -1;
    }
    return self;
}

#pragma mark -- Public method

- (void)addReceiverView
{
    if (!self.receiverView) {
        self.receiverView = [[YogaAgoraReceiverCollectionView alloc] initWithDelegate:self datasource:self];
        [[[YogaAgoraShared shared] topViewController].view addSubview:self.receiverView];
        self.receiverView.isHorizontal = self.isHorizontal;
        self.receiverView.itemSize = self.itemSize;
    }
    [self.receiverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@([YogaAgoraShared shared].sender.margin));
    }];
}

- (void)receiverViewRemakeConstraints
{
    if (self.receiverView.superview) {
        UIView *superview = self.receiverView.superview;
        CGSize size = [YogaAgoraShared shared].viewController.view.bounds.size;
        [self.receiverView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
}

- (void)addUid:(NSUInteger)uid
{
    [self.receiverView addUid:uid];
}

#pragma mark -- Setter

- (void)setMargin:(UIEdgeInsets)margin
{
    _margin = margin;
    [self receiverViewRemakeConstraints];
}

- (void)setMarginTop:(CGFloat)marginTop
{
    _marginTop = marginTop;
    _margin = UIEdgeInsetsMake(marginTop, _margin.left, _margin.bottom, _margin.right);
    [self receiverViewRemakeConstraints];
}

- (void)setMarginLeft:(CGFloat)marginLeft
{
    _marginLeft = marginLeft;
    _margin = UIEdgeInsetsMake(_margin.top, marginLeft, _margin.bottom, _margin.right);
    [self receiverViewRemakeConstraints];
}

- (void)setMarginRight:(CGFloat)marginRight
{
    _marginRight = marginRight;
    _margin = UIEdgeInsetsMake(_margin.top, _margin.left, _margin.bottom, marginRight);
    [self receiverViewRemakeConstraints];
}

- (void)setMarginBottom:(CGFloat)marginBottom
{
    _marginBottom = marginBottom;
    _margin = UIEdgeInsetsMake(_margin.top, _margin.left, marginBottom, _margin.right);
    [self receiverViewRemakeConstraints];
}

- (void)setWidth:(CGFloat)width
{
    _width = width;
    [self receiverViewRemakeConstraints];
}

- (void)setHeight:(CGFloat)height
{
    _height = height;
    [self receiverViewRemakeConstraints];
}

- (void)setIsHorizontal:(BOOL)isHorizontal
{
    _isHorizontal = isHorizontal;
    if (self.receiverView) {
        self.receiverView.isHorizontal = isHorizontal;
    }
}

- (void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
    if (self.receiverView) {
        self.receiverView.itemSize = itemSize;
    }
}

#pragma mark -- YogaAgoraReceiverCollectionViewDatasource

- (UIView *)containerView
{
    return [[YogaAgoraShared shared] topViewController].view;
}

#pragma mark -- YogaAgoraReceiverCollectionViewDelegate

- (void)close
{
    [self.receiverView removeFromSuperview];
    self.receiverView = nil;
}

@end
