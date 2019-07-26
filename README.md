# MLAVPlayer
MLAVPlayer for Video &amp; Audio Play Interface

## 使用示例
```
MLAVPlayer *player = [MLAVPlayer player];
//网络视频
//        player.videoURL = [NSURL URLWithString:@"https://media.w3.org/2010/05/sintel/trailer.mp4"];
//本地视频
//        player.videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"trailer" ofType:@"mp4"]];
//本地音频
player.videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bbc20190709_21306935GX" ofType:@"mp3"]];
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
```

一个标准的podspec文件可以通过 `$ pod spec create <projectName>` 命令生成

检查podspec: `pod spec lint <projectName>.podspec`

*注册 cocoapods trunk*
```
$ pod trunk register MichaelLedger@163.com MichaelLedger
[!] Please verify the session by clicking the link in the verification email that has been sent to MichaelLedger@163.com
```
*上传 .podsepc 文件到 git 的 cocoapods/Specs 公开仓库*
```
$ pod trunk push MLAVPlayer.podspec
Updating spec repo `master`
Validating podspec
-> MLAVPlayer (1.0.1)
- NOTE  | xcodebuild:  note: Using new build system
- NOTE  | [iOS] xcodebuild:  note: Planning build
- NOTE  | [iOS] xcodebuild:  note: Constructing build description

Updating spec repo `master`

--------------------------------------------------------------------------------
🎉  Congrats

🚀  MLAVPlayer (1.0.1) successfully published
📅  July 16th, 23:27
🌎  https://cocoapods.org/pods/MLAVPlayer
👍  Tell your friends!
--------------------------------------------------------------------------------
```
*Cocoapods: pod search无法搜索到类库的解决办法*

1、删除~/Library/Caches/CocoaPods目录下的search_index.json文件


pod setup成功后会生成~/Library/Caches/CocoaPods/search_index.json文件。
终端输入rm ~/Library/Caches/CocoaPods/search_index.json

2、删除成功后再执行pod search

```
$ rm ~/Library/Caches/CocoaPods/search_index.json
$ pod search MLAVPlayer
-> MLAVPlayer (1.0.1)
Encapsulate AVPlayer
pod 'MLAVPlayer', '~> 1.0.1'
- Homepage: https://github.com/MichaelLedger/MLAVPlayer
- Source:   https://github.com/MichaelLedger/MLAVPlayer.git
- Versions: 1.0.1 [master repo]
```

更新Release版本（先将.podspec中的版本同步升级: `spec.version = "1.0.2"`）
```
$ git tag 1.0.2
$ git push origin 1.0.2
remote: Permission to MichaelLedger/MLAVPlayer.git denied to DevaLee.
fatal: unable to access 'https://github.com/MichaelLedger/MLAVPlayer.git/': The requested URL returned error: 403
```
Git clone 成功 git push 却 403错误 解决方案:

1. 在代码的.git/config文件内[remote “origin”]的url的gitlab域名前添加gitlab注册时的“用户名:密码@”
 
2. 这个用户要在对应项目下的角色是Owner或Master才行，如果是Guest、Reporter、Developer，则如下操作后也是不行。

```
$ git config remote.origin.url https://<username>:<password>@github.com/MichaelLedger/MLAVPlayer.git
$ git push origin 1.0.2
Total 0 (delta 0), reused 0 (delta 0)
To https://github.com/MichaelLedger/MLAVPlayer.git
* [new tag]         1.0.2 -> 1.0.2
```
标签提交完毕后即可上传升级后的 .podsepc 文件到 git 的 cocoapods/Specs 公开仓库
```
$ pod trunk push MLAVPlayer.podspec
Updating spec repo `master`

CocoaPods 1.7.5 is available.
To update use: `gem install cocoapods`

For more information, see https://blog.cocoapods.org and the CHANGELOG for this version at https://github.com/CocoaPods/CocoaPods/releases/tag/1.7.5

Validating podspec
-> MLAVPlayer (1.0.2)
- NOTE  | xcodebuild:  note: Using new build system
- NOTE  | [iOS] xcodebuild:  note: Planning build
- NOTE  | [iOS] xcodebuild:  note: Constructing build description

Updating spec repo `master`

CocoaPods 1.7.5 is available.
To update use: `gem install cocoapods`

For more information, see https://blog.cocoapods.org and the CHANGELOG for this version at https://github.com/CocoaPods/CocoaPods/releases/tag/1.7.5


--------------------------------------------------------------------------------
🎉  Congrats

🚀  MLAVPlayer (1.0.2) successfully published
📅  July 22nd, 04:52
🌎  https://cocoapods.org/pods/MLAVPlayer
👍  Tell your friends!
--------------------------------------------------------------------------------
```
