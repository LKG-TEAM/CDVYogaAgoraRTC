
#import <UIKit/UIKit.h>

@protocol YogaAgoraSenderViewDatasource <NSObject>

@required
- (UIView *)containerView;

@end

@protocol YogaAgoraSenderViewDelegate <NSObject>

@required
- (void)close;

@end

@interface YogaAgoraSenderView: UIView

- (instancetype)initWithDelegate:(id<YogaAgoraSenderViewDelegate>)delegate datasource:(id<YogaAgoraSenderViewDatasource>)datasource;
- (void)activityIndicatorViewStopAnimating;

@end
