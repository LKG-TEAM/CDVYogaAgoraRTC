#import "YogaAgoraSenderView.h"
#import "YogaAgoraShared.h"
#import <Masonry/Masonry.h>

@interface YogaAgoraSenderView ()

@property (nonatomic, weak) id<YogaAgoraSenderViewDelegate> delegate;
@property (nonatomic, weak) id<YogaAgoraSenderViewDatasource> datasource;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *switchCameraBtn;
@property (nonatomic, strong) UIButton *videoBtn;
@property (nonatomic, strong) UIButton *audioBtn;

@end

@implementation YogaAgoraSenderView

- (instancetype)initWithDelegate:(id<YogaAgoraSenderViewDelegate>)delegate datasource:(id<YogaAgoraSenderViewDatasource>)datasource
{
    if (self = [super init]) {
        self.backgroundColor = UIColor.lightGrayColor;
        self.delegate = delegate;
        self.datasource = datasource;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    [self.activityIndicatorView startAnimating];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.datasource && [self.datasource respondsToSelector:@selector(containerView)]) {
        if (self && self.superview) {
            [[self.datasource containerView] addSubview:self.switchCameraBtn];
            [self.switchCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@50);
                make.bottom.equalTo(self).offset(-50);
                make.left.equalTo(self).offset(20);
            }];
            [[self.datasource containerView] addSubview:self.videoBtn];
            [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@50);
                make.bottom.equalTo(self).offset(-50);
                make.left.equalTo(self.switchCameraBtn.mas_right).offset(10);
            }];
            [[self.datasource containerView] addSubview:self.audioBtn];
            [self.audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@50);
                make.bottom.equalTo(self).offset(-50);
                make.left.equalTo(self.videoBtn.mas_right).offset(10);
            }];
            [[self.datasource containerView] addSubview:self.closeBtn];
            [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@50);
                make.bottom.equalTo(self).offset(-50);
                make.right.equalTo(self).offset(-20);
            }];
        }
    }
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [self.switchCameraBtn removeFromSuperview];
    [self.videoBtn removeFromSuperview];
    [self.audioBtn removeFromSuperview];
    [self.closeBtn removeFromSuperview];
}

- (void)activityIndicatorViewStopAnimating
{
    [self.activityIndicatorView stopAnimating];
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
    [[YogaAgoraShared shared] videoEnableDisable];
}

- (void)enableAudioAction
{
    [[YogaAgoraShared shared] audioEnableDisable];
}

#pragma mark -- Getter

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
        [_activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@50);
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
        _videoBtn.frame = CGRectMake(0, 0, 50, 50);
        _videoBtn.layer.cornerRadius = 5;
        _videoBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [_videoBtn setTitle:@"V" forState:UIControlStateNormal];
        [_videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _videoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_videoBtn addTarget:self action:@selector(enableVideoAction) forControlEvents:UIControlEventTouchUpInside];
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

@end
