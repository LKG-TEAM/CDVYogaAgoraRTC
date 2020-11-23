#import "YogaAgoraReceiverView.h"
#import <Masonry/Masonry.h>
#import "YogaAgoraUtil.h"
#import "YogaAgoraShared.h"
#import "YogaAgoraUserModel.h"

@interface YogaAgoraReceiverView ()

@property (nonatomic, weak) id<YogaAgoraReceiverViewDelegate> delegate;
@property (nonatomic, weak) id<YogaAgoraReceiverViewDatasource> datasource;
@property (nonatomic, strong) UIView *titleV;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *indexL;
@property (nonatomic, strong) UIButton *audioBtn;

@end

@implementation YogaAgoraReceiverView

- (instancetype)initWithDelegate:(id<YogaAgoraReceiverViewDelegate>)delegate datasource:(id<YogaAgoraReceiverViewDatasource>)datasource
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
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.datasource && [self.datasource respondsToSelector:@selector(containerView)]) {
        if (self && self.superview) {
//            [[self.datasource containerView] addSubview:self.closeBtn];
//            [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.height.equalTo(@50);
//                make.bottom.equalTo(self).offset(-50);
//                make.right.equalTo(self).offset(-20);
//            }];
            
#if DEBUG
//            [[self.datasource containerView] addSubview:self.indexL];
//            [self.indexL mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(@(UIEdgeInsetsZero));
//            }];
#endif
            if (!_viewClean) {
                [[self.datasource containerView] addSubview:self.audioBtn];
                [self.audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.equalTo(@40);
                    make.bottom.equalTo(self).offset(-2);
                    make.left.equalTo(self).offset(2);
                }];
            }
            [[self.datasource containerView] addSubview:self.titleV];
            [self.titleV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self);
                make.height.equalTo(@25);
                make.width.equalTo(@0);
            }];
        }
    }
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [self.titleV removeFromSuperview];
    [self.audioBtn removeFromSuperview];
}

- (void)closeAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(close)]) {
        [self.delegate close];
    }
}

- (void)enableAudioAction
{
    if ([YogaAgoraShared shared].receiver.audioEnabled) {
        int result = [[YogaAgoraShared shared] muteRemoteAudioStream:self.model.uid mute:YES];
        if (result == 0) {
            [self.audioBtn setImage:[UIImage imageNamed:@"voiceMute" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            self.audioBtn.backgroundColor = [YogaAgoraShared shared].mainBgColor;
            self.audioBtn.layer.borderColor = [YogaAgoraShared shared].mainDisableColor.CGColor;
        }
    }else {
        int result = [[YogaAgoraShared shared] muteRemoteAudioStream:self.model.uid mute:NO];
        if (result == 0) {
            [self.audioBtn setImage:[UIImage imageNamed:@"voiceOn" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
            self.audioBtn.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.80];
            self.audioBtn.layer.borderColor = [YogaAgoraShared shared].mainColor.CGColor;
        }
    }
}

#pragma mark -- Setter

- (void)setIndex:(NSInteger)index
{
    _index = index;
    self.indexL.text = [NSString stringWithFormat:@"%ld",self.index];
}

- (void)setModel:(YogaAgoraUserModel *)model
{
    _model = model;
    self.titleL.text = model.title;
    CGSize size = [YogaAgoraUtil getSizeForString:self.titleL.text font:self.titleL.font];
    [self.titleV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width + 21));
    }];
}

- (void)setViewClean:(BOOL)viewClean
{
    _viewClean = viewClean;
    if (viewClean && self.audioBtn.superview) {
        [self.audioBtn removeFromSuperview];
    }
}

#pragma mark -- Getter

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

- (UILabel *)indexL
{
    if (!_indexL) {
        _indexL = [UILabel new];
        _indexL.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _indexL.textColor = [UIColor whiteColor];
        _indexL.textAlignment = NSTextAlignmentCenter;
    }
    return _indexL;
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

- (UIButton *)audioBtn
{
    if (!_audioBtn) {
        _audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _audioBtn.frame = CGRectMake(0, 0, 40, 40);
        _audioBtn.layer.cornerRadius = 5;
        _audioBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_audioBtn addTarget:self action:@selector(enableAudioAction) forControlEvents:UIControlEventTouchUpInside];
        
        _audioBtn.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.80];
        _audioBtn.layer.cornerRadius = 20;
        _audioBtn.layer.borderWidth = 1;
        _audioBtn.layer.borderColor = [YogaAgoraShared shared].mainColor.CGColor;
        [_audioBtn setImage:[UIImage imageNamed:@"voiceOn" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        _audioBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    }
    return _audioBtn;
}

@end
