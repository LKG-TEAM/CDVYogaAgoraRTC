
#import <UIKit/UIKit.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "YogaAgoraSender.h"
#import "YogaAgoraReceiver.h"
#import <Cordova/CDV.h>

typedef void(^YogaBlock_rtcEngine_firstLocalVideo)(CGSize size, NSInteger elapsed);

@interface YogaAgoraShared : NSObject

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) id <CDVCommandDelegate> commandDelegate;

+ (instancetype)shared;
+ (void)destory;

@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;

- (UIViewController *)topViewController;
- (void)setupAgora;
- (void)clean;
- (void)launchVideoViewIsBroadcaster:(BOOL)isBroadcaster;
- (NSString *)jsFuncFormat:(NSString *)str;

/*********************************** 硬件控制声网api ****************************************/
- (void)leave;
- (void)switchCamera;
- (void)videoEnableDisable;
- (void)audioEnableDisable;
- (int)muteRemoteVideoStream:(NSUInteger)uid mute:(BOOL)mute;
- (int)muteRemoteAudioStream:(NSUInteger)uid mute:(BOOL)mute;
- (int)muteAllRemoteVideoStreams:(BOOL)mute;
- (int)muteAllRemoteAudioStreams:(BOOL)mute;
- (int)muteLocalVideo:(BOOL)mute;
- (int)muteLocalAudio:(BOOL)mute;
/*********************************** 硬件控制声网api ****************************************/

- (void)setCollectionViewScrollDirection:(BOOL)isHorizontal;
- (void)setCollectionViewItemSize:(CGSize)itemSize;

@property (nonatomic, assign) BOOL isBroadcaster;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSString *uid;
//@property (nonatomic, strong) NSString *teacherUid;
@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, strong) UIColor *mainBgColor;
@property (nonatomic, strong) UIColor *mainDisableColor;

@property (nonatomic, copy) YogaBlock_rtcEngine_firstLocalVideo yogaBlockFirstLocalVideo;

@property (nonatomic, strong) YogaAgoraSender *sender;
@property (nonatomic, strong) YogaAgoraReceiver *receiver;


@end
