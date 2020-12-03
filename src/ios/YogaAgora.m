/********* YogaAgora.m Cordova Plugin Implementation *******/

#import <SafariServices/SafariServices.h>
#import <Cordova/CDV.h>
#import "YogaAgoraShared.h"
#import "YogaAgoraUtil.h"
#import "YogaAgoraViewController.h"

@interface YogaAgora : CDVPlugin {}

@property (nonatomic, assign) NSInteger uiSetFlag;// 1->设置发送端的ui，2->设置接收端的ui
@property (nonatomic, strong) SFSafariViewController *safariVC;
@property (nonatomic, strong) UIView *overView;
@property (nonatomic, strong) YogaAgoraViewController *yogaAgoraViewController;

@end

@implementation YogaAgora

- (void)pluginInitialize
{
    [super pluginInitialize];
    
    UIDevice *device = [UIDevice currentDevice]; //Get the device object
        [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationListener:) name:UIDeviceOrientationDidChangeNotification object:device];
    
    [YogaAgoraShared shared].viewController = self.viewController;
    [YogaAgoraShared shared].commandDelegate = self.commandDelegate;
    self.yogaAgoraViewController = [[YogaAgoraViewController alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openURL:) name:CDVPluginHandleOpenURLNotification object:nil];
}

- (void)deviceOrientationListener:(NSNotification *)n
{
    UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    [[YogaAgoraShared shared].commandDelegate evalJs:[YogaAgoraUtil jsFuncFormat:[NSString stringWithFormat:@"DeviceOrientation(%ld)",o]]];
    
    [self safariFrameRefresh];
}

- (void)openURL:(NSNotification *)n
{
    NSURL *url = [n object];
    NSLog(@"[%s]url: %@",__func__, url);
    NSString *a = [[url absoluteString] lowercaseString];
    NSString *path = [a stringByReplacingOccurrencesOfString:@"zipyoga://" withString:@""];
    if ([path isEqualToString:@"back"]) {
        [self safariBack];
    }
}

/************************************* Agroa 事件回调 ****************************************/
- (void)on:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][on:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    [self.commandDelegate runInBackground:^{
        if (command.arguments.count == 1) {
            NSString *firstArgument = command.arguments[0];
            if (![firstArgument isKindOfClass:NSNull.class] && firstArgument.length > 0) {
                [[YogaAgoraShared shared].commands setObject:command forKey:firstArgument];
            }
        }
    }];
    
    NSLog(@">>>>>>>>>>>>>>>>[end][on:]");
}
/************************************* Agroa 事件回调 ****************************************/

/************************************* Util ****************************************/
- (void)NSLog:(CDVInvokedUrlCommand*)command
{
//    NSLog(@">>>>>>>>>>>>>>>>[start][NSLog:]");
//    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    if (command.arguments.count == 1) {
        NSString *firstArgument = command.arguments[0];
        NSLog(@"[CDVYogaAgoraRTC]NSLog: %@",firstArgument);
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    NSLog(@">>>>>>>>>>>>>>>>[end][NSLog:]");
}

- (void)safari:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][safari:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (command.arguments.count == 1) {
                NSString *firstArgument = command.arguments[0];
                NSURL *url = nil;
                if ([firstArgument hasPrefix:@"http://"] || [firstArgument hasPrefix:@"https://"]) {
                    url = [NSURL URLWithString:firstArgument];
                }else {
                    url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:firstArgument ofType:@""]];
                }
                self.safariVC = [[SFSafariViewController alloc] initWithURL:url];
                self.safariVC.modalPresentationStyle = UIModalPresentationFullScreen;
                self.safariVC.delegate = self.yogaAgoraViewController;
                self.safariVC.transitioningDelegate = self.yogaAgoraViewController; ///禁用侧滑
                
                [self.viewController presentViewController:self.safariVC animated:NO completion:^{
                    [self safariFrameRefresh];
                }];
            }
        });
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    NSLog(@">>>>>>>>>>>>>>>>[end][safari:]");
}

- (void)dismiss:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][safari:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    [self safariBack];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    NSLog(@">>>>>>>>>>>>>>>>[end][safari:]");
}

- (void)share:(CDVInvokedUrlCommand*)command
{
    NSLog(@">>>>>>>>>>>>>>>>[start][share:]");
    NSLog(@">>>>>>>>>>>>>>>>command.arguments: %@", command.arguments);
    
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:command.arguments applicationActivities:nil];
            UIViewController *currentVC = self.safariVC;
            if (!currentVC) {
                currentVC = self.viewController;
            }
            [currentVC presentViewController:avc animated:YES completion:^{
            }];
        });
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
    NSLog(@">>>>>>>>>>>>>>>>[end][share:]");
}
/************************************* Util ****************************************/

- (void)safariFrameRefresh
{
    UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    switch (o) {
        case UIDeviceOrientationPortrait:
            NSLog(@"竖屏");
            [self safariFrameV];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"倒屏");
//            [self safariFrameV];
            break;
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"左屏");
            [self safariFrameH];
            break;
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"右屏");
            [self safariFrameH];
            break;
        default:
            break;
    }
}

- (void)safariFrameV
{
    [self addOverView];
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    CGRect frame = self.safariVC.view.frame;
    CGFloat OffsetY = 44;
    
    if (@available(iOS 11.0, *)) {
        if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0) {// 刘海屏
            frame.origin = CGPointMake(0, 0);
            frame.size = CGSizeMake(screenSize.width, screenSize.height + OffsetY);
        }else {
            frame.origin = CGPointMake(0, -OffsetY);
            frame.size = CGSizeMake(screenSize.width, screenSize.height + OffsetY*2);
        }
    }else {
        frame.origin = CGPointMake(0, -OffsetY);
        frame.size = CGSizeMake(screenSize.width, screenSize.height + OffsetY*2);
    }
    
    self.safariVC.view.frame = frame;
}

- (void)safariFrameH
{
    [self removeOverView];
    CGSize screenSize = UIScreen.mainScreen.bounds.size;
    CGRect frame = self.safariVC.view.frame;
    CGFloat OffsetY = 44;
    
    frame.origin = CGPointMake(0, -OffsetY);
    frame.size = CGSizeMake(screenSize.width, screenSize.height + OffsetY);
    
    self.safariVC.view.frame = frame;
}

- (void)addOverView
{
    _overView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIApplication.sharedApplication.statusBarFrame.size.height)];
    [_overView setBackgroundColor:UIColor.whiteColor];
    [[YogaAgoraShared shared].window addSubview:_overView];
    [YogaAgoraShared shared].window.backgroundColor = [UIColor whiteColor];
}

- (void)removeOverView
{
    if (self.overView && self.overView.superview) {
        [self.overView removeFromSuperview];
        self.overView = nil;
    }
}

- (void)safariBack
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.safariVC) {
            [self.safariVC dismissViewControllerAnimated:YES completion:^{
                [self removeOverView];
                [YogaAgoraUtil commandCallback:YAESafariBack data:nil];
            }];
        }
    });
}

@end
