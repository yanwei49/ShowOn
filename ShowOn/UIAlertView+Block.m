//
//  UIAlertView+Block.m
//  GoFarm-V1.2.0
//
//  Created by David Yu on 7/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>

static const char *alertview_key_clicked="__avkc";
static const char *alertview_cancel="__avcancel";

@implementation UIAlertView (Block)

-(void) clickedCancel:(void (^)())block {
    self.delegate = self;
    objc_setAssociatedObject(self, alertview_cancel, block, OBJC_ASSOCIATION_COPY);
}

-(void) clickedButtonAtIndex:(void (^)(NSInteger buttonIndex))block {
    self.delegate = self;
    objc_setAssociatedObject(self, alertview_key_clicked, block, OBJC_ASSOCIATION_COPY);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    void (^block)(NSInteger btnIndex) = objc_getAssociatedObject(self, alertview_key_clicked);
    if (block) {
        block(buttonIndex);
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    void (^block)() = objc_getAssociatedObject(self, alertview_cancel);
    if (block) {
        block();
    }
}


@end
