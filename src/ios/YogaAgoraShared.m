
#import "YogaAgoraShared.h"
#import <Masonry/Masonry.h>
#import "YogaAgoraSenderView.h"
#import "YogaAgoraReceiverView.h"
#import "YogaAgoraUtil.h"

@interface YogaAgoraShared ()<AgoraRtcEngineDelegate>

@end

@implementation YogaAgoraShared

static YogaAgoraShared *_shared = nil;
static dispatch_once_t onceToken;

+ (void)destory
{
    [[NSNotificationCenter defaultCenter] removeObserver:[YogaAgoraShared shared]];
    onceToken = 0;
    _shared = nil;
}

+ (instancetype)shared
{
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (instancetype)init
{
    if (self = [super init]) {
        UIDevice *device = [UIDevice currentDevice]; //Get the device object
            [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationListener:) name:UIDeviceOrientationDidChangeNotification object:device];
        _mainColor = [YogaAgoraUtil yoga_colorWithHexString:YogaColorMain alpha:1.0];
        _mainBgColor = [YogaAgoraUtil yoga_colorWithHexString:YogaColorMainBg alpha:1.0];
        _mainDisableColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)deviceOrientationListener:(NSNotification *)n
{
    UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    switch (o) {
        case UIDeviceOrientationPortrait:
            NSLog(@"竖屏");
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"倒屏");
            break;
        case UIDeviceOrientationLandscapeLeft:
//            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
            NSLog(@"左屏");
            break;
        case UIDeviceOrientationLandscapeRight:
//            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            NSLog(@"右屏");
            break;
        default:
            break;
    }
    [[YogaAgoraShared shared].commandDelegate evalJs:[YogaAgoraUtil jsFuncFormat:[NSString stringWithFormat:@"DeviceOrientation(%ld)",o]]];
}

#pragma mark -- Public method

- (UIViewController *)topViewController
{
    if ([YogaAgoraShared shared].viewController) {
        return [YogaAgoraShared shared].viewController;
    }
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)]) {
        return [app.delegate window].rootViewController;
    }
    return [app keyWindow].rootViewController;
}

- (void)setupAgora
{
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:self.appId delegate:self];
    // Step 2, set live broadcasting mode
    // for details: https://docs.agora.io/cn/Video/API%20Reference/oc/Classes/AgoraRtcEngineKit.html#//api/name/setChannelProfile:
    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    // set client role
    [self.agoraKit setClientRole:self.isBroadcaster?AgoraClientRoleBroadcaster:AgoraClientRoleAudience];
    // Step 3, Warning: only enable dual stream mode if there will be more than one broadcaster in the channel
    [self.agoraKit enableDualStreamMode:YES];
    // Step 4, enable the video module
    [self.agoraKit enableVideo];
    [self.agoraKit enableLocalVideo:YES];
    [self.agoraKit enableLocalAudio:YES];
    // set video configuration
    AgoraVideoEncoderConfiguration *configuration = [[AgoraVideoEncoderConfiguration alloc] initWithSize:[YogaAgoraShared shared].sender.videoDimension frameRate:[YogaAgoraShared shared].sender.videoFrameRate bitrate:AgoraVideoBitrateStandard orientationMode:AgoraVideoOutputOrientationModeAdaptative];
    [self.agoraKit setVideoEncoderConfiguration:configuration];
    [self setupAgoraParameters];
    
    if (self.isBroadcaster) {
        NSLog(@"[YogaAgoraShared shared].uid: %@",[YogaAgoraShared shared].uid);
        AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        videoCanvas.uid = [[YogaAgoraShared shared].uid intValue];
        [self.sender addSenderView];
        videoCanvas.view = self.sender.senderView;
        videoCanvas.renderMode = AgoraVideoRenderModeHidden;
        // 设置本地视图。
        [self.agoraKit setupLocalVideo:videoCanvas];
        [self.agoraKit startPreview];
    }
    
    // Step 5, join channel and start group chat
    // If join  channel success, agoraKit triggers it's delegate function
    // 'rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int)'
    [self.agoraKit joinChannelByToken:self.token channelId:self.channelId info:nil uid:[[YogaAgoraShared shared].uid intValue] joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        NSLog(@"进入视频道成功");
    }];
    
    // Step 6, set speaker audio route
    [self.agoraKit setEnableSpeakerphone:YES];
}

