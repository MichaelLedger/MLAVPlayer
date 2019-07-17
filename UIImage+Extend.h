//
//  UIImage+Extend.h
//
//  Created by ML on 2019/7/16.
//  Copyright (c) 2015年 ML. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Extend)

/**
 * 根据颜色生成图片
 */
+(UIImage*)imageWithColor:(UIColor*)color;

/**
 绘制指定大小的图片
 */
- (UIImage *)scaleToSize:(CGSize)size;

/**
 将图片转化裁剪为圆形的头像
 @param inset 从中间裁剪为圆形,参数为偏移量
 @return 圆形的头像
 */
-(UIImage*)imageToHeadViewWithParam:(CGFloat)inset;

@end
