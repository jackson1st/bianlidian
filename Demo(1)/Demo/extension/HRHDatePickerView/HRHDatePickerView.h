//
//  HRHDatePickerView.h
//  HRHDatePickerView
//
//  Created by 1 on 15/12/26.
//  Copyright © 2015年 HRH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    
    // 开始日期
    DateTypeOfStart = 0,
    
    // 结束日期
    DateTypeOfEnd,
    
}DateType;

@protocol HRHDatePickerViewDelegate <NSObject>

- (void)getSelectDate:(NSString *)date type:(DateType)type;

@end

@interface HRHDatePickerView : UIView

+ (HRHDatePickerView *)instanceDatePickerView;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;

@property (nonatomic, weak) id<HRHDatePickerViewDelegate> delegate;

@property (nonatomic, assign) DateType type;

@end
