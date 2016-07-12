//
//  YYUIToolKit.m
//  IWant
//
//  Created by yywang on 14/12/14.
//  Copyright (c) 2014年 yywang. All rights reserved.
//

#import "YYUIToolKit.h"
#import <CommonCrypto/CommonCrypto.h>
#import <AdSupport/AdSupport.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


@implementation YYUIToolKit

@end

#pragma mark -
#pragma mark UILabel Catergory
@implementation UILabel(YYUIToolKit)

+ (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font{
    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
    lbl.font = font;
    lbl.backgroundColor = [UIColor clearColor];
    
    return lbl;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color{
    UILabel *lbl = [self createLabelWithFrame:frame font:font];
    lbl.textColor = color;
    
    return lbl;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font text:(NSString *)text textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment backgroundColor:(UIColor *)backgroundColor
{
    UILabel *lbl = [self createLabelWithFrame:frame font:font];
    lbl.textColor = color;
    lbl.text = text;
    lbl.textAlignment = textAlignment;
    lbl.backgroundColor = backgroundColor;
    return lbl;
}

@end

#pragma mark -  UIAlertView Extensions
@implementation UIAlertView(YYExtensions)

+ (void)showAlertWithTitle:(NSString *)strtitle message:(NSString *)strmessage cancelButton:(NSString *)strcancel{
    [UIAlertView showAlertWithTitle:strtitle message:strmessage cancelButton:strcancel delegate:nil];
}

+ (void)showAlertWithTitle:(NSString *)strtitle message:(NSString *)strmessage cancelButton:(NSString *)strcancel delegate:(id<UIAlertViewDelegate>)alertdelegate{
    [UIAlertView showAlertWithTitle:strtitle message:strmessage cancelButton:strcancel delegate:alertdelegate otherButtonTitles:nil];
}

+ (void)showAlertWithTitle:(NSString *)strtitle message:(NSString *)strmessage cancelButton:(NSString *)strcancel delegate:(id<UIAlertViewDelegate>)alertdelegate otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    if (!strcancel)
        strcancel = @"确定";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strtitle?strtitle:@"" message:strmessage delegate:alertdelegate cancelButtonTitle:strcancel otherButtonTitles:nil];
    
    va_list args;
    va_start(args, otherButtonTitles);
    
    for (NSString *arg=otherButtonTitles;arg!=nil;arg=va_arg(args, NSString *)){
        [alert addButtonWithTitle:arg];
    }
    
    va_end(args);
    
    [alert show];
}

+ (UIAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancel{
    return [UIAlertView alertWithTitle:title message:message cancelButton:cancel delegate:nil];
}

+ (UIAlertView *)alertWithTitle:(NSString *)strtitle message:(NSString *)strmessage cancelButton:(NSString *)strcancel delegate:(id<UIAlertViewDelegate>)alertdelegate{
    return [UIAlertView alertWithTitle:strtitle message:strmessage cancelButton:strcancel delegate:alertdelegate otherButtonTitles:nil];
}

+ (UIAlertView *)alertWithTitle:(NSString *)strtitle message:(NSString *)strmessage cancelButton:(NSString *)strcancel delegate:(id<UIAlertViewDelegate>)alertdelegate otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    if (!strcancel)
        strcancel = @"确定";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strtitle?strtitle:@"" message:strmessage delegate:alertdelegate cancelButtonTitle:strcancel otherButtonTitles:nil];
    
    va_list args;
    va_start(args, otherButtonTitles);
    
    for (NSString *arg=otherButtonTitles;arg!=nil;arg=va_arg(args, NSString *)){
        [alert addButtonWithTitle:arg];
    }
    
    va_end(args);
    
    return alert;
}

@end

#pragma mark -
#pragma mark SWTextView
@interface SWTextView ()
- (void)_initialize;
- (void)_updateShouldDrawPlaceholder;
- (void)_textChanged:(NSNotification *)notification;
@end


@implementation SWTextView {
    BOOL _shouldDrawPlaceholder;
}


#pragma mark Accessors

@synthesize placeholder = _placeholder;
@synthesize placeholderColor = _placeholderColor;

- (void)setText:(NSString *)string {
    [super setText:string];
    [self _updateShouldDrawPlaceholder];
}


- (void)setPlaceholder:(NSString *)string {
    if ([string isEqual:_placeholder]) {
        return;
    }
    
    _placeholder = string;
    
    [self _updateShouldDrawPlaceholder];
}


#pragma mark NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    
}


#pragma mark UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self _initialize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self _initialize];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (_shouldDrawPlaceholder) {
        [_placeholderColor set];
