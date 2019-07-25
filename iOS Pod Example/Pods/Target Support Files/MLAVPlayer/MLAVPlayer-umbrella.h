#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AVPlayer+SeekSmoothly.h"
#import "MLAVPlayer.h"
#import "NSBundle+MLAVPlayer.h"
#import "UIImage+Extend.h"
#import "UIViewController+SafeArea.h"

FOUNDATION_EXPORT double MLAVPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char MLAVPlayerVersionString[];

