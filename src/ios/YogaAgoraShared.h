
#import <UIKit/UIKit.h>
#import <Cordova/CDV.h>


@interface YogaAgoraShared : NSObject

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) id <CDVCommandDelegate> commandDelegate;

+ (instancetype)shared;
+ (void)destory;

@property (nonatomic, strong) NSMutableDictionary *commands;

- (UIWindow *)window;

@end
