# MLAVPlayer
MLAVPlayer for Video &amp; Audio Play Interface

## 使用示例
```
MLAVPlayer *player = [MLAVPlayer player];
//网络视频
player.videoURL = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
[self.view addSubview:player];
//是否循环播放
player.loopPlay = YES;
[player mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(UIEdgeInsetsMake(60, 0, 80, 0));
}];
player.backBlock = ^{
    //处理返回按钮点击
};
player.scaleBlock = ^(BOOL fullScreen) {
    //处理缩放按钮点击
};
[player play];
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //网络视频
    //        player.videoURL = [NSURL URLWithString:@"https://media.w3.org/2010/05/sintel/trailer.mp4"];
    //本地视频
    //        player.videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"trailer" ofType:@"mp4"]];
    //本地音频
    player.videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bbc20190709_21306935GX" ofType:@"mp3"]];
    [player play];
});
```
