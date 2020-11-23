
#import <UIKit/UIKit.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "YogaAgoraReceiverView.h"
@class YogaAgoraUserModel;

@interface YogaAgoraReceiverCell : UICollectionViewCell<YogaAgoraReceiverViewDelegate, YogaAgoraReceiverViewDatasource>

@property (nonatomic, strong) YogaAgoraUserModel *model;
@property (nonatomic, strong) AgoraRtcVideoCanvas *videoCanvas;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL viewClean;// 整洁模式，视图上只存在标题一个ui控件，默认NO;

@end
