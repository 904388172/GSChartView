//
//  GSPlot.m
//  GSChartLineView
//
//  Created by GS on 2018/4/17.
//  Copyright © 2018年 Demo. All rights reserved.
//

#import "GSPlot.h"

@implementation GSPlot

- (instancetype)init {
    if (self = [super init]) {
        self.lineColor = [UIColor blackColor];
        self.pointColor = [UIColor blackColor];
        self.pointSelectedColor = [UIColor blackColor];
    }
    return self;
}
@end
