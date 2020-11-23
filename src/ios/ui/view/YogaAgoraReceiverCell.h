
#import <UIKit/UIKit.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "YogaAgoraReceiverView.h"

@interface YogaAgoraReceiverCell : UICollectionViewCell<YogaAgoraReceiverViewDelegate, YogaAgoraReceiverViewDatasource>

@property (nonatomic, strong) NSNumber *uid;
@property (nonatomic, strong) AgoraRtcVideoCanvas *videoCanvas;
@property (nonatomic, assign) NSInteger index;

@end
