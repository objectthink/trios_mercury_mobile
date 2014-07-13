//
//  MercuryProcedure.m
//  
//
//  Created by stephen eshelman on 6/17/14.
//
//

#import "MercuryInstrument.h"
#import "MercuryProcedure.h"

static int uniqueTagStatic = 0;

@implementation MercurySegmentEditorViewController
@end

@implementation MercurySegment
{
}

-(instancetype)init
{
   if(self = [super init])
   {
      _segmentTag  = 0x544D4753;  //SGMT
   }
   return self;
}

-(NSMutableData*)getBytes
{
   uniqueTagStatic++;
   
   [self.bytes setLength:0];
   
   [self.bytes appendBytes:&_segmentTag length:4];
   [self.bytes appendBytes:&_segmentId length:4];
   [self.bytes appendBytes:&uniqueTagStatic length:4];
   
   return self.bytes;
}

-(NSString*)name
{
   return @"MercurySegment";
}
@end

@implementation SegmentIsothermal
{
   float _timeInMinutes;
}

-(instancetype)initWithBytes:(const void *)bytes
{
   if(self = [super init])
   {
      _segmentId  = 0x01030000;
      _timeInMinutes = [self floatAtOffset:12 inData:[[NSData alloc] initWithBytes:bytes length:16]];
   }
   
   return self;
}

-(instancetype)initWithTime:(float)timeInMinutes
{
   if(self = [super init])
   {
      _segmentId  = 0x01030000;
      _timeInMinutes = timeInMinutes;
   }
   
   return self;
}

-(NSMutableData*)getBytes
{
   [super getBytes];
   
   [self.bytes appendBytes:&_timeInMinutes length:4];
   
   return self.bytes;
}

-(NSString*)name
{
   return @"Isothermal";
}

- (NSString *)description
{
   return
   [NSString stringWithFormat:@"TimeInMinutes: %0.2f", _timeInMinutes];
}

-(instancetype)copyWithZone:(NSZone *)zone
{
   SegmentIsothermal* segment =
   [[SegmentIsothermal alloc]initWithTime:_timeInMinutes];
   return segment;
}
@end

@implementation SegmentEquilibrate
{
   float _equilibrateTemperature;
}

-(instancetype)initWithBytes:(const void *)bytes
{
   if(self = [super init])
   {
      _segmentId  = 0x01030001;
      _equilibrateTemperature = [self floatAtOffset:12 inData:[[NSData alloc] initWithBytes:bytes length:16]];
   }
   
   return self;
}


-(instancetype)initWithTemperature:(float)equilibrateTemperature
{
   if(self = [super init])
   {
      _segmentId  = 0x01030001;
      _equilibrateTemperature = equilibrateTemperature;
   }
   
   return self;
}

-(NSString*)name
{
   return @"Equilibrate";
}

- (NSString *)description
{
   return
   [NSString stringWithFormat:@"Equilibrate Temperature: %.02f", _equilibrateTemperature];
}

-(NSMutableData*)getBytes
{
   [super getBytes];
   
   [self.bytes appendBytes:&_equilibrateTemperature length:4];
   
   return self.bytes;
}

-(instancetype)copyWithZone:(NSZone *)zone
{
   SegmentEquilibrate* segment =
   [[SegmentEquilibrate alloc] initWithTemperature:_equilibrateTemperature];
   return segment;
}
@end

@implementation SegmentRamp
{
   float _degreesPerMinute;
   float _finalTemperature;
}

-(instancetype)initWithBytes:(const void *)bytes
{
   if(self = [super init])
   {
      _segmentId  = 0x01030002;
      _degreesPerMinute = [self floatAtOffset:12 inData:[[NSData alloc] initWithBytes:bytes length:20]];
      _finalTemperature = [self floatAtOffset:16 inData:[[NSData alloc] initWithBytes:bytes length:20]];
   }
   
   return self;
}

-(instancetype)initWithDegreesPerMinute:(float)degreesPerMinute
                        finalTemerature:(float)finalTemperature
{
   if(self = [super init])
   {
      _segmentId  = 0x01030002;
      _degreesPerMinute = degreesPerMinute;
      _finalTemperature = finalTemperature;
   }
   
   return self;
}

-(NSString*)name
{
   return @"Ramp";
}

- (NSString *)description
{
   return
   [NSString stringWithFormat:@"DegreesPerMinute: %.02f FinalTemperature: %.02f", _degreesPerMinute, _finalTemperature];
}

-(NSMutableData*)getBytes
{
   [super getBytes];
   
   [self.bytes appendBytes:&_finalTemperature length:4];
   [self.bytes appendBytes:&_degreesPerMinute length:4];
   
   return self.bytes;
}

