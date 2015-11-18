//
//  GlobalTool.m
//  ShenMaMall
//
//  Created by goopai ios on 13-8-16.
//  Copyright (c) 2013年 goopai ios. All rights reserved.
//

#import "GlobalTool.h"
#import <QuartzCore/QuartzCore.h>

//=======================NSDictionary====================================

@implementation NSDictionary (DictionaryHelper)

- (NSString*) stringForKey:(id)key {
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSString class]]) {
		return @"";
	}
	return s;
}

- (NSNumber*) numberForKey:(id)key {
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSNumber class]]) {
		return nil;
	}
	return s;
}

- (NSMutableDictionary*) dictionaryForKey:(id)key {
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSMutableDictionary class]]) {
		return nil;
	}
	return s;
}

- (NSMutableArray*) arrayForKey:(id)key {
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSMutableArray class]]) {
		return nil;
	}
	return s;
}

@end
//=======================GlobalTool====================================
@interface GlobalTool ()

@end
@implementation GlobalTool


-(id)init{
    self=[super init];
    if (self) {
       
    }
    return self;
}


+(GlobalTool*)sharedTool{
    static dispatch_once_t onceToken;
    static GlobalTool*tool;
    dispatch_once(&onceToken, ^{
        tool=[[GlobalTool alloc] init];
    });
    return tool;
}



#pragma mark  - 创建控件

-(UIButton *)creatButton:(CGRect)frame title:(NSString*)title image:(NSString*)image :(UIView *)superView{
    UIButton *detBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    detBtn.frame=frame;
    [detBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [detBtn setTitle:title forState:UIControlStateNormal];
    [detBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    detBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [superView addSubview:detBtn];
    return detBtn;
}


-(UITableView *)creatTable:(CGRect)frame target:(id)target :(UIView *)superView{
    UITableView *table=[[UITableView alloc]initWithFrame:frame];
    table.delegate=target;
    table.dataSource=target;
    [superView addSubview:table];
    
    table.tableFooterView=[[UIView alloc]init];
    return table;
}

-(UITextField *)creatTextFiled:(CGRect)frame :(NSString *)title :(UIView *)superView{
   UITextField* tf=[[UITextField alloc]initWithFrame:frame];
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf.borderStyle=UITextBorderStyleRoundedRect;
    tf.placeholder=title;
    [superView addSubview:tf];
    return tf;
}

-(UITextView *)creatTextView:(CGRect)frame :(UIView *)superView{
    UITextView* tf=[[UITextView alloc]initWithFrame:frame];
    tf.backgroundColor=[UIColor clearColor];
    
    [superView addSubview:tf];
    return tf;
}


-(UILabel *)creatLab:(CGRect)frame :(NSString *)title :(UIView *)superView{
    UILabel *l=[[UILabel alloc]initWithFrame:frame];
    if (title.length==0) {
        l.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f  blue:231/255.0f  alpha:1];
    }
    else{
         l.backgroundColor=[UIColor clearColor];
    }
   
    l.text=title;
    l.textColor=[UIColor darkGrayColor];
    l.font=[UIFont systemFontOfSize:14];
    l.textAlignment=NSTextAlignmentLeft;
    [superView addSubview:l];
    return l;
}

-(UIImageView *)creatImageView:(CGRect)frame :(NSString *)imageName :(UIView *)superView{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    imageView.backgroundColor=[UIColor clearColor];
    [superView addSubview:imageView];
    imageView.image=[UIImage imageNamed:imageName];
    return imageView;
}

-(UIImageView*)creatCustomBadge:(CGRect)frame :(int)badgeValue :(UIView*)superView{
    UIImageView *img=[self creatImageView:frame :@"image_leftImg" :superView];
    UILabel *valueL=[self creatLab:frame :[NSString stringWithFormat:@"%d",badgeValue] :img];
    valueL.textAlignment=NSTextAlignmentCenter;
    valueL.textColor=[UIColor whiteColor];
    valueL.font=[UIFont systemFontOfSize:11];
    CGSize size = [valueL.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    CGRect rect=frame;
    rect.size.width=MAX(size.width, frame.size.width);
    rect.origin.x=frame.origin.x-(size.width-frame.size.width)/2;
    img.frame=rect;
    img.image=[[UIImage imageNamed:@"image_leftImg"] stretchableImageWithLeftCapWidth:10.5f topCapHeight:10.5f];
    rect.origin.x=0;
    rect.origin.y=0;
    valueL.frame=rect;
    return img;
}

-(UIScrollView *)createSCView:(CGRect)frame :(CGSize)contentSize :(UIView *)superView{
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:frame];
    sc.contentSize = contentSize;//内容尺寸(滚动范围)
//    sc.contentOffset = CGPointZero;//当前滚动的位置
    sc.bounces = YES;//是否有弹簧效果
    sc.scrollEnabled = YES;//滚动，df:YES
    sc.showsHorizontalScrollIndicator = NO;//显示水平方向滚动条
    sc.showsVerticalScrollIndicator = YES;//显示垂直方向滚动条
    
    [superView addSubview:sc];
    return sc;
}

-(UIImage*)createScaleImage:(UIImage*)image size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size); //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)]; //newImageRect指定了图片绘制区域
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(NSDate *)dateForString:(NSString *)dateStr formate:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    return date;
}

