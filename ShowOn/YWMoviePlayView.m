//
//  YWMoviePlayView.m
//  ShowOn
//
//  Created by David Yu on 9/12/15.
//  Copyright © 2015年 yanwei. All rights reserved.
//

#import "YWMoviePlayView.h"
#import <AVFoundation/AVFoundation.h>

@interface YWMoviePlayView()

@property (nonatomic, strong)UIProgressView  *progress;//播放进度

@end
@implementation YWMoviePlayView
{
    AVPlayer        *_player;//播放器对象
    UIButton        *_playOrPause; //播放/暂停按钮
    NSTimeInterval   _totalBuffer;
    UILabel         *_timeLabel;
    NSTimer         *_timer;
    BOOL             _isEnd;
    BOOL             _isPlay;
    BOOL             _isRepeat;
    BOOL             _isRepeatAndNoCount;
}

- (instancetype)initWithFrame:(CGRect)frame playUrl:(NSString *)url {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap)];
        [self addGestureRecognizer:tap];

//        url = [[NSBundle mainBundle] pathForResource:@"video1.mov" ofType:nil];
        [self playWihUrl:url];
        [self setupUI];
        [self addGestureRecognizer];
    }
    
    return self;
}

-(void)dealloc{
    [self removeObserverFromPlayerItem:_player.currentItem];
    [self removeNotification];
}

#pragma mark - 私有方法
- (void)addGestureRecognizer {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionSwipe:)];
    [self addGestureRecognizer:pan];
}

- (void)actionSwipe:(UIPanGestureRecognizer *)pan {
    if (!_isEnd) {
        static CGPoint point;
        switch (pan.state) {
            case UIGestureRecognizerStateBegan:
                point = [pan locationInView:pan.view];
                break;
            case UIGestureRecognizerStateChanged:
            {
                CGPoint point1 = [pan locationInView:pan.view];
                CGFloat time = (point1.x - point.x)/2;
                [self setCurrentPlayWithTime:time];
                NSLog(@"=========%.2f", time);
                point = point1;
            }
                break;
            default:
                break;
        }
    }
}

- (void)setCurrentPlayWithTime:(CGFloat)time {
    float current = CMTimeGetSeconds(_player.currentTime);
    float total=CMTimeGetSeconds([_player.currentItem duration]);
    if (current+time<total && current+time>0) {
        [_progress setProgress:(current+time)/total animated:YES];
        [_player seekToTime:CMTimeMake(current+time, 1)];
    }else if(current+time>_totalBuffer) {
        [_progress setProgress:_totalBuffer/total animated:YES];
        [_player seekToTime:CMTimeMake(_totalBuffer, 1)];
    }else {
        _progress.progress = 0;
        [_player seekToTime:CMTimeMake(0, 1)];
        _isEnd = YES;
    }
}

-(void)setupUI{
    //创建播放器层
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame=self.bounds;
    playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;//视频填充模式
    [self.layer addSublayer:playerLayer];
    
    _playOrPause = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-30, self.bounds.size.height/2-30, 60, 60)];
    [_playOrPause setImage:[UIImage imageNamed:@"play_big.png"] forState:UIControlStateNormal];
    [_playOrPause setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [_playOrPause addTarget:self action:@selector(actionPlayOrPasue) forControlEvents:UIControlEventTouchUpInside];
    [self.layer addSublayer:_playOrPause.layer];
    
    _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(20, self.frame.size.height-5, [UIScreen mainScreen].bounds.size.width-40, 5)];
    _progress.trackTintColor = [UIColor lightGrayColor];
    _progress.progressTintColor = [UIColor orangeColor];
    _progress.hidden = YES;
    [self.layer addSublayer:_progress.layer];
}

-(void)playWihUrl:(NSString *)urlStr {
    _urlStr = urlStr;
    if (!_player) {
        urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *sourceMovieURL = [NSURL URLWithString:urlStr];
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        _player=[AVPlayer playerWithPlayerItem:playerItem];
        [self addProgressObserver];
        [self addObserverToPlayerItem:playerItem];
        [self addNotification];

        [_player pause];
    }
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    _isPlay = NO;
    _isRepeat = NO;
    [self removeNotification];
    [self removeObserverFromPlayerItem:_player.currentItem];
    urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *sourceMovieURL = [NSURL URLWithString:urlStr];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    [self addObserverToPlayerItem:playerItem];
    //切换视频
    [_player replaceCurrentItemWithPlayerItem:playerItem];
    [_player pause];
//    [_player play];
    [self addProgressObserver];
    [self addNotification];
}

