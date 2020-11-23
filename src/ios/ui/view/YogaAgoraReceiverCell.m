
#import "YogaAgoraReceiverCell.h"
#import <Masonry/Masonry.h>
#import "YogaAgoraShared.h"
#import "YogaAgoraUserModel.h"

@interface YogaAgoraReceiverCell ()

@property (nonatomic, strong) YogaAgoraReceiverView *receiverView;

@end

@implementation YogaAgoraReceiverCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.backgroundColor = self.contentView.backgroundColor = [YogaAgoraShared shared].mainBgColor;
    
    self.receiverView = [[YogaAgoraReceiverView alloc] initWithDelegate:self datasource:self];
    self.receiverView.backgroundColor = [YogaAgoraShared shared].mainBgColor;
    [self.contentView addSubview:self.receiverView];
    [self.receiverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@(UIEdgeInsetsMake(5, 5, 5, 5)));
    }];
    
    self.videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    self.videoCanvas.view = self.receiverView;
    self.videoCanvas.renderMode = AgoraVideoRenderModeHidden;
}

#pragma mark -- YogaAgoraReceiverViewDatasource

- (UIView *)containerView
{
    return self.contentView;
}

#pragma mark -- YogaAgoraReceiverViewDelegate

- (void)close
{
    
}

#pragma mark -- Setter

- (void)setModel:(YogaAgoraUserModel *)model
{
    _model = model;
    self.receiverView.index = self.index;
    self.receiverView.model = model;
    self.receiverView.viewClean = self.viewClean;
    self.videoCanvas.uid = model.uid;
    [[YogaAgoraShared shared].agoraKit setupRemoteVideo:self.videoCanvas];
}

@end
