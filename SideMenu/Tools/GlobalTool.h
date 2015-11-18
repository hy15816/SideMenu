//
//  GlobalTool.h
//  ShenMaMall
//
//  Created by goopai ios on 13-8-16.
//  Copyright (c) 2013年 goopai ios. All rights reserved.
//


typedef enum{
    OpenGateTypeAuto        = 1,
    OpenGateTypeNothing     = 2,
    OpenGateTypeYaoYiYao    = 3
    
} OpenGateType;

typedef void (^httpRequestBlock)(id getData);

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface GlobalTool : NSObject

@property(assign)int type;

+(GlobalTool*)sharedTool;

-(void)saveItems:(NSDictionary*)dic;
-(NSString *)getPath;
-(NSString *)getRecordPath;
-(NSArray*)getRecord;
-(void)saveRecord:(NSDictionary*)recordDic;
-(void)deleteRecord;

#pragma mark -- 创建控件
/**
 *  创建一个tableView
 *
 *  @param frame     frame-rect
 *  @param target    delegate = ? datasourec = ?
 *  @param superView 添加在where
 *
 *  @return UITableView
 */
-(UITableView *)creatTable:(CGRect)frame target:(id)target :(UIView *)superView;

/**
 *  创建一个label
 *
 *  @param frame     rect
 *  @param title     label.text
 *  @param superView super view
 *
 *  @return UILabel
 */
-(UILabel *)creatLab:(CGRect)frame :(NSString *)title :(UIView *)superView;

/**
 *  创建一个UIButton
 *
 *  @param frame     rect
 *  @param title     title
 *  @param image     bgImage
 *  @param superView super view
 *
 *  @return UIButton
 */
-(UIButton *)creatButton:(CGRect)frame title:(NSString*)title image:(NSString*)image :(UIView *)superView;

/**
 *  创建一个imvg
 *
 *  @param frame     rect
 *  @param imageName imgv.image名字
 *  @param superView super view
 *
 *  @return UIImageView
 */
-(UIImageView *)creatImageView:(CGRect)frame :(NSString *)imageName :(UIView *)superView;

/**
 *  创建一个UITextField
 *
 *  @param frame     rect
 *  @param title     field.placeholder
 *  @param superView super view
 *
 *  @return UITextField
 */
-(UITextField *)creatTextFiled:(CGRect)frame :(NSString *)title :(UIView *)superView;

/**
 *  创建一个UITextView
 *
 *  @param frame     frame
 *  @param superView siper view
 *
 *  @return UITextView
 */
-(UITextView *)creatTextView:(CGRect)frame :(UIView *)superView;

/**
 *  图片+文字，文字在图片中间显示
 *
 *  @param frame      frame
 *  @param badgeValue text
 *  @param superView  super view
 *
 *  @return 图片+文字
 */
-(UIImageView *)creatCustomBadge:(CGRect)frame :(int)badgeValue :(UIView*)superView;

/**
 *  生成指定大小的image
 *
 *  @param image 源image
 *  @param size  frame
 *
 *  @return 转换后的size
 */
-(UIImage *)createScaleImage:(UIImage*)image size:(CGSize)size;

/**
 *  创建一个UIScrollView
 *
 *  @param frame     frame
 *  @param superView super view
 *  @param contentSize  内容尺寸(滚动范围)
 *
 *  @return UIScrollView
 */
-(UIScrollView *)createSCView:(CGRect)frame :(CGSize)contentSize :(UIView *)superView;

#pragma mark - 时间...格式 & 时间戳 & 以1970距今时长等
/**
 *  时间String转date
 *
 *  @param dateStr string 如2015-09-15 17:50:00
 *  @param format 格式， 如yyyy-MM-dd HH:mm:ss
 *
 *  @return NSDate
 */
+(NSDate *)dateForString:(NSString *)dateStr formate:(NSString *)format;;

/**
 *  NSDate转字符串
 *
 *  @param date   NSDate
 *  @param format 格式，如yyyy-MM-dd HH:mm:ss
 *
 *  @return 时间字符串
 */
+(NSString *)stringForDate:(NSDate *)date formate:(NSString *)format;

/**
 *  获取当前时间点字符串
 *
 *  @param format 格式 如yyyy-MM-dd HH:mm:ss
 *
 *  @return String
 */
+(NSString *)getCurrDateWithFormat:(NSString *)format;

