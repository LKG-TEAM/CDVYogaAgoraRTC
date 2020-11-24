#import "YogaAgoraSenderView.h"
#import "YogaAgoraShared.h"
#import <Masonry/Masonry.h>
#import "YogaAgoraUtil.h"

@interface YogaAgoraSenderView ()

@property (nonatomic, weak) id<YogaAgoraSenderViewDelegate> delegate;
@property (nonatomic, weak) id<YogaAgoraSenderViewDatasource> datasource;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIView *titleV;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *switchCameraBtn;
@property (nonatomic, strong) UIButton *videoBtn;
@property (nonatomic, strong) UIButton *audioBtn;

@end

@implementation YogaAgoraSenderView

- (instancetype)initWithDelegate:(id<YogaAgoraSenderViewDelegate>)delegate datasource:(id<YogaAgoraSenderViewDatasource>)datasource
{
    if (self = [super init]) {
        self.backgroundColor = [YogaAgoraShared shared].mainBgColor;
        self.delegate = delegate;
        self.datasource = datasource;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    if ([YogaAgoraShared shared].sender.videoEnabled) {
        [self.activityIndicatorView startAnimating];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.datasource && [self.datasource respondsToSelector:@selector(containerView)]) {
        if (self && self.superview) {
//            [[self.datasource containerView] addSubview:self.switchCameraBtn];
//            [self.switchCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.height.equalTo(@50);
//                make.bottom.equalTo(self).offset(0);
//                make.left.equalTo(self).offset(20);
//            }];
            if (!_viewClean) {
                [[self.datasource containerView] addSubview:self.videoBtn];
                [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.equalTo(@40);
                    make.bottom.right.equalTo(self).offset(-2);
                }];
            }
//            [[self.datasource containerView] addSubview:self.audioBtn];
//            [self.audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.height.equalTo(@50);
//                make.bottom.equalTo(self).offset(0);
//                make.left.equalTo(self.videoBtn.mas_right).offset(10);
//            }];
//            [[self.datasource containerView] addSubview:self.closeBtn];
//            [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.height.equalTo(@50);
//                make.bottom.equalTo(self).offset(0);
//                make.right.equalTo(self).offset(-20);
//            }];
            [[self.datasource containerView] addSubview:self.titleV];
            [self.titleV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self);
                make.height.equalTo(@25);
                make.width.equalTo(@100);
            }];
        }
    }
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
//    [self.switchCameraBtn removeFromSuperview];
    [self.videoBtn removeFromSuperview];
    [self.titleV removeFromSuperview];
//    [self.audioBtn removeFromSuperview];
//    [self.closeBtn removeFromSuperview];
//    [self.titleV removeFromSuperview];
}

- (void)activityIndicatorViewStopAnimating
{
    [self.activityIndicatorView stopAnimating];
    [self.videoBtn setBackgroundImage:[UIImage imageNamed:[YogaAgoraShared shared].sender.videoEnabled?@"videoOn":@"videoMute" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
}

- (void)closeAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(close)]) {
        [self.delegate close];
    }
}

- (void)switchCameraAction
{
    [[YogaAgoraShared shared] switchCamera];
}

- (void)enableVideoAction
{
//    [[YogaAgoraShared shared] videoEnableDisable];
    if ([YogaAgoraShared shared].sender.videoEnabled) {
        int result = [[YogaAgoraShared shared].agoraKit enableLocalVideo:NO];
        if (result == 0) {
            [self.videoBtn setBackgroundImage:[UIImage imageNamed:@"videoMute" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        }
    }else {
        int result = [[YogaAgoraShared shared].agoraKit enableLocalVideo:YES];
        if (result == 0) {
            [self.videoBtn setBackgroundImage:[UIImage imageNamed:@"videoOn" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        }
    }
}

- (void)enableAudioAction
{
    [[YogaAgoraShared shared] audioEnableDisable];
}

#pragma mark -- Setter

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleL.text = title;
    CGSize size = [YogaAgoraUtil getSizeForString:title font:self.titleL.font];
    [self.titleV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width + 21));
    }];
}

- (void)setViewClean:(BOOL)viewClean
{
    _viewClean = viewClean;
    if (viewClean && self.videoBtn.superview) {
        [self.videoBtn removeFromSuperview];
    }
}

#pragma mark -- Getter

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
        [_activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@40);
            make.center.equalTo(@0);
        }];
    }
    return _activityIndicatorView;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(0, 0, 50, 50);
        _closeBtn.layer.cornerRadius = 5;
        _closeBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [_closeBtn setTitle:@"X" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)switchCameraBtn
{
    if (!_switchCameraBtn) {
        _switchCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchCameraBtn.frame = CGRectMake(0, 0, 50, 50);
        _switchCameraBtn.layer.cornerRadius = 5;
        _switchCameraBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [_switchCameraBtn setTitle:@"S" forState:UIControlStateNormal];
        [_switchCameraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _switchCameraBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_switchCameraBtn addTarget:self action:@selector(switchCameraAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCameraBtn;
}

- (UIButton *)videoBtn
{
    if (!_videoBtn) {
        _videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _videoBtn.frame = CGRectMake(0, 0, 40, 40);
        _videoBtn.layer.cornerRadius = 5;
//        _videoBtn.backgroundColor = [UIColor whiteColor];
//        [_videoBtn setTitle:@"V" forState:UIControlStateNormal];
//        [_videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _videoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_videoBtn addTarget:self action:@selector(enableVideoAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_videoBtn setBackgroundImage:[UIImage imageNamed:[YogaAgoraShared shared].sender.videoEnabled?@"videoOn":@"videoMute" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    }
    return _videoBtn;
}

- (UIButton *)audioBtn
{
    if (!_audioBtn) {
        _audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _audioBtn.frame = CGRectMake(0, 0, 50, 50);
        _audioBtn.layer.cornerRadius = 5;
        _audioBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [_audioBtn setTitle:@"A" forState:UIControlStateNormal];
        [_audioBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _audioBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_audioBtn addTarget:self action:@selector(enableAudioAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audioBtn;
}

- (UIView *)titleV
{
    if (!_titleV) {
        _titleV = [UIView new];
        _titleV.backgroundColor = [UIColor whiteColor];
    }
    return _titleV;
}

- (UILabel *)titleL
{
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.textColor = [UIColor blackColor];
        [self.titleV addSubview:_titleL];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(@10);
            make.right.equalTo(@(-10));
        }];
    }
    return _titleL;
}

@end