+(NSString *)stringForDate:(NSDate *)date formate:(NSString *)format{
    NSString *dateString;
    NSDateFormatter *dfmt = [[NSDateFormatter alloc] init];
    [dfmt setLocale:[NSLocale currentLocale]];
    [dfmt setDateFormat:format];
    NSString *s = [dfmt stringFromDate:date];
    
    dateString = s;
    return dateString;
}

+(NSString *)getCurrDateWithFormat:(NSString *)format{
    NSDate *date =  [NSDate date];
    NSDateFormatter *dfmt = [[NSDateFormatter alloc] init];
    [dfmt setLocale:[NSLocale currentLocale]];
    [dfmt setDateFormat:format];
    NSString *dataString = [dfmt stringFromDate:date];
    return dataString;
}

/**
 *  时间（毫秒格式） 1970年~任意时间之间的秒数 *1000
 *
 *  @param dateString  时间字符串 exp:20151111085000,代表2015-11-11 08:50:00
 *
 *  @return string
 */
+ (NSString *)intervalSinceNowWithString:(NSString *)dateString {
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *d=[date dateFromString:dateString];
    NSTimeInterval late=[d timeIntervalSince1970]*1000;
    NSLog(@"date start:%.f",late);
    
    return [NSString stringWithFormat:@"%0.f",late];
}

/**
 *  时间（毫秒格式）1970年~任意时间之间的秒数 *1000
 *
 *  @param date NSDate ,exp:[NSDate date]
 *
 *  @return string
 */
+ (NSString *)intervalSinceNowWithDate:(NSDate *)date {
    
    //    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now =[date timeIntervalSince1970]*1000;
    NSLog(@"date stop:%f",now);
    
    return [NSString stringWithFormat:@"%0.f",now];
}

-(NSString *)getPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"saveData.plist"];
    return dbPath;
}

-(NSString *)getRecordPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"saveRecord.plist"];
    return dbPath;
}

-(NSArray*)getRecord{
     NSMutableArray *arr=[NSMutableArray arrayWithContentsOfFile:[self getRecordPath]];
    return arr?arr:[NSMutableArray new];
}

-(void)deleteRecord{
   NSMutableArray* arr=[NSMutableArray new];
    [arr writeToFile:[self getRecordPath] atomically:YES];
}

-(void)saveRecord:(NSDictionary*)recordDic{

    NSMutableArray *arr=[NSMutableArray arrayWithContentsOfFile:[self getRecordPath]];
    if (!arr) {
        arr=[NSMutableArray new];
    }
    if (![arr containsObject:recordDic]) {
       [arr insertObject:recordDic atIndex:0];
    }
    
    BOOL is= [arr writeToFile:[self getRecordPath] atomically:YES];
    NSLog(@"%d%@",is,[self getRecordPath]);
}


-(void)saveItems:(NSDictionary*)dic{
    
    NSMutableDictionary*temp=[dic mutableCopy];
    [temp setObject:[NSString stringWithFormat:@"%d",self.type] forKey:@"type"];
    NSMutableArray *arr=[NSMutableArray arrayWithContentsOfFile:[self getPath]];
    if (!arr) {
        arr=[[NSMutableArray alloc] initWithArray:@[[NSDictionary new],[NSDictionary new],[NSDictionary new],[NSDictionary new],[NSDictionary new]]];
    }
    [arr replaceObjectAtIndex:self.type withObject:temp];
    [arr writeToFile:[self getPath] atomically:YES];
}


#pragma mark - 网络请求

+ (void)getJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(NSError *err))fail{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
   // manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
            
        }
    }];
    
}


