//
//  MainMenuViewController.m
//  TRIOS-MOBILE-DEMO-2
//
//  Created by stephen eshelman on 7/10/14.
//  Copyright (c) 2014 objectthink.com. All rights reserved.
//

#import "MainMenuViewController.h"
#import "AppDelegate.h"
#import "MercuryInstrument.h"
#import "MercuryProcedure.h"
#import "MercuryStatus.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
{
   MercuryInstrument* _instrument;
   
   MercuryGetProcedureResponse* _response;
   MercuryProcedureStatus* _procedureStatus;
   
   IBOutlet UILabel *_procedureStatusLabel;
   IBOutlet UILabel *_temperatureLabel;
}

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
   
   AppDelegate* app = [[UIApplication sharedApplication] delegate];
   
   _instrument = app.instrument;

   [_instrument addDelegate:self];
   
   NSString* accessString;
   if(_instrument.access == Master)
      accessString = @"Master";
   else
      accessString = @"Viewer";
   
   self.title =
   [[NSString alloc]initWithFormat:@"Trios Main Menu [%@] %@",_instrument.host,accessString];
   
   [_instrument sendCommand:[[MercuryGetProcedureStatusCommand alloc]init]];
   [_instrument sendCommand:[[MercuryGetProcedureCommand alloc]init]];
}

-(void)noAction
{
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];   // Dispose of any resources that can be recreated.
}

-(void)updateProcedureStatus
{
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
      
      [self updateProcedureStatus];
   }
   
   if(subcommand == RealTimeSignalStatus)
   {
      float signal = [_instrument floatAtOffset:8 inData:message];
      
      _temperatureLabel.text = [NSString stringWithFormat:@"%f",signal];
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
      float signal = [_instrument floatAtOffset:12 inData:message];
      
      _temperatureLabel.text = [NSString stringWithFormat:@"%f",signal];
   }
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
