//
//  TriosCollectionViewController.m
//  TRIOS-MOBILE-DEMO-2
//
//  Created by stephen eshelman on 7/10/14.
//  Copyright (c) 2014 objectthink.com. All rights reserved.
//

#import "TriosCollectionViewController.h"
#import "TriosInstrumentCell.h"
#import "ConnectPopoverViewController.h"
#import "AppDelegate.h"
#import "ProgressHUD.h"

@interface InstrumentInfo : NSObject
@property (strong) NSString* name;
@property (strong) NSString* serialNumber;
@property (strong) NSString* address;

-(id)initWith:(NSString*)name
 serialNumber:(NSString*)serialNumber
      address:(NSString*)address;
@end

@implementation InstrumentInfo
-(id)initWith:(NSString *)name
 serialNumber:(NSString *)serialNumber
      address:(NSString *)address
{
   if([super init])
   {
      self.name = name;
      self.serialNumber = serialNumber;
      self.address = address;
   }
   return self;
}
@end

@interface TriosCollectionViewController() <UIPopoverControllerDelegate, ConnectDelegate>
{
   UIPopoverController* _popoverController;
   
   MercuryInstrument* _instrument;
   
   BOOL _connected;
}
@end

@implementation TriosCollectionViewController
{
   NSArray* _instruments;
}

#pragma mark - Mercury
-(void)connected
{
   NSLog(@"connected");
   
   [ProgressHUD dismiss];
   
   [_instrument
    loginWithUsername:@"SNE"
          machineName:@"SUPER-SECRET-IPAD-2"
            ipAddress:@"localhost"
               access:Engineering
    ];
   
   _connected = YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

-(void)accept:(MercuryAccess)access
{
   NSLog(@"accept:%d",access);
   [self performSegueWithIdentifier:@"TriosInstrumentCellSegue" sender:self];
}

-(void)stat:(NSData*)message withSubcommand:(uint)subcommand {}
-(void)response:(NSData*)message withSequenceNumber:(uint)sequenceNumber subcommand:(uint)subcommand status:(uint)status {}
-(void)ackWithSequenceNumber:(uint)sequencenumber {}
-(void)nakWithSequenceNumber:(uint)sequencenumber andError:(uint)errorcode {}

-(void)error:(NSError *)error
{
   if (error != nil)
      [ProgressHUD showError:[error debugDescription]];
}

-(void)onlineTapped:(ConnectPopoverViewController*)controller
{
   [_popoverController dismissPopoverAnimated:YES];
   
   [ProgressHUD show:[NSString stringWithFormat:@"Connecting to %@",controller.name]];
   
   [_instrument connectToHost:controller.address andPort:8080];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   CGRect rect = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath].frame;
   
   ConnectPopoverViewController* c =
   [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
    instantiateViewControllerWithIdentifier:@"ConnectPopover"];
   
   c.connectDelegate = self;
   
   InstrumentInfo* info = [_instruments objectAtIndex:indexPath.row];
   
   c.name = info.name;
   c.serialNumber = info.serialNumber;
   c.address = info.address;

   _popoverController =
   [[UIPopoverController alloc] initWithContentViewController:c];
   
   _popoverController.delegate = self;
   
   [_popoverController
    presentPopoverFromRect:[self.collectionView convertRect:rect toView:self.view]
    inView:self.view
    permittedArrowDirections:UIPopoverArrowDirectionAny
    animated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return [_instruments count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   TriosInstrumentCell *cell =
   [collectionView dequeueReusableCellWithReuseIdentifier:@"TriosInstrumentCell" forIndexPath:indexPath];
   
   UIImageView* _imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];

   [cell.contentView addSubview:_imageView];
   
   [_imageView setImage:[UIImage imageNamed:@"MERCURYDSC.png"]];
   [_imageView setBackgroundColor:[UIColor clearColor]];
   [_imageView setOpaque:NO];


//   switch (indexPath.row) {
//      case 0:
//         [_imageView setImage:[UIImage imageNamed:@"MERCURYDSC.png"]];
//         [_imageView setBackgroundColor:[UIColor clearColor]];
//         [_imageView setOpaque:NO];
//         break;
//      case 1:
//         [_imageView setImage:[UIImage imageNamed:@"dhr.png"]];
//         [_imageView setBackgroundColor:[UIColor clearColor]];
//         [_imageView setOpaque:NO];
//         break;
//      case 2:
//         [_imageView setImage:[UIImage imageNamed:@"disc_dsc.png"]];
//         [_imageView setBackgroundColor:[UIColor clearColor]];
//         [_imageView setOpaque:NO];
//         break;
//      case 3:
//         [_imageView setImage:[UIImage imageNamed:@"disc_dsc.png"]];
//         [_imageView setBackgroundColor:[UIColor clearColor]];
//         [_imageView setOpaque:NO];
//         break;
//      default:
//         [_imageView setImage:[UIImage imageNamed:@"MERCURYDSC.png"]];
//         [_imageView setBackgroundColor:[UIColor clearColor]];
//         [_imageView setOpaque:NO];
//         break;
//   }
   
   //cell.backgroundColor = [UIColor clearColor];
   
   //cell.imageView.image = [UIImage imageNamed:@"MERCURYDSC.png"];
   //[cell.imageView setImage:[UIImage imageNamed:@"MERCURYDSC.png"]];
   
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
   [super viewDidLoad];

   [self.collectionView registerClass:[TriosInstrumentCell class] forCellWithReuseIdentifier:@"TriosInstrumentCell"];
   
   [self.collectionView
    setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BricoPack Wallpaper.bmp"]]];
   
   self.title = @"Trios Mobile Connect";
   
   AppDelegate* app = [[UIApplication sharedApplication] delegate];
   
   _instrument = app.instrument;
   
   [_instrument addDelegate:self];
   
   _instruments =
  @[
      [[InstrumentInfo alloc]initWith:@"Dionysus"     serialNumber:@"010101" address:@"10.52.53.114"],
      [[InstrumentInfo alloc]initWith:@"Atlas"        serialNumber:@"011101" address:@"10.52.53.207"],
      [[InstrumentInfo alloc]initWith:@"Mariner"      serialNumber:@"110111" address:@"10.52.53.155"],
      [[InstrumentInfo alloc]initWith:@"Quicksilver"  serialNumber:@"111111" address:@"10.52.53.156"]
   ];
}

-(void)viewWillAppear:(BOOL)animated
{
   if(_connected)
   {
      [_instrument disconnect];
      _connected = NO;
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
