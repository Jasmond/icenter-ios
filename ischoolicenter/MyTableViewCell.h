//
//  MyTableViewCell.h
//  ischoolicenter
//
//  Created by Jasmond Luk on 30/5/2016.
//  Copyright © 2016 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"
#import "GCPlaceholderTextView.h"

@import Charts;

@interface MyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageview1;
@property (weak, nonatomic) IBOutlet UIImageView *imageview2;
@property (weak, nonatomic) IBOutlet UIImageView *imageview3;
@property (weak, nonatomic) IBOutlet UIImageView *imageview4;
@property (weak, nonatomic) IBOutlet UIImageView *imageview5;
@property (weak, nonatomic) IBOutlet UIImageView *imageview6;
@property (weak, nonatomic) IBOutlet UIImageView *imageview7;
@property (weak, nonatomic) IBOutlet UIImageView *imageview8;
@property (weak, nonatomic) IBOutlet UIImageView *imageview9;
@property (weak, nonatomic) IBOutlet UIImageView *imageview10;
@property (weak, nonatomic) IBOutlet UIImageView *imageview11;
@property (weak, nonatomic) IBOutlet UIImageView *imageview12;
@property (weak, nonatomic) IBOutlet UIImageView *imageview13;
@property (weak, nonatomic) IBOutlet UIImageView *imageview14;



@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *label8;
@property (weak, nonatomic) IBOutlet UILabel *label9;
@property (weak, nonatomic) IBOutlet UILabel *label10;
@property (weak, nonatomic) IBOutlet UILabel *label11;
@property (weak, nonatomic) IBOutlet UILabel *label12;
@property (weak, nonatomic) IBOutlet UILabel *label13;
@property (weak, nonatomic) IBOutlet UILabel *label14;
@property (weak, nonatomic) IBOutlet UILabel *label15;
@property (weak, nonatomic) IBOutlet UILabel *label16;
@property (weak, nonatomic) IBOutlet UILabel *label17;
@property (weak, nonatomic) IBOutlet UILabel *label18;
@property (weak, nonatomic) IBOutlet UILabel *label19;
@property (weak, nonatomic) IBOutlet UILabel *label20;
@property (weak, nonatomic) IBOutlet UILabel *label21;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIButton *button7;
@property (weak, nonatomic) IBOutlet UIButton *button8;
@property (weak, nonatomic) IBOutlet UIButton *button9;
@property (weak, nonatomic) IBOutlet UIButton *button10;
@property (weak, nonatomic) IBOutlet UIButton *button11;
@property (weak, nonatomic) IBOutlet UIButton *button12;
@property (weak, nonatomic) IBOutlet UIButton *button13;
@property (weak, nonatomic) IBOutlet UIButton *button14;
@property (weak, nonatomic) IBOutlet UIButton *button15;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1heightconstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingcontraint1;

@property (weak, nonatomic) IBOutlet UIStackView *stackview1;
@property (weak, nonatomic) IBOutlet UIStackView *stackview2;
@property (weak, nonatomic) IBOutlet UIStackView *stackview3;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionviewheightconstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint3;

@property (weak, nonatomic) IBOutlet UIView *separator1;
@property (weak, nonatomic) IBOutlet NMRangeSlider *rangeslider1;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedcontrol1;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedcontrol2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutconstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutconstraint2;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview1;
@property (weak, nonatomic) IBOutlet UITextView *textview1;

@property (weak, nonatomic) IBOutlet UISwitch *switch1;
@property (weak, nonatomic) IBOutlet BarChartView *barchartview1;

@property (weak, nonatomic) IBOutlet UITextView *textview2;
@property (weak, nonatomic) IBOutlet UITextField *textfield1;
@property (weak, nonatomic) IBOutlet UITextField *textfield2;
@property (weak, nonatomic) IBOutlet UITextField *textfield3;
@property (weak, nonatomic) IBOutlet UITextField *textfield4;
@property (weak, nonatomic) IBOutlet UITextField *textfield5;

@property (weak, nonatomic) IBOutlet UISlider *slider1;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *gctextview1;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *gctextview2;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerview1;

@end
