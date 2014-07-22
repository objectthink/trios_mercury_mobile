//
//  MercuryStatus.h
//  TRIOS-MOBILE
//
//  Created by stephen eshelman on 6/14/14.
//  Copyright (c) 2014 objectthink.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MercuryInstrument.h"
typedef enum
{
   ProcedureStatus = 0x00020003,
   DataFileStatus = 0x00020001,
   RealTimeSignalStatus = 0x00020002
}
MercuryStatusId;

typedef enum
{
   Idle = 0,
   PreTest = 1,
   Test = 2,
   PostTest = 3
}
MercuryProcedureRunStatus;

typedef enum
{
   Running = 0,
   Complete = 1,
   UserStopped = 2,
   Error = 3,
   NotRun = 4
}
MercuryProcedureEndStatus;

typedef enum
{
   Closed = 0,
   Open = 1,
   DoesNotExist = 2
}
MercuryDataFileState;

@interface MercuryProcedureStatus : MercuryStatus
@property MercuryProcedureRunStatus runStatus;
@property MercuryProcedureEndStatus endStatus;
@property int currentSegmentId;
@end

@interface MercuryDataFileStatus : MercuryStatus
@property uint length;
@property MercuryDataFileState state;
@end
