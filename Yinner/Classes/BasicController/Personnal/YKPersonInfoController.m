//
//  YKPersonInfoController.m
//  Yinner
//
//  Created by Maru on 15/8/3.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKPersonInfoController.h"

@interface YKPersonInfoController ()

@end

@implementation YKPersonInfoController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSetting];
}


#pragma mark - Private Method
- (void)setupSetting
{
    
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            //打开摄像头
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                
                picker.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                
                picker.delegate = self;
                
                //设置拍照后的图片可被编辑
                
                picker.allowsEditing = YES;
                
                picker.sourceType = sourceType;
                
                [self presentViewController:picker animated:YES completion:nil];
                
            }else
            {
                NSLog(@"模拟其中无法打开照相机,请在真机中使用");
                
            }
            
        }];
        
        UIAlertAction *localPhoto = [UIAlertAction actionWithTitle:@"从本地相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            //打开本地相册
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            picker.delegate = self;
            
            //设置选择后的图片可被编辑
            
            picker.allowsEditing = YES;
            
            [self presentViewController:picker animated:YES completion:nil];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        
        [actionSheet addAction:takePhoto];
        [actionSheet addAction:localPhoto];
        [actionSheet addAction:cancel];
        
        
        [self presentViewController:actionSheet animated:YES completion:nil];
        
    }
}

#pragma mark - Pick Delegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
//    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
// 
//    //当选择的类型是图片
//    if ([type isEqualToString:@"public.image"])
//       
//    {
//
//        //先把图片转成NSData
//        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//
//        NSData *data;
//        
//        if (UIImagePNGRepresentation(image) == nil)
//            
//        {
//            
//            data = UIImageJPEGRepresentation(image, 1.0);
//            
//        }
//        
//        else
//            
//        {
//            
//            data = UIImagePNGRepresentation(image);
//            
//        }
//        
//        
//        
//        //图片保存的路径
//        
//        //这里将图片放在沙盒的documents文件夹中
//        
//        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        
//        
//        
//        //文件管理器
//        
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        
//        
//        
//        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
//        
//        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        
//        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
//        
//        //得到选择后沙盒中图片的完整路径
//        
////        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
//        
//        
//        
//        //关闭相册界面
//        
//        [picker dismissViewControllerAnimated:YES completion:nil];
//        
//        //创建一个选择后图片的小图标放在下方
//        
//        //类似微薄选择图后的效果
//        
//        UIImageView *smallimage = [[[UIImageView alloc] initWithFrame:
//                                    163
//                                    CGRectMake(50, 120, 40, 40)] autorelease];
//        
//        smallimage.image = image;
//        
//        //加在视图中
//        
//        [self.view addSubview:smallimage];
//     
//    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

@end
