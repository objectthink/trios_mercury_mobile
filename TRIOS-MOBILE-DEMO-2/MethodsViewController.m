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
}

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
   cell.detailTextLabel.textColor = [UIColor blueColor];
   
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
}

-(void)viewWillAppear:(BOOL)animated
{
   NSLog(@"viewWillAppear");
   
   [_instrument addDelegate:self];
   [_instrument sendCommand:[[MercuryGetProcedureCommand alloc]init]];
}

-(void)viewWillDisappear:(BOOL)animated
{
   NSLog(@"viewDidDisappear");
   
   [_instrument removeDelegate:self];
}

-(void)noAction
{
}

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
