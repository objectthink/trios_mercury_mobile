//
//  MethodsViewController.m
//  TRIOS-MOBILE-DEMO-2
//
//  Created by stephen eshelman on 7/10/14.
//  Copyright (c) 2014 objectthink.com. All rights reserved.
//

#import "MethodsViewController.h"
#import "AppDelegate.h"
#import "MercuryProcedure.h"

@interface MethodsViewController () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation MethodsViewController
{
   AppDelegate* _app;
   MercuryInstrument* _instrument;
   IBOutlet UITableView *_tableView;
   
   MercuryGetProcedureResponse* _response;
   MercuryProcedureStatus* _procedureStatus;

   
   NSObject<MercuryDataFileVisualizer>* _dataFileVisualizer;
   NSObject<MercuryDataFileVisualizerEx>* _dataFileVisualizerEx;
   
   MercuryFile* _file;
   MercuryDataFileReader* _reader;
   
   MercuryDataRecord* _dataRecord;

   int _offset;
   int _selectedSignalIndex;
   
   IBOutlet UILabel *_procedureStatusLabel;
   IBOutlet UILabel *_temperatureLabel;
   IBOutlet UIButton *_chartButton;
}

#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([segue.identifier isEqualToString:@"ProcedureDetail"])
   {
      _dataFileVisualizer = [segue destinationViewController];
      _dataFileVisualizerEx = [segue destinationViewController];
      
      _offset = 0;
      
      _file =
      [[MercuryFile alloc]initWithInstrument:_instrument andFilename:@"Procedure.dat"];
      
      _reader =
      [[MercuryDataFileReader alloc]initWithInstrument:_instrument file:_file readSize:8192];
      
      _reader.delegate = self;
      
      [_reader start];
   }
   
}

#pragma mark - IMercuryFileReader
-(void)finished:(id<IMercuryFile>)file
{
   _reader.delegate = nil;
   
   _file = nil;
   _reader = nil;
   
   [_dataFileVisualizerEx end];
}

-(void)updated:(id<IMercuryFile>)file
{
   NSLog(@"updated:%lu",(unsigned long)file.data.length);
   while (_offset < file.data.length)
   {
      MercuryRecord* r = (MercuryRecord*)[file getMercuryRecordAtOffset:_offset];
      
      id s = r;
      
      if (r == nil)
         break;
      
      NSLog(@"%@",r.tag);
      
      _offset += r.length;
      
      if([s isKindOfClass:MercuryDataRecord.class])
      {
         _dataRecord = (MercuryDataRecord*)r;
         
         if (_dataFileVisualizer != nil)
         {

            [_dataFileVisualizerEx procedure:_response
                                      record:_dataRecord
                                     xSignal:IdCommonTime
                                     ySignal:[_response signalAtIndex:_selectedSignalIndex]
                                 seriesIndex:0];
         }
      }
      
      if ([s isKindOfClass:MercurySgmtRecord.class])
      {
         MercurySgmtRecord* gr = (MercurySgmtRecord*)r;
         
         [_dataFileVisualizerEx procedure:_response
                                  segment:gr];
      }
      
      if([s isKindOfClass:MercuryGetRecord.class])
      {
         //MercuryGetRecord* gr = (MercuryGetRecord*)r;
         
         //NSData *data = [[NSData alloc] initWithBytes:gr.data.bytes + 4 length:gr.data.length - 4];
         
         //_response =
         //[[MercuryGetProcedureResponse alloc]initWithMessage:data];
      }
   }
}

#pragma mark - tableview
-(NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section
{
   return [_response.segments count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView
       cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
   
   if (cell == nil)
   {
      cell = [[UITableViewCell alloc]
              initWithStyle:UITableViewCellStyleValue1
              reuseIdentifier:@"MyIdentifier"];
      
      cell.backgroundColor = [UIColor clearColor];
   }
   
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
   cell.textLabel.text = [[_response.segments objectAtIndex:indexPath.row] name];
   
   cell.detailTextLabel.text = [[_response.segments objectAtIndex:indexPath.row] description];
   
   cell.textLabel.textColor = [UIColor whiteColor];
   cell.detailTextLabel.textColor = [UIColor blackColor];
   
   return cell;
}

#pragma mark - initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   if (self)
   {
   }
   return self;
}

- (void)viewDidLoad
{
   NSLog(@"viewDidLoad");
   
   [super viewDidLoad];

   UIBarButtonItem* space =
   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
   
   UIBarButtonItem* lid =
   [[UIBarButtonItem alloc] initWithTitle:@"Lid" style:UIBarButtonItemStyleBordered target:self action:@selector(noAction)];
   
   UIBarButtonItem* standby_temp =
   [[UIBarButtonItem alloc] initWithTitle:@"Standby Temp" style:UIBarButtonItemStyleBordered target:self action:@selector(noAction)];
   
   UIBarButtonItem* reset =
   [[UIBarButtonItem alloc] initWithTitle:@"Reset A/S" style:UIBarButtonItemStyleBordered target:self action:@selector(noAction)];
   
   UIBarButtonItem* play =
   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(noAction)];
   
   UIBarButtonItem* stop =
   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(noAction)];
   
   UIBarButtonItem* open =
   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(noAction)];
   
   [self.navigationController setToolbarHidden:NO];
   [self setToolbarItems:[NSArray arrayWithObjects:
                          play,
                          space,
                          stop,
                          space,
                          open,
                          space,
                          lid,
                          space,
                          standby_temp,
                          space,
                          reset,
                          nil]];
   
   self.title = @"Methods";
   
   _app = [[UIApplication sharedApplication] delegate];
   _instrument = [_app instrument];
   
   _selectedSignalIndex = 8;  //default for now until we allow the user to choose
   
   [_tableView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2]];
   
   [_instrument sendCommand:[[MercuryGetProcedureStatusCommand alloc]init]];
   [_instrument sendCommand:[[MercuryGetDataFileStatusCommand alloc]init]];
   [_instrument sendCommand:[[MercuryGetProcedureCommand alloc]init]];
}

