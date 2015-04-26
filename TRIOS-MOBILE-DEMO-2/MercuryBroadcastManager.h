//
//  MercuryBroadcastManager.h
//  TRIOS-MOBILE-DEMO-2
//
//  Created by stephen eshelman on 4/19/15.
//  Copyright (c) 2015 objectthink.com. All rights reserved.
//

#ifndef TRIOS_MOBILE_DEMO_2_MercuryBroadcastManager_h
#define TRIOS_MOBILE_DEMO_2_MercuryBroadcastManager_h

#import <Foundation/Foundation.h>
#import "MercuryInstrument.h"
#import "GCDAsyncUDPSocket.h"

@interface MercuryBroadcastManager : NSObject <GCDAsyncUdpSocketDelegate>
-(void)start:(void (^)())onCompletion;

@end

#endif