-(instancetype)copyWithZone:(NSZone *)zone
{
   SegmentRamp* segment =
   [[SegmentRamp alloc]initWithDegreesPerMinute:_degreesPerMinute finalTemerature:_finalTemperature];
   return segment;
}
@end

@implementation SegmentDataOn
{
   BOOL _on;
}

-(instancetype)initWithBytes:(const void *)bytes
{
   if(self = [super init])
   {
      _segmentId  = DataOn;
      _on = (BOOL)[self uintAtOffset:12 inData:[[NSData alloc] initWithBytes:bytes length:16]];
   }
   
   return self;
}

-(instancetype)initWithBool:(BOOL)on
{
   if(self = [super init])
   {
      _segmentId  = DataOn;
      _on = on;
   }
   
   return self;
}

-(NSString*)name
{
   return @"Data On";
}

-(NSString*)description
{
   return
   [NSString stringWithFormat:@"Data On: %@",_on?@"Yes":@"No"];
}

-(NSMutableData*)getBytes
{
   [super getBytes];
   
   [self.bytes appendBytes:&_on length:4];
   
   return self.bytes;
}

-(instancetype)copyWithZone:(NSZone *)zone
{
   SegmentDataOn* segment =
   [[SegmentDataOn alloc]initWithBool:_on];
   return segment;
}
@end

@implementation SegmentRepeat
{
   uint _repeatIndex;
   uint _count;
}

-(instancetype)initWithBytes:(const void *)bytes
{
   if(self = [super init])
   {
      _segmentId  = Repeat;
      _repeatIndex = [self floatAtOffset:12 inData:[[NSData alloc] initWithBytes:bytes length:20]];
      _count = [self floatAtOffset:16 inData:[[NSData alloc] initWithBytes:bytes length:20]];
   }
   
   return self;
}

-(instancetype)initWithRepeatIndex:(uint)index count:(uint)count
{
   if(self = [super init])
   {
      _segmentId  = Repeat;

      _repeatIndex = index;
      _count = count;
   }
   
   return self;
}

-(NSString*)name
{
   return @"Repeat";
}

-(NSString*)description
{
   return
   [NSString stringWithFormat:@"Repeat Index: %d Count: %d", _repeatIndex, _count];
}

-(NSMutableData*)getBytes
{
   [super getBytes];
   
   [self.bytes appendBytes:&_repeatIndex length:4];
   [self.bytes appendBytes:&_count length:4];
   
   return self.bytes;
}

-(instancetype)copyWithZone:(NSZone *)zone
{
   SegmentRepeat* segment =
   [[SegmentRepeat alloc] initWithRepeatIndex:_repeatIndex count:_count];
   
   return segment;
}
@end

@implementation MercuryGetProcedureResponse
{
   NSDictionary* _signalToString;
}

-(NSString*)signalToString:(int)signal
{
   NSString* value = [_signalToString objectForKey:[NSNumber numberWithInt:signal]];
   
   if(value != nil)
   {
      return value;
   }
   else
   {
      return @"UNKNOWN";
   }
}

-(int)signalAtIndex:(int)index
{
   int signal;
   [self.bytes getBytes:&signal range:NSMakeRange(index * 4, 4)];
   
   return signal;
}

-(int)indexOfSignal:(int)signal
{
   int index = -1;
   int signalCount = (int)self.bytes.length  / 4;
   
   for (int i=0; i < signalCount; i++)
   {
      if (signal == [self signalAtIndex:i])
      {
         index = i;
         break;
      }
   }
   
   return index;
}

