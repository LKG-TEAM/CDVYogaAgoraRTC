
#import "YogaAgoraReceiverCell.h"
#import <Masonry/Masonry.h>
#import "YogaAgoraShared.h"

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
    self.backgroundColor = self.contentView.backgroundColor = [UIColor grayColor];
    
    self.receiverView = [[YogaAgoraReceiverView alloc] initWithDelegate:self datasource:self];
    self.receiverView.backgroundColor = [UIColor lightGrayColor];
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

- (void)setUid:(NSNumber *)uid
{
    _uid = uid;
    self.receiverView.index = self.index;
    NSLog(@">>>>>>>>>uid: %@",uid);
    self.videoCanvas.uid = [uid intValue];
    [[YogaAgoraShared shared].agoraKit setupRemoteVideo:self.videoCanvas];
}

@end
