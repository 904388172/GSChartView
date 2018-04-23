//
//  GSXAxisView.m
//  GSChartLineView
//
//  Created by GS on 2018/4/17.
//  Copyright © 2018年 Demo. All rights reserved.
//

#import "GSXAxisView.h"
#import "GSPlot.h"
#import "UIView+Extension.h"

@interface GSXAxisView () {
    //选中的第几条数据
    NSInteger viewTag;
    
    //如果一条线上的数据有遮挡，上一个数据上移的高度
    CGFloat labelHeight;
    
}

/**
 *  图表顶部留白区域
 */
@property (assign, nonatomic) CGFloat topMargin;
/**
 *  记录图表区域的高度
 */
@property (assign, nonatomic) CGFloat chartHeight;
/**
 *  记录坐标轴Label的高度
 */
@property (assign, nonatomic) CGFloat textHeight;
/**
 *  存放坐标轴的label（底部的）
 */
@property (strong, nonatomic) NSMutableArray *titleLabelArray;
/**
 *  记录坐标轴的第一个Label
 */
@property (strong, nonatomic) UILabel *firstLabel;
/**
 *  记录点按钮的集合
 */
@property (strong, nonatomic) NSMutableArray *buttonPointArray;
/**
 *  选中的点
 */
@property (strong, nonatomic) UIButton *selectedPoint;
/**
 *  选中的点的top值
 */
@property (strong, nonatomic) NSMutableArray *selectedPointArray;

@property (strong, nonatomic) NSMutableArray *pointButtonArray;
/**
 *  一共几条线
 */
@property (assign, nonatomic) CGFloat plotIndex;

@end

@implementation GSXAxisView

#pragma mark =================== 懒加载 ==================
-(NSMutableArray *)pointButtonArray {
    if (_pointButtonArray) {
        _pointButtonArray = [[NSMutableArray alloc] init];
    }
    return _pointButtonArray;
}
-(NSMutableArray *)selectedPointArray {
    if (_selectedPointArray) {
        _selectedPointArray = [[NSMutableArray alloc] init];
    }
    return _selectedPointArray;
}
- (NSMutableArray *)titleLabelArray {
    if (_titleLabelArray) {
        _titleLabelArray = [[NSMutableArray alloc] init];
    }
    return _titleLabelArray;
}
- (NSMutableArray *)buttonPointArray {
    if (_buttonPointArray) {
        _buttonPointArray = [[NSMutableArray alloc] init];
    }
    return _buttonPointArray;
}

#pragma mark =================== 初始化 ==================
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textFont = [UIFont systemFontOfSize:12.0];
    }
    return self;
}
- (void)setPointGap:(CGFloat)pointGap {
    _pointGap = pointGap;
    //顶部留白高度0
    self.topMargin = 0;
    //绘制
    [self draw];
}

