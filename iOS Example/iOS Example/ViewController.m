//
//  ViewController.m
//  iOS Example
//
//  Created by MountainX on 2019/7/17.
//  Copyright © 2019 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "ViewController.h"
#import "MLAVPlayer.h"

@interface ViewController ()

@property (nonatomic, strong) MLAVPlayer *player;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MLAVPlayer *player = [MLAVPlayer player];
    [self.view addSubview:player];
    //是否循环播放
    player.loopPlay = YES;
    player.frame = CGRectMake(0, self.view.safeAreaInsets.top, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 2.0);
    player.backBlock = ^{
        //处理返回按钮点击
    };
    player.scaleBlock = ^(BOOL fullScreen) {
        //处理缩放按钮点击
    };
    self.player = player;
}
- (IBAction)swithToPlayOnlineVideo:(UIButton *)sender {
    //网络视频
    self.player.videoURL = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    [self.player play];
}

- (IBAction)switchToPlayVideo:(UIButton *)sender {
    //本地视频
    self.player.videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"trailer" ofType:@"mp4"]];
    [self.player play];
}
- (IBAction)switchToPlayAudio:(UIButton *)sender {
    //本地音频
    self.player.videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bbc20190709_21306935GX" ofType:@"mp3"]];
    [self.player play];
}


@end
