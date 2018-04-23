//
//  GSYAxisView.m
//  GSChartLineView
//
//  Created by GS on 2018/4/17.
//  Copyright © 2018年 Demo. All rights reserved.
//

#import "GSYAxisView.h"
#import "UIView+Extension.h"

@interface GSYAxisView ()

@property (nonatomic, strong) UIView *separate;

@end

@implementation GSYAxisView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //y轴
        UIView *separate = [[UIView alloc] init];
        self.separate = separate;
        [self addSubview:separate];
        self.textFont = [UIFont systemFontOfSize:13];
    }
    return self;
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
}
- (void)draw {
    self.backgroundColor = self.backColor;
    
    //计算坐标轴位置及大小
    NSDictionary *attr = @{NSFontAttributeName : self.textFont};
    
    CGSize labelSize = [@"x" sizeWithAttributes:attr];
    
    self.separate.backgroundColor = self.axisColor;
    self.separate.x = self.width - 1;
    self.separate.width = 1;
    self.separate.y = 0;
    self.separate.height = self.height - labelSize.height - self.xAxisTextGap;
    
    // Label做占据的高度
    CGFloat allLabelHeight = self.height - self.xAxisTextGap - labelSize.height;
    
    // Label之间的间隙
    CGFloat labelMargin = (allLabelHeight + labelSize.height - (self.numberOfYAxisElements + 1) * labelSize.height) / self.numberOfYAxisElements;
    
    // 移除所有的Label
    for (UILabel *label in self.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            
            [label removeFromSuperview];
        }
    }
    
    // 添加Label
    for (int i = 0; i < self.numberOfYAxisElements + 1; i++) {
        UILabel *label = [[UILabel alloc] init];
        CGFloat avgValue = self.yAxisMaxValue / (self.numberOfYAxisElements);
        if (self.isPercent) {
            label.text = [NSString stringWithFormat:@"%.0f%%", avgValue * i];
        }else{
            // 当数值大于10万时，单位按万显示
            if (self.yAxisMaxValue >= 100000) {
                label.text = [NSString stringWithFormat:@"%.1f万", avgValue / 100000.0 * i];
            } else {
                label.text = [NSString stringWithFormat:@"%.0f", avgValue * i];
            }
        }
        
        label.textAlignment = NSTextAlignmentRight;// UITextAlignmentRight;
        label.font = self.textFont;
        label.textColor = self.textColor;
        
        label.x = 0;
        label.height = labelSize.height;
        label.y = self.height - labelSize.height - self.xAxisTextGap - (label.height + labelMargin) * i - label.height/2;
        label.width = self.width - 1 - self.yAxisTextGap;
        [self addSubview:label];
    }
}














@end
