//
//  PreviewCollectionVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/14.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import "PreviewCollectionVC.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PreviewCollectionVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIButton *_completeBtn; //完成
    UIButton *_checkedBtn;  //选择/取消
    NSMutableArray *_checkArray;    //最终选择的结果
    int currentIndex;
    NSMutableDictionary *_tempMutDicts;     //保存asset生成的字典
    BOOL _flag;
    /**
     *  此字典的元素最开始和_tempMutDicts一样，因为_tempMutDicts要做删除或者设值操作，_mutDictsAndNoOperation则用来作对比，这样，即使_tempMutDicts删除了，要添加时，也能在_mutDictsAndNoOperation中找到key对应的值
     */
    NSMutableDictionary *_mutDictsAndNoOperation;
    NSInteger _itemsCount;      //前一页面选择的图片总数，
}

@property (strong,nonatomic) UICollectionView *collectionView;

@end

@implementation PreviewCollectionVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init
    _checkArray = [[NSMutableArray alloc] init];
    _tempMutDicts = [[NSMutableDictionary alloc] init];
    _mutDictsAndNoOperation = [[NSMutableDictionary alloc] init];
    _flag = NO;
    _itemsCount = self.selectedArray.count;
    
    //右上按钮
    [self addCheckOrCancelBtn];
    
    [self createCollectionView];
    
    //init data
    for (int i=0; i<[self.selectedArray count]; i++) {
        ALAsset *asset=self.selectedArray[i];
        [_tempMutDicts setObject:asset forKey:[NSString stringWithFormat:@"%d",i]];//生成key=i,value=asset的字典，添加到
    }
    _mutDictsAndNoOperation = [NSMutableDictionary dictionaryWithDictionary:_tempMutDicts];
    NSLog(@"_tempMutDicts:%@",_tempMutDicts);
    NSLog(@"_mutDictsAndNoOperation:%@",_mutDictsAndNoOperation);
    
    [self addBottomView];
}

/**
 *  创建 collectionView
 */
- (void)createCollectionView{
    
    //layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//设置水平滚动
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;
    [self.view addSubview:self.collectionView];
    //注册Cell类，否则崩溃: must register a nib or a class for the identifier or connect a prototype cell in a storyboard
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

/**
 *  选择与取消
 */
- (void)addCheckOrCancelBtn{
    _checkedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkedBtn.frame=CGRectMake(0, 0, 22, 22);
    [_checkedBtn setImage:[UIImage imageNamed:@"OK.png"] forState:UIControlStateNormal];
    [_checkedBtn addTarget:self action:@selector(checkOrCancelClick:)forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_checkedBtn];
}

/**
 *  完成按钮(button)
 */
- (void)addBottomView{
    //bottom view
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-114, self.view.frame.size.width, 50)];
    bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    bottomView.alpha = .9;
    
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeBtn.frame = CGRectMake(bottomView.frame.size.width - 70,  (bottomView.frame.size.height-32)/2, 61, 32);
    [_completeBtn setBackgroundImage:[UIImage imageNamed:@"complete.png"] forState:UIControlStateNormal];
    [_completeBtn setTitle:[NSString stringWithFormat:@"完成(%lu)",(unsigned long)_itemsCount] forState:UIControlStateNormal];
    _completeBtn .titleLabel.font = [UIFont systemFontOfSize:10];
    [_completeBtn addTarget:self action:@selector(previewCompleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomView];
    [bottomView addSubview:_completeBtn];

}

- (void)checkOrCancelClick:(UIButton *)button{
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

- (void)previewCompleteClick:(UIButton *)button{
    
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

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.selectedArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    imagev.contentMode=UIViewContentModeScaleAspectFill;
    imagev.clipsToBounds=YES;
    ALAsset *asset=self.selectedArray[indexPath.row];
    UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    [imagev setImage:tempImg];
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    [cell.contentView addSubview:imagev];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.frame.size.width-10, self.view.frame.size.height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 5, 0, 5);
}
#pragma mark - <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@",,,,,,,,,,did select item %lu",indexPath.row);
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

/*
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.collectionView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    //滚动图片，改变小点的显示位置
    int index = fabs(self.collectionView.contentOffset.x) / self.collectionView.frame.size.width;
    if (currentIndex != index) {
        NSLog(@"index:%d",index);
        self.title= [NSString stringWithFormat:@"%d",index];
        currentIndex = index;
        _flag = NO;
        [_checkedBtn setImage:[UIImage imageNamed:@"OK.png"] forState:UIControlStateNormal];
    }
}

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
