

#import <UIKit/UIKit.h>
#import "YogaAgoraReceiverCollectionView.h"

@interface YogaAgoraReceiver : NSObject

@property (nonatomic, strong) YogaAgoraReceiverCollectionView *receiverView;//
@property (nonatomic, assign) UIEdgeInsets margin;
@property (nonatomic, assign) CGFloat marginTop;
@property (nonatomic, assign) CGFloat marginLeft;
@property (nonatomic, assign) CGFloat marginBottom;
@property (nonatomic, assign) CGFloat marginRight;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

- (void)addReceiverView;
- (void)receiverViewRemakeConstraints;
- (void)addUid:(NSUInteger)uid title:(NSString *)title;

@property (nonatomic, assign) BOOL isHorizontal;// 横向排列，默认NO
@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) BOOL videoEnabled;// 别人的视频开启关闭状态，默认开启
@property (nonatomic, assign) BOOL audioEnabled;// 别人的音频开启关闭状态，默认开启
@property (nonatomic, assign) BOOL viewClean;// 整洁模式，视图上只存在标题一个ui控件，默认NO

@end
