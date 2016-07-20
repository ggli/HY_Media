//
//  ViewController.m
//  HY_Media
//
//  Created by xianglin li on 16/6/20.
//  Copyright © 2016年 xianglin li. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic, strong)   AVPlayer *player;

@property (strong, nonatomic)   UISlider *avSlider;//用来现实视频的播放进度，并且通过它来控制视频的快进快退。
@property (assign, nonatomic)   BOOL isReadToPlay;//用来判断当前视频是否准备好播放。
@property (strong, nonatomic)   AVPlayerItem *playitem;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self loadLocalMovie];
    [self loadNetMovie];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.view.frame.size.width-100)/2, 350+20+30, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"按钮" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    [self.avSlider addTarget:self action:@selector(avSliderAction) forControlEvents:
     UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchUpOutside];
    
}

- (void)loadLocalMovie{
    //1.创建URL
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"testvideo.mp4" withExtension:nil];
    //2.创建视频播放控制器
    self.player = [AVPlayer playerWithURL:url];
    
    NSAssert(url, @"URL不能为空");
    AVPlayerLayer *playerLayer = [AVPlayerLayer  playerLayerWithPlayer:self.player];
    playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:playerLayer];
    
    
}

- (void)loadNetMovie
{
//    NSString * url = @"http://ouzhenxuan.file.alimmdn.com/560a4ced60b258073cc75269/ios1444120900.jpg?t=1444120909931";
    NSString *url = @"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8";
    NSURL *mediaURL = [NSURL URLWithString:url];
    //NSURL *mediaURL = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1455782903700jy.mp4"];
    //NSURL *mediaURL = [[NSBundle mainBundle] URLForResource:@"testvideo.mp4" withExtension:nil];
    self.playitem = [AVPlayerItem playerItemWithURL:mediaURL];
    self.player = [AVPlayer playerWithPlayerItem:self.playitem];
    
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer  playerLayerWithPlayer:self.player];
    playerLayer.frame = CGRectMake(0, 50, self.view.frame.size.width, 300);
    [self.view.layer addSublayer:playerLayer];
    
    //通过KVO来观察status属性的变化，来获得播放之前的错误信息
    [self.playitem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                NSLog(@"item 有误");
                self.isReadToPlay = NO;
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准好播放了");
                self.isReadToPlay = YES;
                self.avSlider.maximumValue = self.playitem.duration.value / self.playitem.duration.timescale;
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"视频资源出现未知错误");
                self.isReadToPlay = NO;
                break;
            default:
                break;
        }
    }
    //移除监听（观察者）
    [object removeObserver:self forKeyPath:@"status"];
}

- (void)playAction{
    if (self.isReadToPlay)
    {
        if (self.player.rate == 1)
        {
            [self.player pause];
        }
        else
        {
            [self.player play];
        }
        
    }else{
        NSLog(@"视频正在加载中");
    }
}

- (UISlider *)avSlider{
    if (!_avSlider) {
        _avSlider = [[UISlider alloc]initWithFrame:CGRectMake(0, 350+20, self.view.bounds.size.width, 30)];
        [self.view addSubview:_avSlider];
    }return _avSlider;
}


- (void)avSliderAction{
    //slider的value值为视频的时间
    float seconds = self.avSlider.value;
    //让视频从指定的CMTime对象处播放。
    CMTime startTime = CMTimeMakeWithSeconds(seconds, self.playitem.currentTime.timescale);
    //让视频从指定处播放
    [self.player seekToTime:startTime completionHandler:^(BOOL finished) {
        if (finished) {
            [self playAction];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 开始播放
    [self.player play];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
