//
//  ViewController.h
//  CorePlotTest
//
//  Created by gong wen kai on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
@interface ViewController : UIViewController<CPTPlotDataSource>
{
    CPTXYGraph                  *graph;             //画板
    CPTScatterPlot              *dataSourceLinePlot;//线
    NSMutableArray              *dataForPlot1;      //坐标数组
    NSTimer                     *timer1;            //定时器
    int                         j;
    int                         r;
    int                         tmp;   //临时变量
    float                       valuesMin;
    float                       valuesMax;
    
}
@property (retain, nonatomic) NSMutableArray *dataForPlot1;
@end
