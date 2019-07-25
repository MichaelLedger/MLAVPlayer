//
//  AVPlayer+SeekSmoothly.h
//  iOS Example
//
//  Created by MountainX on 2019/7/22.
//  Copyright © 2019 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVPlayer (SeekSmoothly)

- (void)ss_seekToTime:(CMTime)time;

- (void)ss_seekToTime:(CMTime)time
 completionHandler:(void (^)(BOOL finished))completionHandler;

- (void)ss_seekToTime:(CMTime)time
      toleranceBefore:(CMTime)toleranceBefore
       toleranceAfter:(CMTime)toleranceAfter
    completionHandler:(void (^)(BOOL finished))completionHandler;

@end

NS_ASSUME_NONNULL_END
