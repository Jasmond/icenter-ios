//
//  MessageViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 8/10/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "MessagePopoverViewController.h"
#import "SwitchCenterViewController.h"
#import "MessagePhotoCollectionViewCell.h"
#import "FullScreenPhotoViewController.h"
#import "PickerViewController.h"
#import "StaffGroupViewController.h"
#import "messageDocumentUIView.h"
#import "StudentDetailsViewController.h"
#import "LeadDetailsNavController.h"
#import "StudentDetailsNavController.h"
#import "LeadDetailsViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate,mySwitchCenterViewControllerDelegate,myMessagePopoverViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,myFullScreenPhotoViewControllerDelegate,myPickerViewControllerDelegate,myStaffGroupViewControllerDelegate,UIDocumentPickerDelegate,myStudentViewController,myLeadDetailsViewController,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UIGestureRecognizerDelegate>{
    GlobalVariables *globalvariables;
    MainViewController *mainviewcontroller;
    IBOutlet UILabel *viewtitle;
    
    UITableView *messagerecordtable;
    //UITableView *optiontable;
    __weak IBOutlet UITableView *contactlisttable;
    __weak IBOutlet UITableView *categorytable;
    NSArray *categoryarray;
    __weak IBOutlet UISegmentedControl *scmessageview;
    __weak IBOutlet UIButton *showsystemmessagebutton;
    
//    NSMutableArray *messageArray;
//    NSMutableArray *filteredMessageArray;
    
    NSMutableArray *JSONArray;
    
    UILabel *messagetype;
    UILabel *messagereceipient;
    UILabel *messagecreatetime;
    UILabel *messagestarttime;
    UILabel *messageendtime;
    UILabel *messagechinese;
    UILabel *messageenglish;
    
    UILabel *starttimelabel;
    UILabel *endtimelabel;
    UILabel *createtimelabel;
    
    UIView *messageseparator;
    UIView *headerview;
    UIView *messagetypeflag;
    
    UILabel *GeneralLabel;

    NSString *selectedmessagetype;
    NSString *selectedstatus;
    NSString *selectedreceipienttype;
    
    __weak IBOutlet UIButton *addmessagebutton;
    
    UILabel *ReceipientTypeAllLabel;
    UILabel *ReceipientTypeStudentLabel;
    UILabel *ReceipientTypeLeadLabel;
    UILabel *ReceipientTypeStaffLabel;
    UILabel *TypeAllLabel;
    UILabel *TypeImportantLabel;
    UILabel *TypeGeneralLabel;
    UILabel *TypePromotionalLabel;
    UILabel *TypeTeacherNoteLabel;
    UILabel *StatusAllLabel;
    UILabel *StatusSentLabel;
    UILabel *StatusScheduledLabel;
    UILabel *StatusDraftLabel;
    UILabel *CreatedByAllLabel;
    UILabel *CreatedByUserLabel;
    UILabel *CreatedBySystemLabel;
    
    UIView *headertitleview;
    UILabel *headertitlename;
    UILabel *headercentername;
    UIImageView *headercenternamearrow;
    UIButton *switchcenterbutton;
    SwitchCenterViewController *switchcenterviewcontroller;
    
    NSMutableArray *allleadarray;
    NSMutableArray *allstudentarray;
    NSMutableArray *allstaffarray;
    NSMutableArray *staffgrouparray;
    NSMutableArray *allstaffgrouparray;
    BOOL runviewdidappear;
    __weak IBOutlet UITableView *OutboxMessageTable;
    __weak IBOutlet UISearchBar *messagesearchbar;
    
    NSMutableArray *outboxMessageArray;
    NSMutableArray *filteredOutboxMessageArray;
    
    OutboxMessageRecord *workingMessage;
    NSInteger firstunreadrow;
    
    UIView *sidewindowview;
    UIButton *sidewindowviewclosebutton;
    UIActivityIndicatorView *ailoadindicator;
    UIWindow *mainWindow;
    UIStoryboard *mainStoryboard;
    
    NSMutableArray *FilteredMessageContactArray;
    NSMutableArray *MessageContactArray;
    NSMutableArray *NewContactArray;
