//
//  AssessmentPrintView.h
//  iCenter
//
//  Created by Jasmond Luk on 3/8/2022.
//  Copyright © 2022 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "MyClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssessmentPrintView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
{
    GlobalVariables *globalvariables;
    __weak IBOutlet UIImageView *logo;
    __weak IBOutlet UITableView *reportTable;
    __weak IBOutlet NSLayoutConstraint *reportTableHeight;
    __weak IBOutlet UILabel *studentLabel;
    __weak IBOutlet UILabel *dobLabel;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UILabel *formLabel;
    __weak IBOutlet UIStackView *viewstack;
    __weak IBOutlet UILabel *instructorLabel;
    __weak IBOutlet UILabel *sumbitdateLabel;
    
    
    NSMutableArray *assessmentformarray;
    
    NSArray *assessmentColorArray;
    AssessmentFormRowObject *assessmentformrowobject;
}

@property (weak, nonatomic) IBOutlet UIView *view;
- (id)initWithFrame:(CGRect)frame assessmentformarray:(NSMutableArray *)_assessmentformarray classrecord:(nonnull ClassScheduleRecord *)_classrecord assessmentformobject:(AssessmentFormListObject *)assessmentformobject tableheight:(CGFloat)_tableheight;

@end

NS_ASSUME_NONNULL_END
