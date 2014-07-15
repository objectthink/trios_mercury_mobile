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
}

- (long)numberOfSeriesInSChart:(ShinobiChart *)chart
{
   return 2;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(long)index
{
   
   SChartLineSeries *lineSeries = [[SChartLineSeries alloc] init];
   
   // the first series is a cosine curve, the second is a sine curve
   if (index == 0)
   {
      lineSeries.title = [NSString stringWithFormat:@"y = cos(x)"];
   }
   else
   {
      lineSeries.title = [NSString stringWithFormat:@"y = sin(x)"];
   }
   
   return lineSeries;
}

-                     (long)sChart:(ShinobiChart *)chart
numberOfDataPointsForSeriesAtIndex:(long)seriesIndex
{
   return 100;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart
        dataPointAtIndex:(long)dataIndex
        forSeriesAtIndex:(long)seriesIndex
{
   
   SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];
   
   // both functions share the same x-values
   double xValue = dataIndex / 10.0;
   datapoint.xValue = [NSNumber numberWithDouble:xValue];
   
   // compute the y-value for each series
   if (seriesIndex == 0)
   {
      datapoint.yValue = [NSNumber numberWithDouble:cosf(xValue)];
   }
   else
   {
      datapoint.yValue = [NSNumber numberWithDouble:sinf(xValue)];
   }
   
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

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   CGFloat margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 10.0 : 100.0;

   _chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.view.bounds, margin, margin)];
   _chart.title = @"Live!";
   
   _chart.licenseKey = @"rS3mkUUne/mi95GMjAxNDA3MjFzdGVwaGVuLm4uZXNoZWxtYW5Ab2JqZWN0dGhpbmsuY29tdr8nNk8qpbHgex6AE6+LVRAaE9fuGbXpuupSWpWHaqsO6pDxG9OpRdLD7JN7N7pDaWGQOAxg+e2R1NldUy2vIIApMrMR+lyeAnENN8Erk7lKYmd0UmcKDw1nDxZ7AogcifWcwLUyGuik5ffgkV17wFqTsGHo=BQxSUisl3BaWf/7myRmmlIjRnMU2cA7q+/03ZX9wdj30RzapYANf51ee3Pi8m2rVW6aD7t6Hi4Qy5vv9xpaQYXF5T7XzsafhzS3hbBokp36BoJZg8IrceBj742nQajYyV7trx5GIw9jy/V6r0bvctKYwTim7Kzq+YPWGMtqtQoU=PFJTQUtleVZhbHVlPjxNb2R1bHVzPnh6YlRrc2dYWWJvQUh5VGR6dkNzQXUrUVAxQnM5b2VrZUxxZVdacnRFbUx3OHZlWStBK3pteXg4NGpJbFkzT2hGdlNYbHZDSjlKVGZQTTF4S2ZweWZBVXBGeXgxRnVBMThOcDNETUxXR1JJbTJ6WXA3a1YyMEdYZGU3RnJyTHZjdGhIbW1BZ21PTTdwMFBsNWlSKzNVMDg5M1N4b2hCZlJ5RHdEeE9vdDNlMD08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
   
   // TODO: add your trial licence key here!
   
   _chart.autoresizingMask =  ~UIViewAutoresizingNone;
   
   // add a pair of axes
   SChartNumberAxis *xAxis = [[SChartNumberAxis alloc] init];
   _chart.xAxis = xAxis;
   
   SChartNumberAxis *yAxis = [[SChartNumberAxis alloc] init];
   _chart.yAxis = yAxis;
   
   [self.view addSubview:_chart];
   
   _chart.backgroundColor = [UIColor clearColor];
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
