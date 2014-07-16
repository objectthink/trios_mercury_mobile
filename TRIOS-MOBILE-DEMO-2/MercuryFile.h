//
//  MercuryFile.h
//  
//
//  Created by stephen eshelman on 6/13/14.
//
//

#import <Foundation/Foundation.h>
#import "MercuryInstrument.h"
#import "MercuryStatus.h"
#import "MercuryProcedure.h"

@class MercuryDataRecord;
@class MercurySgmtRecord;

enum MercuryKnownFileType
{
   ProcedureData,
   ProcedurePreamble,
   ProcedureEpilogue
};

@interface Util : NSObject
+(float)floatAtOffset:(NSUInteger)offset inData:(NSData*)data;
+(uint )uintAtOffset :(NSUInteger)offset inData:(NSData*)data;
@end

@protocol MercuryDataFileVisualizer <NSObject>
-(void)pointData:(float)data time:(float)time;
@end

@protocol MercuryDataFileVisualizerEx <NSObject>

-(void)procedure:(MercuryGetProcedureResponse*)procedure
          record:(MercuryDataRecord*)record
         xSignal:(int)xSignal
         ySignal:(int)ySignal
     seriesIndex:(int)seriesIndex;

-(void)procedure:(MercuryGetProcedureResponse*)procedure
         segment:(MercurySgmtRecord*)segment;

-(void)end;
@end

@protocol IMercuryRecord
@property (strong, nonatomic) NSString* tag;
@property (nonatomic) int length;
@property (strong, nonatomic) NSData* data;
@end

@protocol IMercuryFile

@property (strong, nonatomic) NSMutableData* data;
@property (copy, nonatomic) NSString* filename;

- (id <IMercuryRecord>) getMercuryRecordAtOffset:(int)offset;

@end

@protocol IMercuryFileReader

-(void)finished:(id <IMercuryFile>)file;
-(void)updated:(id <IMercuryFile>)file;

@end

@interface MercuryReadFileCommand : MercuryGet

-(id)initWithFilename:(NSString*)filename
               offset:(int)offset
           moveMethod:(int)moveMethod
  dataLengthRequested:(uint)dataLengthRequested;

@end

@interface MercuryReadFileResponse : MercuryResponse
@property (strong, nonatomic) NSData* data;
-(instancetype)initWithMessage:(NSData*)message;
@end

@interface MercuryRecord : NSObject <IMercuryRecord>
@property (strong, nonatomic) NSString* tag;
@property (nonatomic) int length;
@property (strong, nonatomic) NSData* data;

-(instancetype)initWithTag:(NSString*)tag length:(int)length data:(NSData*)data;
@end

@interface MercuryDataRecord : MercuryRecord
-(float)valueAtIndex:(int)index;
@end

@interface MercuryGetRecord : MercuryRecord
@end

@interface MercurySgmtRecord : MercuryRecord
@property uint segmentId;
@end

@interface MercuryFile : NSObject <IMercuryFile>

@property (strong, nonatomic) NSMutableData* data;
@property (copy, nonatomic) NSString* filename;

-(id)initWithInstrument:(MercuryInstrument*)instrument andFilename:(NSString*)filename;

@end

@interface MercuryDataFileReader : NSObject <MercuryInstrumentDelegate>

@property (weak) id<IMercuryFileReader> delegate;

-(id)initWithInstrument:(MercuryInstrument*)instrument file:(id<IMercuryFile>)file readSize:(uint)readSize;
-(void)start;

@end

