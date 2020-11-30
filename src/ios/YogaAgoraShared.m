
#import "YogaAgoraShared.h"
#import "YogaAgoraUtil.h"

@interface YogaAgoraShared ()

@end

@implementation YogaAgoraShared

static YogaAgoraShared *_shared = nil;
static dispatch_once_t onceToken;

+ (void)destory
{
    [[NSNotificationCenter defaultCenter] removeObserver:[YogaAgoraShared shared]];
    onceToken = 0;
    _shared = nil;
}

+ (instancetype)shared
{
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (instancetype)init
{
    if (self = [super init]) {
        UIDevice *device = [UIDevice currentDevice]; //Get the device object
            [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationListener:) name:UIDeviceOrientationDidChangeNotification object:device];
    }
    return self;
}

- (void)deviceOrientationListener:(NSNotification *)n
{
    UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    switch (o) {
        case UIDeviceOrientationPortrait:
            NSLog(@"竖屏");
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"倒屏");
            break;
        case UIDeviceOrientationLandscapeLeft:
//            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
            NSLog(@"左屏");
            break;
        case UIDeviceOrientationLandscapeRight:
//            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            NSLog(@"右屏");
            break;
        default:
            break;
    }
    [[YogaAgoraShared shared].commandDelegate evalJs:[YogaAgoraUtil jsFuncFormat:[NSString stringWithFormat:@"DeviceOrientation(%ld)",o]]];
}

- (NSMutableDictionary *)commands
{
    if (!_commands) {
        _commands = [NSMutableDictionary dictionary];
    }
    return _commands;
}

@end