/**
 *  POST提交json数据
 *
 *  @param urlStr     请求地址
 *  @param parameters 提交的json数据
 *  @param success    suc
 *  @param fail       fail
 */
+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(NSError *err))fail
{
//    if (![self isRchab]) {
//        return;
//    }
    //void (^)(AFHTTPRequestOperation *operation, id responseObject)
    //[SVProgressHUD showWithStatus: @"请稍候..." maskType:SVProgressHUDMaskTypeNone];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer]; //data格式
    // 设置返回格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //json格式
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //data格式
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (success) {
            success(responseObject);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"%@", error);
        if (fail) {
            fail(error);
            //NSLog(@"err code:%lu",error.code);
            if (error.code == -1005) {
                [SVProgressHUD showErrorWithStatus:@"请检查网络"];
            }if (error.code == -1001) {
                [SVProgressHUD showErrorWithStatus:@"请求超时"];
            }if (error.code == -1009) {
                [SVProgressHUD showErrorWithStatus:@"请检查网络"];
            }else{
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }
        }
    }];
    
}

/**
 *  xml 方式获取数据
 *
 *  @param urlStr  请求地址
 *  @param success suc
 *  @param fail    fail
 */
+ (void)XMLDataWithUrl:(NSString *)urlStr success:(void (^)(id xml))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 返回的数据格式是XML
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    NSDictionary *dict = @{@"format": @"xml"};
    
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [manager GET:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (fail) {
            fail();
        }
    }];
}

/**
 *  下载文件
 *
 *  @param urlStr  请求地址
 *  @param success suc
 *  @param fail    fail
 */
+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)())fail
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        //        NSLog(@"%@ %@", targetPath, response.suggestedFilename);
        // 将下载文件保存在缓存路径中
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        
        // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
        //        NSURL *fileURL1 = [NSURL URLWithString:path];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        
        //        NSLog(@"== %@ |||| %@", fileURL1, fileURL);
        if (success) {
            success(fileURL);
        }
        
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@ %@", filePath, error);
        if (fail) {
            fail();
        }
    }];
    
    [task resume];
}

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
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    // 本地上传给服务器时,没有确定的URL,不好用MD5的方式处理
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        
        // 要上传保存在服务器中的名称
        // 使用时间来作为文件名 2014-04-30 14:20:57.png
        // 让不同的用户信息,保存在不同目录中
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        // 设置日期格式
        //        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        //        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        
        //@"image/png"
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" fileName:fileName mimeType:fileTye error:NULL];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail();
        }  
    }];  
}

/**
 *  判断是否登录状态
 *
 *  @return YES是,NO否
 */
+(BOOL)isLogin{
    
    BOOL loginState = [[kUSERDFS valueForKey:kLOGINSTATE] intValue];
    if (loginState) {
        return YES;
    }
    return NO;
}

/**
 *  判断错误码
 *
 *  @param code 错误码
 */
+(void)errorWithCode:(int)code{
    
    NSString *errorString = @"";
    switch (code) {
        case 102:
            errorString = @"账号已存在";
            break;
        case 104:
            errorString = @"验证码过期";
            break;
        case 105:
            errorString = @"验证码错误";
            break;
//        case 202:
//            errorString = @"登录状态已过期，请重新登录";//@"凭证码错误";
//            break;
        case 205:
            errorString = @"密码错误";
            break;
        case 207:
            errorString = @"用户名错误";
            break;
        case 208:
            errorString = @"用户不存在";
            break;
            
            //=====添加error=======
        case 10001:
            errorString = @"已被绑定";
            break;
        case 10002:
            errorString = @"超过5辆车";
            break;
        case 10003:
            errorString = @"车牌为空";
            break;
        case 10004:
            errorString = @"用户不存在";
            break;
        case 10005:
            errorString = @"用户为空";
            break;
            
            //=====删除error=======
        case 10007:
            errorString = @"该用户没绑定该车";
            break;
        case 10008:
            errorString = @"用户没有绑定过";
            break;
        case 10009:
            errorString = @"车牌没有被绑定";
            break;
        case 10010:
            errorString = @"车牌为空";
            break;
        case 10011:
            errorString = @"用户为空";
            break;
            
            //=====查询error=======
            break;
        case 100019:
            errorString = @"用户不存在";
            break;
        case 100020:
            errorString = @"用户为空";
            break;

        default:
            break;
    }
    if (errorString.length > 0) {
        [SVProgressHUD showErrorWithStatus:errorString];
    }
    
}

/**
 *  退出登录
 */
