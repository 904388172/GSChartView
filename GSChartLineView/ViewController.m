//
//  ViewController.m
//  GSChartLineView
//
//  Created by GS on 2018/4/17.
//  Copyright © 2018年 Demo. All rights reserved.
//

#import "ViewController.h"
#import "GSLineChartView.h"
#import "UIView+Extension.h"
#import "GSPlot.h"
#import "UIColor+Hex.h"

@interface ViewController () <GSLineChartViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加折线图
    [self addZhexian];
    
}
#pragma mark =================== 添加折线 ==================
- (void)addZhexian {
    GSLineChartView *ccc = [[GSLineChartView alloc] init];
    [self.view addSubview:ccc];
    
    ccc.width = self.view.width;
    
    ccc.yAxisViewWidth = 52; //纵轴距离左边的间距
    
    ccc.numberOfYAxisElements = 5; //纵轴点个数
    
    ccc.delegate = self;
    ccc.pointUserInteractionEnabled = YES;
    
    ccc.yAxisMaxValue = 1000;
    
    ccc.pointGap = 50;
    
    ccc.showSeparate = YES;
    ccc.separateColor = [UIColor colorWithHexString:@"67707c"];
    ccc.showThePointNum = YES;
    
    ccc.textColor = [UIColor colorWithHexString:@"9aafc1"];
    ccc.backColor = [UIColor whiteColor];
    ccc.axisColor = [UIColor colorWithHexString:@"67707c"];
    
    ccc.xAxisTitleArray = @[@"4.1", @"4.2", @"4.3", @"4.4", @"4.5", @"4.6", @"4.7", @"4.8", @"4.9", @"4.10", @"4.11", @"4.12", @"4.13", @"4.14", @"4.15", @"4.16", @"4.17", @"4.18", @"4.19", @"4.20", @"4.21", @"4.22", @"4.23", @"4.24", @"4.25", @"4.26", @"4.27", @"4.28", @"4.29", @"4.30"];
    
    
    ccc.x = 0;
    ccc.y = 100;
    ccc.width = self.view.width;
    ccc.height = 300;
    
    
    //第一条折线
    GSPlot *plot = [[GSPlot alloc] init];
    plot.pointArray = @[@300, @550, @700, @200, @370, @890, @760, @430, @210, @30, @300, @550, @700, @200, @370, @890, @760, @430, @210, @30, @300, @550, @700, @200, @370, @890, @760, @430, @210, @30];
    plot.lineColor = [UIColor lightGrayColor];
    plot.pointColor = [UIColor colorWithHexString:@"14b9d6"];
    plot.chartViewFill = NO;
    plot.withPoint = YES;
    
    //第二条折线
    GSPlot *plot1 = [[GSPlot alloc] init];
    plot1.pointArray = @[@100, @300, @200, @120, @650, @770, @240, @530, @10, @90, @100, @300, @200, @120, @650, @770, @240, @530, @10, @90, @100, @300, @200, @120, @650, @770, @240, @530, @10, @90];
    plot1.lineColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    plot1.pointColor = [UIColor redColor];
    plot1.chartViewFill = NO;
    plot1.withPoint = YES;
    
    //第三条折线
    GSPlot *plot2 = [[GSPlot alloc] init];
    plot2.pointArray = @[@300, @200, @120, @650, @770, @240, @530, @10, @90, @100, @300, @200, @120, @650, @770, @240, @530, @10, @90, @100, @300, @200, @120, @650, @770, @240, @530, @10, @90, @100];
    plot2.lineColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
    plot2.pointColor = [UIColor blueColor];
    plot2.chartViewFill = NO;
    plot2.withPoint = YES;
    
    [ccc addPlot:plot];
    [ccc addPlot:plot1];
    [ccc addPlot:plot2];
    [ccc draw];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)lineChartView:(GSLineChartView *)lineChartView DidClickPointAtIndex:(NSInteger)index {
    
    NSLog(@"%ld", index);
    
}

@end
