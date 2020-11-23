
#import <UIKit/UIKit.h>

@protocol YogaAgoraReceiverCollectionViewDatasource <NSObject>

@required
- (UIView *)containerView;

@end

@protocol YogaAgoraReceiverCollectionViewDelegate <NSObject>

@required
- (void)close;

@end

@interface YogaAgoraReceiverCollectionView: UIView

- (instancetype)initWithDelegate:(id<YogaAgoraReceiverCollectionViewDelegate>)delegate datasource:(id<YogaAgoraReceiverCollectionViewDatasource>)datasource;

- (void)addUid:(NSUInteger)uid title:(NSString *)title;
- (void)removeUid:(NSUInteger)uid;

@property (nonatomic, assign) BOOL isHorizontal;// 横向排列，默认NO
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) BOOL viewClean;// 整洁模式，视图上只存在标题一个ui控件，默认NO;

@end
