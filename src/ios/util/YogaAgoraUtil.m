
#import "YogaAgoraUtil.h"

@implementation YogaAgoraUtil

NSString * const YogaColorMain = @"#53B798";
NSString * const YogaColorMainBg = @"#434343";

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

@end