//        [_placeholder drawInRect:CGRectMake(8.0f, 8.0f, self.frame.size.width - 16.0f, self.frame.size.height - 16.0f) withFont:self.font];
        [_placeholder drawInRect:CGRectMake(8.0f, 8.0f, self.frame.size.width - 16.0f, self.frame.size.height - 16.0f)  withAttributes:@{NSForegroundColorAttributeName :self.font}];
    }
}


#pragma mark Private

- (void)_initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:self];
    
    self.placeholderColor = [UIColor colorWithWhite:0.702f alpha:1.0f];
    _shouldDrawPlaceholder = NO;
}


- (void)_updateShouldDrawPlaceholder {
    BOOL prev = _shouldDrawPlaceholder;
    _shouldDrawPlaceholder = self.placeholder && self.placeholderColor && self.text.length == 0;
    
    if (prev != _shouldDrawPlaceholder) {
        [self setNeedsDisplay];
    }
}


- (void)_textChanged:(NSNotification *)notificaiton {
    [self _updateShouldDrawPlaceholder];
}

@end

#pragma mark NSString extensions
@implementation NSString(YYExtensions)

- (NSString *)imageCachePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *imagesPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"images"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagesPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:imagesPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ImageDirectoryExcluded"]){
        NSURL *url = [NSURL fileURLWithPath:imagesPath];
        NSError *error = nil;
        BOOL success = [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        
        if (success)
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ImageDirectoryExcluded"];
    }
    
    NSString *path = [imagesPath stringByAppendingPathComponent:self];
    
    return path;
}

- (NSString *)documentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:self];
    
    return path;
}

- (NSString *)temporaryPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *tmpPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"tmp"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:tmpPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:tmpPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"TmpDirectoryExcluded"]){
        NSURL *url = [NSURL fileURLWithPath:tmpPath];
        NSError *error = nil;
        BOOL success = [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        
        if (success)
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TmpDirectoryExcluded"];
    }
    
    
    NSString *path = [tmpPath stringByAppendingPathComponent:self];
    return path;
}

- (NSString *)bundlePath{
    NSString *path = [[NSBundle mainBundle] pathForResource:self ofType:nil];
    
    return path;
}

-(NSString *)URLEncode
{
    NSMutableString *mutstr = [NSMutableString string];
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    const unsigned char *a = data.bytes;
    //    const unsigned char *a = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSInteger len = data.length;
    
    for (int i=0;i<len;i++){
        unsigned char c = a[i];
        if ((c>='a' && c<='z') || (c>='A' && c<='Z') || (c>='0' && c<='9') || c=='.' || c=='-')
            [mutstr appendFormat:@"%c",c];
        else
            [mutstr appendFormat:@"%%%02x",(unsigned int)c];
    }
    
    return mutstr;
    
    NSString *str = nil;
    //	$entities = array('%21', '%2A', '%27', '%28', '%29', '%3B', '%3A', '%40', '%26', '%3D', '%2B', '%24', '%2C', '%2F', '%3F', '%25', '%23', '%5B', '%5D');
    //	$replacements = array('!', '*', "'", "(", ")", ";", ":", "@", "&", "=", "+", "$", ",", "/", "?", "%", "#", "[", "]");
    NSArray *replaceArray = [NSArray arrayWithObjects:@"!",@"*",@"'",@"(",@")",@";",@":",@"@",@"&",@"=",@"+",@"$",@",",@"/",@"?",@"%",@"#",@"[",@"]",@" ",@"\"",nil];
    NSArray *codeArray = [NSArray arrayWithObjects:@"%21",@"%2A",@"%27",@"%28",@"%29",@"%3B",@"%3A",@"%40",@"%26",@"%3D",
                          @"%2B",@"%24",@"%2C",@"%2F",@"%3F",@"%25",@"%23",@"%5B",@"%5D",@"%20",@"%22",nil];
    //	NSLog(@"decoded:%@",self);
    str = [self stringByReplacingOccurrencesOfString:[replaceArray objectAtIndex:15] withString:[codeArray objectAtIndex:15]];
    for(int i=0;i<21;i++)
    {
        if(15!=i)
            str = [str stringByReplacingOccurrencesOfString:[replaceArray objectAtIndex:i] withString:[codeArray objectAtIndex:i]];
    }
    
    //	NSLog(@"encoded:%@",str);
    return str;
}

