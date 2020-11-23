
#import <UIKit/UIKit.h>

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

@end
