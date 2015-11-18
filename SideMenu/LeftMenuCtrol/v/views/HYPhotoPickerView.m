//
//  HYPhotoPickerManager.m
//  ActionSheet
//
//  Created by AEF-RD-1 on 15/11/5.
//  Copyright © 2015年 hyIm. All rights reserved.
//

#import "HYPhotoPickerView.h"

@interface HYPhotoPickerView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (strong,nonatomic) UIViewController *formVC;
@property (strong,nonatomic) PhotoPickerCompelitionBlock    compelitionBlock;
@property (strong,nonatomic) PhotoPickerCancelBlock         cancelBlock;

@end

@implementation HYPhotoPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (HYPhotoPickerView *)shard{
    static HYPhotoPickerView *photo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photo = [[self alloc] init];
    });
    return photo;
}
- (void)showActionInViewController:(UIViewController *)formController completion:(PhotoPickerCompelitionBlock)completion cancelBlock:(PhotoPickerCancelBlock)cancelBlock{
    
    self.compelitionBlock = completion;
    self.cancelBlock = cancelBlock;
    self.formVC = formController;
    self.formVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //子线程运行
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIActionSheet *actionSheet = nil;
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [actionSheet showInView:formController.view];
        });
        
    });
    return;
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.navigationBar.tintColor = [UIColor blackColor];

    switch (buttonIndex) {
        case 0:
            //拍照
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;//图片源为相机
            [self.formVC presentViewController:picker animated:YES completion:^{}];
            break;
        case 1:
            //相册选取
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;//图片源为相册;
            [self.formVC presentViewController:picker animated:YES completion:^{}];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    /**
     *  UIImagePickerControllerOriginalImage    选择的整张图片（原始图片）
     *  UIImagePickerControllerEditedImage      裁剪部分，(选取框类型)
     */
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];//选取框类型
    if (img && self.compelitionBlock) {
        
        [self saveImage:img];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.compelitionBlock(img);
        });
        
        
    }
    
    [self.formVC dismissViewControllerAnimated:YES completion:nil];
    return;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self.formVC dismissViewControllerAnimated:YES completion:nil];
    return;
}

#pragma mark - 把图片保存到本地
//保存到本地
- (void)saveImage:(UIImage *)image{
    
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:kMyHeadPortraitName];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    //UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    //UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //self.userImage.image = selfPhoto;
    
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
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
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


@end
