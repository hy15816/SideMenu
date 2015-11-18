//
//  PreViewViewController.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/13.
//  Copyright © 2015年 hyIm. All rights reserved.
//  图片多时加载较慢，考虑用collection来做，这样把一张image放在已个cell中，

#import "PreViewViewController.h"

@interface PreViewViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate>
{
    UIButton *_completeBtn; //完成
    UIButton *_checkedBtn;  //选择/取消
    UIScrollView *_scrollView;
    UIImageView *_imageView;
    NSMutableArray *_checkArray;    //最终选择的结果
    int currentIndex;
    NSMutableDictionary *_tempMutDicts;     //保存asset生成的字典
    BOOL _flag;
    NSMutableDictionary *_mutDictsAndNoOperation;   //此字典的元素最开始和_tempMutDicts一样，因为_tempMutDicts要做删除或者设值操作，_mutDictsAndNoOperation则用来作对比，这样，即使_tempMutDicts删除了，要添加时，也能在_mutDictsAndNoOperation中找到key对应的值
    NSInteger _itemsCount;      //前一页面选择的图片总数，
}
@end

@implementation PreViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"0";
    
    _checkArray = [[NSMutableArray alloc] init];
    _tempMutDicts = [[NSMutableDictionary alloc] init];
    _mutDictsAndNoOperation = [[NSMutableDictionary alloc] init];
    _flag = NO;
    _itemsCount = self.selectedArray.count;
    
    //选择与取消
    _checkedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkedBtn.frame=CGRectMake(0, 0, 22, 22);
    [_checkedBtn setImage:[UIImage imageNamed:@"OK.png"] forState:UIControlStateNormal];
    [_checkedBtn addTarget:self action:@selector(checkOrCancel:)forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_checkedBtn];
    
    [self setupView];
    /*
    { 
     1 = asset1,
     2 = asset2,
     3 = asset3,
     4 = asset4
     }
     */
}

- (void)setupView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    //显示选中的图片的大图
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    
    for (int i=0; i<[self.selectedArray count]; i++) {

        ALAsset *asset=self.selectedArray[i];
        [_tempMutDicts setObject:asset forKey:[NSString stringWithFormat:@"%d",i]];//生成key=i,value=asset的字典，添加到
        
        UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(i*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        imgview.contentMode=UIViewContentModeScaleAspectFill;
        imgview.clipsToBounds=YES;
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [imgview setImage:tempImg];
        [_scrollView addSubview:imgview];
    }
    _mutDictsAndNoOperation = [NSMutableDictionary dictionaryWithDictionary:_tempMutDicts];
    NSLog(@"_tempMutDicts:%@",_tempMutDicts);
    NSLog(@"_mutDictsAndNoOperation:%@",_mutDictsAndNoOperation);
    _scrollView.contentSize = CGSizeMake((self.selectedArray.count) * (self.view.frame.size.width),0);
    [self.view addSubview:_scrollView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-114, self.view.frame.size.width, 50)];
    bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    bottomView.alpha = .9;
    
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeBtn.frame = CGRectMake(bottomView.frame.size.width - 70,  (bottomView.frame.size.height-32)/2, 61, 32);
    [_completeBtn setBackgroundImage:[UIImage imageNamed:@"complete.png"] forState:UIControlStateNormal];
    [_completeBtn setTitle:[NSString stringWithFormat:@"完成(%lu)",(unsigned long)_itemsCount] forState:UIControlStateNormal];
    _completeBtn .titleLabel.font = [UIFont systemFontOfSize:10];
    [_completeBtn addTarget:self action:@selector(completeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomView];
    [bottomView addSubview:_completeBtn];
}

- (void)checkOrCancel:(UIButton *)button{
    _flag = !_flag;
    if (_flag) {//取消选中
        _itemsCount--;
        [_tempMutDicts removeObjectForKey:[NSString stringWithFormat:@"%d",currentIndex]];
        [_checkedBtn setImage:[UIImage imageNamed:@"No.png"] forState:UIControlStateNormal];
        [_completeBtn setTitle:[NSString stringWithFormat:@"完成(%lu)",(unsigned long)_itemsCount] forState:UIControlStateNormal];
        NSLog(@"delete--> _tempMutDicts:%lu",(unsigned long)_tempMutDicts.count);
    }else{//恢复选中
        _itemsCount++;
        NSString *key = [NSString stringWithFormat:@"%d",currentIndex];
        [_tempMutDicts setObject:[_mutDictsAndNoOperation objectForKey:key] forKey:key];
        [_checkedBtn setImage:[UIImage imageNamed:@"OK.png"] forState:UIControlStateNormal];
        [_completeBtn setTitle:[NSString stringWithFormat:@"完成(%lu)",(unsigned long)_itemsCount] forState:UIControlStateNormal];
        NSLog(@"add  --> _tempMutDicts:%lu",(unsigned long)_tempMutDicts.count);
    }
    
}

#pragma  mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //设定y为0
    _scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    //滚动图片，改变小点的显示位置
    int index = fabs(_scrollView.contentOffset.x) / _scrollView.frame.size.width;
    if (currentIndex != index) {
        NSLog(@"index:%d",index);
        self.title= [NSString stringWithFormat:@"%d",index];
        currentIndex = index;
        _flag = NO;
        [_checkedBtn setImage:[UIImage imageNamed:@"OK.png"] forState:UIControlStateNormal];
    }
    
}

- (void)completeClick:(UIButton *)button{

    //获取最终选择的array
    _checkArray = [NSMutableArray arrayWithArray:[_tempMutDicts allValues]];
    
    NSLog(@"complete click _checkArray:%lu",(unsigned long)_checkArray.count);
    if (_previewFinishBlock) {
        _previewFinishBlock(_checkArray);
    }
    [self dismissViewControllerAnimated:YES completion:Nil];
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

@end