/**
 *  时间（毫秒格式） 1970年~任意时间之间的秒数 *1000
 *
 *  @param dateString  时间字符串 exp:20151111085000,代表2015-11-11 08:50:00
 *
 *  @return string
 */
+ (NSString *)intervalSinceNowWithString:(NSString *)dateString;

/**
 *  时间（毫秒格式）1970年~任意时间之间的秒数 *1000
 *
 *  @param date NSDate ,exp:[NSDate date]
 *
 *  @return string
 */
+ (NSString *)intervalSinceNowWithDate:(NSDate *)date;

#pragma mark - 网络请求

/**
 *  GET 提交json数据
 *
 *  @param urlStr     地址
 *  @param parameters 数据
 *  @param success    请求suc
 *  @param fail       请求失败
 */
+ (void)getJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(NSError *err))fail;

/**
 *  POST提交json数据
 *
 *  @param urlStr     请求地址
 *  @param parameters 提交的json数据
 *  @param success    请求suc
 *  @param fail       请求失败
 */
+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(NSError *err))fail;

/**
 *  xml 方式获取数据
 *
 *  @param urlStr  请求地址
 *  @param success suc
 *  @param fail    fail
 */
+ (void)XMLDataWithUrl:(NSString *)urlStr success:(void (^)(id xml))success fail:(void (^)())fail;

/**
 *  下载文件
 *
 *  @param urlStr  请求地址
 *  @param success suc
 *  @param fail    fail
 */
+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)())fail;

/**
 *  文件上传，自定义上传文件名
 *
 *  @param urlStr   请求地址
 *  @param fileURL  文件路径
 *  @param fileName 文件名
 *  @param fileTye  文件类型
 *  @param success  suc
 *  @param fail     fail
 */
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail;

/**
 *  判断错误码
 *
 *  @param code 错误码
 */
+(void)errorWithCode:(int)code;

#pragma mark - 保存到本地
/**
 *  判断是否登录状态
 *
 *  @return YES是,NO否
 */
+(BOOL)isLogin;

/**
 *  退出登录
 */
+(void)loginOut;

/**
 *  设置本地帐户文件
 */
+ (void)setUserPlistFile:(NSString *)name;

/**
 *  根据文件名获取所有记录
 *
 *  @param fileName 文件名
 *
 *  @return NSMutableArray 所有记录
 */
+ (NSMutableArray *)getData:(NSString *)fileName;

/**
 *  保存数据
 *
 *  @param carNum 车牌
 *  @param numId  车牌id
 *  @param name   文件名
 */
+ (void)saveData:(NSString *)carNum carNumId:(NSString *)numId user:(NSString *)name ;

/**
 *  修改一条记录
 *
 *  @param index index(元素位置)
 */
+(void)updateData:(NSString *)fileName index:(NSInteger)index;

/**
 *  删除指定记录
 *
 *  @param index 位置(数组索引)
 */
+ (void)deleteRecord:(NSInteger)index user:(NSString *)name;

/**
 *  保存开闸类型
 *
 *  @param type  类型，0摇一摇,1自动
 *  @param number 车牌号
 */
+ (void)saveState:(OpenGateType)type forCarNumber:(NSString *)number;

/**
 *  通过车牌获取开闸类型
 *
 *  @param carNum 车牌
 *
 *  @return NSInteger 0摇，1自动
 */
+ (OpenGateType)getOpenGateTypeFro:(NSString *)carNum;

/**
 *  把data数据转字典
 *
 *  @param jsonData data
 *
 *  @return NSDictionary
 */
+(NSDictionary *)dictionaryFromJsonData:(NSData *)jsonData;

/**
 *  将选取的头像图片保存到本地,
 *
 *  @param image 选取的 image
 *  @param err   若发生错误，返回错误
 */
+ (void)saveMyIcon:(UIImage *)image finish:(void (^)(NSError *err))err;

/**
 *  获取我的头像-image,没有则放置默认图片user_icon
 *
 *  @return image
 */
+ (UIImage *)getMyIcon;

@end

@interface NSDictionary (DictionaryHelper)
- (NSString*) stringForKey:(id)key;

- (NSNumber*) numberForKey:(id)key;

- (NSMutableDictionary*) dictionaryForKey:(id)key;

- (NSMutableArray*) arrayForKey:(id)key;

@end

