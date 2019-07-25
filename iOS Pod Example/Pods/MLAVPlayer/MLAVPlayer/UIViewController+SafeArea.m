//
//  UIViewController+SafeArea.m
//  iOS Example
//
//  Created by MountainX on 2019/7/22.
//  Copyright © 2019 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "UIViewController+SafeArea.h"

@implementation UIViewController (SafeArea)

- (UIEdgeInsets)ml_safeArea {
    if (@available(iOS 11.0, *)) {
        return self.view.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

@end
