
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
    }
    return self;
}

- (NSMutableDictionary *)commands
{
    if (!_commands) {
        _commands = [NSMutableDictionary dictionary];
    }
    return _commands;
}

- (UIWindow *)window
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)]) {
        return [app.delegate window];
    }
    return [app keyWindow];
}

@end
