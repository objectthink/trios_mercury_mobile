//
//  SignalViewController.m
//  TRIOS-MOBILE-DEMO-2
//
//  Created by stephen eshelman on 7/12/14.
//  Copyright (c) 2014 objectthink.com. All rights reserved.
//

#import "SignalViewController.h"
#import "AppDelegate.h"
#import "MercuryProcedure.h"
#import "SignalChoiceViewController.h"

@interface SignalViewController ()

@end

@implementation SignalViewController
{
   AppDelegate* _app;
   MercuryInstrument* _instrument;
   MercurySetRealTimeSignalsCommand* _command;
   NSMutableArray* _signalsList;
   NSMutableArray* _signals;
   
   IBOutlet UITableView *_signalTableView;
   
   UIPopoverController* _signalChoiceListPopover;
   IBOutlet UIImageView *_backgroundImageView;
   
   BOOL _colors;
}

- (IBAction)signalsButtonTapped:(id)sender
{
   CGRect frame = CGRectMake(525, 650, 10, 10);

   //CGRect rect = [_signalTableView convertRect:frame toView:self.view];
   
   SignalChoiceViewController* c =
   [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
    instantiateViewControllerWithIdentifier:@"SignalChoiceViewController"];
   
   _signalChoiceListPopover =
   [[UIPopoverController alloc] initWithContentViewController:c];
   
   [_signalChoiceListPopover presentPopoverFromRect:frame
                                             inView:self.view
                           permittedArrowDirections:UIPopoverArrowDirectionDown
                                           animated:YES];
}

-(NSInteger)tableView:tableView numberOfRowsInSection:(NSInteger)section
{
   return [_signalsList count];
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
   
   //create a set procedure for now to get signal string name
   MercuryGetProcedureResponse* procedure =
   [[MercuryGetProcedureResponse alloc] init];
   
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
   cell.textLabel.text =
   [procedure signalToString:[[_signalsList objectAtIndex:indexPath.row] intValue]];
   
   cell.detailTextLabel.text =
   [NSString stringWithFormat:@"%@",
    [_signals objectAtIndex:indexPath.row]
    ];
   
   cell.textLabel.textColor = [UIColor whiteColor];
   cell.detailTextLabel.textColor = [UIColor blackColor];
   
   return cell;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   if (self)
   {
   }
   return self;
}

-(void)onColors
{
   if (_colors == YES)
   {
      [_backgroundImageView setImage:nil];
      [_backgroundImageView setBackgroundColor:[UIColor grayColor]];
      _colors = NO;
   }
   else
   {
      [_backgroundImageView setImage:[UIImage imageNamed:@"BricoPack Wallpaper.bmp"]];
      [_backgroundImageView setBackgroundColor:[UIColor clearColor]];
      _colors = YES;
   }
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   _colors = true;
   
   self.title = @"Real Time Signals";
   
   _app = [[UIApplication sharedApplication] delegate];
   _instrument = [_app instrument];
   
   _signalsList = [[NSMutableArray alloc] init];
   _signals     = [[NSMutableArray alloc] init];
   
   [_instrument addDelegate:self];
   
   //get the current list of signals
   [_instrument sendCommand:[[MercuryGetRealTimeSignalsCommand alloc]init]];
   
   [_signalTableView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2]];
}

-(void)stat:(NSData*)message withSubcommand:(uint)subcommand
{
   if(subcommand == 0x00020002)
   {
      [_signals removeAllObjects];
      
      long signalCount = [message length]/4;
      for (int i = 1; i < signalCount -1; i++)
      {
         float signal = [_instrument floatAtOffset:i*4 inData:message];
         [_signals addObject:[NSNumber numberWithFloat:signal]];
      }
      
      [_signalTableView reloadData];
   }
}

-(void)response:(NSData *)message withSequenceNumber:(uint)sequenceNumber subcommand:(uint)subcommand status:(uint)status
{
   NSLog(@"response:%d %d %d", sequenceNumber, subcommand, status);
   
   //get response
   if(subcommand == 0x00000008)
   {
      [_signalsList removeAllObjects];
      
      long signalCount = [message length]/4;
      for (int i =0; i < signalCount; i++)
      {
         uint signal = [_instrument uintAtOffset:i*4 inData:message];
         [_signalsList addObject:[NSNumber numberWithInt:signal]];
      }
   }
   
   //set response, do get
   if(subcommand == 0x0001000A)
   {
      [_instrument sendCommand:[[MercuryGetRealTimeSignalsCommand alloc]init]];
   }
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
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
