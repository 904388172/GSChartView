//
//  GSLineChartView.h
//  GSChartLineView
//
//  Created by GS on 2018/4/17.
//  Copyright © 2018年 Demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPlot.h"

@class GSLineChartView;

@protocol GSLineChartViewDelegate <NSObject>

@optional

- (void) lineChartView:(GSLineChartView *)lineChartView DidClickPointAtIndex:(NSInteger)index;

@end

@interface GSLineChartView : UIView

@property (nonatomic, weak) id<GSLineChartViewDelegate> delegate;



/**
* 文字大小
*/
@property (nonatomic, assign) UIFont *textFont;

/**
* 文字颜色
*/
@property (nonatomic, strong) UIColor *textColor;

/**
* x轴文字与坐标轴间隙
*/
@property (nonatomic, assign) CGFloat xAxisTextGap;

/**
* 坐标轴颜色
*/
@property (nonatomic, strong) UIColor *axisColor;

/**
* x轴的文字集合
*/
@property (nonatomic, strong) NSArray *xAxisTitleArray;

/**
* 点与点之间的间距
*/
@property (nonatomic, assign) CGFloat pointGap;

/**
* y轴文字与坐标轴间隙
*/
@property (nonatomic, assign) CGFloat yAxisTextGap;

/**
* y轴的最大值
*/
@property (nonatomic, assign) CGFloat yAxisMaxValue;

/**
* y轴分为几段（默认5）
*/
@property (nonatomic, assign) int numberOfYAxisElements ;

/**
* y轴与左侧的间距
*/
@property (nonatomic, assign) CGFloat yAxisViewWidth;

/**
* y轴数值是否添加百分号
*/
@property (nonatomic, assign, getter=isPercent) BOOL percent;

/**
 *  是否显示点Label
 */
@property (assign, nonatomic, getter=isShowPointLabel) BOOL showPointLabel;

/**
 *  存放plot的数组
 */
@property (strong, nonatomic) NSMutableArray *plots;

/**
 *  是否显示横向分割线
 */
@property (assign, nonatomic, getter=isShowSeparate) BOOL showSeparate;

/**
 *  横向分割线的颜色
 */
@property (strong, nonatomic) UIColor *separateColor;

/**
 *  视图的背景颜色
 */
@property (strong, nonatomic) UIColor *backColor;

/**
 *  点是否允许点击
 */
@property (assign, nonatomic, getter=isPointUserInteractionEnabled) BOOL pointUserInteractionEnabled;
/**
* 是否允许点击竖线，显示线上的数据
*/
@property (assign, nonatomic, getter=isShowThePointNum) BOOL showThePointNum;
/**
 * 是否显示所有点的数据
 */
@property (nonatomic, assign, getter=isShowAllLabel) BOOL showAllLabel;
/**
 *  定位时的索引值
 */
@property (assign, nonatomic) NSInteger index;

/**
 *  快速创建lineChartView的方法
 */
+ (instancetype)lineChartView;

/**
* 添加折线
*/
- (void)addPlot:(GSPlot *)plot;

- (void)draw;

@end
