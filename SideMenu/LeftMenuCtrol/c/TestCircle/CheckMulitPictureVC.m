//
//  CheckMulitPictureVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/12.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#define CollectionCellSizeMake CGSizeMake((self.view.frame.size.width -35)/3+1, 100)

#import "CheckMulitPictureVC.h"
#import "ZYQAssetPickerController.h"
#import "ShowBigViewController.h"
#import "PreViewViewController.h"
#import "PreviewCollectionVC.h"


@interface CheckMulitPictureVC ()<ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *_picturesArray;
    UIActionSheet *myActionSheet;
    NSString *filePath;
}
@end

@implementation CheckMulitPictureVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _picturesArray = [[NSMutableArray alloc] init];
    [_picturesArray addObject:[UIImage imageNamed:@"btn_add_photo_s"]];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
     self.collectionView.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}


- (void)check{
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
    
    picker.maximumNumberOfSelection = MAX_CANON;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings){
        if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
            return duration >= 5;
        }else{
            return  YES;
        }
    }];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - ZYQAssetPickerControllerDelegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets;
{
    NSLog(@"self.itemArray is %lu",(unsigned long)assets.count);
    NSLog(@"assets is %lu",(unsigned long)assets.count);
    //跳转到显示大图的页面
    /*
    ShowBigViewController *big = [[ShowBigViewController alloc]init];
    big.arrayOK = [NSMutableArray arrayWithArray:assets];
    NSLog(@"arraryOk is %lu",(unsigned long)big.arrayOK.count);
    [picker pushViewController:big animated:YES];
    */
    
    
    //PreViewViewController *preview = [[PreViewViewController alloc] init];
    PreviewCollectionVC *preview = [[PreviewCollectionVC alloc] init];
    preview.selectedArray = [NSMutableArray arrayWithArray:assets];
    preview.previewFinishBlock = ^(NSMutableArray *array){
        for(int i=0;i<array.count;i++){
            ALAsset *asset= assets[i];
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            //tempImg = [self thumbnailWithImageWithoutScale:tempImg size:CollectionCellSizeMake];
            [_picturesArray insertObject:tempImg atIndex:_picturesArray.count-1];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    };
    
    [picker pushViewController:preview animated:YES];
    
    
    
    
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == myActionSheet.cancelButtonIndex){
        NSLog(@"取消");
    }
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self check];
            break;
        default:
            break;
    }
}

-(void)takePhoto{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _picturesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    imagev.image = [_picturesArray objectAtIndex:indexPath.row];
    /*
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-15, cell.frame.size.width, 15)];
    l.textAlignment = NSTextAlignmentCenter;
    l.font = [UIFont systemFontOfSize:14];
    l.text = [NSString stringWithFormat:@"image %ld",(long)indexPath.row];
    if (indexPath.row == _picturesArray.count-1) {
        l.text = @"添加图片";
    }
    l.textColor = [UIColor blackColor];
    l.backgroundColor = [UIColor clearColor];
    
    [cell.contentView addSubview:l];
     */
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    [cell.contentView addSubview:imagev];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CollectionCellSizeMake;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


#pragma mark <UICollectionViewDelegate>

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //cell.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"indexPath.section:%ld,indexPath.row:%ld",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.row == _picturesArray.count-1) {
        
        myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
        //显示
        [myActionSheet showInView:self.view];
    }
    
}

//选择某张照片之后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self reloadDataWithImage:img];
        return;
    }
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)reloadDataWithImage:(UIImage *)image{

    //1. add image
    //2. 展示
    //image = [self thumbnailWithImageWithoutScale:image size:CollectionCellSizeMake];
    
    [_picturesArray insertObject:image atIndex:_picturesArray.count-1];
    [self.collectionView reloadData];
}

//保持图片原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/1;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/1;
        }
        
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


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
