//
//  DataViewController.m
//  TRIOS-MOBILE-DEMO-2
//
//  Created by stephen eshelman on 7/15/14.
//  Copyright (c) 2014 objectthink.com. All rights reserved.
//

#import "DataViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface DataViewController () <SChartDatasource>

@end

@implementation DataViewController
{
   ShinobiChart* _chart;
   float _data;
   float _time;
}

#pragma mark - MercuryDataFileVisualizer
-(void)end
{
   self.navigationItem.title = @"Done";
}

-(void)procedure:(MercuryGetProcedureResponse *)procedure
         segment:(MercurySegment *)segment
{
   switch (segment.segmentId) {
      case Isothermal:
         self.navigationItem.title = @"Isothermal";
         break;
         
      case Equilibrate:
         self.navigationItem.title = @"Equilibrate";
         break;
         
      case Ramp:
         self.navigationItem.title = @"Ramp";
         break;
         
      case Repeat:
         self.navigationItem.title = @"Repeat";
         break;
         
      case DataOn:
         self.navigationItem.title = @"DataOn";
         break;
         
      default:
         break;
   }
}

-(void)pointData:(float)data time:(float)time
{
   _data = data;
   _time = time;
   
   [_chart appendNumberOfDataPoints:1 toEndOfSeriesAtIndex:0];
   [_chart redrawChart];
}

-(void)procedure:(MercuryGetProcedureResponse*)procedure
          record:(MercuryDataRecord*)record
         xSignal:(int)xSignal
         ySignal:(int)ySignal
     seriesIndex:(int)seriesIndex;
{
   _time = [record valueAtIndex:[procedure indexOfSignal:xSignal]];
   _data = [record valueAtIndex:[procedure indexOfSignal:ySignal]];
   
   _chart.xAxis.title = [procedure signalToString:xSignal];
   _chart.yAxis.title = [procedure signalToString:ySignal];
   
   [_chart appendNumberOfDataPoints:1 toEndOfSeriesAtIndex:0];
   [_chart redrawChart];
}

#pragma mark - chart
-(SChartSeries *)sChart:(ShinobiChart *)chart
          seriesAtIndex:(NSInteger)index
{
   SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
   
   lineSeries.style.lineColor = [UIColor blueColor];
   
   return lineSeries;
}

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart
{
   return 1;
}

-                 (NSInteger)sChart:(ShinobiChart *)chart
 numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex
{
   return 0;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart
        dataPointAtIndex:(NSInteger)dataIndex
        forSeriesAtIndex:(NSInteger)seriesIndex
{
   
   SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
   
   datapoint.xValue = [NSNumber numberWithDouble:_time];
   datapoint.yValue = [NSNumber numberWithDouble:_data];
   
   return datapoint;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   if (self)
   {
   }
   return self;
}

-(void)noAction
{
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   /////////////////////////////
   //TOOLBAR
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
   /////////////////////////////
   
   //CGFloat margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 10.0 : 100;

   _chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, 10, 100)];
   _chart.title = @"";
   
   _chart.licenseKey = @"XrSZg5gnv85RxHDMjAxNDA4MTVtaWNoYWVsLmYuYmVja2VyQGdtYWlsLmNvbQ==q+jUJBDR4i9uKuLEn9BkW5RpNE87rA+wkhC5GZNDpfDRU8BtaboVJh9VDVwltmTRUFBv+cKgbE4/g1xneyDNkcx+ysNfMgpsXGKQ4KxkLvy6piZ1QixZ6LSNdDyfJWbVOXKS+DHZd/OE4U1c5NCsolTBSbdw=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
   
   // TODO: add your trial licence key here!
   
   _chart.autoresizingMask =  ~UIViewAutoresizingNone;
   
   // add a pair of axes
   SChartNumberAxis *xAxis = [[SChartNumberAxis alloc] init];
   xAxis.title = @"Time";
   xAxis.style.majorTickStyle.labelColor = [UIColor blackColor];
   _chart.xAxis = xAxis;
   
   SChartNumberAxis *yAxis = [[SChartNumberAxis alloc] init];
   yAxis.title = @"<SIGNAL NAME>";
   yAxis.style.majorTickStyle.labelColor = [UIColor blackColor];
   _chart.yAxis = yAxis;
   
   // enable gestures
   yAxis.enableGesturePanning = YES;
   yAxis.enableGestureZooming = YES;
   xAxis.enableGesturePanning = YES;
   xAxis.enableGestureZooming = YES;
   
   [self.view addSubview:_chart];
   
   _chart.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4];//[UIColor clearColor];
   _chart.canvasAreaBackgroundColor = [UIColor clearColor];
   _chart.plotAreaBackgroundColor = [UIColor clearColor];
   
   _chart.datasource = self;
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
