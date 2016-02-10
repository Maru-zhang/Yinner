//
//  YKPersonInfoController.m
//  Yinner
//
//  Created by Maru on 15/8/3.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKPersonInfoController.h"
#import "ReuseFrame.h"

#define KPickerH 227

@interface YKPersonInfoController ()
{
    NSArray *_ProvincesAndCities;
    NSArray *_cityArray;//城市的数组
    UIView *_maskView;
}

@end

@implementation YKPersonInfoController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSetting];
    
    [self setupView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}


#pragma mark - Private Method
- (void)setupSetting
{
    //加载所有数据
    if (!_ProvincesAndCities) {
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"ProvincesAndCities" withExtension:@"plist"];
        _ProvincesAndCities = [NSArray arrayWithContentsOfURL:url];
    }
    
    //加载城市数组
    if (!_cityArray) {
        
        NSDictionary *cities = _ProvincesAndCities[0];
        _cityArray = [cities objectForKey:@"Cities"];
    }
}

- (void)setupView
{
    //懒加载遮罩层
    if (!_maskView) {
        
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KwinW, 378)];
        
        _maskView.backgroundColor = [UIColor grayColor];
        
        _maskView.alpha = 0.6;
        
        [self.view addSubview:_maskView];
        
        _maskView.hidden = YES;
    }
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        
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
    
    //地区选择
    if (indexPath.section == 1 && indexPath.row == 2) {
        
        _pickerCell.frame = CGRectMake(0, KwinH, KwinW, KPickerH);
        
        _pickerCell.hidden = NO;
        
        _maskView.hidden = NO;
        
        //选择器出现动画
        [UIView animateWithDuration:0.2 animations:^{

            _pickerCell.frame = CGRectMake(0, 378, KwinW, KPickerH);
            
            NSLog(@"%@",NSStringFromCGRect(_pickerCell.frame));
        }];
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

#pragma mark - PickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        
        return _ProvincesAndCities.count;
    }
    else
    {
        return _cityArray.count;
    }
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component == 0) {
        
        NSDictionary *dic = _ProvincesAndCities[row];
        
        NSString *Provinces = [dic objectForKey:@"State"];
        
        return Provinces;
    }
    else
    {
        NSDictionary *dic = _cityArray[row];
        
        NSString *cityName = [dic objectForKey:@"city"];
        
        return cityName;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        NSDictionary *cities = _ProvincesAndCities[row];
        _cityArray = [cities objectForKey:@"Cities"];
        
        //重新加载
        [_picker reloadComponent:1];
    }
}


#pragma mark - Event Hander
- (IBAction)confirm:(id)sender {
    
    _maskView.hidden = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _pickerCell.frame = CGRectMake(0, KwinH, KwinW, 227);
        
    }];
    
    //相关结果处理
    NSInteger provincesIndex = [_picker selectedRowInComponent:0];
    NSInteger cityIndex = [_picker selectedRowInComponent:1];
    
    NSString *province = [_ProvincesAndCities[provincesIndex] objectForKey:@"State"];
    NSString *city = [_cityArray[cityIndex] objectForKey:@"city"];
    NSString *result = [NSString stringWithFormat:@"%@ %@",province,city];
    
    _areaLable.text = result;
    
}

- (IBAction)cancel:(id)sender {
    
    _maskView.hidden = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _pickerCell.frame = CGRectMake(0, KwinH, KwinW, 227);
        
    }];
}
@end
