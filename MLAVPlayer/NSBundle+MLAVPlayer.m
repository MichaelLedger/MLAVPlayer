//
//  NSBundle+MLAVPlayer.m
//  MLAVPlayer
//
//  Created by MountainX on 2019/7/20.
//

#import "NSBundle+MLAVPlayer.h"
#import "MLAVPlayer.h"

@implementation NSBundle (MLAVPlayer)

+ (instancetype)ml_avplayerBundle {
    static NSBundle *avplayerBundle = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        avplayerBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[MLAVPlayer class]] pathForResource:@"MLAVPlayer" ofType:@"bundle"]];
//    });
    if (avplayerBundle == nil) {
        NSString *path = [[NSBundle bundleForClass:[MLAVPlayer class]] pathForResource:@"MLAVPlayer" ofType:@"bundle"];
        avplayerBundle = [NSBundle bundleWithPath:path];
    }
    return avplayerBundle;
}

@end
