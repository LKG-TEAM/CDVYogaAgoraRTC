

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
- (void)addUid:(NSUInteger)uid;

@property (nonatomic, assign) BOOL isHorizontal;// 横向排列，默认NO
@property (nonatomic, assign) CGSize itemSize;

@end
