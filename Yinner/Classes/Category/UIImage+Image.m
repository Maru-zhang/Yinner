//
//  UIImage+Image.m
//  ShopAssistant
//
//  Created by Maru on 15/3/16.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)

+(UIImage *)stretchImageWithName:(NSString *)icon
{
    UIImage *image = [UIImage imageNamed:icon];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.7];
}

@end
