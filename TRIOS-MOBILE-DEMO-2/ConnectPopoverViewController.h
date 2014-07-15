//
//  ConnectPopoverViewController.h
//  TRIOS-MOBILE-DEMO-2
//
//  Created by stephen eshelman on 7/11/14.
//  Copyright (c) 2014 objectthink.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConnectPopoverViewController;

@protocol ConnectDelegate <NSObject>
-(void)onlineTapped:(ConnectPopoverViewController*)controller;
@end

@interface ConnectPopoverViewController : UIViewController
@property (strong) NSString* name;
@property (strong) NSString* serialNumber;
@property (strong) NSString* address;
@property id<ConnectDelegate> connectDelegate;
@end
