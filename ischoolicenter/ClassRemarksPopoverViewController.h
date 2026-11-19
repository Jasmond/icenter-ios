//
//  ClassRemarksPopoverViewController.h
//  ELTestX
//
//  Created by Jasmond Luk on 5/9/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "GCPlaceholderTextView.h"
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
#import "MessagePopoverViewController.h"

@protocol myClassRemarksPopoverViewControllerDelegate <NSObject>

-(void) dismissclassremarkspopover;
-(void) dismisssextendpopover;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;

@end

@interface ClassRemarksPopoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UIGestureRecognizerDelegate,UIDocumentInteractionControllerDelegate,MFMailComposeViewControllerDelegate,UIPrintInteractionControllerDelegate,UIPopoverPresentationControllerDelegate>
{
    GlobalVariables *globalvariables;
    
    __weak IBOutlet UITableView *classremarkstable;
    UITableView *extendedclasstable;
    UIView *extendmasterview;
    
    float keyboardheight;
    UILabel *remarkstitle;

    __weak IBOutlet UIButton *remarksbutton;
    __weak IBOutlet UIButton *extendbutton;
    __weak IBOutlet UIButton *assessmentbutton;
    __weak IBOutlet NSLayoutConstraint *buttonStackWidthConstraints;
    __weak IBOutlet NSLayoutConstraint *assessmenttablebottomconstraint;
    
    //UIView *assessmentmasterview;
    __weak IBOutlet UIView *assessmentmasterview;
    UIView *formtitleview;
    
    int extendedtotime;
    int extendedfromtime;
    int outstandingextendedtime;
    
    NSMutableArray *outstandingextendedclassarray;
    NSMutableArray *extendedtoclassarray;
    NSMutableArray *extendedfromclassarray;
    
    UILabel *extendedfrom_classdatetime;
    UILabel *extendedfrom_schedulename;
    UILabel *extendedfrom_extendedminute;

    UILabel *extendedto_classdatetime;
    UILabel *extendedto_schedulename;
    UILabel *extendedto_extendedminute;
    
    UILabel *outstanding_fromclassdatetime;
    UILabel *outstanding_schedulename;
    UILabel *outstanding_remainingtime;
    
    ExtendedClassRecord *extendedclassobject;
    
    long thisclassduration;
    
    UILabel *extendedtimelabel;
    UILabel *outstandingbalancelabel;
    UITextField *timetoextendtext;
    
    UIView *extendedtoheaderview;
    UIView *extendedfromheaderview;
    UILabel *extendedtothisclassbalancelabel;
    UILabel *extendedtototalbalancelabel;
    
//    UIBarButtonItem *doneButton;
//    UIBarButtonItem *deletebutton;
//    UIBarButtonItem *shareButton;
    
    UITextField *extensiontimetext;
    
    UILabel *classdurationlabel;

    
    int tableoffset;
    
    NSString *tmpthisclassremarks;
    NSString *tmpabsentmakeupreason;
    NSString *tmpallclassremarks;
    NSString *tmpparentnote;
    NSString *tmpnextclassremarks;
    NSString *tmppreviousclassremarks;
    
    //UITextView *thisClassRemarksText;
    //UITextView *nextClassRemarksText;
    //UITextView *previousClassRemarksText;
    //UITextView *allClassRemarksText;
    //UITextView *absentmakeupreasonText;
    //UITextView *parentNoteText;
    
    UIToolbar *RemarksToolBar;
    
    NSMutableArray *assessmentformarray;
    NSMutableArray *assessmentformlistarray;
    //UITableView *assessmenttable;
    __weak IBOutlet UITableView *assessmenttable;
    AssessmentFormRowObject *assessmentformrowobject;
    AssessmentFormSectionObject *assessmentformsectionobject;
    
    GCPlaceholderTextView *answertextview;
    
    AssessmentFormListObject *assessmentformlistobject;
    NSString *selectedformkey;
    UILabel *formtitlelabel;
    UILabel *formlastsubmittedtimelabel;
    UIImageView *formselectionimage;
    UITableView *assessmentformlisttable;
    UIButton *changeformbutton;
    UIButton *assessmentblockbutton;
    
    UILabel *assessmentformcenterlabel;
    
    UIImpactFeedbackGenerator *impactFeedbackGenerator;
    AVAudioPlayer *audioPlayer;
    NSTimer *sliderTimer;
    UISlider *selectedUIslide;
    
    AVAudioRecorder *audioRecorder;
    NSTimer *audioRecorderTimer;
    
    UIImageView *audioRecordingImage;
    UILabel *slideToCancelTitle;
    UIView *textinputbox;
    
    OutboxMessageRecord *workingMessage;
    UIView *recordingStatusView;
    UILabel *recordingDuration;
    UIPanGestureRecognizer *audioPanGesture;
    __weak IBOutlet NSLayoutConstraint *remarkstablebottomconstraint;
    
    NSArray *assessmentColorArray;
    UIPopoverPresentationController *mySharePopovercontroller;
    
    UIDocumentInteractionController * documentInteractionController;
    
    AssessmentFormListObject *selectedForm;
    
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UIButton *shareButton;
    
    
    
}

@property (weak,nonatomic) id<myClassRemarksPopoverViewControllerDelegate>delegate;
@property (strong,nonatomic) ClassScheduleRecord *classScheduleObject;
@property (strong,nonatomic) NSMutableArray *jsonArray;
@property (strong,nonatomic) NSString *nextClassClasskey;
@property (strong,nonatomic) NSString *nextClassRemarks;
@property (strong,nonatomic) NSString *previousClassClasskey;
@property (strong,nonatomic) NSString *previousClassRemarks;
@property (strong,nonatomic) NSString *presentingview;
@property (strong,nonatomic) NSMutableArray *parentNoteStudentClassKeys;

-(BOOL)retrievenextclassremarks;
- (IBAction)remarksbuttonpressed:(id)sender;
- (IBAction)extendbuttonpressed:(id)sender;
- (IBAction)assessmentbuttonpressed:(id)sender;

@end
