
#import <UIKit/UIKit.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "YogaAgoraSenderView.h"

@interface YogaAgoraSender : NSObject

@property (nonatomic, assign) AgoraVideoFrameRate videoFrameRate;
@property (nonatomic, assign) CGSize videoDimension;

@property (nonatomic, strong) YogaAgoraSenderView *senderView;// 老师的view
@property (nonatomic, assign) UIEdgeInsets margin;
@property (nonatomic, assign) CGFloat marginTop;
@property (nonatomic, assign) CGFloat marginLeft;
@property (nonatomic, assign) CGFloat marginBottom;
@property (nonatomic, assign) CGFloat marginRight;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL videoEnabled;// 自己的视频开启关闭状态，默认开启
@property (nonatomic, assign) BOOL audioEnabled;// 自己的音频开启关闭状态，默认开启
@property (nonatomic, assign) BOOL viewClean;// 整洁模式，视图上只存在标题一个ui控件，默认NO

- (void)addSenderView;
- (void)senderViewRemakeConstraints;

@end
