//
//  ViewController.m
//  CorePlotTest
//
//  Created by gong wen kai on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize dataForPlot1;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    graph = [[CPTXYGraph alloc] initWithFrame:self.view.bounds];

    
    //给画板添加一个主题
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    
    //创建主画板视图添加画板
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    hostingView.hostedGraph = graph;
    
	[self.view addSubview:hostingView];
    [hostingView release];

    //设置留白
    graph.paddingLeft = 0;
	graph.paddingTop = 0;
	graph.paddingRight = 0;
	graph.paddingBottom = 0;
    
    graph.plotAreaFrame.paddingLeft = 100.0 ;
    graph.plotAreaFrame.paddingTop = 80.0 ;
    graph.plotAreaFrame.paddingRight = 50.0 ;
    graph.plotAreaFrame.paddingBottom = 80.0 ;
    //设置坐标范围
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(600.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(1000.0)];
  
    
    // Grid lines
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.15;
    majorGridLineStyle.lineColor = [CPTColor greenColor];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [CPTColor blueColor];
    
    //设置坐标刻度大小
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet ;
    CPTXYAxis *x = axisSet.xAxis ;
    x. minorTickLineStyle = minorGridLineStyle ;
    x. majorGridLineStyle = majorGridLineStyle ;
    // 大刻度线间距： 50 单位
    x. majorIntervalLength = CPTDecimalFromString ( @"50" );
    // 坐标原点： 0
    x. orthogonalCoordinateDecimal = CPTDecimalFromString ( @"0" );
    // title
    x.title                       = @"X Axis";
    x.titleOffset                 = 50.0;
    
    // axis position
    x.axisConstraints             = [CPTConstraints constraintWithLowerOffset:0.0];
    
    CPTXYAxis *y = axisSet.yAxis ;
    //y 轴：不显示小刻度线
    y. minorTickLineStyle = minorGridLineStyle ;
    y. majorGridLineStyle = majorGridLineStyle ;
    // 大刻度线间距： 50 单位
    y. majorIntervalLength = CPTDecimalFromString ( @"50" );
    // 坐标原点： 0
    y. orthogonalCoordinateDecimal = CPTDecimalFromString (@"0");
    // title
    y.title                       = @"Y Axis";
    y.titleOffset                 = 55.0;
    
    // axis position fixed
    y.axisConstraints             = [CPTConstraints constraintWithLowerOffset:0.0];
    
    //创建blue色区域
    dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
    dataSourceLinePlot.identifier = @"Blue Plot";
    
    //设置blue色区域边框的样式
    CPTMutableLineStyle *lineStyle = [[dataSourceLinePlot.dataLineStyle mutableCopy] autorelease];
    lineStyle.lineWidth = 2.f;
    lineStyle.lineColor = [CPTColor blueColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    //设置透明实现添加动画
    dataSourceLinePlot.opacity = 0.0f;

    //设置数据元代理
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];

    
    // 创建一个颜色渐变：从 建变色 1 渐变到 无色
    CPTGradient *areaGradient = [ CPTGradient gradientWithBeginningColor :[CPTColor blueColor] endingColor :[CPTColor colorWithComponentRed:0.0 green:0.0 blue:0.10 alpha:0.1]];
    // 渐变角度： -90 度（顺时针旋转）
    areaGradient.angle = -90.0f ;
    // 创建一个颜色填充：以颜色渐变进行填充
    CPTFill *areaGradientFill = [ CPTFill fillWithGradient :areaGradient];
    // 为图形设置渐变区
    //dataSourceLinePlot. areaFill = areaGradientFill;
    dataSourceLinePlot. areaBaseValue = CPTDecimalFromString ( @"0.0" );
    dataSourceLinePlot.interpolation = CPTScatterPlotInterpolationLinear ;
    
    // PLOTSymbol
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    [plotSymbol setSize:CGSizeMake(5, 5)];
    [plotSymbol setFill:[CPTFill fillWithColor:[CPTColor blueColor]]];
    [plotSymbol setLineStyle:nil];
    dataSourceLinePlot.plotSymbol = plotSymbol;
    
    
    dataForPlot1 = [[NSMutableArray alloc] init];
    j = 600;
    r = 0;
    tmp = 100;
    timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dataOpt) userInfo:nil repeats:YES];
    [timer1 fire];
    
}

- (void) dataOpt
{
    //添加随机数
    if ([dataSourceLinePlot.identifier isEqual:@"Blue Plot"]) {
        NSString *xp = [NSString stringWithFormat:@"%d",j];
        NSString *yp = [NSString stringWithFormat:@"%d",(rand()%1000)+tmp];
        NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
        
        // 去除旧数据点
        if(dataForPlot1.count == 11)
        {
            [dataForPlot1 removeObjectAtIndex:11-1];
        }
        [dataForPlot1 insertObject:point1 atIndex:0];
        
    }
    
    
    //刷新画板
    [graph reloadData];
    

    // 调整坐标轴
    [graph.defaultPlotSpace scaleToFitPlots:[graph allPlots]];
    
    j = j + 60;
    r = r + 60;
    tmp = tmp + 100;
    
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#pragma mark - dataSourceOpt

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [dataForPlot1 count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
    NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    NSNumber *num;
    //让视图偏移
	if ( [(NSString *)plot.identifier isEqualToString:@"Blue Plot"] ) {
        num = [[dataForPlot1 objectAtIndex:index] valueForKey:key];
        if ( fieldEnum == CPTScatterPlotFieldX ) {
			num = [NSNumber numberWithDouble:[num doubleValue] - r];
		}
	}
    //添加动画效果
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeInAnimation.duration = 1.0f;
	fadeInAnimation.removedOnCompletion = NO;
	fadeInAnimation.fillMode = kCAFillModeForwards;
	fadeInAnimation.toValue = [NSNumber numberWithFloat:2.0];
	[dataSourceLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    return num;
}

@end
