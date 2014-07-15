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

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

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
   
   MercuryInstrument* instrument = app.instrument;

   NSString* accessString;
   if(instrument.access == Master)
      accessString = @"Master";
   else
      accessString = @"Viewer";
   
   self.title =
   [[NSString alloc]initWithFormat:@"Trios Main Menu [%@] %@",instrument.host,accessString];
}

-(void)noAction
{
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];   // Dispose of any resources that can be recreated.
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
