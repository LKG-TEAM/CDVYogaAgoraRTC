
#import <UIKit/UIKit.h>

extern NSString * const YogaColorMain;
extern NSString * const YogaColorMainBg;

extern NSString * const YAEStreamRemoved;// 该回调通知应用已删除远端音视频流
extern NSString * const YAEPeerLeave;// 该回调通知应用有远端用户离线。
extern NSString * const YAEConnectionStateChang;// 该回调通知应用SDK 与服务器的连接状态发生改变
extern NSString * const YAEStreamAdded;// 该回调通知应用远端音视频流已添加。
extern NSString * const YAEStreamSubscribed;// 该回调通知应用已接收远端音视频流。
extern NSString * const YAEOnTokenPrivilegeWillExpire;// 在 Token 过期前 30 秒，会收到该事件通知。
extern NSString * const YAECallbackMainKey;
extern NSString * const YAESafariBack;

extern NSString * const YAArgumentKeyClientRoleAudience;

@interface YogaAgoraUtil : NSObject

+ (CGSize)getSizeForString:(NSString *)str font:(UIFont *)font;
+ (UIColor *)yoga_colorWithHexString:(NSString *)str alpha:(CGFloat)opacity;
+ (NSString *)jsFuncFormat:(NSString *)str;
+ (void)commandCallback:(NSString *)commandName data:(NSDictionary *)data;

@end
