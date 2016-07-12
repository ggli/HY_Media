//
//  ViewController.m
//  HY_Media
//
//  Created by xianglin li on 16/6/20.
//  Copyright © 2016年 xianglin li. All rights reserved.
//

#import "ViewController.h"

#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMovie];
    
}

- (void)loadMovie{
    //1.创建URL
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"testvideo.mp4" withExtension:nil];
    //2.创建视频播放控制器
    NSAssert(url, @"URL不能为空");
    MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    //3.弹出视频播放控制器
    [self presentMoviePlayerViewControllerAnimated:vc];
    //4.视频播放器代码退出 -- 在视频播放完之后退出
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //让窗口消失
        [self dismissMoviePlayerViewControllerAnimated];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