+(void)loginOut{
    //[kUSERDFS setValue:@"" forKey:hDMTCODE];//pzm=nil
    [kUSERDFS setValue:@"0" forKey:kLOGINSTATE];
    
}

/// 设置本地帐户文件
+ (void)setUserPlistFile:(NSString *)name
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:kPlistPath(name)])
    {
        NSArray *arr = [[NSArray alloc] init];
        [arr writeToFile:kPlistPath(name) atomically:YES];
    }
}

/**
 *  根据文件名获取所有记录
 *
 *  @param fileName 文件名
 *
 *  @return NSMutableArray 所有记录
 */
+ (NSMutableArray *)getData:(NSString *)fileName{
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:kPlistPath(fileName)];
    return array;
}

/**
 *  保存数据
 *
 *  @param carNum 车牌
 *  @param numId  车牌id
 *  @param name   文件名
 */
+ (void)saveData:(NSString *)carNum carNumId:(NSString *)numId user:(NSString *)name {
    NSMutableArray *array = [GlobalTool getData:kPlistPath(name)];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:carNum forKey:@"License_plate_number"];//车牌
    [dict setObject:numId forKey:@"License_plate_id"];//车牌id
    [array addObject:dict];
    [array writeToFile:kPlistPath(name) atomically:YES];
    NSLog(@"path:%@",kPlistPath(name));
}

/**
 *  修改一条记录
 *
 *  @param index index(元素位置)
 */
+ (void)updateData:(NSString *)fileName index:(NSInteger)index{
    NSMutableArray *array = [GlobalTool getData:kPlistPath(fileName)];

    //获取指定元素
    NSMutableDictionary *dict0 = [array objectAtIndex:index];
    [dict0 setObject:@"hIm" forKey:@"name"];
    [dict0 setObject:@"23" forKey:@"age"];
    [dict0 setObject:@"jx" forKey:@"address"];
    [dict0 setObject:@"13800000001" forKey:@"phone"];
    [dict0 setObject:@"12345678" forKey:@"pwd"];
    
    [array replaceObjectAtIndex:index withObject:dict0];
    [array writeToFile:kPlistPath(kDFUSERNAME) atomically:YES];
    
}
/**
 *  删除指定记录
 *
 *  @param index 位置(数组索引)
 */
+ (void)deleteRecord:(NSInteger)index user:(NSString *)name{
    
    NSMutableArray *array = [GlobalTool getData:kPlistPath(name)];
    [array removeObjectAtIndex:index];
    [array writeToFile:kPlistPath(name) atomically:YES];
}

/**
 *  保存开闸类型
 *
 *  @param type  类型，0摇一摇,1自动
 *  @param number 车牌号
 */
+ (void)saveState:(OpenGateType)type forCarNumber:(NSString *)number{
    NSString *state = @"3";
    if (type == OpenGateTypeAuto) {
        state = @"1";//自动
    }
    if (type == OpenGateTypeNothing) {
        state = @"2";
    }
    //保存开闸状态
    [kUSERDFS setObject:state forKey:[NSString stringWithFormat:@"%@%@",number,@"auto"]];
}

/**
 *  通过车牌获取开闸类型
 *
 *  @param carNum 车牌
 *
 *  @return NSString 0摇，1自动
 */
+ (OpenGateType)getOpenGateTypeFro:(NSString *)carNum{
    NSInteger state = [[kUSERDFS valueForKey:[NSString stringWithFormat:@"%@%@",carNum,@"auto"]] integerValue];
    if (state == 3) {
        return OpenGateTypeYaoYiYao;//摇一摇
    }
    if (state == 2) {
        return OpenGateTypeNothing;
    }
    return OpenGateTypeAuto;
}

/**
 *  把data数据转字典
 *
 *  @param jsonData data
 *
 *  @return NSDictionary
 */
+(NSDictionary *)dictionaryFromJsonData:(NSData *)jsonData{
    
    if (jsonData == nil) {
        return nil;
    }
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    
    return responseJSON;
}

+ (void)saveMyIcon:(UIImage *)image finish:(void (^)(NSError *err))err{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:kMyHeadPortraitName];
    //NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    //UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
    success =  [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    if (!success) {
        
        if (err) {
            err(error);
        }
        
    }
}

+ (UIImage *)getMyIcon{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:kMyHeadPortraitName];
    //NSLog(@"imageFile->>%@",imageFilePath);
    UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
    
    return image!=nil?image:[UIImage imageNamed:@"user_icon"];
}

@end
