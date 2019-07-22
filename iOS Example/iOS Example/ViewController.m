//
//  ViewController.m
//  iOS Example
//
//  Created by MountainX on 2019/7/17.
//  Copyright © 2019 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "ViewController.h"
#import "MLAVPlayer.h"
#import "UIViewController+SafeArea.h"
#import <Masonry.h>

@interface ViewController ()

// 用weak修饰，避免无法释放
@property (nonatomic, weak) MLAVPlayer *player;

@property (weak, nonatomic) IBOutlet UIButton *topBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MLAVPlayer *player = [MLAVPlayer player];
    [self.view addSubview:player];

    [player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view).mas_offset(self.ml_safeArea.left);
        make.trailing.mas_equalTo(self.view).mas_offset(self.ml_safeArea.right);
        make.top.mas_equalTo(self.view).mas_offset(self.ml_safeArea.top);
        make.bottom.mas_equalTo(self.topBtn.mas_top).mas_offset(-20);
    }];
    //是否循环播放
    player.loopPlay = YES;
//    __weak __typeof(self) weakSelf = self;
    player.backBlock = ^{
        //处理返回按钮点击
//        weakSelf.player = nil;
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

#pragma mark - 横竖屏切换
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    NSLog(@"===%@====", NSStringFromCGSize(size));
}

@end