- (BOOL)isValidEmailAddress{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidateMobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

//+ (NSString *)UUIDString{
//    NSString *UUID = nil;
//    UIDevice *device = [UIDevice currentDevice];
//    if ([device respondsToSelector:@selector(identifierForVendor)])
//        UUID = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
//    else{
//        UUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"];
//        if (!UUID){
//            CFUUIDRef uuidref = CFUUIDCreate(NULL);
//            CFStringRef uuidstr = CFUUIDCreateString(NULL, uuidref);
//            UUID = (__bridge_transfer NSString *)uuidstr;
//            CFRelease(uuidref);
//            [[NSUserDefaults standardUserDefaults] setObject:UUID forKey:@"UUID"];
//        }
//    }
//    
//    return UUID;
//}



+(NSString *)MACAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    NSString            *errorFlag = NULL;
    size_t              length;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    // Get the size of the data available (store in len)
    else if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
        errorFlag = @"sysctl mgmtInfoBase failure";
    // Alloc memory based on above call
    else if ((msgBuffer = malloc(length)) == NULL)
        errorFlag = @"buffer allocation failure";
    // Get system information, store in buffer
    else if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
    {
        free(msgBuffer);
        errorFlag = @"sysctl msgBuffer failure";
    }
    else
    {
        // Map msgbuffer to interface message structure
        struct if_msghdr *interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
        
        // Map to link-level socket structure
        struct sockaddr_dl *socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
        
        // Copy link layer address data in socket structure to an array
        unsigned char macAddress[6];
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        
        // Read from char array into a string object, into traditional Mac address format
        NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                      macAddress[0], macAddress[1], macAddress[2], macAddress[3], macAddress[4], macAddress[5]];
        
        // Release the buffer memory
        free(msgBuffer);
        
        return macAddressString;
    }
    
    // Error...
    NSLog(@"Get Mac Address Failed:%@",errorFlag);
    return nil;
}

- (NSString *)HMACSHA1StringWithKey:(NSString *)key{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    
    NSData *keydata = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *selfdata = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA1, [keydata bytes], [key length], [selfdata bytes], [selfdata length], result);
    
    NSMutableString *str = [NSMutableString string];
    
    for (int i=0;i<CC_SHA1_DIGEST_LENGTH;i++)
        [str appendFormat:@"%02X",result[i]];
    
    return str;
}

- (NSData *)HMACSHA1WithKey:(NSString *)key{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    
    NSData *keydata = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *selfdata = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA1, [keydata bytes], [key length], [selfdata bytes], [selfdata length], result);
    
    NSData *data = [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
    
    return data;
}

- (UIColor *)tagColor{
    float colors[] = {0x4b,0xbe,0xba,0xff,0x78,0x82,0xf6,0xa0,0x3b,0x81,0xbe,0x4b,0x00,0xa2,0xff};
    
    NSString *hash = [[self dataUsingEncoding:NSUTF8StringEncoding] SHA1String];
    const unichar a = [hash characterAtIndex:0];
    int index = a%5;
    UIColor *color = [UIColor colorWithRed:colors[index*3]/255.0f green:colors[index*3+1]/255.0f blue:colors[index*3+2]/255.0f alpha:1];
    
    return color;
}

