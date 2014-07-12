//
//  SignalChoiceViewController.m
//  TRIOS-MOBILE-DEMO-2
//
//  Created by stephen eshelman on 7/12/14.
//  Copyright (c) 2014 objectthink.com. All rights reserved.
//

#import "SignalChoiceViewController.h"

@interface SignalChoiceViewController ()

@end

@implementation SignalChoiceViewController
{
   IBOutlet UITableView *_tableView;
   
   NSArray* _strings;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
   
   if (cell == nil)
   {
      cell = [[UITableViewCell alloc]
              initWithStyle:UITableViewCellStyleSubtitle
              reuseIdentifier:@"MyIdentifier"];
      
   }
   
   cell.textLabel.text = [_strings objectAtIndex:indexPath.row];
   
   cell.accessoryView = [[UISwitch alloc]init];
   
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
   
   _strings = @[
                @"IdHeaterADC",
                @"IdHeaderMV" ,
                @"IdHeaderC"  ,
                @"IdFlangeADC",
                @"IdFlangC"   ,
                @"IdT0UncorrectedADC",
                @"IdT0UncorrectedMV",
                @"IdT0C",
                @"IdT0UncorrectedC",
                @"IdDeltaT0MV",
                @"IdDeltaT0UVUnc",
                @"IdRefJunctionADC",
                @"IdRefJunctionMV",
                @"IdRefJunctionC"
                ];
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