//    MessageContactRecord *selectedmessagecontact;
    NSInteger unreadcount;
    
    __weak IBOutlet UITableView *contentTable;
    __weak IBOutlet UITextView *messageinputtext;
    __weak IBOutlet UIView *textinputbox;
    __weak IBOutlet UISegmentedControl *scsender;
    __weak IBOutlet UIButton *channelbutton;
    __weak IBOutlet UISearchBar *contactlistsearchbar;
    __weak IBOutlet UIImageView *contactimage;
    __weak IBOutlet UILabel *contactlabel;
    __weak IBOutlet UIView *contactview;
    __weak IBOutlet UIButton *contactbutton;
    __weak IBOutlet UIView *instantmessagetopbox;
    
    __weak IBOutlet UIButton *sendinstantmessagebutton;
    __weak IBOutlet UIButton *camerabutton;
    __weak IBOutlet UICollectionView *instantPhotoCollectionView;
    FullScreenPhotoViewController *fullscreenphotoviewcontroller;
//    NSMutableArray *readmessagearray;
    UIPopoverPresentationController *mypopovercontroller;
    UIImagePickerController *imagepicker;
    UIButton *addphotobutton;
    BOOL scrolltoclosekeyboard;
    __weak IBOutlet NSLayoutConstraint *messageinputtextbottomconstraint;
    BOOL keyboardshow;
    CGFloat keyboardheight;
    __weak IBOutlet NSLayoutConstraint *messageinputtextheightconstraint;
    AVAudioPlayer *beepPlayer;
    
    UIRefreshControl *tablerefresh;
    
    StaffGroupViewController *staffgroupviewcontroller;
    
//    BOOL forwardmessagemode;
    InboxMessageRecord *forwardmessagerecord;
    
    BOOL showsystemmessage;
    
    __weak IBOutlet UIButton *recordAudioButton;
    __weak IBOutlet UIView *recordingStatusView;
    __weak IBOutlet UILabel *recordingDuration;
    __weak IBOutlet UILabel *slideToCancelTitle;
    __weak IBOutlet UIImageView *audioRecordingImage;
    
    UIImpactFeedbackGenerator *impactFeedbackGenerator;
    AVAudioPlayer *audioPlayer;
    NSTimer *sliderTimer;
    UISlider *selectedUIslide;
    
    AVAudioRecorder *audioRecorder;
    NSTimer *audioRecorderTimer;
    
    __weak IBOutlet UIView *replyToMessageBar;
    __weak IBOutlet UIView *replyToMessageView;
    __weak IBOutlet UILabel *replyToMessageTitle;
    __weak IBOutlet UIImageView *replyToImageView;
    __weak IBOutlet UILabel *replyToSender;
    
    InboxMessageRecord *replyToMessageRecord;
    
    NSMutableDictionary *replyToMessageDict;
    
    __weak IBOutlet UIView *selectStatusView;
    NSString *selectMode;
    NSMutableArray *selectedinboxmessages;
    NSMutableArray *selectedoutboxmessages;
    __weak IBOutlet UIButton *cancelSelectButton;
    __weak IBOutlet UIButton *deleteMessageButton;
    __weak IBOutlet UIButton *forwardMessageButton;
    __weak IBOutlet UILabel *selectedTitle;
}

@property (nonatomic,strong) UIPopoverPresentationController *myPopoverController;
//@property (nonatomic,strong) MessageContactRecord *selectedmessagecontact;

- (void) reloadMessageScreenWithCenterkey:(NSString *)centerkey;
- (void) reloadMessageContact;

- (IBAction)menubutton:(id)sender;
- (IBAction)addnewmessage:(id)sender;
- (IBAction)messageviewselected:(id)sender;
- (IBAction)camerabuttonpressed:(id)sender;
- (IBAction)channelbuttonpressed:(id)sender;
- (IBAction)sendinstantmessagebuttonpressed:(id)sender;
- (IBAction)selectsender:(id)sender;
- (IBAction)contactbuttonpressed:(id)sender;
- (IBAction)showsystemmessagebuttonpressed:(id)sender;
- (IBAction)startAudioRecording:(id)sender;
- (IBAction)stopAudioRecording:(id)sender;
- (IBAction)replyToMessageCancelButtonPressed:(id)sender;

- (IBAction)deleteMessageButtonPressed:(id)sender;
- (IBAction)forwardMessageButtonPressed:(id)sender;
- (IBAction)cancelSelectButtonPressed:(id)sender;


@end
