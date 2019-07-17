//
//  UIImage+Extend.m
//
//  Created by ML on 2019/7/16.
//  Copyright (c) 2015年 ML. All rights reserved.
//

#import "UIImage+Extend.h"

@implementation UIImage(Extend)

/**
 * 根据颜色生成图片
 */
+(UIImage*)imageWithColor:(UIColor*)color{
    CGRect rect = CGRectMake(0, 0, 1.f, 1.f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
   // image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 0, 0) resizingMode:UIImageResizingModeTile];
    return image;
}


/**
 绘制指定大小的图片
 */
- (UIImage *)scaleToSize:(CGSize)size{
    
     CGFloat scale = [UIScreen mainScreen].scale;
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


/**
 将图片转化裁剪为圆形的头像
 */
-(UIImage*)imageToHeadViewWithParam:(CGFloat)inset{
    
    //先获取大小
    CGFloat lengthW = CGImageGetWidth(self.CGImage);
    CGFloat lengthH = CGImageGetHeight(self.CGImage);
    CGFloat cutSzie;
    //判断长宽比,获得最大正方形裁剪值
    if(lengthW>= lengthH){
        cutSzie = lengthH;
    }
    else cutSzie = lengthW;
    //执行裁剪(为正方形)
    CGImageRef sourceImageRef = [self CGImage]; //将UIImage转换成CGImageRef
    CGRect rect = CGRectMake(lengthW/2-cutSzie/2, lengthH/2 - cutSzie/2, cutSzie, cutSzie);  //构建裁剪区
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);    //按照给定的矩形区域进行剪裁
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];                     //将CGImageRef转换成UIImage
    //取圆形
    UIGraphicsBeginImageContextWithOptions(newImage.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect newrect = CGRectMake(inset, inset, newImage.size.width - inset * 2.0f, newImage.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, newrect);
    CGContextClip(context);
    
    [newImage drawInRect:newrect];
    CGContextAddEllipseInRect(context, newrect);
    CGContextStrokePath(context);
    UIImage *circleImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return circleImg;
}

@end
