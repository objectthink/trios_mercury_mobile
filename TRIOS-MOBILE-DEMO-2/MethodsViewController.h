//
//  MethodsViewController.h
//  TRIOS-MOBILE-DEMO-2
//
//  Created by stephen eshelman on 7/10/14.
//  Copyright (c) 2014 objectthink.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MercuryInstrument.h"
#import "MercuryFile.h"
#import "MercuryStatus.h"

@interface MethodsViewController : MercuryViewControllerAdapter <
MercuryInstrumentDelegate,
IMercuryFileReader
>
@end