- (void)draw {
    self.backgroundColor = self.backColor;
    labelHeight = 15;
    
    //  先移除存在的所有视图
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    //  清空数组
    [self.titleLabelArray removeAllObjects];
    [self.pointButtonArray removeAllObjects];
    
    //  添加坐标轴Label
    for (int i = 0; i < self.xAxisTitleArray.count; i++) {
        //每间隔3个label显示和最后一个label显示，其余不显示
        if (i % 3 ==0 || i == self.xAxisTitleArray.count - 1) {
            NSString *title = self.xAxisTitleArray[i];
            
            UILabel *label = [[UILabel alloc] init];
            label.text = title;
            label.font = self.textFont;
            label.textColor = self.textColor;
            
            NSDictionary *attr = @{NSFontAttributeName : self.textFont};
            CGSize labelSize = [title sizeWithAttributes:attr];
            
            //不从0点开始
            label.x = (i+1) * self.pointGap - labelSize.width/2;
            label.y = self.height - labelSize.height;
            label.width = labelSize.width;
            label.height = labelSize.height;
            
            if (i == 0) {
                //记录坐标轴的第一个点
                self.firstLabel = label;
            }
            [self.titleLabelArray addObject:label];
            [self addSubview:label];
        }
    }
    
    // 添加坐标轴
    NSDictionary *attribute = @{NSFontAttributeName : self.textFont};
    CGSize textSize = [@"x" sizeWithAttributes:attribute];
    self.textHeight = textSize.height;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = self.axisColor;
    view.height = 1;
    view.width = self.width + 200;
    view.x = -200;
    view.y = self.height - textSize.height - self.xAxisTextGap;
    [self addSubview:view];
    
    // 计算横向分割线位置
    self.chartHeight = self.height - textSize.height - self.xAxisTextGap - self.topMargin;
    CGFloat separateHeight = 1;
    CGFloat separateMargin = (self.height - self.topMargin - textSize.height - self.xAxisTextGap - self.numberOfYAxisElements * separateHeight) / self.numberOfYAxisElements;
   
    // 画横向分割线
    if (self.isShowSeparate) {
        //横线
        for (int i = 0; i < self.numberOfYAxisElements; i++) {
            
            UIView *separate = [[UIView alloc] init];
            
            separate.x = 0;
            separate.width = self.width;
            separate.height = separateHeight;
            separate.y = view.y - (i + 1) * (separateMargin + separate.height);
            separate.backgroundColor = self.separateColor;
            [self addSubview:separate];
        }
        for (int i = 0; i < self.xAxisTitleArray.count; i++) {
            if (self.isShowThePointNum) {
                
                UIView *separate = [[UIView alloc] init];
                separate.y = 0;
                separate.width = separateHeight;
                separate.height = self.height - separateMargin/2.0;
                separate.x = (i+1) * self.pointGap;
                separate.backgroundColor = self.separateColor;
                [self addSubview:separate];
            
                UIView *btnView = [[UIView alloc] init];
                btnView.y = 0;
                btnView.tag = 40000 + i;
                btnView.userInteractionEnabled = YES;
                btnView.width = self.pointGap;
                btnView.height = self.height - separateMargin/2.0;
                btnView.x = self.pointGap / 2 + self.pointGap * i;
                btnView.backgroundColor = [UIColor clearColor];
                //添加一个手势
                UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
                //将手势添加到需要相应的view中去
                [btnView addGestureRecognizer:tapGesture];
                
                [self addSubview:btnView];
            }
        }
        // 如果Label的文字有重叠，那么隐藏
        for (int i = 0; i < self.titleLabelArray.count; i++) {
            UILabel *label = self.titleLabelArray[i];
            CGFloat maxX = CGRectGetMaxX(self.firstLabel.frame);
            if (self.isShowTailAndHead == NO) {
                if (i != 0) {
                    if ((maxX + 3) > label.x) {
                        label.hidden = YES;
                    } else {
                        label.hidden = NO;
                        self.firstLabel = label;
                    }
                } else {
                    if (self.firstLabel.x < 0) {
                        self.firstLabel.x = 0;
                    }
                }
            } else {
                if (i > 0 && i < self.titleLabelArray.count - 1) {
                    label.hidden = YES;
                } else if (i == 0){
                    if (self.firstLabel.x < 0) {
                        self.firstLabel.x = 0;
                    }
                } else {
                    if (CGRectGetMaxX(label.frame) > self.width) {
                        label.x = self.width - label.width;
                    }
                }
            }
        }
        
        [self setNeedsDisplay];
    }
}
- (void)drawRect:(CGRect)rect {
    self.plotIndex = 1;
    self.plotIndex = self.plots.count;
    for (NSInteger i = 0; i < self.plots.count; i++) {
        GSPlot *plot = self.plots[i];
        if (plot.withPoint) {  //不用加载不显示点的折线
            [self drawLineInRect:rect withPlot:plot isPoint:NO withPlotIndex:i];
            
            if (plot.withPoint) {
                
                [self drawLineInRect:rect withPlot:plot isPoint:YES withPlotIndex:i];
                
            }
        }
    }
}

