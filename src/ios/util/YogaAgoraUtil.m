
#import "YogaAgoraUtil.h"
#import "YogaAgoraShared.h"

@implementation YogaAgoraUtil

NSString * const YogaColorMain = @"#53B798";
NSString * const YogaColorMainBg = @"#434343";

NSString * const YAEStreamRemoved = @"stream-removed";// 该回调通知应用已删除远端音视频流
NSString * const YAEPeerLeave = @"peer-leave";// 该回调通知应用有远端用户离线。
NSString * const YAEConnectionStateChang = @"connection-state-chang";// 该回调通知应用SDK 与服务器的连接状态发生改变
NSString * const YAEStreamAdded = @"stream-added";// 该回调通知应用远端音视频流已添加。
NSString * const YAEStreamSubscribed = @"stream-subscribed";// 该回调通知应用已接收远端音视频流。
NSString * const YAEOnTokenPrivilegeWillExpire = @"onTokenPrivilegeWillExpire";// 在 Token 过期前 30 秒，会收到该事件通知。
NSString * const YAECallbackMainKey = @"evt";
NSString * const YAESafariBack = @"safari-back";

NSString * const YAArgumentKeyClientRoleAudience = @"audience";

+ (CGSize)getSizeForString:(NSString *)str font:(UIFont *)font
{
    CGSize size = CGSizeZero;
    if ([str respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options: (NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attribute context:nil].size;
    }
    return size;
}

+ (UIColor *)yoga_colorWithHexString:(NSString *)str alpha:(CGFloat)opacity
{
    if (str.length == 6 && ![str hasPrefix:@"#"]) {
        str = [@"#" stringByAppendingString:str];
    }
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [self _yoga_colorWithHex:x alpha:opacity];
}

+ (UIColor *)_yoga_colorWithHex:(long)hexColor alpha:(CGFloat)opacity
{
    CGFloat red = ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0;
    CGFloat green = ((CGFloat)((hexColor & 0xFF00) >> 8))/255.0;
    CGFloat blue = ((CGFloat)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

+ (NSString *)jsFuncFormat:(NSString *)str
{
    return [NSString stringWithFormat:@"yogaAgoraRTC%@",str];
}

+ (void)commandCallback:(NSString *)commandName data:(NSDictionary *)data
{
    CDVInvokedUrlCommand *command = [[YogaAgoraShared shared].commands objectForKey:commandName];
    [[YogaAgoraShared shared].commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:data];
        [pluginResult setKeepCallbackAsBool:YES];
        [[YogaAgoraShared shared].commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end