- (UIColor *)tag2Color{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[self substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[self substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[self substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}

@end

@implementation NSData(YYExtensions)

- (NSString *)SHA1String{
    if (!self)
        return nil;
    
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1([self bytes], self.length, result);
    
    NSMutableString *str = [NSMutableString string];
    
    for (int i=0;i<CC_SHA1_DIGEST_LENGTH;i++)
        [str appendFormat:@"%02X",result[i]];
    
    return str;
}

- (NSString *)MD5String{
    if (!self)
        return nil;
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5([self bytes], self.length, result);
    
    NSMutableString *str = [NSMutableString string];
    
    for (int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
        [str appendFormat:@"%02x",result[i]];
    
    return str;
}



@end

@implementation NSDate(YYExtensions)

- (NSString *)dateString
{
    NSDate *created_date = self;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [formatter stringFromDate:created_date];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date1 = [formatter stringFromDate:created_date];
    NSString *date2 = [formatter stringFromDate:[NSDate date]];
    if ([date1 isEqualToString:date2]){
        [formatter setDateFormat:@"HH:mm"];
        
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self];
        if (timeInterval<0)
            timeInterval = 0;
        if (timeInterval>3600){
            strDate = [formatter stringFromDate:created_date];
            strDate = [NSString stringWithFormat:@"%@ %@",@"今天",strDate];
        }
        else{
            strDate = [NSString stringWithFormat:@"%d分钟前",(int)(timeInterval/60)];
        }
    }else {
        [formatter setDateFormat:@"yyyy-MM-dd 00:00"];
        NSDate *tempdate = [formatter dateFromString:[formatter stringFromDate:[NSDate date]]];
        if ([tempdate timeIntervalSinceDate:created_date]<3600*24){
            [formatter setDateFormat:@"HH:mm"];
            strDate = [formatter stringFromDate:created_date];
            strDate = [NSString stringWithFormat:@"%@ %@",@"昨天",strDate];
        }else{
            [formatter setDateFormat:@"yyyy"];
            date1 = [formatter stringFromDate:created_date];
            date2 = [formatter stringFromDate:[NSDate date]];
            
            if ([date1 isEqualToString:date2]){
                [formatter setDateFormat:@"MM-dd HH:mm"];
                strDate = [formatter stringFromDate:created_date];
            }
        }
    }
    
    return strDate;
}


@end


#import <objc/runtime.h>
static const void *memberidKey = &memberidKey;
@implementation UIButton (IWANT)
@dynamic memberid;

- (NSString *)memberid
{
    return objc_getAssociatedObject(self, memberidKey);
}

- (void)setMemberid:(NSString *)memberid
{
    objc_setAssociatedObject(self, memberidKey, memberid, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation NSArray (LJExtention)

- (id)objectAtIndexCheck:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}
@end

@implementation NSDictionary (LJCheckExtence)
- (NSString *)safeStringForKey: (NSString *)key
{
    if (!self || [self isEqual:[NSNull class]] || [self isMemberOfClass:[NSArray class]] || self.count == 0) {
        return @"";
    }
    NSString *string = [self objectForKey:key];
    if (!string || [string isMemberOfClass:[NSNull class]]) {
        string = @"";
    }
    return string;
}


- (NSString *)safeStringForKey: (NSString *)key placeName: (NSString *)placeStr;
{
    if (!self || [self isEqual:[NSNull class]] || [self isMemberOfClass:[NSArray class]] || self.count == 0) {
        return placeStr;
    }
    NSString *string = [self objectForKey:key];
    if (!string || [string isMemberOfClass:[NSNull class]] || string.length == 0) {
        string = placeStr;
    }
    return string;
}


- (NSInteger)safeIntegerForKey: (NSString *)key
{
    if (!self || [self isEqual:[NSNull class]] || [self isMemberOfClass:[NSArray class]] || self.count == 0) {
        return 0;
    }
    NSString *string = [self objectForKey:key];
    if (!string || [string isMemberOfClass:[NSNull class]]) {
        string = 0;
    }
    return [string integerValue];
}

- (NSInteger)safeIntegerForKey: (NSString *)key placeInt : (NSInteger)placeInt
{
    if (!self || [self isEqual:[NSNull class]] || [self isMemberOfClass:[NSArray class]] || self.count == 0) {
        return placeInt;
    }
    NSString *string = [self objectForKey:key];
    if (!string || [string isMemberOfClass:[NSNull class]]) {
        return placeInt;
    }
    return [string integerValue];
}

//有转换        服务器返回字符串——> 方法返回整形
- (NSString *)safeTransStringForKey: (NSString *)key
{
    if (!self || [self isEqual:[NSNull class]] || [self isMemberOfClass:[NSArray class]] || self.count == 0) {
        return @"";
    }
    NSInteger string = [self safeIntegerForKey: key];
    return @(string).stringValue;
}

- (NSString *)safeTransStringForKey: (NSString *)key withPlaceString: (NSString *)placeStr
{
    if (!self || [self isEqual:[NSNull class]] || [self isMemberOfClass:[NSArray class]] || self.count == 0) {
        return placeStr;
    }
    NSInteger string = [self safeIntegerForKey: key];
    if (string == 0) {
        return placeStr;
    }
    return @(string).stringValue;
}

//服务器返回整形——> 方法返回字符串
- (NSInteger )safeTransIntForKey: (NSString *)key
{
    if (!self || [self isEqual:[NSNull class]] || [self isMemberOfClass:[NSArray class]] || self.count == 0) {
        return 0;
    }
    NSString *string = [self safeStringForKey:key];
    if ([string isEqualToString:@""]) {
        return 0;
    }
    return [string integerValue];
}

- (NSInteger )safeTransIntForKey: (NSString *)key WithPlaceInt: (NSInteger)placeInt
{
    if (!self || [self isEqual:[NSNull class]] || [self isMemberOfClass:[NSArray class]] || self.count == 0) {
        return placeInt;
    }
    NSString *string = [self safeStringForKey:key];
    if ([string isEqualToString:@""]) {
        return placeInt;
    }
    return [string integerValue];
}



@end



