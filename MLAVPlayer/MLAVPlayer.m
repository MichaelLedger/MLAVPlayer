//
//  MLAVPlayer.m
//
//  Created by MTX on 2019/7/16.
//  Copyright © 2019 MTX. All rights reserved.
//

#import "MLAVPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+Extend.h"

#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:a]
#define RGBHEX(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
#define RGBHEXA(hex,a) [UIColor colorWithRed:((float)(((hex) & 0xFF0000) >> 16))/255.0 green:((float)(((hex) & 0xFF00)>>8))/255.0 blue: ((float)((hex) & 0xFF))/255.0 alpha:(a)]

static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;

@interface MLAVPlayer () <UIGestureRecognizerDelegate>

// UI
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *lightBtn;
@property (weak, nonatomic) IBOutlet UIView *toolBar;
@property (weak, nonatomic) IBOutlet UIButton *backwardBtn;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *scaleBtn;
@property (weak, nonatomic) IBOutlet UIView *lightCtrlView;
@property (weak, nonatomic) IBOutlet UIImageView *lightMaxIv;
@property (weak, nonatomic) IBOutlet UISlider *lightSlider;
@property (weak, nonatomic) IBOutlet UIImageView *lightMinIv;
@property (weak, nonatomic) IBOutlet UIView *voiceCtrlView;
@property (weak, nonatomic) IBOutlet UIImageView *voiceMaxIv;
@property (weak, nonatomic) IBOutlet UISlider *voiceSlider;
@property (weak, nonatomic) IBOutlet UIImageView *voiceMinIv;

// 播放器player
@property (nonatomic,retain) AVPlayer   *player;
//当前播放的item
@property (nonatomic,retain) AVPlayerItem   *currentItem;
//playerLayer,可以修改frame
@property (nonatomic,retain) AVPlayerLayer  *playerLayer;
@property (nonatomic, strong) UISlider *systemVolumeSlider;
//监听播放起状态的监听者
@property (nonatomic,strong) id playbackTimeObserver;
//是否正在拖曳进度条
@property (nonatomic,assign) BOOL isDragingSlider;
//视频进度条的单击手势
@property (nonatomic, strong) UITapGestureRecognizer *progressTap;
// 音频播放器

@end

@implementation MLAVPlayer

+ (instancetype)player {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MLAVPlayer" owner:self options:nil];
    MLAVPlayer *player = nibs.firstObject;
    [player addObservers];
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    return player;
}

- (void)dealloc {
    [self pause];
    [self.player removeTimeObserver:self.playbackTimeObserver];
    [self.player removeObserver:self forKeyPath:@"timeControlStatus"];
    self.player = nil;
    self.playerLayer = nil;
    self.currentItem = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIApplication sharedApplication].idleTimerDisabled=NO;
}

#pragma mark - Public Method
- (void)play {
    self.playOrPauseBtn.selected = YES;
    [self.player play];
}

- (void)pause {
    self.playOrPauseBtn.selected = NO;
    [self.player pause];
}

