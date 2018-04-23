//
//  GSPlot.h
//  GSChartLineView
//
//  Created by GS on 2018/4/17.
//  Copyright © 2018年 Demo. All rights reserved.
//

/**
* 折线
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GSPlot : NSObject

/**
 *  线的颜色
 */
@property (strong, nonatomic) UIColor *lineColor;

/**
 *  坐标点数组
 */
@property (strong, nonatomic) NSArray *pointArray;

/**
 *  坐标点颜色
 */
@property (strong, nonatomic) UIColor *pointColor;

/**
 *  坐标点选中颜色
 */
@property (strong, nonatomic) UIColor *pointSelectedColor;

/**
 *  是否将颜色充满图表
 */
@property (assign, nonatomic, getter=isChartViewFill) BOOL chartViewFill;

@property (assign, nonatomic) BOOL withPoint;

@end
