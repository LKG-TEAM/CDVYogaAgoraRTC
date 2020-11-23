
#import <UIKit/UIKit.h>

extern NSString * const YogaColorMain;
extern NSString * const YogaColorMainBg;

@interface YogaAgoraUtil : NSObject

+ (CGSize)getSizeForString:(NSString *)str font:(UIFont *)font;
+ (UIColor *)yoga_colorWithHexString:(NSString *)str alpha:(CGFloat)opacity;

@end
