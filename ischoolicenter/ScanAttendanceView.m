//
//  ScanAttendanceView.m
//  iCenter
//
//  Created by Jasmond Luk on 4/9/2018.
//  Copyright © 2018 DreamHigh Company Limited. All rights reserved.
//

#import "ScanAttendanceView.h"


@implementation ScanAttendanceView
@synthesize studentname,studentid,subject,classtime,warning,outstanding,studentimage,statusimage,actionimage,loadingimage,studentkeytext,action,closeButton,retryButton,cancelButton,historyButton;

-(id) initWithFrame:(CGRect)frame
{

    //globalvariables=[GlobalVariables singleObj];
    
    
    NSString* nibName = NSStringFromClass([self class]);
    self = [super initWithFrame:frame];
    if (self) {
        if ([[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil]) {
            
            HeaderLabel.text=[MyClass returntitlewithtitle:@"Attendance Taking by Scan Code"];
            
            [closeButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            [closeButton setTitle:[MyClass returntitlewithtitle:@"Close"] forState:UIControlStateNormal];
            closeButton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
            closeButton.layer.borderWidth=1;

            [retryButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            [retryButton setTitle:[MyClass returntitlewithtitle:@"Retry"] forState:UIControlStateNormal];
            retryButton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
            retryButton.layer.borderWidth=1;
            retryButton.hidden=YES;
            
            [cancelButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            [cancelButton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
            cancelButton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
            cancelButton.layer.borderWidth=1;
            cancelButton.hidden=YES;
            
            loadingimage=[[UIImageView alloc]initWithFrame:CGRectMake(-20, -20, 80, 80)];
            loadingimage.animationImages= [[NSArray alloc]initWithObjects:
                                                [UIImage imageNamed:@"loading_icon1.png"],
                                                [UIImage imageNamed:@"loading_icon2.png"],
                                                [UIImage imageNamed:@"loading_icon3.png"],
                                                [UIImage imageNamed:@"loading_icon4.png"],
                                                [UIImage imageNamed:@"loading_icon5.png"],
                                                [UIImage imageNamed:@"loading_icon6.png"],
                                                [UIImage imageNamed:@"loading_icon7.png"],
                                                [UIImage imageNamed:@"loading_icon8.png"],
                                                [UIImage imageNamed:@"loading_icon9.png"],
                                                [UIImage imageNamed:@"loading_icon10.png"],
                                                [UIImage imageNamed:@"loading_icon11.png"],
                                                [UIImage imageNamed:@"loading_icon12.png"], nil];
            loadingimage.animationDuration=1;
            [loadingimage startAnimating];
            

            ailoadindicator.transform=CGAffineTransformMakeScale(1, 1);
            [ailoadindicator startAnimating];
            [ailoadindicator addSubview:loadingimage];
            
            self.view.frame=self.bounds;
            [self addSubview:self.view];
        }
    }
    return self;
    
    
}

-(void) showLoadingImage:(BOOL)show
{
    if (show) {
        [loadingimage startAnimating];
        [ailoadindicator startAnimating];
    }else{
        [loadingimage stopAnimating];
        [ailoadindicator stopAnimating];
    }
}

- (IBAction)closebuttonpressed:(UIButton *)sender {
    [self.delegate scan_closebuttonpressed:sender];
}

- (IBAction)retrybuttonpressed:(UIButton *)sender {
    [self.delegate scan_retrybuttonpressed:sender];
}

- (IBAction)cancelbuttonpressed:(UIButton *)sender {
    [self.delegate scan_cancelbuttonpressed:sender];
}

- (IBAction)scanhistorybuttonpressed:(UIButton *)sender {
    [self.delegate scan_historybuttonpressed:sender];
}

- (IBAction)buttonhighlightcolor:(UIButton *)sender {
    sender.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)buttonresetcolor:(UIButton *)sender {
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
}




@end
