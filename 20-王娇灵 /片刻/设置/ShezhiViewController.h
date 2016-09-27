//
//  SetViewController.h
//  happyness
//
//  Created by 嘛嘛科技 on 16/4/13.
//  Copyright © 2016年 嘛嘛科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancleLoginState)();

@interface ShezhiViewController : UIViewController
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,copy)CancleLoginState cancleLogin;

@end
