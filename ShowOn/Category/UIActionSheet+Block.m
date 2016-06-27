//
//  UIActionSheet+Block.m
//  GoFarm-V1.2.0
//
//  Created by David Yu on 20/4/16.
//  Copyright © 2016年 yanwei. All rights reserved.
//

#import "UIActionSheet+Block.h"
#import <objc/runtime.h>

static const char *actionSheet_key_clicked="__avkc";
static const char *actionSheet_cancel="__avcancel";

@implementation UIActionSheet (Block)

-(void) clickedCancel:(void (^)())block {
    self.delegate = self;
    objc_setAssociatedObject(self, actionSheet_cancel, block, OBJC_ASSOCIATION_COPY);
}

-(void) clickedButtonAtIndex:(void (^)(NSInteger buttonIndex))block {
    self.delegate = self;
    objc_setAssociatedObject(self, actionSheet_key_clicked, block, OBJC_ASSOCIATION_COPY);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    void (^block)(NSInteger btnIndex) = objc_getAssociatedObject(self, actionSheet_key_clicked);
    if (block) {
        block(buttonIndex);
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    void (^block)() = objc_getAssociatedObject(self, actionSheet_cancel);
    if (block) {
        block();
    }
}

@end
