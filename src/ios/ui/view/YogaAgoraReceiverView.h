
#import <UIKit/UIKit.h>
@class YogaAgoraUserModel;

@protocol YogaAgoraReceiverViewDatasource <NSObject>

@required
- (UIView *)containerView;

@end

@protocol YogaAgoraReceiverViewDelegate <NSObject>

@required
- (void)close;

@end

@interface YogaAgoraReceiverView: UIView

- (instancetype)initWithDelegate:(id<YogaAgoraReceiverViewDelegate>)delegate datasource:(id<YogaAgoraReceiverViewDatasource>)datasource;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) YogaAgoraUserModel *model;
@property (nonatomic, assign) BOOL viewClean;// 整洁模式，视图上只存在标题一个ui控件，默认NO;

@end
