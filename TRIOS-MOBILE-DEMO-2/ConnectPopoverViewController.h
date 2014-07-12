//
//  ConnectPopoverViewController.h
//  TRIOS-MOBILE-DEMO-2
//
//  Created by stephen eshelman on 7/11/14.
//  Copyright (c) 2014 objectthink.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConnectDelegate <NSObject>
-(void)onlineTapped;
@end

@interface ConnectPopoverViewController : UIViewController
@property id<ConnectDelegate> connectDelegate;
@end