-(void)initSignalToString
{
   _signalToString =
   @{
     [NSNumber numberWithInt:IdHeaterADC] : @"IdHeaterADC",
     [NSNumber numberWithInt:IdHeaterMV] : @"IdHeaterMV",
     [NSNumber numberWithInt:IdHeaterC] : @"IdHeaterC",
     [NSNumber numberWithInt:IdFlangeADC] : @"IdFlangeADC",
     [NSNumber numberWithInt:IdFlangeMV] : @"IdFlangeMV",
     [NSNumber numberWithInt:IdFlangeC] : @"IdFlangeC",
     [NSNumber numberWithInt:IdT0UncorrectedADC] : @"IdT0UncorrectedADC",
     [NSNumber numberWithInt:IdT0UncorrectedMV] : @"IdT0UncorrectedMV",
     [NSNumber numberWithInt:IdT0C] : @"IdT0C",
     [NSNumber numberWithInt:IdT0UncorrectedC] : @"IdT0UncorrectedC",
     [NSNumber numberWithInt:IdRefJunctionADC] : @"IdRefJunctionADC",
     
     [NSNumber numberWithInt:IdDeltaT0ADC] : @"IdDeltaT0ADC",
     [NSNumber numberWithInt:IdDeltaT0MV] : @"IdDeltaT0MV",
     [NSNumber numberWithInt:IdDeltaT0UVUnc] : @"IdDeltaT0UVUnc",
     
     [NSNumber numberWithInt:IdRefJunctionMV] : @"IdRefJunctionMV",
     [NSNumber numberWithInt:IdRefJunctionC] : @"IdRefJunctionC",
     [NSNumber numberWithInt:IdDeltaLidADC] : @"IdDeltaLidADC",
     [NSNumber numberWithInt:IdDeltaLidMV] : @"IdDeltaLidMV",
     [NSNumber numberWithInt:IdDeltaLidUV] : @"IdDeltaLidUV",
     [NSNumber numberWithInt:IdDTAmpTempADC] : @"IdDTAmpTempADC",
     [NSNumber numberWithInt:IdDTAmpTempMV] : @"IdDTAmpTempMV",
     [NSNumber numberWithInt:IdDTAmpTempC] : @"IdDTAmpTempC",
     [NSNumber numberWithInt:IdDeltaT0CUnc] : @"IdDeltaT0CUnc",
     [NSNumber numberWithInt:IdDeltaT0C] : @"IdDeltaT0C",
     [NSNumber numberWithInt:IdSampleTC] : @"IdSampleTC",
     
     [NSNumber numberWithInt:IdCommonTime] : @"IdCommonTime",
     [NSNumber numberWithInt:IdHeatFlow]:@"IdHeatFlow",
     
     [NSNumber numberWithInt:IdHeatFlowT1]:@"IdHeatFlowT1",
     [NSNumber numberWithInt:IdHeatFlowT1Filt]:@"IdHeatFlowT1Filt",
     [NSNumber numberWithInt:IdHeatFlowT1Unc]:@"IdHeatFlowT1Unc",
     [NSNumber numberWithInt:IdHeatFlowT4]:@"IdHeatFlowT4",
     [NSNumber numberWithInt:IdHeatFlowT4Filt]:@"IdHeatFlowTFilt",
     [NSNumber numberWithInt:IdHeatFlowT4P]:@"IdHeatFlowT4P",
     [NSNumber numberWithInt:IdHeatFlowT4PFilt]:@"IdHeatFlowT4pFilt",
     [NSNumber numberWithInt:IdHeatFlowT4PUnc]:@"IdHeatFlowT4PInc",
     [NSNumber numberWithInt:IdHeatFlowT4Unc]:@"IdHeatFlowT4Unc",
     [NSNumber numberWithInt:IdHeatFlowT5]:@"IdHeatFlowT5",
     [NSNumber numberWithInt:IdHeatFlowT5Filt]:@"IdHeatFlowT5Filt",
     [NSNumber numberWithInt:IdHeatFlowT5Unc]:@"IdHeatFlowT5Unc",
     
     [NSNumber numberWithInt:IdDeltaT0UV]:@"IdDeltaT0UV",
     [NSNumber numberWithInt:IdDeltaT0UVFilt]:@"IdDeltaT0UVFilt",
     [NSNumber numberWithInt:IdDeltaT0UVUnc]:@"IdDeltaT0UVUnc"
     };
}

-(instancetype)init
{
   if(self = [super init])
   {
      [self initSignalToString];
   }
   return self;
}

//TODO:ENSURE THAT MESSAGE DATA STARTS AFTER SUB COMMAND ID!
//TODO:ROLL SEGMENT LENGTH INCLUDING OVERHEAD INTO SEGMENT CLASS
-(instancetype)initWithMessage:(NSData *)message
{
   if(self = [super initWithMessage:message])
   {
      self.signals = [[NSMutableArray alloc] init];
      self.segments = [[NSMutableArray alloc] init];
      
      uint lengthOfSetupSection = [self uintAtOffset:0 inData:message];
      uint lengthOfSignalSection= [self uintAtOffset:lengthOfSetupSection + 4 inData:message];
      
      int signalSectionIndex = lengthOfSetupSection+8;
      
      int numberOfSignals = lengthOfSignalSection /4;
      for (int i = 0; i < numberOfSignals; i++)
      {
         float signalAsFloat =
         [self uintAtOffset:signalSectionIndex+i*4 inData:message];
         
         [self.signals addObject:[NSNumber numberWithFloat:signalAsFloat]];

         NSLog(@"%f",signalAsFloat);
      }
      
      //GET SEGMENT, CREATE CONCRETE TYPE, ASK FOR LENGTH
      int lengthOfSegmentSection =
      [self uintAtOffset:lengthOfSetupSection + 4 + lengthOfSignalSection + 4
                  inData:message];
      
      int segmentSectionIndex = lengthOfSetupSection + 4 + lengthOfSignalSection + 4 + 4;
      
      int segmentRunLegnth = 0;
      
      while (segmentSectionIndex + segmentRunLegnth < [message length])
      {
         MercurySegment* segment;
         uint segmentId =
         [self uintAtOffset:segmentSectionIndex + segmentRunLegnth + 4 inData:message];
         switch (segmentId)
         {
            case Isothermal:
               segment =
               [[SegmentIsothermal alloc]initWithBytes:message.bytes + segmentSectionIndex + segmentRunLegnth];
               break;
            case Ramp:
               segment =
               [[SegmentRamp alloc]initWithDegreesPerMinute:20 finalTemerature:50];
               break;
            case Equilibrate:
               segment =
               [[SegmentEquilibrate alloc]initWithBytes:message.bytes + segmentSectionIndex + segmentRunLegnth];
               break;
            case DataOn:
               segment =
               [[SegmentDataOn alloc]initWithBytes:message.bytes + segmentSectionIndex + segmentRunLegnth];
               break;
            case Repeat:
               segment =
               [[SegmentRepeat alloc]initWithBytes:message.bytes + segmentSectionIndex + segmentRunLegnth];
               break;
         }
         
         segmentRunLegnth += [[segment getBytes] length];
         
         [_segments addObject:segment];
      }
      
      [self initSignalToString];
   }
   return self;
}
@end

