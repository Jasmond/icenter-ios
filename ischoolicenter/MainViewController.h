//
//  MainViewController.h
//  ELTestX
//
//  Created by Jasmond Luk on 5/9/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import "sqlite3.h"
#import "MyObject.h"
#import "SwitchCenterViewController.h"
#import "MainMenuNavController.h"
#import "RegistrationViewController.h"

@interface MainViewController : UIViewController<mySwitchCenterViewControllerDelegate,myRegistrationViewControllerDelegate>{
    //sqlite3 *isdb;
    GlobalVariables *globalvariables;
    
    NSMutableArray *jsonArray;

    NSString *productionserveraddress;
    NSString *secondaryserveraddress;
    BOOL firsttime;

    float keyboardheight;
    
    UILabel *logintitle;
    __weak IBOutlet UILabel *loginmessage;
    __weak IBOutlet UITextField *usernametext;
    __weak IBOutlet UITextField *passwordtext;
    __weak IBOutlet UIButton *loginbutton;
    __weak IBOutlet UIButton *resetpassword;
    __weak IBOutlet UIButton *englishlanguagebutton;
    __weak IBOutlet UIButton *chineselanguagebutton;
    __weak IBOutlet UIButton *schineselanguagebutton;
    UIButton *trialbutton;

    __weak IBOutlet UIView *passwordresetview;
    __weak IBOutlet UITextField *newpasswordtext;
    __weak IBOutlet UITextField *confirmpasswordtext;
    __weak IBOutlet UILabel *resetpasswordmessage;
    __weak IBOutlet UILabel *resetpasswordtitle;
    __weak IBOutlet UIButton *resetdonebutton;
    __weak IBOutlet UIButton *applyTrialAccountButton;
    __weak IBOutlet UIView *loadingindicatorview;
    __weak IBOutlet UIView *centerview;
    __weak IBOutlet UILabel *appTitle;
    UIButton *cancelsmsbutton;
    
    CenterRecord *centerobject;

//    NSMutableArray *CenterArray;
    NSMutableArray *PhoneArray;
    
    NSString *tmpusername;
    NSString *tmppassword;
    
    
    NSDateFormatter *df;
    
    NSString *phpfilename;
    NSString *ProPriServerUrl;
    NSString *ProSecServerUrl;
    NSString *DevPriServerUrl;
    NSString *DevSecServerUrl;
    
    UILabel *phonelabel;
    UILabel *centerlabel;
    
    NSString *devicelastlanguagetitleupdatetime;
    NSString *devicelastoncesystemmessagetime;
    
    NSCache *imageCache;
    
    NSString *showgetnewpassword;
    
    SwitchCenterViewController *switchcenterviewcontroller;
    
    NSArray *jsonarray_globalsettings;
    NSArray *jsonarray_userauthentication;
    NSDictionary *jsonarray_countrycode;
    NSDictionary *jsonarray_languagepack;
    NSDictionary *centerrecorddictionary;

    UIAlertController *updatealert;
    __weak IBOutlet UIImageView *backgroundimage;
    __weak IBOutlet UIView *appBackgroundImageView;
    __weak IBOutlet UIImageView *appBackgroundView;
    __weak IBOutlet UIView *loginview;
    __weak IBOutlet UIActivityIndicatorView *ailogin;
    __weak IBOutlet NSLayoutConstraint *ailoadingConstraint;
    __weak IBOutlet UIActivityIndicatorView *ailoading;
    __weak IBOutlet UILabel *loadinglabel;
    BOOL runviewdidappear;
    MainMenuNavController *mainmenunavcontroller;
    
    UIStoryboard *mainStoryboard;
    
    NSString *returnmessage;
    
    
}

@property (nonatomic,strong) NSString *alreadyshowedsystemmessage;
@property (nonatomic,strong) IBOutlet UIImageView *launchimage;
//@property (nonatomic,strong) UILabel *loadinglabel;
//@property (nonatomic,strong) UIActivityIndicatorView *ailoading;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;


- (IBAction)languagebuttonpressed:(id)sender;
- (void) loginapp;
-(void) showLoadingIndicator:(BOOL)show initialscreen:(BOOL)initialscreen;
-(void) logoutapp;
-(void) reloadapp;
- (void) gotoscreenindex:(NSInteger)screenindex pageindex:(NSInteger)pageindex keyindex:(NSInteger)keyindex;
- (void) refreshscreenindex:(NSInteger)screenindex;
-(void) sendOutboxDocument;
-(void) sendAssessmentReport;
- (IBAction)applyTrialAccountButtonPressed:(id)sender;
-(void) backgroundretrievemessagecontactlistwithcenterkey:(NSString *)centerkey;
-(void) initializedpassword:(BOOL)loginscreen;

@end
