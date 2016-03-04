//
//  MPMoviePlayerController+Rotation.m
//  ShowOn
//
//  Created by David Yu on 4/3/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "MPMoviePlayerViewController+Rotation.h"

@implementation MPMoviePlayerViewController (Rotation)

- (void)rotateVideoViewWithDegrees:(NSInteger)degrees {
    if(degrees==0||degrees==360) return;
    if(degrees<0) degrees = (degrees % 360) + 360;
    if(degrees>360) degrees = degrees % 360;
    // MPVideoView在iOS8中Tag为1002，不排除苹果以后更改的可能性。参考递归查看View层次结构的lldb命令： (lldb) po [movePlayerViewController.view recursiveDescription]
    UIView *videoView = [self.view viewWithTag:1002];
    if ([videoView isKindOfClass:NSClassFromString(@"MPVideoView")]) {
        videoView.transform = CGAffineTransformMakeRotation(M_PI * degrees / 180.0);
        videoView.frame = self.view.bounds;
    }
}

@end