- (void)setupAgoraParameters
{
    [self.agoraKit setParameters:@"{\"che.audio.live_for_comm\": true}"];
}

- (void)clean
{
    [YogaAgoraShared shared].yogaBlockFirstLocalVideo = nil;
}

- (void)launchVideoViewIsBroadcaster:(BOOL)isBroadcaster
{
    self.isBroadcaster = isBroadcaster;
    if (isBroadcaster) {
        [[YogaAgoraShared shared].sender senderViewRemakeConstraints];
    }else {
        [[YogaAgoraShared shared].receiver addReceiverView];
        [[YogaAgoraShared shared].receiver receiverViewRemakeConstraints];
    }
    
    [self setupAgora];
}

- (void)leave
{
    [self.agoraKit setupLocalVideo:nil];
    // 离开频道。
    [self.agoraKit leaveChannel:nil];
    if (self.isBroadcaster) {
        [self.agoraKit stopPreview];
    }
//    [AgoraRtcEngineKit destroy];
}

- (void)switchCamera
{
    [self.agoraKit switchCamera];
}

- (void)videoEnableDisable
{
    if (self.sender.videoEnabled) {
        [self.agoraKit enableLocalVideo:NO];
    }else {
        [self.agoraKit enableLocalVideo:YES];
    }
}

- (void)audioEnableDisable
{
    if (self.sender.audioEnabled) {
        [self.agoraKit enableLocalAudio:NO];
    }else {
        [self.agoraKit enableLocalAudio:YES];
    }
}

- (int)muteRemoteVideoStream:(NSUInteger)uid mute:(BOOL)mute
{
    return [self.agoraKit muteRemoteVideoStream:uid mute:mute];
}

- (int)muteRemoteAudioStream:(NSUInteger)uid mute:(BOOL)mute
{
    return [self.agoraKit muteRemoteAudioStream:uid mute:mute];
}

- (int)muteAllRemoteVideoStreams:(BOOL)mute
{
    return [self.agoraKit muteAllRemoteVideoStreams:mute];
}

- (int)muteAllRemoteAudioStreams:(BOOL)mute
{
    return [self.agoraKit muteAllRemoteAudioStreams:mute];
}

- (int)muteLocalVideo:(BOOL)mute
{
    return [self.agoraKit enableLocalVideo:!mute];
}

- (int)muteLocalAudio:(BOOL)mute
{
    return [self.agoraKit enableLocalAudio:!mute];
}

- (void)setCollectionViewScrollDirection:(BOOL)isHorizontal
{
    self.receiver.isHorizontal = isHorizontal;
}

- (void)setCollectionViewItemSize:(CGSize)itemSize
{
    self.receiver.itemSize = itemSize;
}

- (int)setClientRole:(BOOL)isBroadcaster
{
    return [self.agoraKit setClientRole:isBroadcaster?AgoraClientRoleBroadcaster:AgoraClientRoleAudience];
}

- (AgoraConnectionStateType)getConnectionState
{
    return [self.agoraKit getConnectionState];
}

- (int)enableDualStream
{
    return [self.agoraKit enableDualStreamMode:YES];
}

- (int)stopAudioMixing
{
    return [self.agoraKit stopAudioMixing];
}

- (int)startAudioMixing:(NSString *_Nonnull)filePath loopback:(BOOL)loopback replace:(BOOL)replace cycle:(NSInteger)cycle
{
    return [self.agoraKit startAudioMixing:filePath loopback:loopback replace:replace cycle:cycle];
}

- (int)pauseAudioMixing
{
    return [self.agoraKit pauseAudioMixing];
}

- (int)resumeAudioMixing
{
    return [self.agoraKit resumeAudioMixing];
}

- (int)adjustAudioMixingVolume:(NSInteger)volume
{
    return [self.agoraKit adjustAudioMixingVolume:volume];
}

- (int)getAudioMixingCurrentPosition
{
    return [self.agoraKit getAudioMixingCurrentPosition];
}

- (int)getAudioMixingDuration
{
    return [self.agoraKit getAudioMixingDuration];
}

- (NSString *)getCallId
{
    return [self.agoraKit getCallId];
}

- (int)setRemoteVideoStream:(NSUInteger)uid
                       type:(AgoraVideoStreamType)streamType
{
    return [self.agoraKit setRemoteVideoStream:uid type:streamType];
}

