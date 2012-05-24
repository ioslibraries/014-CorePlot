//
//  ILCustomViewController.m
//  PlotApp
//
//  Created by jeremy Templier on 22/05/12.
//  Copyright (c) 2012 particulier. All rights reserved.
//

#import "ILCustomViewController.h"
#import "CorePlot-CocoaTouch.h"

@interface ILCustomViewController ()

@property (nonatomic, strong) NSMutableArray* datas;
@end

@implementation ILCustomViewController
@synthesize datas;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.datas = [NSMutableArray array];
    for (NSInteger i = 0; i < 30; i++) {
        float x = arc4random() % 30 +10;
        [self.datas addObject:[NSNumber numberWithFloat:x]];
    }
    
    CPTGraphHostingView * chartView = [[CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:chartView];
    
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    CPTXYGraph* graph = (CPTXYGraph *)[theme newGraph];	
    chartView.hostedGraph = graph;
    
    
    graph.paddingLeft = 10.0;
    graph.paddingTop = 10.0;
    graph.paddingRight = 10.0;
    graph.paddingBottom = 10.0;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                    length:CPTDecimalFromFloat([self.datas count])];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                    length:CPTDecimalFromFloat(100)];

    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    CPTXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPTDecimalFromFloat(10);
    x.minorTicksPerInterval = 2;
    x.borderWidth = 0;
    x.labelExclusionRanges = [NSArray arrayWithObjects:nil];
    
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPTDecimalFromFloat(10);
    y.minorTicksPerInterval = 1;
    y.labelExclusionRanges = [NSArray arrayWithObjects:
                              [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-100) 
                                                           length:CPTDecimalFromFloat(300)], 
							  nil];
   
    
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot.identifier = @"AllTests";
    CPTMutableLineStyle* lineStyle = [[CPTMutableLineStyle alloc] init];
    lineStyle.lineWidth = 1.0f;
    dataSourceLinePlot.dataLineStyle = lineStyle;
    lineStyle.lineColor = [CPTColor blackColor];
    
    dataSourceLinePlot.plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    dataSourceLinePlot.plotSymbol.size = CGSizeMake(7.0f, 7.0f);
    dataSourceLinePlot.plotSymbol.fill = [CPTFill fillWithColor:[CPTColor greenColor]];
    
    dataSourceLinePlot.dataSource = self;
    dataSourceLinePlot.delegate = self;
    
    [graph addPlot:dataSourceLinePlot];
    
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:[CPTColor greenColor] 
                                                            endingColor:[CPTColor greenColor]];
    areaGradient.angle = -90.0f;

    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    dataSourceLinePlot.areaFill = areaGradientFill;
    dataSourceLinePlot.areaBaseValue = CPTDecimalFromString(@"1.75");

    
}

//data source
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot 
{
    return [self.datas count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
    switch (fieldEnum)
    {
        case CPTScatterPlotFieldX: 
        {
            int x = [self.datas count]-index; 
            return [NSDecimalNumber numberWithInt:x];
        }
        case CPTScatterPlotFieldY:
        {
            if ([plot.identifier isEqual:@"AllTests"])
            {
                float v = [[self.datas objectAtIndex:index] floatValue];
                return [NSNumber numberWithFloat:v];
            }
        }
    }
    return nil;
}

//scatter plot delegate
- (void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index {
    CGPoint center = [plot plotAreaPointOfVisiblePointAtIndex:index];
    float v;
    if ([plot.identifier isEqual:@"AllTests"])
    {
        v = [[self.datas objectAtIndex:index] floatValue];
    }
    NSLog(@"Tap on %f : %@", v, NSStringFromCGPoint(center));    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