-(void)viewWillAppear:(BOOL)animated
{
   NSLog(@"viewWillAppear");
   
   [_instrument addDelegate:self];
   [_instrument sendCommand:[[MercuryGetProcedureCommand alloc]init]];
   [_instrument sendCommand:[[MercuryGetProcedureStatusCommand alloc]init]];
}

-(void)viewWillDisappear:(BOOL)animated
{
   NSLog(@"viewDidDisappear");
   
   [_instrument removeDelegate:self];
}

-(void)noAction
{
}

-(void)updateProcedureStatus
{
   if (_procedureStatus.runStatus != Test)
      _chartButton.enabled = NO;
   else
      _chartButton.enabled = YES;
   
   NSString* runStatus;
   switch (_procedureStatus.runStatus)
   {
      case Idle:
         runStatus = @"Idle";
         break;
      case PostTest:
         runStatus = @"PostTest";
         break;
      case PreTest:
         runStatus = @"PreTest";
         break;
      case Test:
         runStatus = @"Test";
         break;
      default:
         runStatus = @"Unknown";
         break;
   }
   
   NSString* endStatus;
   switch (_procedureStatus.endStatus)
   {
      case Complete:
         endStatus = @"Complete";
         break;
      case Error:
         endStatus = @"Error";
         break;
      case NotRun:
         endStatus = @"NotRun";
         break;
      case Running:
         endStatus = @"Running";
         break;
      case UserStopped:
         endStatus = @"UserStopped";
         break;
      default:
         endStatus = @"Unknown";
         break;
   }
   
   NSString* segmentName = @"None";
   
   if (_procedureStatus.currentSegmentId != -1 && _response != nil)
   {
      MercurySegment* currentSegment =
      [[_response segments] objectAtIndex:_procedureStatus.currentSegmentId];
      
      segmentName = currentSegment.name;
   }
   
   _procedureStatusLabel.text =
   [NSString stringWithFormat:@"%@:%@:%@",
    runStatus , endStatus, segmentName];
}

#pragma mark - instrument delegate
-(void)   response:(NSData*)message
withSequenceNumber:(uint)sequenceNumber
        subcommand:(uint)subcommand
            status:(uint)status
{
   if (subcommand == MercuryGetProcedureCommandId)
   {
      _response =
      [[MercuryGetProcedureResponse alloc]initWithMessage:message];
      
      [_tableView reloadData];
      [self updateProcedureStatus];
   }
}

-(void)stat:(NSData*)message withSubcommand:(uint)subcommand
{
   if(subcommand == ProcedureStatus)
   {
      _procedureStatus =
      [[MercuryProcedureStatus alloc] initWithMessage:message];
      
      [self updateProcedureStatus];
   }
   
   if(subcommand == RealTimeSignalStatus)
   {
      float signal = [_instrument floatAtOffset:8 inData:message];
      
      _temperatureLabel.text = [NSString stringWithFormat:@"%f",signal];
   }

   if(subcommand == DataFileStatus)
   {
//      MercuryDataFileStatus* status =
//      [[MercuryDataFileStatus alloc]initWithMessage:message];
//      
//      NSString* state;
//      switch (status.state)
//      {
//         case Open:
//            state = @"Open";
//            break;
//         case Closed:
//            state = @"Closed";
//            break;
//         case DoesNotExist:
//            state = @"DoesNotExist";
//         default:
//            state = @"Unkown";
//            break;
//      }
//      
//      self.DataFileStatusData.text =
//      [NSString stringWithFormat:@"length: %d  state: %@", status.length, state];
   }
}


- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