- (int)setVideoProfile
{
    AgoraVideoEncoderConfiguration *configuration = [[AgoraVideoEncoderConfiguration alloc] initWithSize:[YogaAgoraShared shared].sender.videoDimension frameRate:[YogaAgoraShared shared].sender.videoFrameRate bitrate:AgoraVideoBitrateStandard orientationMode:AgoraVideoOutputOrientationModeAdaptative];
    return [self.agoraKit setVideoEncoderConfiguration:configuration];
}

#pragma mark -- Getter

- (YogaAgoraSender *)sender
{
    if (!_sender) {
        _sender = [[YogaAgoraSender alloc] init];
    }
    return _sender;
}

- (YogaAgoraReceiver *)receiver
{
    if (!_receiver) {
        _receiver = [[YogaAgoraReceiver alloc] init];
    }
    return _receiver;
}

- (NSMutableDictionary *)commands
{
    if (!_commands) {
        _commands = [NSMutableDictionary dictionary];
    }
    return _commands;
}

#pragma mark -- CDVScreenOrientationDelegate

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationMaskPortrait;
}

#pragma mark -- AgoraRtcEngineDelegate

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalAudioFrame:(NSInteger)elapsed
{
    NSLog(@"%s",__func__);
    [[YogaAgoraShared shared].sender senderViewRemakeConstraints];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine localVideoStateChange:(AgoraLocalVideoStreamState)state error:(AgoraLocalVideoStreamError)error
{
    NSLog(@"%s",__func__);
    NSLog(@"%ld",state);
    BOOL enabled = YES;
    switch (state) {
        case AgoraLocalVideoStreamStateStopped:
            enabled = NO;
            break;
        case AgoraLocalVideoStreamStateCapturing:
            [[YogaAgoraShared shared].sender.senderView activityIndicatorViewStopAnimating];
            break;
        case AgoraLocalVideoStreamStateEncoding:
            [[YogaAgoraShared shared].sender.senderView activityIndicatorViewStopAnimating];
            break;
        case AgoraLocalVideoStreamStateFailed:
            enabled = NO;
            break;
        default:
            break;
    }
    [[YogaAgoraShared shared].commandDelegate evalJs:[YogaAgoraUtil jsFuncFormat:[NSString stringWithFormat:@"Video(%ld)",state]]];
    NSLog(@"我自己的视频%@",enabled?@"启用了":@"关闭了");
    [YogaAgoraShared shared].sender.videoEnabled = enabled;
    
    [YogaAgoraUtil commandCallback:@"localVideoStateChange" data:@{@"state":[NSNumber numberWithInteger:state], @"reason":[NSNumber numberWithInteger:error]}];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine localAudioStateChange:(AgoraAudioLocalState)state error:(AgoraAudioLocalError)error
{
    NSLog(@"%s",__func__);
    NSLog(@"%ld",state);
    BOOL enabled = YES;
    switch (state) {
        case AgoraAudioLocalStateStopped:
            enabled = NO;
            break;
        case AgoraAudioLocalStateRecording:
            break;
        case AgoraAudioLocalStateEncoding:
            break;
        case AgoraAudioLocalStateFailed:
            enabled = NO;
            break;
        default:
            break;
    }
    [[YogaAgoraShared shared].commandDelegate evalJs:[YogaAgoraUtil jsFuncFormat:[NSString stringWithFormat:@"Audio(%ld)",state]]];
    NSLog(@"我自己的音频%@",enabled?@"启用了":@"关闭了");
    [YogaAgoraShared shared].sender.audioEnabled = enabled;
    
    [YogaAgoraUtil commandCallback:@"localAudioStateChange" data:@{@"state":[NSNumber numberWithInteger:state], @"reason":[NSNumber numberWithInteger:error]}];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine remoteVideoStateChangedOfUid:(NSUInteger)uid state:(AgoraVideoRemoteState)state reason:(AgoraVideoRemoteStateReason)reason elapsed:(NSInteger)elapsed
{
    NSLog(@"%s",__func__);
    NSLog(@"%ld",state);
    BOOL enabled = YES;
    switch (state) {
        case AgoraVideoRemoteStateStopped:
            enabled = NO;
            break;
        case AgoraVideoRemoteStateStarting:
            break;
        case AgoraVideoRemoteStateDecoding:
            break;
        case AgoraVideoRemoteStateFrozen:
            enabled = NO;
            break;
        case AgoraVideoRemoteStateFailed:
            enabled = NO;
            break;
        default:
            break;
    }
    [[YogaAgoraShared shared].commandDelegate evalJs:[YogaAgoraUtil jsFuncFormat:[NSString stringWithFormat:@"RemoteVideo(%ld,%ld)",uid,state]]];
    NSLog(@"[%ld]的视频%@",uid,enabled?@"启用了":@"关闭了");
    [YogaAgoraShared shared].receiver.videoEnabled = enabled;
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine remoteAudioStateChangedOfUid:(NSUInteger)uid state:(AgoraAudioRemoteState)state reason:(AgoraAudioRemoteStateReason)reason elapsed:(NSInteger)elapsed
{
    NSLog(@"%s",__func__);
    NSLog(@"%ld",state);
    BOOL enabled = YES;
    switch (state) {
        case AgoraAudioRemoteStateStopped:
            enabled = NO;
            break;
        case AgoraAudioRemoteStateStarting:
            break;
        case AgoraAudioRemoteStateDecoding:
            break;
        case AgoraAudioRemoteStateFrozen:// 卡住了
            enabled = NO;
            break;
        case AgoraAudioRemoteStateFailed:
            enabled = NO;
            break;
        default:
            break;
    }
    [[YogaAgoraShared shared].commandDelegate evalJs:[YogaAgoraUtil jsFuncFormat:[NSString stringWithFormat:@"RemoteAudio(%ld,%ld)",uid,state]]];
    NSLog(@"%ld的音频%@",uid,enabled?@"启用了":@"关闭了");
    [YogaAgoraShared shared].receiver.audioEnabled = enabled;
}

/*****/
// rtc.client.on("onTokenPrivilegeWillExpire")
- (void)rtcEngine:(AgoraRtcEngineKit *)engine tokenPrivilegeWillExpire:(NSString * _Nonnull)token
{
    NSLog(@"%s",__func__);
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setValue:token?:@"" forKey:@"token"];
    [YogaAgoraUtil commandCallback:YAEOnTokenPrivilegeWillExpire data:[data copy]];
}

// rtc.client.on("peer-leave")
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason
{
    NSLog(@"%s",__func__);
    NSLog(@"uid: %ld",uid);
    [[YogaAgoraShared shared].receiver.receiverView removeUid:uid];
    [[YogaAgoraShared shared].commandDelegate evalJs:[YogaAgoraUtil jsFuncFormat:[NSString stringWithFormat:@"DidOfflineOfUidAndReason(%ld,%ld)",uid,reason]]];
    
    NSMutableDictionary *evt = [NSMutableDictionary dictionary];
    [evt setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [evt setObject:[NSNumber numberWithInteger:reason] forKey:@"reason"];
    [YogaAgoraUtil commandCallback:YAEPeerLeave data:[evt copy]];
}

// rtc.client.on("stream-added")
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    NSLog(@"%s",__func__);
    NSLog(@"uid: %ld",uid);
    [[YogaAgoraShared shared].commandDelegate evalJs:[YogaAgoraUtil jsFuncFormat:[NSString stringWithFormat:@"DidJoinedOfUidAndElapsed(%ld,%ld)",uid,elapsed]]];
    
    NSMutableDictionary *evt = [NSMutableDictionary dictionary];
    [evt setObject:[NSNumber numberWithInteger:uid] forKey:@"uid"];
    [evt setObject:[NSNumber numberWithInteger:elapsed] forKey:@"elapsed"];
    [YogaAgoraUtil commandCallback:YAEStreamAdded data:[evt copy]];
}

// rtc.client.on("connection-state-change")
- (void)rtcEngine:(AgoraRtcEngineKit *)engine connectionChangedToState:(AgoraConnectionStateType)state reason:(AgoraConnectionChangedReason)reason
{
    NSLog(@"%s",__func__);
    NSMutableDictionary *evt = [NSMutableDictionary dictionary];
    [evt setObject:[NSNumber numberWithInteger:state] forKey:@"state"];
    [evt setObject:[NSNumber numberWithInteger:reason] forKey:@"reason"];
    [YogaAgoraUtil commandCallback:YAEConnectionStateChang data:[evt copy]];
}
/*****/

@end
