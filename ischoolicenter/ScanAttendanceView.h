//
//  ScanAttendanceView.h
//  iCenter
//
//  Created by Jasmond Luk on 4/9/2018.
//  Copyright © 2018 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MyObject.h"
#import "MyClass.h"

@protocol myScanAttendanceViewDelegate <NSObject>

-(void) scan_cancelbuttonpressed:(UIButton *)sender;
-(void) scan_retrybuttonpressed:(UIButton *)sender;
-(void) scan_closebuttonpressed:(UIButton *)sender;
-(void) scan_historybuttonpressed:(UIButton *)sender;


@end

@interface ScanAttendanceView : UIView
{
    //GlobalVariables *globalvariables;
    __weak IBOutlet UILabel *HeaderLabel;
    __weak IBOutlet UIActivityIndicatorView *ailoadindicator;
}

-(id) initWithFrame:(CGRect)frame;
@property (weak,nonatomic)id<myScanAttendanceViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *action;
@property (weak, nonatomic) IBOutlet UILabel *studentname;
@property (weak, nonatomic) IBOutlet UILabel *studentid;
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *classtime;
@property (weak, nonatomic) IBOutlet UILabel *warning;
@property (weak, nonatomic) IBOutlet UILabel *outstanding;
@property (weak, nonatomic) IBOutlet UIImageView *studentimage;
@property (weak, nonatomic) IBOutlet UIImageView *statusimage;
@property (weak, nonatomic) IBOutlet UIImageView *actionimage;
@property (strong, nonatomic) UIImageView *loadingimage;
@property (weak, nonatomic) IBOutlet UITextField *studentkeytext;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *retryButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;



- (IBAction)closebuttonpressed:(UIButton *)sender;
- (IBAction)retrybuttonpressed:(UIButton *)sender;
- (IBAction)buttonhighlightcolor:(UIButton *)sender;
- (IBAction)buttonresetcolor:(UIButton *)sender;
- (IBAction)cancelbuttonpressed:(UIButton *)sender;
- (IBAction)scanhistorybuttonpressed:(UIButton *)sender;
- (void)showLoadingImage:(BOOL)show;

@end