- (void)setIsCountdown:(BOOL)isCountdown {
    _isCountdown = isCountdown;
}

#pragma mark - 通知
/**
 *  添加播放器通知
 */
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
    _progress.progress = 0;
    _playOrPause.selected = NO;
    _playOrPause.hidden = NO;
    _isPlay = NO;
    _isRepeatAndNoCount = YES;
    if ([_delegate respondsToSelector:@selector(moviePlayViewPlayDown:)]) {
        [_delegate moviePlayViewPlayDown:self];
    }
}

#pragma mark - 监控
/**
 *  给播放器添加进度更新
 */
-(void)addProgressObserver{
    AVPlayerItem *playerItem=_player.currentItem;
    __weak YWMoviePlayView *this = self;
    //这里设置每秒执行一次
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 10.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current=CMTimeGetSeconds(time);
        float total=CMTimeGetSeconds([playerItem duration]);
        NSLog(@"当前已经播放%.2fs. %.2f",current, total);
        if (current) {
            [this.progress setProgress:(current/total) animated:YES];
        }
    }];
}

/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        _totalBuffer = startSeconds + durationSeconds;//缓冲总长度
//        NSLog(@"共缓冲：%.2f", _totalBuffer);
        //
    }
}

#pragma mark - UI事件
/**
 *  点击播放/暂停按钮
 *
 *  @param sender 播放/暂停按钮
 */
- (void)actionPlayOrPasue {
    _isEnd = NO;
    _playOrPause.selected = !_playOrPause.selected;
    _playOrPause.hidden = YES;
    if(_player.rate==0){ //说明时暂停
        if (_isCountdown && !_isPlay) {
            _isPlay = YES;
            _playOrPause.hidden = YES;
            _timeLabel = [[UILabel alloc] initWithFrame:_playOrPause.frame];
            _timeLabel.textColor = [UIColor whiteColor];
            _timeLabel.textAlignment = NSTextAlignmentCenter;
            _timeLabel.text = @"3";
            _timeLabel.font = [UIFont boldSystemFontOfSize:50];
            [self addSubview:_timeLabel];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:YES];
        }else if(!_isRepeatAndNoCount) {
            [_player play];
            if ([_delegate respondsToSelector:@selector(moviePlayViewPlayWithState:)]) {
                [_delegate moviePlayViewPlayWithState:_playOrPause.selected];
            }
        }else {
            self.urlStr = _urlStr;
            [_player play];
            if ([_delegate respondsToSelector:@selector(moviePlayViewPlayWithState:)]) {
                [_delegate moviePlayViewPlayWithState:_playOrPause.selected];
            }
        }
    }else if(_player.rate==1){//正在播放
        [_player pause];
        if ([_delegate respondsToSelector:@selector(moviePlayViewPlayWithState:)]) {
            [_delegate moviePlayViewPlayWithState:_playOrPause.selected];
        }
    }
}

- (void)delayMethod {
    NSInteger cnt = _timeLabel.text.integerValue;
    cnt--;
    _timeLabel.text = [NSString stringWithFormat:@"%ld", cnt];
    if (!cnt) {
        [_timeLabel removeFromSuperview];
        [_timer invalidate];
        _timer = nil;
        if (_isRepeat) {
            self.urlStr = _urlStr;
            [_player play];
        }else {
            _isRepeat = YES;
            [_player play];
        }
//        [_player play];
        if ([_delegate respondsToSelector:@selector(moviePlayViewPlayWithState:)]) {
            [_delegate moviePlayViewPlayWithState:_playOrPause.selected];
        }
    }
}

- (void)play {
    [_player play];
}

- (void)stop {
    [_player pause];
}

- (void)setPlayButtonHiddenState:(BOOL)playButtonHiddenState {
    _playButtonHiddenState = playButtonHiddenState;
    _playOrPause.hidden = playButtonHiddenState;
}

- (void)actionTap {
    if (_playOrPause.hidden) {
        _playOrPause.hidden = NO;
        [self performSelector:@selector(hiddePlayOrPauseButton) withObject:nil afterDelay:3.0f];
    }
}

- (void)hiddePlayOrPauseButton {
    _playOrPause.hidden = YES;
}

@end
