//
//  MLAVPlayer.h
//
//  Created by ML on 2019/7/16.
//  Copyright © 2019 ML. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BackBtnClickBlock)(void);
typedef void(^ScaleBtnClickBlock)(BOOL fullScreen);

@interface MLAVPlayer : UIView

// 视频or视频的URL，本地路径or网络路径http
@property (nonatomic, strong) NSURL    *videoURL;

// 是否循环播放（不循环则意味着需要手动触发第二次播放）
@property (nonatomic,assign) BOOL  loopPlay;

/**
 返回回调
 */
@property (copy, nonatomic) BackBtnClickBlock backBlock;

/**
 缩放回调
 */
@property (copy, nonatomic) ScaleBtnClickBlock scaleBlock;

/**
 播放结束回调
 */
@property (nonatomic, copy) void (^playerDidToEnd)(void);

+ (instancetype)player;

/**
 播放
 */
- (void)play;

/**
 暂停
 */
- (void)pause;

@end

NS_ASSUME_NONNULL_END
