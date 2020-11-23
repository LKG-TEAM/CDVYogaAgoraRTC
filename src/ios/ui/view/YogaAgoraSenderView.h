
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

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL viewClean;// 整洁模式，视图上只存在标题一个ui控件，默认NO;

@end
