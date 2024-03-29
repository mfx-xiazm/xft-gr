//
//  UITextField+GYExpand.m
//  GY
//
//  Created by 夏增明 on 2019/11/13.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "UITextField+GYExpand.h"
#import <objc/runtime.h>


@implementation UITextField (GYExpand)

static char limit;

- (void)setLimitBlock:(LimitBlock)limitBlock {
    objc_setAssociatedObject(self, &limit, limitBlock, OBJC_ASSOCIATION_COPY);
}

- (LimitBlock)limitBlock {
    return objc_getAssociatedObject(self, &limit);
}

- (void)lengthLimit:(void (^)(void))limit {
    [self addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    self.limitBlock = limit;
}

- (void)textFieldEditChanged:(UITextField *)textField {
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position){
        if (self.limitBlock) {
            self.limitBlock();
        }
    }
}
@end
