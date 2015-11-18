//
//  LocationVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/14.
//  Copyright © 2015年 hyIm. All rights reserved.
//  使用iOS自带定位技术，导入<CoreLocation/CoreLocation.h>框架，
/**
 *定位种类：1）持续的位置更新，2）使用期间的更新
 *
 *
 *
 *
 *
 */


/*
    kCLAuthorizationStatusNotDetermined = 0,    //用户尚未做出选择
 
	kCLAuthorizationStatusRestricted,           //用户未授权使用定位服务
 
	kCLAuthorizationStatusDenied,               //用户已经禁止定位
 
	kCLAuthorizationStatusAuthorizedAlways      //始终允许
	
	kCLAuthorizationStatusAuthorizedWhenInUse   //试用期间允许
 */


#define kTAG_LOCATION  20151114

#import "LocationVC.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationVC ()<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    NSString *cityName;
    UIAlertView *locationAlert;
    BOOL isLocationing;
}
@property (strong,nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *startLocations;
- (IBAction)startLocationsClick:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UILabel *fLongitude;
@property (strong, nonatomic) IBOutlet UILabel *fLatitude;
@property (strong, nonatomic) IBOutlet UILabel *fAddress;
@property (strong, nonatomic) IBOutlet UILabel *fLastTime;
/**
 *  海拔
 */
@property (strong, nonatomic) IBOutlet UILabel *fAltitude;
@property (strong, nonatomic) IBOutlet UILabel *fRound;


@end

@implementation LocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    isLocationing = NO;
    locationAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"定位服务已关闭,是否打开?" delegate:self cancelButtonTitle:@"不打开" otherButtonTitles:@"前往打开", nil];
    locationAlert.tag = kTAG_LOCATION;
    
    // Do any additional setup after loading the view.
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 200;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;//精度10米，定位要求的精度越高、属性distanceFilter的值越小，应用程序的耗电量就越大。
        [self.locationManager requestWhenInUseAuthorization];//使用期间允许
        /*
         CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
         if (authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
         // TODO：do what you want e.g. goto setting view
         }
         [self.locationManager requestAlwaysAuthorization];    //始终允许
         */
        //[self.locationManager startUpdatingLocation];
    }else{
        
        [locationAlert show];
    }
    
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //通知，进入前台时发出，在此处接收
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLocationing) name:@"startNotificationName" object:nil];
    
    
}

/**
 *  开始定位
 */
- (void)startLocationing{
    
    [self.locationManager startUpdatingLocation];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == kTAG_LOCATION) {
        if (buttonIndex) {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }
    }
}

#pragma mark - CLLocationManagerDelegate

//位置更新(成功)
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{

    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    //NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);

    self.fLongitude.text = [NSString stringWithFormat:@"%f",coordinate.longitude];
    self.fLatitude.text = [NSString stringWithFormat:@"%f",coordinate.latitude];
    
    
    if(location.horizontalAccuracy > 0)
    {
        //NSLog(@"当前位置：lon:%.0f,lat:%.0f ± %.0f 米",location.coordinate.longitude, location.coordinate.latitude, location.horizontalAccuracy);
        self.fRound.text = [NSString stringWithFormat:@"在(lon)%.2f,(lat)%.2f ± %.2f m之内",coordinate.longitude,coordinate.latitude,location.horizontalAccuracy];
    }
    
    if(location.verticalAccuracy > 0)
    {
        //NSLog(@"当前海拔高度：%.0f ± %.0f 米",location.altitude,location.verticalAccuracy);
        self.fAltitude.text = [NSString stringWithFormat:@"%.2f ± %.2f m",location.altitude,location.verticalAccuracy];
        
    }
    //==========================================
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //NSLog(@%@,placemark.name);//具体位置
             //获取城市
             NSString *city = placemark.locality;
             NSDictionary *areaDict = placemark.addressDictionary;
             //NSLog(@"areaDict:%@",areaDict);
             if (!areaDict) {
                 return ;
             }else{
                 dispatch_async(dispatch_get_main_queue(), ^{
                     self.fAddress.text =[NSString stringWithFormat:@"country:%@,\ncity      :%@,\nstate    :%@,\ncountryCode:%@,\nFormattedAddressLines:%@ ,\nname:%@",[areaDict objectForKey:@"Country"],[areaDict objectForKey:@"State"],[areaDict objectForKey:@"City"],[areaDict objectForKey:@"CountryCode"],[[areaDict objectForKey:@"FormattedAddressLines"] objectAtIndex:0],[areaDict objectForKey:@"Name"]];
                     self.fLastTime.text = [GlobalTool getCurrDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
                     [self.startLocations setTitle:@"定位完成"];
                     [SVProgressHUD showSuccessWithStatus:@"定位完成"];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [self.startLocations setTitle:@"开始定位"];
                         self.startLocations.enabled = YES;
                         [self.startLocations setTintColor:[UIColor whiteColor]];
                         
                     });
                 });
             }
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             cityName = city;
             //NSLog(@"定位完成:%@",city);
             //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
             [manager stopUpdatingLocation];
         }else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
         self.startLocations.enabled = YES;
         
         //[self currentLocations];
     }];
    
}

- (void)currentLocations{
    
    self.title = [NSString stringWithFormat:@"当前城市:%@",cityName];
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //CLError
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可打印error.code值查找原因所在
        [locationAlert show];
        // 2.停止定位管理器
        [manager stopUpdatingLocation];
    }
    NSLog(@"location err:%@",error.localizedDescription);
}

//===========方向更新=============
//否向用户显示校准提示
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if(newHeading.headingAccuracy >=0)
    {
        NSString *headingDesc = [NSString stringWithFormat:@"%.0f degrees (true), %.0f degrees (magnetic)",newHeading.trueHeading,newHeading.magneticHeading];
        
        NSLog(@"newHeading %@",headingDesc);
    }
}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startLocationsClick:(UIBarButtonItem *)sender {
    [SVProgressHUD showWithStatus:@"正在定位"];
    [self.locationManager startUpdatingLocation];
    [self.startLocations setTitle:@"正在定位"];
    [self.startLocations setTintColor:[UIColor grayColor]];
    self.startLocations.enabled = NO;
    
}
@end