- (void)drawLineInRect:(CGRect)rect withPlot:(GSPlot *)plot isPoint:(BOOL)isPoint withPlotIndex:(NSInteger)plotIndex {
    
    if (isPoint) {  // 画点
        for (int i = 0; i < plot.pointArray.count; i++) {
            
            NSNumber *value = plot.pointArray[i];
            NSString *title = [self decimalwithFormat:@"0.00" floatV:value.floatValue];
            
            
            // 判断title的值，整数或者小数
            if (![self isPureFloat:title]) {
                title = [NSString stringWithFormat:@"%.0f", title.floatValue];
            }
            
            
            if (value.floatValue < 0) {
                value = @(0);
            }
            
            CGPoint center = CGPointMake((i+1)*self.pointGap, self.chartHeight - value.floatValue/self.yAxisMaxValue * self.chartHeight + self.topMargin);
            
            if (self.yAxisMaxValue * self.chartHeight == 0) {
                center = CGPointMake((i+1)*self.pointGap, self.chartHeight + self.topMargin);
            }
            
            // 添加point处的Label
            if (self.isShowPointLabel) {
                
                [self addLabelWithTitle:title atLocation:center andTag:i andLineIndex:plotIndex];
                
            }
            
            UIButton *button = [[UIButton alloc] init];
            button.tag = i;
            [button setBackgroundImage:[self imageWithColor:plot.pointColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[self imageWithColor:plot.pointSelectedColor] forState:UIControlStateSelected];
            button.size = CGSizeMake(6, 6);
            button.center = center;
            
            button.layer.cornerRadius = 3;
            button.layer.masksToBounds = YES;
            
            button.userInteractionEnabled = self.isPointUserInteractionEnabled;
            
            [button addTarget:self action:@selector(pointDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.pointButtonArray addObject:button];
            
            if (button.userInteractionEnabled) {
                if (i == 0) {
                    [self pointDidClicked:button];
                }
            }
            
            [self addSubview:button];
        }
        
    }else{
        
        if (plot.isChartViewFill) { // 画线，空白处填充
            
            
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            UIBezierPath *path = [[UIBezierPath alloc] init];
            
            CGPoint start = CGPointMake(self.pointGap, self.height - self.xAxisTextGap - self.textHeight);
            
            [path moveToPoint:start];
            
            for (int i = 0; i < plot.pointArray.count; i++) {
                
                NSNumber *value = plot.pointArray[i];
                
                if (value.floatValue < 0) {
                    value = @(0);
                }
                
                CGPoint center = CGPointMake((i+1)*self.pointGap, self.chartHeight - value.floatValue/self.yAxisMaxValue * self.chartHeight + self.topMargin);
                
                if (self.yAxisMaxValue * self.chartHeight == 0) {
                    center = CGPointMake((i+1)*self.pointGap, self.chartHeight + self.topMargin);
                }
                
                [path addLineToPoint:center];
                
            }
            
            CGPoint end = CGPointMake(plot.pointArray.count*self.pointGap, self.height - self.xAxisTextGap - self.textHeight);
            
            [path addLineToPoint:end];
            
            [plot.lineColor set];
            // 将路径添加到图形上下文
            CGContextAddPath(ctx, path.CGPath);
            // 渲染
            CGContextFillPath(ctx);
            
        }else{  // 画线，只有线，没有填充色
            
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            UIBezierPath *path = [[UIBezierPath alloc] init];
            
            NSNumber *startValue = plot.pointArray.firstObject;
            
            CGPoint start = CGPointMake(self.pointGap, self.chartHeight - startValue.floatValue/self.yAxisMaxValue * self.chartHeight + self.topMargin);
            
            [path moveToPoint:start];
            
            for (int i = 0; i < plot.pointArray.count; i++) {
                
                if (i < plot.pointArray.count - 1) {
                    
                    NSNumber *value = plot.pointArray[i+1];
                    CGPoint center = CGPointMake((i+2)*self.pointGap, self.chartHeight - value.floatValue/self.yAxisMaxValue * self.chartHeight + self.topMargin);
                    
                    if (self.yAxisMaxValue * self.chartHeight == 0) {
                        center = CGPointMake((i+1)*self.pointGap, self.chartHeight + self.topMargin);
                    }
                    [path addLineToPoint:center];
                    
                }
                
            }
            
            [[plot.lineColor colorWithAlphaComponent:0.7] set];
            // 将路径添加到图形上下文
            CGContextAddPath(ctx, path.CGPath);
            // 渲染
            CGContextStrokePath(ctx);
        }
    }
    
}

// 添加pointLabel的方法
- (void)addLabelWithTitle:(NSString *)title atLocation:(CGPoint)location andTag:(NSInteger)i andLineIndex:(NSInteger)index{
    
    if (self.showThePointNum) {
        UILabel *label = [[UILabel alloc] init];
        
        if (self.isPercent) {
            label.text = [NSString stringWithFormat:@"%@%%", title];
        }else{
            label.text = title;
        }
        GSPlot *plot = self.plots[index];
        label.textColor = plot.lineColor;
        label.font = self.textFont;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 50000 * (index + 1) + i;
        
        NSDictionary *attr = @{NSFontAttributeName : self.textFont};
        CGSize buttonSize = [label.text sizeWithAttributes:attr];
        label.hidden = YES;
        if (self.showAllLabel) {
            label.hidden = self.showAllLabel;
        }
        
        label.width = buttonSize.width;
        label.height = buttonSize.height;
        label.x = location.x - label.width / 2;
        label.y = location.y - label.height - 3;
        NSLog(@"label的顶部：%@----%f",label.text,label.y);
        [self addSubview:label];
    } else {
        UIButton *button = [[UIButton alloc] init];
        if (self.isPercent) {
            [button setTitle:[NSString stringWithFormat:@"%@%%", title] forState:UIControlStateNormal];
        } else {
            [button setTitle:title forState:UIControlStateNormal];
        }
        [button setTitleColor:self.textColor forState:UIControlStateNormal];
        button.titleLabel.font = self.textFont;
        button.layer.backgroundColor = self.backColor.CGColor;
        button.tag = i;
        button.userInteractionEnabled = self.isPointUserInteractionEnabled;
        
        NSDictionary *attr = @{NSFontAttributeName : self.textFont};
        CGSize buttonSize = [button.currentTitle sizeWithAttributes:attr];
        
        button.width = buttonSize.width;
        button.height = buttonSize.height;
        button.x = location.x - button.width / 2;
        button.y = location.y - button.height - 3;
        [button addTarget:self action:@selector(pointDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

//点击某个折线上的点
- (void)pointDidClicked:(UIButton *)button {
    
    self.selectedPoint.selected = NO;
    UIButton *pointButton = [self.pointButtonArray objectAtIndex:button.tag];
    pointButton.selected = YES;
    self.selectedPoint = pointButton;
    
    if ([self.delegate respondsToSelector:@selector(xAxisView:didClickButtonAtIndex:)]) {
        [self.delegate xAxisView:self didClickButtonAtIndex:button.tag];
    }
}
//选中某一条x轴上的所有点显示数据
- (void) event:(UITapGestureRecognizer *)tap {
    NSLog(@"%@%ld",@"点击的是哪个view",tap.view.tag);
    if (viewTag != tap.view.tag) {
        for (int j = 1; j <= self.plotIndex; j++) {
            for (int i = 0; i < self.xAxisTitleArray.count; i++) {
                
                UILabel *pointLabel = (UILabel *)[self viewWithTag:50000 * j + i];
                pointLabel.hidden = YES;
            }
        }

        viewTag = tap.view.tag;
        [self.selectedPointArray removeAllObjects];
        for (NSInteger i = 0; i < self.plots.count; i++) {
            UILabel *pointLabel = (UILabel *)[self viewWithTag:tap.view.tag  + 10000 + 50000 * i];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            float top = pointLabel.y;
            [dic setObject:[NSNumber numberWithFloat:top] forKey:@"top"];
            [dic setObject:[NSNumber numberWithInteger:(tap.view.tag  + 10000 + 50000*i)] forKey:@"index"];
            [self.selectedPointArray addObject:dic];
            pointLabel.hidden = NO;
        }
        for (int i = 0; i < self.selectedPointArray.count; i++) {
            for (int j = 0; j < self.selectedPointArray.count; j++) {
                if (self.selectedPointArray[i][@"top"] < self.selectedPointArray[j][@"top"]) {
                    NSDictionary *tmp = self.selectedPointArray[i];
                    self.selectedPointArray[i] = self.selectedPointArray[j];
                    self.selectedPointArray[j] = tmp;
                }
            }
        }
        float temp = [self.selectedPointArray[0][@"top"] floatValue];
        for (int i = 1; i < self.selectedPointArray.count; i++) {
            if (fabsf([self.selectedPointArray[i][@"top"] floatValue] - temp) < labelHeight && [self.selectedPointArray[i][@"top"] floatValue] != temp) {
                UILabel *lab;
                if ([self.selectedPointArray[i][@"top"] floatValue] < [self.selectedPointArray[i-1][@"top"] floatValue]) {
                    lab = (UILabel *)[self viewWithTag:[self.selectedPointArray[i][@"index"] intValue]];

                } else {
                    lab = (UILabel *)[self viewWithTag:[self.selectedPointArray[i - 1][@"index"] intValue]];
                }
                lab.y = lab.y - labelHeight;
                return;
            }
        }

        if ([self.delegate respondsToSelector:@selector(xAxisView:didClickButtonAtIndex:)]) {
            [self.delegate xAxisView:self didClickButtonAtIndex:tap.view.tag - 40000];
        }
    }
}

- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}
// 判断是小数还是整数
- (BOOL)isPureFloat:(NSString *)numStr
{
    CGFloat num = [numStr floatValue];
    int i = num;
    CGFloat result = num - i;
    
    // 当不等于0时，是小数
    return result != 0;
}
//以颜色当图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}





@end
