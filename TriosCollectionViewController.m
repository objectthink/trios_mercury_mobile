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

@interface TriosCollectionViewController() <UIPopoverControllerDelegate, ConnectDelegate>
{
   UIPopoverController* _popoverController;
   
   MercuryInstrument* _instrument;
   
   BOOL _connected;
}
@end

@implementation TriosCollectionViewController

#pragma mark - Mercury
-(void)connected
{
   NSLog(@"connected");
   
   [_instrument
    loginWithUsername:@"USERNAME"
          machineName:@"SUPER-SECRET-IPAD-2"
            ipAddress:@"localhost"
               access:Master
    ];
   
   _connected = YES;
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
-(void)error:(NSError*)error {}

BOOL _toggle = NO;
-(void)onlineTapped
{
   [_popoverController dismissPopoverAnimated:YES];
   
   if(_toggle)
      [_instrument connectToHost:@"10.52.51.32" andPort:8080];
   else
      [_instrument connectToHost:@"10.52.53.155" andPort:8080];
   
   _toggle = !_toggle;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   CGRect rect = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath].frame;
   
   ConnectPopoverViewController* c =
   [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
    instantiateViewControllerWithIdentifier:@"ConnectPopover"];
   
   c.connectDelegate = self;
   
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
   return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   TriosInstrumentCell *cell =
   [collectionView dequeueReusableCellWithReuseIdentifier:@"TriosInstrumentCell" forIndexPath:indexPath];
   
   UIImageView* _imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];

   [cell.contentView addSubview:_imageView];

   switch (indexPath.row) {
      case 0:
         [_imageView setImage:[UIImage imageNamed:@"MERCURYDSC.png"]];
         [_imageView setBackgroundColor:[UIColor clearColor]];
         [_imageView setOpaque:NO];
         break;
      case 1:
         [_imageView setImage:[UIImage imageNamed:@"dhr.png"]];
         [_imageView setBackgroundColor:[UIColor clearColor]];
         [_imageView setOpaque:NO];
         break;
      case 2:
         [_imageView setImage:[UIImage imageNamed:@"disc_dsc.png"]];
         [_imageView setBackgroundColor:[UIColor clearColor]];
         [_imageView setOpaque:NO];
         break;
      case 3:
         [_imageView setImage:[UIImage imageNamed:@"disc_dsc.png"]];
         [_imageView setBackgroundColor:[UIColor clearColor]];
         [_imageView setOpaque:NO];
         break;
      default:
         [_imageView setImage:[UIImage imageNamed:@"MERCURYDSC.png"]];
         [_imageView setBackgroundColor:[UIColor clearColor]];
         [_imageView setOpaque:NO];
         break;
   }
   
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
   
   //_instrument.instrumentDelegate = self;
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
