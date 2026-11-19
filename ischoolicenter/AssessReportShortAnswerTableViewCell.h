//
//  AssessReportShortAnswerTableViewCell.h
//  iCenter
//
//  Created by Jasmond Luk on 26/8/2022.
//  Copyright © 2022 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssessReportShortAnswerTableViewCell : UITableViewCell
{
    
}
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *gctextview1;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *gctextview2;
@property (weak, nonatomic) IBOutlet UIButton *button1;

@end

NS_ASSUME_NONNULL_END
