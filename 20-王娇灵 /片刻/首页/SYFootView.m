//
//  SYFootView.m
//  美物心语
//
//  Created by qingyun on 16/9/1.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import "SYFootView.h"
@interface SYFootView ()
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UIView *loadView;

@end



@implementation SYFootView

+ (instancetype)loadFootView {
    
    return  [[[NSBundle mainBundle] loadNibNamed:@"SYFootView" owner:nil options:nil] lastObject];
    
}

- (IBAction)loadButton:(UIButton *)sender {
    
    //隐藏加载按钮
    self.btn.hidden = YES;
    
    self.loadView.hidden = NO;
    if ([self.delegate respondsToSelector:@selector(SYFootViewClickLoadBtn:)]) {
        
        [self.delegate SYFootViewClickLoadBtn:self];
        self.btn.hidden = NO;
        self.loadView.hidden = YES;
    }
    
    
}

@end
