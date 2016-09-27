//
//  XinquListVC.h
//  美物心语
//
//  Created by qingyun on 16/9/4.
//  Copyright © 2016年 bjsxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XinquListVC : UIViewController

@property (nonatomic ,copy) NSString *album_id;
@property (nonatomic ,copy) NSString *pic;
@property (nonatomic, retain) NSDictionary *responseObject;

@end