@implementation MercuryGetProcedureCommand
-(instancetype)init
{
   if(self = [super init])
   {
      subCommandId = MercuryGetProcedureCommandId;
   }
   return self;
}
@end

@implementation MercurySetProcedureCommand
{
   NSMutableArray* _segments;
   NSMutableArray* _signals;
}
-(id)init
{
   if(self = [super init])
   {
      subCommandId = MercurySetProcedureCommandId;
      _segments = [[NSMutableArray alloc]init];
      _signals  = [[NSMutableArray alloc] init];
   }
   return self;
}

-(void)addSegment:(MercurySegment *)segment
{
   [_segments addObject:segment];
}

-(void)addSignal:(DSCSignalId)signal
{
   [_signals addObject:[NSNumber numberWithInt:signal]];
}

-(NSMutableData*)getBytes
{
   //base class adds the command id
   [super getBytes];
   
   /////////////////setup section
   char zero = 0;
   
   uint setupSectionLength = 68;
   [self.bytes appendBytes:&setupSectionLength length:4];
   
   CFUUIDRef guid = CFUUIDCreate(NULL);
   CFUUIDBytes guidBytes = CFUUIDGetUUIDBytes(guid);
   
   [self.bytes appendBytes:&guidBytes length:16];
   
   for (int i = 0; i < 68 - 16; i++)
      [self.bytes appendBytes:&zero length:1];
   
   /////////////////signal section
   uint signalSectionLength = (uint)[_signals count] * 4;
   [self.bytes appendBytes:&signalSectionLength length:4];
   
   for (NSNumber* n in _signals)
   {
      int signal = [n intValue];
      [self.bytes appendBytes:&signal length:4];
   }
   /////////////////segment section
   int segmentSectionLength = 0;
   for (MercurySegment* segment in _segments)
   {
      segmentSectionLength += [[segment getBytes] length];
   }
   
   [self.bytes appendBytes:&segmentSectionLength length:4];
   
   for (MercurySegment* segment in _segments)
   {
      [self.bytes appendData:[segment getBytes]];
   }
   
   return self.bytes;
}

-(NSMutableData*)getBytesTEST
{
   [super getBytes];
   
   char zero = 0;
   
   uint setupSectionLength = 68;
   [self.bytes appendBytes:&setupSectionLength length:4];

   CFUUIDRef guid = CFUUIDCreate(NULL);
   CFUUIDBytes guidBytes = CFUUIDGetUUIDBytes(guid);
   
   [self.bytes appendBytes:&guidBytes length:16];
   
   for (int i = 0; i < 68 - 16; i++)
      [self.bytes appendBytes:&zero length:1];
   
   uint signalSectionLength = 8;
   [self.bytes appendBytes:&signalSectionLength length:4];
   
   uint aSignal = 9;
   [self.bytes appendBytes:&aSignal length:4];
   
   aSignal = IdCommonTime;
   [self.bytes appendBytes:&aSignal length:4];

   uint segmentSectionLength = 52;
   [self.bytes appendBytes:&segmentSectionLength length:4];

   MercurySegment* segment =
   [[SegmentEquilibrate alloc] initWithTemperature:40.0];

   [self.bytes appendData:[segment getBytes]];

   segment =
   [[SegmentIsothermal alloc] initWithTime:2.0];
   
   [self.bytes appendData:[segment getBytes]];

   segment =
   [[SegmentRamp alloc] initWithDegreesPerMinute:20 finalTemerature:50];
   
   [self.bytes appendData:[segment getBytes]];

   return self.bytes;
}
@end