#pragma mark - AwakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor blackColor];
    
    _voiceCtrlView.hidden = YES;
    _lightCtrlView.hidden = YES;
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"MLAVPlayer" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    [_backBtn setImage:[[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_support_return@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_lightBtn setImage:[[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_support_bright@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_backwardBtn setImage:[[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_video_-10s@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_playOrPauseBtn setImage:[[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_video_play@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_playOrPauseBtn setImage:[[UIImage imageWithContentsOfFile:[bundle pathForResource:@"player_ctrl_icon_pause@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [_forwardBtn setImage:[[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_video_+10s@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_voiceBtn setImage:[[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_video_volume@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_scaleBtn setImage:[[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_video_Full screen@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_scaleBtn setImage:[[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_video_Exit full screen@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    
    [_timeSlider setMinimumTrackTintColor:RGBHEX(0xF5A623)];
    [_timeSlider setMaximumTrackTintColor:RGBHEXA(0xFFFFFF, 0.5)];
    [_timeSlider setThumbImage:[[[UIImage imageWithColor:RGBHEX(0xF5A623)] scaleToSize:CGSizeMake(8, 8)] imageToHeadViewWithParam:0] forState:UIControlStateNormal];
    _timeSlider.value = 0;
    _timeSlider.minimumValue = 0.0;
    _timeSlider.maximumValue = 1.0;
    //监听滑块滑动进行事件
    [_timeSlider addTarget:self action:@selector(sliderChanging:) forControlEvents:UIControlEventValueChanged];
    //监听滑块滑动完成事件
    [_timeSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    //给进度条添加单击手势
    self.progressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    self.progressTap.delegate = self;
    [_timeSlider addGestureRecognizer:self.progressTap];
    
    _lightMaxIv.image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_support_bright3@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _lightMinIv.image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_support_bright2@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _voiceMaxIv.image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_video_volume3@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _voiceMinIv.image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:@"icon_video_volume2@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [_lightSlider setMinimumTrackTintColor:RGBHEX(0xFFFFFF)];
    [_lightSlider setMaximumTrackTintColor:RGBHEXA(0xFFFFFF, 0.2)];
    [_lightSlider setThumbImage:[[[UIImage imageWithColor:RGBHEX(0xFFFFFF)] scaleToSize:CGSizeMake(8, 8)] imageToHeadViewWithParam:0] forState:UIControlStateNormal];
    _lightSlider.value = [UIScreen mainScreen].brightness;
    _lightSlider.minimumValue = 0.0;
    _lightSlider.maximumValue = 1.0;
    //监听滑块滑动进行事件
    [_lightSlider addTarget:self action:@selector(sliderChanging:) forControlEvents:UIControlEventValueChanged];
    //监听滑块滑动完成事件
    [_lightSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventTouchUpInside];
    _lightSlider.layer.anchorPoint = CGPointMake(0.5, 0.5);
    _lightSlider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    [_voiceSlider setMinimumTrackTintColor:RGBHEX(0xFFFFFF)];
    [_voiceSlider setMaximumTrackTintColor:RGBHEXA(0xFFFFFF, 0.2)];
    [_voiceSlider setThumbImage:[[[UIImage imageWithColor:RGBHEX(0xFFFFFF)] scaleToSize:CGSizeMake(8, 8)] imageToHeadViewWithParam:0] forState:UIControlStateNormal];
    _voiceSlider.value = 0;
    _voiceSlider.minimumValue = 0.0;
    _voiceSlider.maximumValue = 1.0;
    //监听滑块滑动进行事件
    [_voiceSlider addTarget:self action:@selector(sliderChanging:) forControlEvents:UIControlEventValueChanged];
    //监听滑块滑动完成事件
    [_voiceSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventTouchUpInside];
    _voiceSlider.layer.anchorPoint = CGPointMake(0.5, 0.5);
    _voiceSlider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    MPVolumeView *volumeView = [[MPVolumeView alloc]init];
    for (UIControl *view in volumeView.subviews) {
        if ([view.superclass isSubclassOfClass:[UISlider class]]) {
            _systemVolumeSlider = (UISlider *)view;
            //在app刚刚初始化的时候使用MPVolumeView获取音量大小为0
            _voiceSlider.value = _systemVolumeSlider.value > 0 ? _systemVolumeSlider.value : [[AVAudioSession sharedInstance] outputVolume];
            break;
        }
    }
    
}

#pragma mark - Private Methods
#pragma mark - Setter
- (void)setCurrentItem:(AVPlayerItem *)currentItem {
    _currentItem = currentItem;
    [_currentItem addObserver:self
                   forKeyPath:@"status"
                      options:NSKeyValueObservingOptionNew
                      context:PlayViewStatusObservationContext];
    
    [_currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
    // 缓冲区空了，需要等待数据
    [_currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options: NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
    // 缓冲区有足够数据可以播放了
    [_currentItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options: NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
    
    [_currentItem addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
    
    [_currentItem addObserver:self forKeyPath:@"presentationSize" options:NSKeyValueObservingOptionNew context:PlayViewStatusObservationContext];
    
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
}

- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
    if (self.currentItem) {//已初始化
        AVURLAsset *urlAsset = (AVURLAsset *)self.currentItem.asset;
        if (urlAsset.URL != self.videoURL) {//播放地址更改
            self.currentItem = [AVPlayerItem playerItemWithAsset:[AVURLAsset assetWithURL:self.videoURL]];
            [self.player replaceCurrentItemWithPlayerItem:self.currentItem];
            _timeSlider.value = 0;
            [self pause];
        }
    } else {
        self.currentItem = [AVPlayerItem playerItemWithAsset:[AVURLAsset assetWithURL:self.videoURL]];
        self.player = [AVPlayer playerWithPlayerItem:self.currentItem];
        self.player.actionAtItemEnd = self.loopPlay ? AVPlayerActionAtItemEndNone : AVPlayerActionAtItemEndPause;
        self.currentItem = [AVPlayerItem playerItemWithAsset:[AVURLAsset assetWithURL:self.videoURL]];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.frame = self.layer.bounds;
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.layer insertSublayer:self.playerLayer atIndex:0];
        //监听播放状态
        [self initTimer];
        // 暂停/播放的监听,iOS10之后。iOS10之前,用rate，但有问题
        [self.player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    /* AVPlayerItem "status" property value observer. */
    if (context == PlayViewStatusObservationContext){
        if ([keyPath isEqualToString:@"status"]) {
            AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            switch (status){
                case AVPlayerItemStatusUnknown:
                {
                    
                }
                    break;
                case AVPlayerItemStatusReadyToPlay:
                {
                    self.timeSlider.maximumValue = [self duration];
                }
                    break;
                    
                case AVPlayerItemStatusFailed:
                {
                    NSError *error = [self.player.currentItem error];
                    NSLog(@"视频加载失败===%@",error.description);
                }
                    break;
            }
        }else if ([keyPath isEqualToString:@"duration"]) {
            
        }else if ([keyPath isEqualToString:@"presentationSize"]) {
            
        }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            // 缓冲进度
            
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            // 当缓冲是空的时候

        }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            // 当缓冲好的时候
        }
    }else{
        if ([keyPath isEqualToString:@"timeControlStatus"]){
            NSInteger playStatus = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            if (playStatus == 1) {
                NSLog(@"准备");
            } else if (playStatus == 2){
                NSLog(@"播放了");
            } else {
                NSLog(@"暂停了");
            }
        }
    }
}

#pragma mark - Observers
- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustLightSliderValue:) name:UIScreenBrightnessDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustVoiceSilderValue:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

- (void)adjustLightSliderValue:(NSNotification *)noti {
    _lightSlider.value = [UIScreen mainScreen].brightness;
}

- (void)adjustVoiceSilderValue:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    float value = [[userInfo objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    _voiceSlider.value = value;
}

#pragma mark - 监听播放状态
- (void)initTimer {
    __weak __typeof(self) weakSelf = self;
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        [weakSelf syncTimeSlider];
    }];
}

#pragma mark - 同步进度条
- (void)syncTimeSlider {
    //拖拽slider中，不更新slider的值
    if (self.isDragingSlider) {
        return;
    }
    _timeSlider.value = [self currentTime];
}

#pragma mark - 播放完成
- (void)moviePlayDidEnd:(NSNotification *)notification {
    [self.player seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        if (finished) {
            if(!self.loopPlay){
                [self pause];
            } else {
                [self play];
            }
        }
    }];
}

#pragma mark - 视频进度条的点击事件
- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
    CGPoint touchLocation = [sender locationInView:_timeSlider];
    CGFloat value = (_timeSlider.maximumValue - _timeSlider.minimumValue) * (touchLocation.x/_timeSlider.frame.size.width);
    [_timeSlider setValue:value animated:YES];
    
    [self.player seekToTime:CMTimeMakeWithSeconds(self.timeSlider.value, self.currentItem.currentTime.timescale)];
    if (self.player.rate != 1.f) {
        self.playOrPauseBtn.selected = NO;
        [self play];
    }
}

#pragma mark - IBActions
- (IBAction)backwardBtnClicked:(UIButton *)sender {
    [self.player pause];
    Float64 seconds = ([self currentTime] - 10) > 0 ? ([self currentTime] - 10) : 0;
    [self.player seekToTime:CMTimeMakeWithSeconds(seconds, self.currentItem.currentTime.timescale) completionHandler:^(BOOL finished) {
        [self play];
    }];
}
- (IBAction)playOrPauseBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [self pause];
    } else {
        [self play];
    }
}
- (IBAction)forwardBtnClicked:(UIButton *)sender {
    [self.player pause];
    Float64 seconds = ([self currentTime] + 10) < [self duration] ? ([self currentTime] + 10) : [self duration];
    [self.player seekToTime:CMTimeMakeWithSeconds(seconds, self.currentItem.currentTime.timescale) completionHandler:^(BOOL finished) {
        [self play];
    }];
}
- (IBAction)voiceBtnClicked:(UIButton *)sender {
    _lightCtrlView.hidden = YES;
    _voiceCtrlView.hidden = !_voiceCtrlView.hidden;
}
- (IBAction)scaleBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.scaleBlock) {
        self.scaleBlock(sender.selected);
    }
}
- (IBAction)backBtnClicked:(UIButton *)sender {
    [self removeFromSuperview];
    if (self.backBlock) {
        self.backBlock();
    }
}
- (IBAction)lightBtnClicked:(UIButton *)sender {
    _voiceCtrlView.hidden = YES;
    _lightCtrlView.hidden = !_lightCtrlView.hidden;
}
- (IBAction)singleTap:(UITapGestureRecognizer *)sender {
    self.toolBar.hidden = !self.toolBar.hidden;
    if (self.toolBar.hidden) {
        self.backBtn.hidden = YES;
        self.lightBtn.hidden = YES;
        self.lightCtrlView.hidden = YES;
        self.voiceCtrlView.hidden = YES;
        self.lightBtn.selected = NO;
        self.voiceBtn.selected = NO;
    } else {
        self.backBtn.hidden = NO;
        self.lightBtn.hidden = NO;
        self.lightCtrlView.hidden = YES;
        self.voiceCtrlView.hidden = YES;
        self.lightBtn.selected = NO;
        self.voiceBtn.selected = NO;
    }
}

#pragma mark - Slider Change Method
- (void)sliderChanging:(UISlider *)sender {
    self.isDragingSlider = YES;
    if (sender == self.timeSlider) {
        [self.player pause];
        Float64 seconds = self.timeSlider.value;
        if (seconds < 0) seconds = 0;
        if (seconds > [self duration]) seconds = [self duration];
        [self.player seekToTime:CMTimeMakeWithSeconds(seconds, self.currentItem.currentTime.timescale) completionHandler:^(BOOL finished) {
            [self play];
        }];
    } else if (sender == self.lightSlider) {
        [UIScreen mainScreen].brightness = self.lightSlider.value;
    } else if (sender == self.voiceSlider) {
        _systemVolumeSlider.value = self.voiceSlider.value;
    }
}

- (void)sliderChanged:(UISlider *)sender {
    self.isDragingSlider = NO;
}

//获取视频长度
- (double)duration{
    AVPlayerItem *playerItem = self.player.currentItem;
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        return CMTimeGetSeconds([[playerItem asset] duration]);
    }else{
        return 0.f;
    }
}
//获取视频当前播放的时间
- (double)currentTime{
    if (self.player) {
        return CMTimeGetSeconds([self.player currentTime]);
    }else{
        return 0.0;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.toolBar || [touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    return YES;
}

@end
