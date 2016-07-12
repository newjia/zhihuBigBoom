//
//  YYUIToolKit.h
//  IWant
//
//  Created by yywang on 14/12/14.
//  Copyright (c) 2014年 yywang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YYUIToolKit : NSObject

@end


#pragma mark -  UILabel Category
@interface UILabel(YYUIToolKit)

+ (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font;
+ (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color;

@end

#pragma mark -  UIAlertView Extensions
@interface UIAlertView(YYExtensions)

+ (void)showAlertWithTitle:(NSString *)strtitle message:(NSString *)strmessage cancelButton:(NSString *)strcancel;
+ (void)showAlertWithTitle:(NSString *)strtitle message:(NSString *)strmessage cancelButton:(NSString *)strcancel delegate:(id<UIAlertViewDelegate>)alertdelegate;
+ (void)showAlertWithTitle:(NSString *)strtitle message:(NSString *)strmessage cancelButton:(NSString *)strcancel delegate:(id<UIAlertViewDelegate>)alertdelegate otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (UIAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancel;
+ (UIAlertView *)alertWithTitle:(NSString *)strtitle message:(NSString *)strmessage cancelButton:(NSString *)strcancel delegate:(id<UIAlertViewDelegate>)alertdelegate;
+ (UIAlertView *)alertWithTitle:(NSString *)strtitle message:(NSString *)strmessage cancelButton:(NSString *)strcancel delegate:(id<UIAlertViewDelegate>)alertdelegate otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
@end

//place holder
#pragma mark -
#pragma mark SWTextView
/**
 UITextView subclass that adds placeholder support like UITextField has.
 */
@interface SWTextView : UITextView

/**
 The string that is displayed when there is no other text in the text view.
 
 The default value is `nil`.
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 The color of the placeholder.
 
 The default is `[UIColor lightGrayColor]`.
 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end

#pragma mark NSString Extensions
@interface NSString(YYExtensions)

- (NSString *)documentPath;
- (NSString *)temporaryPath;
- (NSString *)imageCachePath;
- (NSString *)bundlePath;

- (NSString *)URLEncode;
- (BOOL)isValidEmailAddress;
- (BOOL)isValidateMobile;

//+ (NSString *)UUIDString;
+ (NSString *)MACAddress;
- (NSString *)HMACSHA1StringWithKey:(NSString *)key;
- (NSData *)HMACSHA1WithKey:(NSString *)key;
- (UIColor *)tagColor;
- (UIColor *)tag2Color;

@end

@interface NSData(YYExtensions)

- (NSString *)SHA1String;
- (NSString *)MD5String;

@end

@interface NSDate(YYExtensions)

- (NSString *)dateString;
//- (NSString *)animalString;

@end

@interface UIButton (IWANT)
@property (strong, nonatomic) NSString *memberid;

@end

@interface NSArray (LJExtention)

/*!
 @method objectAtIndexCheck:
 @abstract 检查是否越界和NSNull如果是返回nil
 @result 返回对象
 */
- (id)objectAtIndexCheck:(NSUInteger)index;

@end

@interface NSDictionary (LJCheckExtence)
//判断安全键值        服务器返回字符串——方法返回字符串
- (NSString *)safeStringForKey: (NSString *)key;
                                                            //带占位字符
- (NSString *)safeStringForKey: (NSString *)key placeName: (NSString *)placeStr;

//服务器返回整形- 方法返回整形
- (NSInteger)safeIntegerForKey: (NSString *)key;
                                                            //带占位字符
- (NSInteger)safeIntegerForKey: (NSString *)key placeInt : (NSInteger)placeInt;




//带转换       服务器返回字符串——> 方法返回整形
- (NSString *)safeTransStringForKey: (NSString *)key;
                                                                        //带占位字符
- (NSString *)safeTransStringForKey: (NSString *)key withPlaceString: (NSString *)placeStr;

//服务器返回整形——> 方法返回字符串
- (NSInteger )safeTransIntForKey: (NSString *)key;
                                                                        //带占位
- (NSInteger )safeTransIntForKey: (NSString *)key WithPlaceInt: (NSInteger)placeInt;
@end