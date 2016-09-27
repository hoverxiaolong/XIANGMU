//
//  ChatVC.h
//  
//
//  Created by qingyun on 16/9/16.
//
//

#import <UIKit/UIKit.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface ChatVC : UIViewController

@property(nonatomic,strong)NSString *strFriendName;
@property(nonatomic,strong)NSString *strFriendPhone;
@property(nonatomic,strong)NSString *strMyName;

@property (strong, nonatomic) AVIMClient *client;

@end
