//
//  MercuryInstrument.h
//  TRIOS-MOBILE
//
//  Created by stephen eshelman on 6/4/14.
//  Copyright (c) 2014 objectthink.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

typedef enum MercuryAccessType
{
   Viewer = 1,
   Master = 2
} MercuryAccess;

typedef enum
{
   MercuryReadFileCommandId = 0x00000007,
   MercuryStartProcedureCommandId = 0x00010006,
   MercurySetProcedureCommandId = 0x01010000,
   MercuryGetProcedureStatusCommandId = 0x00000009,
   MercuryGetDataFileStatusCommandId = 0x00000006
}MercuryCommandId;

@interface MercuryInstrumentItem : NSObject <NSCopying>
{
}
@property (strong, nonatomic) NSMutableData* bytes;

-(float)floatAtOffset:(NSUInteger)offset inData:(NSData*)data;
-(uint)uintAtOffset:(NSUInteger)offset inData:(NSData*)data;

-(id)initWithMessage:(NSData*)message;
@end

@interface MercuryCommand : MercuryInstrumentItem
{
   uint subCommandId;
}
-(id)init;
-(NSMutableData*)getBytes;
@end

@interface MercuryStatus : MercuryInstrumentItem
{
   uint subCommandId;
}
@end

@interface MercuryAction : MercuryCommand
@end

@interface MercuryGet : MercuryCommand
@end

@interface MercuryResponse : MercuryInstrumentItem
@property (strong, nonatomic) NSMutableData* bytes;
@end

@interface MercuryStartProcedureCommand : MercuryAction
-(id)init;
@end

@interface MercuryGetProcedureStatusCommand : MercuryGet
-(id)init;
@end

@interface MercuryGetDataFileStatusCommand : MercuryGet
-(id)init;
@end

@interface MercurySetRealTimeSignalsCommand : MercuryAction
-(id)init;
-(void)addSignal:(int)signal;
@end

@interface MercuryGetRealTimeSignalsCommand : MercuryGet
-(id)init;
@end

@interface MercuryGetRealTimeSignalsResponse : MercuryResponse
-(id)init;
@end

@protocol MercuryInstrumentDelegate <NSObject>
-(void)connected;
-(void)accept:(MercuryAccess)access;
-(void)stat:(NSData*)message withSubcommand:(uint)subcommand;
-(void)response:(NSData*)message withSequenceNumber:(uint)sequenceNumber subcommand:(uint)subcommand status:(uint)status;
-(void)ackWithSequenceNumber:(uint)sequencenumber;
-(void)nakWithSequenceNumber:(uint)sequencenumber andError:(uint)errorcode;

@optional
-(void)error:(NSError*)error;
@end

@interface  MercuryViewControllerAdapter : UIViewController <MercuryInstrumentDelegate>
@end

@interface MercuryInstrument : NSObject <GCDAsyncSocketDelegate>
{
   GCDAsyncSocket* socket;
}

@property (nonatomic) MercuryAccess access;
@property (strong, nonatomic)NSString* host;

-(instancetype)init;

-(BOOL)connectToHost:(NSString*)host andPort:(uint16_t)port;
-(void)disconnect;

-(uint)sendCommand:(MercuryCommand*)command;

-(BOOL)
   loginWithUsername:(NSString*)username
   machineName:(NSString*)machineName
   ipAddress:(NSString*)ipAddress
   access:(uint)access;

-(float)floatAtOffset:(NSUInteger)offset inData:(NSData*)data;
-(uint)uintAtOffset:(NSUInteger)offset inData:(NSData*)data;
-(void)addDelegate:(id<MercuryInstrumentDelegate>) delegate;
-(NSArray*)knownSignalNames;
@end
