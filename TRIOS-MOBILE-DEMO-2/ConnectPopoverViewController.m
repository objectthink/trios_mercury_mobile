//
//  ConnectPopoverViewController.m
//  TRIOS-MOBILE-DEMO-2
//
//  Created by stephen eshelman on 7/11/14.
//  Copyright (c) 2014 objectthink.com. All rights reserved.
//

#import "ConnectPopoverViewController.h"

@interface ConnectPopoverViewController ()

@end

@implementation ConnectPopoverViewController
{
   IBOutlet UILabel *_nameLabel;
   IBOutlet UILabel *_serialNumberLabel;
   IBOutlet UILabel *_addressLabel;
}

- (IBAction)onlineTapped:(id)sender
{
   [self.connectDelegate onlineTapped:self];
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
   
   _nameLabel.text = self.name;
   _serialNumberLabel.text = self.serialNumber;
   _addressLabel.text = self.address;
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
