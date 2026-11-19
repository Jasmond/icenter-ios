//
//  MainViewController.m
//  ELTestX
//
//  Created by Jasmond Luk on 5/9/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import "MainViewController.h"
#import "MyClass.h"
#import "UIViewController+AMSlideMenu.h"
#import "MainMenuNavController.h"
#import "MessageViewController.h"
#import "MessagePopoverViewController.h"
#import "SDWebImagePDFCoder.h"
#import "SceneDelegate.h"


@interface MainViewController ()

@end

#ifdef DEBUG
#define DEBUGMODE YES
#else
#define DEBUGMODE NO
#endif

@implementation MainViewController
@synthesize alreadyshowedsystemmessage,launchimage,mainContainerView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    [self.view layoutIfNeeded];
    
    ProPriServerUrl=@"https://dreamware.click/is/";
    ProSecServerUrl=@"https://dreamware.com.hk/is/";
    phpfilename=@"ischool3.php";
    globalvariables=[GlobalVariables singleObj];
    globalvariables.primaryserverpath=ProPriServerUrl;
    globalvariables.secondaryserverpath=ProSecServerUrl;
    globalvariables.generalphpfullpath=@"";
    globalvariables.activeserver=@"";
    globalvariables.generalphpfilename=phpfilename;
    globalvariables.newlogin=@"";
    globalvariables.passwordexpirydate=@"";
    globalvariables.passwordexpirylastshowndate=@"";
    
    globalvariables.leftmenuindex=nil;
    globalvariables.isdb=[MyClass openDB];
    [self createloadingindicator];
    
    centerobject=[[CenterRecord alloc]init];
    
    
    df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    globalvariables.centerrecord=[[CenterRecord alloc]init];

    
    
    globalvariables.boyimage=[UIImage imageNamed:@"boyimage.jpg"];
    globalvariables.boyimage=[UIImage imageWithCGImage:CGImageCreateWithImageInRect([globalvariables.boyimage CGImage], CGRectMake((globalvariables.boyimage.size.width-globalvariables.boyimage.size.height*154/180)/2,0,globalvariables.boyimage.size.height*154/180,globalvariables.boyimage.size.height)) ];
    globalvariables.girlimage=[UIImage imageNamed:@"girlimage.png"];
    globalvariables.girlimage=[UIImage imageWithCGImage:CGImageCreateWithImageInRect([globalvariables.girlimage CGImage], CGRectMake((globalvariables.girlimage.size.width-globalvariables.girlimage.size.height*154/180)/2,0,globalvariables.girlimage.size.height*154/180,globalvariables.girlimage.size.height)) ];
    
    //for loading label
    globalvariables.language=[MyClass getlocaldbwithparameter:@"language"];
    if (!globalvariables.language) {
        if ([[[[NSLocale preferredLanguages] objectAtIndex:0] substringToIndex:2] isEqualToString:@"zh"]) {
            globalvariables.language=@"Chinese";
        }else{
            globalvariables.language=@"English";
        }
    }
    
    globalvariables.colorcodearray=[[NSArray alloc]initWithObjects:
        [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:156.0/255.0 alpha:1.0],
        [UIColor colorWithRed:255.0/255.0 green:213.0/255.0 blue:156.0/255.0 alpha:1.0],
        
        [UIColor colorWithRed:199.0/255.0 green:225.0/255.0 blue:161.0/255.0 alpha:1.0],
        [UIColor colorWithRed:197.0/255.0 green:174.0/255.0 blue:229.0/255.0 alpha:1.0],
        [UIColor colorWithRed:230.0/255.0 green:221.0/255.0 blue:244.0/255.0 alpha:1.0],

        [UIColor colorWithRed:197.0/255.0 green:204.0/255.0 blue:189.0/255.0 alpha:1.0],
        [UIColor colorWithRed:164.0/255.0 green:210.0/255.0 blue:232.0/255.0 alpha:1.0],
        [UIColor colorWithRed:246.0/255.0 green:179.0/255.0 blue:176.0/255.0 alpha:1.0],
        [UIColor colorWithRed:214.0/255.0 green:198.0/255.0 blue:214.0/255.0 alpha:1.0],
        [UIColor colorWithRed:226.0/255.0 green:169.0/255.0 blue:237.0/255.0 alpha:1.0],

        [UIColor colorWithRed:255.0/255.0 green:182.0/255.0 blue:204.0/255.0 alpha:1.0],
        [UIColor colorWithRed:244.0/255.0 green:224.0/255.0 blue:158.0/255.0 alpha:1.0],
        [UIColor colorWithRed:156.0/255.0 green:214.0/255.0 blue:156.0/255.0 alpha:1.0],
        [UIColor colorWithRed:211.0/255.0 green:253.0/255.0 blue:156.0/255.0 alpha:1.0],
        [UIColor colorWithRed:156.0/255.0 green:253.0/255.0 blue:213.0/255.0 alpha:1.0],

        [UIColor colorWithRed:156.0/255.0 green:254.0/255.0 blue:255.0/255.0 alpha:1.0],
        [UIColor colorWithRed:156.0/255.0 green:214.0/255.0 blue:255.0/255.0 alpha:1.0],
        [UIColor colorWithRed:255.0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0],
        [UIColor colorWithRed:255.0/255.0 green:174.0/255.0 blue:213.0/255.0 alpha:1.0],
        [UIColor colorWithRed:255.0/255.0 green:238.0/255.0 blue:161.0/255.0 alpha:1.0],

        [UIColor colorWithRed:203.0/255.0 green:206.0/255.0 blue:255.0/255.0 alpha:1.0],
        [UIColor colorWithRed:185.0/255.0 green:231.0/255.0 blue:224.0/255.0 alpha:1.0],
        [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0],
        nil];
    
    globalvariables.contactrelationshiparray=[[NSArray alloc]initWithObjects:@"Mother",@"Father",@"Self",@"Grand Father",@"Grand Mother",@"Brother",@"Sister",@"Uncle",@"Auntie",@"Home",@"Helper",@"Emergency",@"Other", nil];


    //load documentfolder
    globalvariables.documentfolder=[[DocumentFolder alloc]initDocumentFolderWithClassInvoiceArray:[[NSMutableArray alloc]init] ClassReceiptArray:[[NSMutableArray alloc]init] SalesInvoiceArray:[[NSMutableArray alloc]init] SalesReceiptArray:[[NSMutableArray alloc]init] ClassPaymentArray:[[NSMutableArray alloc]init] SalesPaymentArray:[[NSMutableArray alloc]init] defaultcheckedclassinvoiceenrollmentkeys:[[NSMutableArray alloc]init] defaultcheckedclasspaymentenrollmentkeys:[[NSMutableArray alloc]init] defaultcheckedsalesinvoicesaleskeys:[[NSMutableArray alloc]init] defaultcheckedsalespaymentsaleskeys:[[NSMutableArray alloc]init] defaultcheckedclassreceiptenrollmentkeys:[[NSMutableArray alloc]init] defaultcheckedsalesreceiptsaleskeys:[[NSMutableArray alloc]init]];
    

    if (!alreadyshowedsystemmessage) {
        alreadyshowedsystemmessage=@"No";
    }
    
    switchcenterviewcontroller = (SwitchCenterViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"SwitchCenterViewController"];
    switchcenterviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    switchcenterviewcontroller.delegate=self;
    switchcenterviewcontroller.showcancelbutton=@"Yes";
    

    [self createloginwindow];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checktoreloadapp) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.alpha=0.9;
    
    visualEffectView.frame = self.view.frame;
    [appBackgroundView addSubview:visualEffectView];
    [MyClass loadingindicatorwithoption:@"Stop" color:nil];
    
    SDImagePDFCoder *PDFCoder = [SDImagePDFCoder sharedCoder];
    [[SDImageCodersManager sharedManager] addCoder:PDFCoder];
    
    applyTrialAccountButton.hidden=NO;
    
    mainContainerView.hidden=YES;
    runviewdidappear=TRUE;

    
    if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"hk.com.dreamware.icenter.icenter0"]){
        appTitle.text=@"Eye Level GraceLand Center";
    }else{
        appTitle.text=@"iCenter";
    }
    
    

}



-(void) checktoreloadapp
{
    if (![globalvariables.appbecomeactiveaction isEqualToString:@""] && [globalvariables.lastviewcontroller isKindOfClass:[self class]] ) {
        
        //close diag
        
        if ([self isAlertViewShowing]) {
            [updatealert dismissViewControllerAnimated:NO completion:^ {
                self->globalvariables.appbecomeactiveaction=@"";
                self->globalvariables.leftmenuindex=@"0";
                [self showLoadingIndicator:YES initialscreen:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loginapp];
                });
            }];
        }else{

            globalvariables.appbecomeactiveaction=@"";
            globalvariables.leftmenuindex=@"0";
            [self showLoadingIndicator:YES initialscreen:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loginapp];
            });
        }
        

    }
}

- (BOOL)isAlertViewShowing{
    if ([self.presentedViewController isKindOfClass:[UIAlertController class]]) {
        
        return YES;
        
    }
    return NO;
}

-(void) showLoadingIndicator:(BOOL)show initialscreen:(BOOL)initialscreen
{
    ailoadingConstraint.constant=initialscreen?self.view.bounds.size.height/4:0;
    if (show) {
        loadinglabel.text=[MyClass returnlogintitlewithtitle:@"Loading Information"];
        loadinglabel.hidden=NO;
        [ailoading startAnimating];
    }else{
        loadinglabel.hidden=YES;
        [ailoading stopAnimating];
    }
}


-(void)viewDidAppear:(BOOL)animated
{
//    return;
    globalvariables.lastviewcontroller=(NSString *)self;

    if (!runviewdidappear) {
        return;
    }
    runviewdidappear=FALSE;
    
    
    [self showLoadingIndicator:YES initialscreen:YES];
    
    
    [self createSqlTable];
    [self retrievelastconnectedserver];
    [self retrievelocalinformation];
    [self retrievecenterkey];
    
    if([globalvariables.language isEqualToString:@"English"]){
        [englishlanguagebutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [chineselanguagebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [schineselanguagebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if([globalvariables.language isEqualToString:@"Chinese"]){
        [englishlanguagebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [chineselanguagebutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [schineselanguagebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [englishlanguagebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [chineselanguagebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [schineselanguagebutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    

    if ([globalvariables.passwordexpirydate isEqualToString:@"expired"]) {
        
        globalvariables.password=@"";
        passwordtext.text=@"";
        [self enableloginbutton:YES];
        [self showLoadingIndicator:NO initialscreen:NO];
        loginview.hidden=NO;appBackgroundImageView.hidden=NO;
        loginmessage.text=[MyClass returnlogintitlewithtitle:@"Please enter your username and password"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            updatealert = [UIAlertController alertControllerWithTitle:[MyClass returnlogintitlewithtitle:@"User Account"] message:[MyClass returnlogintitlewithtitle:@"Your password has been expired. Please reset it"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ResetNowAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"Reset Now"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self initializedpassword:YES];
                
            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                
            }];
            
            [updatealert addAction:CancelAction];
            [updatealert addAction:ResetNowAction];
            [self presentViewController:updatealert animated:YES completion:nil];
        });
    }else{
        [self performSelector:@selector(loginapp) withObject:nil afterDelay:0];
    }
    
    
    
}

-(void) createloginwindow
{
    loginmessage.text=[MyClass returnlogintitlewithtitle:@"Please enter your username and password"];
    usernametext.placeholder=[MyClass returnlogintitlewithtitle:@"Username"];
    passwordtext.placeholder=[MyClass returnlogintitlewithtitle:@"Password"];
    [loginbutton setTitle:[MyClass returnlogintitlewithtitle:@"Login"] forState:UIControlStateNormal];
    [loginbutton addTarget:self action:@selector(loginbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];

    [resetpassword setTitle:[MyClass returnlogintitlewithtitle:@"Get One Time Password"] forState:UIControlStateNormal];
    [resetpassword addTarget:self action:@selector(resetpasswordbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [applyTrialAccountButton setTitle:[MyClass returnlogintitlewithtitle:@"Apply Trial Account"] forState:UIControlStateNormal];
}

-(void) trialbuttonpressed
{
    if ([globalvariables.language isEqualToString:@"English"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://dreamware.com.hk/eng/?page_id=269"] options:@{} completionHandler:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://dreamware.com.hk/chi/?page_id=269"] options:@{} completionHandler:nil];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://dreamware.com.hk/chi/?page_id=269"]];
    }
}

-(void) createpasswordresetwindow
{
    newpasswordtext.text=@"";
    confirmpasswordtext.text=@"";
    passwordresetview.hidden=NO;
    resetpasswordmessage.text=[MyClass returnlogintitlewithtitle:@"Please choose a new password"];
    resetpasswordtitle.text=[MyClass returnlogintitlewithtitle:@"Reset Password"];
    newpasswordtext.placeholder=[MyClass returnlogintitlewithtitle:@"New password"];
    confirmpasswordtext.placeholder=[MyClass returnlogintitlewithtitle:@"Re-enter new password"];
    [resetdonebutton setTitle:[MyClass returnlogintitlewithtitle:@"Done"] forState:UIControlStateNormal];
    [resetdonebutton addTarget:self action:@selector(donebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL) LastLoginCenter
{
    centerobject=[globalvariables.CenterDict valueForKey:globalvariables.centerrecord.centerkey];
    if (centerobject) {
        globalvariables.centerrecord=centerobject;
        return TRUE;
    }
    
//    for (long i=0; i<CenterArray.count; i++) {
//        centerobject=[CenterArray objectAtIndex:i];
//        if ([centerobject.centerkey isEqualToString:globalvariables.centerrecord.centerkey]) {
//            globalvariables.centerrecord=centerobject;
//            return TRUE;
//            break;
//        }
//    }
    return FALSE;
}

-(void) setServer
{
    NSRange range=[tmpusername rangeOfString:@":"];
    if (range.location==NSNotFound) {
        globalvariables.primaryserverpath=ProPriServerUrl;
        globalvariables.secondaryserverpath=ProSecServerUrl;
        globalvariables.generalphpfilename=phpfilename;
        globalvariables.mediaDomain=@"https://d180fsozwsvp6s.cloudfront.net/";
    }else{
        NSRange rangephp=[tmpusername rangeOfString:@"/" options:NSBackwardsSearch];
        if (rangephp.location!=NSNotFound) {
            DevPriServerUrl=[tmpusername substringWithRange:NSMakeRange(range.location+1, rangephp.location-range.location)];
            DevSecServerUrl=@"";
            globalvariables.generalphpfilename=[[tmpusername substringFromIndex:rangephp.location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            globalvariables.primaryserverpath=DevPriServerUrl;
            globalvariables.secondaryserverpath=DevSecServerUrl;
            globalvariables.mediaDomain=@"https://d1plzovhgjocuh.cloudfront.net/";
        }
    }
}

-(void) enableloginbutton:(BOOL)enableloginbutton
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (enableloginbutton) {
            loginbutton.enabled=YES;
            [ailogin stopAnimating];
            [loginbutton setTitle:[MyClass returnlogintitlewithtitle:@"Login"] forState:UIControlStateNormal];
        }else{
            loginbutton.enabled=NO;
            [ailogin startAnimating];
            [loginbutton setTitle:[MyClass returnlogintitlewithtitle:@""] forState:UIControlStateNormal];
        }
    });
}


-(void) loginapp
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setServer];
        if ([self CheckDatabaseAvailability]) {
            [self retrieveglobalsettings];
            [self retrievecountrycode];
            [self retrievelanguagepackrecord];
            [self createloginwindow];
            
            
            //system broadcast message
            if ([globalvariables.globalsettings.broadcastmessagemode isEqualToString:@"AlwaysBlock"]) {
                //[ailoading stopAnimating];
                //loadinglabel.hidden=YES;
                
                [self enableloginbutton:YES];
                
                UIAlertController *successalert = [UIAlertController alertControllerWithTitle:[MyClass returnlogintitlewithtitle: @"System Message"] message:[globalvariables.language isEqualToString:@"English"]?globalvariables.globalsettings.broadcastmessageenglish:globalvariables.globalsettings.broadcastmessagechinese preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                }];
                
                [successalert addAction:OKAction];
                [self presentViewController:successalert animated:YES completion:nil];
                return;
            }else if ([globalvariables.globalsettings.broadcastmessagemode isEqualToString:@"AlwaysThrough"]){
                if ([alreadyshowedsystemmessage isEqualToString:@"No"]) {
                    alreadyshowedsystemmessage=@"Yes";
                    UIAlertController *successalert = [UIAlertController alertControllerWithTitle:[MyClass returnlogintitlewithtitle: @"System Message"] message:[globalvariables.language isEqualToString:@"English"]?globalvariables.globalsettings.broadcastmessageenglish:globalvariables.globalsettings.broadcastmessagechinese preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [successalert dismissViewControllerAnimated:YES completion:nil];
                        [self loginapp];
                    }];
                    
                    [successalert addAction:OKAction];
                    [self presentViewController:successalert animated:YES completion:nil];
                }else{
                    alreadyshowedsystemmessage=@"No";
                }
            }else{
                if ([globalvariables.globalsettings.broadcastmessagemode length]>=4) {
                    if ([[globalvariables.globalsettings.broadcastmessagemode substringToIndex:4] isEqualToString:@"Once"]){
                        if ([globalvariables.globalsettings.broadcastmessagemode length]==24) {
                            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            if ([[df dateFromString:devicelastoncesystemmessagetime] compare:[df dateFromString:[globalvariables.globalsettings.broadcastmessagemode substringFromIndex:5]]]==NSOrderedAscending) {
                                UIAlertController *successalert = [UIAlertController alertControllerWithTitle:[MyClass returnlogintitlewithtitle: @"System Message"] message:[globalvariables.language isEqualToString:@"English"]?globalvariables.globalsettings.broadcastmessageenglish:globalvariables.globalsettings.broadcastmessagechinese preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                    [successalert dismissViewControllerAnimated:YES completion:nil];
                                    [self loginapp];
                                }];
                                
                                [successalert addAction:OKAction];
                                [self presentViewController:successalert animated:YES completion:nil];
                                
                                
                                //update devicelastoncesystemessagetime value
                                devicelastoncesystemmessagetime=[df stringFromDate:[NSDate date]];
                                [MyClass updatelocaldbwithparameter:@"lastoncesystemmessagetime" value:devicelastoncesystemmessagetime];
                                
                                
                            }
                        }
                    }
                }
            }
            
            if ([MyClass checkiflatestversion]) {
                NSString *userauthenticationresult=[self UserAuthentication];
                if ([userauthenticationresult isEqualToString:@"Passed"]) {
                    if ([self retrievecenterlist]) {
                        if (globalvariables.CenterDict.count>0) {
                            
                            if (globalvariables.CenterDict.count==1) {
                                centerobject=globalvariables.CenterDict.allValues.firstObject;
                                globalvariables.centerrecord=centerobject;
                                
                                [self successfullylogin];
                            }else{
                                if (![self LastLoginCenter]){
                                    [self enableloginbutton:YES];
                                    [self showLoadingIndicator:NO initialscreen:NO];
                                        loginview.hidden=NO;appBackgroundImageView.hidden=NO;
                                        loginmessage.text=[MyClass returnlogintitlewithtitle:@"Please enter your username and password"];
                                    usernametext.text=tmpusername;
                                    passwordtext.text=tmppassword;
                                    switchcenterviewcontroller.modalPresentationStyle = UIModalPresentationFormSheet;
                                    switchcenterviewcontroller.singleselection=@"Yes";
                                    switchcenterviewcontroller.updatecenterkey=@"Yes";
                                    [self presentViewController:switchcenterviewcontroller animated:YES completion: nil];
                                }else{
                                    [self successfullylogin];
                                }
                            }
                        }else{
                            if (!loginview.hidden) {
                                loginmessage.text=[MyClass returnlogintitlewithtitle:@"No Center is available"];
                                loginview.hidden=NO;appBackgroundImageView.hidden=NO;
                            }else{
                                [self createloginwindow];
                            }
                            
                            usernametext.text=tmpusername;
                            passwordtext.text=tmppassword;
                            [self enableloginbutton:YES];
                        }
                    }else{
                        [self showserverconnectionnotavailable];
                    }
                }else if ([userauthenticationresult isEqualToString:@"ResetPassword"]){
                    [self showLoadingIndicator:NO initialscreen:NO];
                    [self enableloginbutton:YES];
                    if (!loginview.hidden) {
                        loginview.hidden=YES;
                        [self createpasswordresetwindow];
                    }else{
                        [self createloginwindow];
                        usernametext.text=globalvariables.username;
                        passwordtext.text=@"";
                    }
                }else{
                    [self showLoadingIndicator:NO initialscreen:NO];
                    [self enableloginbutton:YES];
                    if (loginview.hidden) {
                        //[self createloginwindow];
                        ///loginmessage.textColor=[UIColor darkGrayColor];
                        usernametext.text=tmpusername;// globalvariables.username;
                        passwordtext.text=@"";
                        loginmessage.text=[MyClass returnlogintitlewithtitle:@"Please enter your username and password"];
                        if ([returnmessage isEqualToString:@"Password Expired"]) {
                            loginmessage.text=[MyClass returnlogintitlewithtitle:returnmessage];
                            
                            updatealert = [UIAlertController alertControllerWithTitle:[MyClass returnlogintitlewithtitle:@"User Account"] message:[MyClass returnlogintitlewithtitle:@"Your password has been expired. Please reset it"] preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *ResetNowAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"Reset Now"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                [self initializedpassword:YES];
                                
                            }];
                            
                            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                                
                            }];
                            
                            [updatealert addAction:CancelAction];
                            [updatealert addAction:ResetNowAction];
                            [self presentViewController:updatealert animated:YES completion:nil];
                            
                        }
                        
                    }
                    loginview.hidden=NO;appBackgroundImageView.hidden=NO;
                    if ([tmppassword isEqualToString:@""]) {
                        ///loginmessage.textColor=[UIColor darkGrayColor];
                        usernametext.text=tmpusername;// globalvariables.username;
                        passwordtext.text=@"";
                        loginmessage.text=[MyClass returnlogintitlewithtitle:@"Please enter your username and password"];
                    }
                    
//                    if([loginmessage.text isEqualToString:[MyClass returnlogintitlewithtitle:@"Password Expired"]]){
//                        
//                        updatealert = [UIAlertController alertControllerWithTitle:[MyClass returnlogintitlewithtitle:@"User Account"] message:[MyClass returnlogintitlewithtitle:@"Your password has been expired. Please reset it"] preferredStyle:UIAlertControllerStyleAlert];
//                        UIAlertAction *ResetNowAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"Update"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                            [self initializedpassword:YES];
//                            
//                        }];
//                        
//                        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"Update"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//
//                            
//                        }];
//                        
//                        [updatealert addAction:CancelAction];
//                        [updatealert addAction:ResetNowAction];
//                        [self presentViewController:updatealert animated:YES completion:nil];
//                        
//                        
//                    }

                }
            }else{
                [self showLoadingIndicator:NO initialscreen:NO];
                [self enableloginbutton:YES];
                globalvariables.backfromappstore=TRUE;
                updatealert = [UIAlertController alertControllerWithTitle:[MyClass returnlogintitlewithtitle:@"New iCenter Update"] message:[NSString stringWithFormat:@"%@\r\n\r\n%@",[MyClass returnlogintitlewithtitle:@"There is an Update available. Please update to use this App"],[MyClass returnlogintitlewithtitle:@"If you encounter update issue, you can go to App Store's Updates page, pull down to refresh the page and then update the app there"]] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"Update"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    NSURL *url=[NSURL URLWithString:[[jsonarray_globalsettings objectAtIndex:0] objectForKey:@"latestappurl"]];
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                    
                }];
                [updatealert addAction:OKAction];
                [self presentViewController:updatealert animated:YES completion:nil];
            }
        }else{
            [self showserverconnectionnotavailable];
        }
    });
}

-(void) successfullylogin
{
    [MyClass clearTmpDirectoryContent];
    [self loadlaunchimage];
    [MyClass updatecenterkey];

    [MyClass resetdevicelastupdatetimewithparameters:@"staff,classroom,centersettings,userroleandprivilege,centerrecord,arcode"];
    [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,subject,product,staff,classroom,marketing,centersettings,userroleandprivilege,student,lead,leavenature,arcode,messagecontact" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable) {
        if (!newupdateavailable) {
            [MyClass updatelocaldbwithparameter:@"showgetnewpassword" value:@"No"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self enableloginbutton:YES];
                appBackgroundImageView.hidden=YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self gotonotificationpage];
                });
            });

        }
    }];
}

-(void) showserverconnectionnotavailable
{
    [self enableloginbutton:YES];
    [self showLoadingIndicator:NO initialscreen:NO];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"iSchool" message:[MyClass returnlogintitlewithtitle:@"Server connection is not available. Please check your internet connection and try again"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"Retry"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (loginview.hidden) {
            [self showLoadingIndicator:YES initialscreen:YES];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loginapp];
        });
    }];
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            usernametext.text=tmpusername;
            passwordtext.text=tmppassword;
            loginmessage.text=[MyClass returnlogintitlewithtitle:@"Please enter your username and password"];
        if(loginview.hidden){
            loginview.hidden=NO;appBackgroundImageView.hidden=NO;
        }
    }];
    [alert addAction:OKAction];
    [alert addAction:CancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) gotonotificationpage
{
    //for testing document send function only
//    if ([globalvariables.username isEqualToString:@"jasmond_luk@yahoo.com"]) {
//        [self sendOutboxDocument];
//        [self sendAssessmentReport];
//    }

    [MyClass updatelocaldbwithparameter:@"password" value:globalvariables.password];
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [MyClass updatelocaldbwithparameter:@"lastlogin" value:[df stringFromDate:[NSDate date]]];
    
    if (@available(iOS 13.0, *)) {
        mainContainerView.hidden=NO;
        mainmenunavcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuNavController"];
        mainmenunavcontroller.view.frame=mainContainerView.bounds;
        [self addChildViewController:mainmenunavcontroller];
        [mainContainerView addSubview:mainmenunavcontroller.view];
        [mainmenunavcontroller didMoveToParentViewController:self];
        
        
        AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
    }else{
        mainmenunavcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuNavController"];
        mainmenunavcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
        mainmenunavcontroller.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:mainmenunavcontroller animated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) createSqlTable{
    char *err;
    NSString *sql;
    sqlite3_stmt *statement;
    
    //check if table already exist
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"settings"];
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            
        }else{
            //table does not exist
            
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY, '%@' TEXT);",@"settings",@"parametername",@"parametervalue"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
        
        [self addEntriesToSettingsIfNotExist];
    }
    
    //check if classtime table tabview table already exist
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"tabview"];
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            
            //any new column for the new release//
            
            // add "headertype" if not exists, starting 424
            if (![MyClass checkColumnExistswithTableName:@"tabview" columnname:@"headertype"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS tabview;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //add table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"tabview",@"tabid",@"headerlist",@"centerkey",@"username",@"mode",@"selecteddate",@"headertype"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    //sqlite3_close(isdb);
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }
            }

        }else{
            //table does not exist
            
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"tabview",@"tabid",@"headerlist",@"centerkey",@"username",@"mode",@"selecteddate",@"headertype"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
    }
    
    
    //check and add lastupdate table
    globalvariables.lastupdatedict=[[NSMutableDictionary alloc]init];
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"lastupdate"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            
            //table exist
            
            if (![MyClass checkColumnExistswithTableName:@"lastupdate" columnname:@"messagecontact"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS lastupdate;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"lastupdate",@"centerkey",@"calendar",@"staff",@"classroom",@"languagetitle",@"subject",@"product",@"marketing",@"studentimage",@"leadimage",@"centerimage",@"classimage",@"centerrecord",@"centersettings",@"userroleandprivilege",@"student",@"lead",@"leavenature",@"arcode",@"messagecontact"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    //sqlite3_close(isdb);
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }
                
                //[MyClass updatedevicelastupdatetimewithparameter:@"" centerkey:@"All"];
            }else{
                //load value from local db to globalvariables
                
                
                sql =[NSString stringWithFormat:@"SELECT * FROM lastupdate"];
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        NSString *centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
                        NSString *calendar=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        NSString *staff=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        NSString *classroom=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        NSString *languagetitle=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)];
                        NSString *subject=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)];
                        NSString *product=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 6)];
                        NSString *marketing=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 7)];
                        NSString *studentimage=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 8)];
                        NSString *leadimage=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 9)];
                        NSString *centerimage=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 10)];
                        NSString *classimage=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 11)];
                        NSString *centerrecord=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 12)];
                        NSString *centersettings=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 13)];
                        NSString *userroleandprivilege=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 14)];
                        NSString *student=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 15)];
                        NSString *lead=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 16)];
                        NSString *leavenature=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 17)];
                        NSString *arcode=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 18)];
                        NSString *messagecontact=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 19)];
                        [globalvariables.lastupdatedict setValue:[[LastUpdateRecord alloc]initLastUpdateRecordwithCenterkey:centerkey Calendar:calendar Staff:staff Classroom:classroom LanguageTitle:languagetitle Subject:subject Product:product Marketing:marketing Centerimage:centerimage StudentImage:studentimage LeadImage:leadimage ClassImage:classimage Centerrecord:centerrecord Centersettings:centersettings Userroleandprivilege:userroleandprivilege Student:student Lead:lead LeaveNature:leavenature ARCode:arcode MessageContact:messagecontact] forKey:centerkey];
                    }
                }
            }
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"lastupdate",@"centerkey",@"calendar",@"staff",@"classroom",@"languagetitle",@"subject",@"product",@"marketing",@"studentimage",@"leadimage",@"centerimage",@"classimage",@"centerrecord",@"centersettings",@"userroleandprivilege",@"student",@"lead",@"leavenature",@"arcode",@"messagecontact"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
        
        
        
    }
    
    //check and add product_information table
    globalvariables.productlistarray=[[NSMutableDictionary alloc]init];
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"product_information"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            /*if ([MyClass checkColumnExistswithTableName:@"student" columnname:@"parentapp"]) {
             //delete table
             sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS student;"];
             sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
             
             //create table
             sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"student", @"studentkey",@"centerkey",@"studentid",@"firstname",@"lastname",@"gender",@"dateofbirth",@"age",@"grade",@"preferredlanguage",@"school",@"parentname",@"parentemail",@"parentaddress",@"remarks",@"image",@"status",@"flag",@"promotion",@"leadkey",@"studentmedia",@"studentsource",@"othername",@"math_hq",@"eng_hq",@"playmath_hq",@"spark_hq",@"htalk_hq"];
             if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
             //sqlite3_close(isdb);
             NSAssert(0, @"Could not create table");
             }else{
             NSLog(@"table created");
             }
             
             //[MyClass updatedevicelastupdatetimewithparameter:@"" centerkey:@"All"];
             }else{*/
            //load value from local db to globalvariables
            
            
            sql =[NSString stringWithFormat:@"SELECT * FROM product_information"];
            
            if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                while (sqlite3_step(statement)==SQLITE_ROW) {
                    
                    NSString *productkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
                    NSString *centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                    NSString *englishname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                    NSString *chinesename=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                    NSString *code=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)];
                    NSString *category=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)];
                    NSString *price=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 6)];
                    NSString *remarks=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 7)];
                    NSString *status=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 8)];
                    NSString *autorenew=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 9)];
                    NSString *avatar=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 10)];
                    NSString *stockcount=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 11)];
                    NSString *allstockcounts=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 12)];
                    NSString *alertthreshold=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 13)];
                    
                    
                    //add system default schedule if not user default
                    [globalvariables.productlistarray setValue:[[ProductRecord alloc]initProductRecordwithCenterkey:centerkey Productkey:productkey Category:category Englishname:englishname Chinesename:chinesename Code:code Price:price Status:status Remarks:remarks Autorenew:autorenew avatar:avatar stockCount:stockcount alertThreshold:alertthreshold allstockcounts:allstockcounts] forKey:[NSString stringWithFormat:@"%@#%@",centerkey,code]];
                    
                }
                //}
            }
            
        }else{
            //table does not exist
            [MyClass resetdevicelastupdatetimewithparameters:@"product"];
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"product_information", @"productkey",@"centerkey",@"englishname",@"chinesename",@"code",@"category",@"price",@"remarks",@"status",@"autorenew",@"avatar",@"stockcount",@"allstockcounts",@"alertthreshold"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
        
        
        
    }
    
    //check and add languagetitle table
    //globalvariables.languagetitlearray=[[NSMutableArray alloc]init];
    globalvariables.languagetitledictionary=[[NSMutableDictionary alloc]init];
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"languagetitle"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if (![MyClass checkColumnExistswithTableName:@"languagetitle" columnname:@"schinese"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS languagetitle;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT);",@"languagetitle",@"titlekey",@"centerkey",@"title",@"english",@"chinese",@"schinese"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    //sqlite3_close(isdb);
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }
            }else{
                //load value from local db to globalvariables
                sql =[NSString stringWithFormat:@"SELECT * FROM languagetitle"];
                
                //NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                
                
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        NSString *ccenterkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        NSString *ctitle=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        NSString *cenglish=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        NSString *cchinese=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)];
                        NSString *cschinese=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)];
                        //[globalvariables.languagetitlearray addObject:[[LanguageTitleRecord alloc]initLanguageTitleRecordwithCenterkey:ccenterkey Title:ctitle Chinese:cchinese English:cenglish]];
                        
                        [globalvariables.languagetitledictionary setValue:[[LanguageTitleRecord alloc]initLanguageTitleRecordwithCenterkey:ccenterkey Title:ctitle Chinese:cchinese English:cenglish SChinese:cschinese] forKey:[NSString stringWithFormat:@"%@#%@",ccenterkey,ctitle]];
                        
                    }
                }
                
            }
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT);",@"languagetitle",@"titlekey",@"centerkey",@"title",@"english",@"chinese",@"schinese"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
    }
    
    //check and add student table
    globalvariables.studentlistarray=[[NSMutableDictionary alloc]init];
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"student"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if (![MyClass checkColumnExistswithTableName:@"student" columnname:@"creditamount"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS student;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"student", @"studentkey",@"centerkey",@"studentid",@"firstname",@"lastname",@"gender",@"dateofbirth",@"age",@"grade",@"preferredlanguage",@"school",@"parentname",@"parentemail",@"parentaddress",@"remarks",@"image",@"status",@"flag",@"promotion",@"leadkey",@"studentmedia",@"studentsource",@"othername",@"due",@"avatar",@"sendmessage",@"displayfullname",@"fcmemberid",@"ddaenabled",@"ddaaccountno",@"ddaaccountname",@"ddadebtorreference",@"ddalimit",@"extrafield1",@"parentname2",@"validcouponcount",@"extrafield2",@"creditamount"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    //sqlite3_close(isdb);
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }
                
                [MyClass updatedevicelastupdatetimewithparameter:@"student" centerkeyarray:nil systemcurrenttime:@""];
            }else{
                //load value from local db to globalvariables
                
                
                sql =[NSString stringWithFormat:@"SELECT * FROM student"];
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        NSString *studentkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
                        NSString *centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        NSString *studentid=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        NSString *firstname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        NSString *lastname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)];
                        NSString *gender=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)];
                        NSString *dateofbirth=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 6)];
                        NSString *age=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 7)];
                        NSString *grade=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 8)];
                        NSString *preferredlanguage=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 9)];
                        NSString *school=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 10)];
                        NSString *parentname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 11)];
                        NSString *parentemail=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 12)];
                        NSString *parentaddress=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 13)];
                        NSString *remarks=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 14)];
                        NSString *image=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 15)];
                        NSString *status=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 16)];
                        NSString *flag=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 17)];
                        NSString *promotion=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 18)];
                        NSString *leadkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 19)];
                        NSString *studentmedia=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 20)];
                        NSString *studentsource=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 21)];
                        NSString *othername=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 22)];
                        NSString *due=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 23)];
                        NSString *avatar=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 24)];
                        BOOL sendmessage=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 25)] isEqualToString:@"Yes"];
                        NSString *displayfullname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 26)];
                        NSString *fcmemberid=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 27)];
                        BOOL ddaenabled=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 28)] isEqualToString:@"Yes"];
                        NSString *ddaaccountno=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 29)];
                        NSString *ddaaccountname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 30)];
                        NSString *ddadebtorreference=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 31)];
                        NSString *ddalimit=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 32)];
                        NSString *extrafield1=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 33)];
                        NSString *parentname2=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 34)];
                        NSString *validcouponcount=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 35)];
                        NSString *extrafield2=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 36)];
                        float creditamount=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 37)] floatValue];
                        
                        [globalvariables.studentlistarray setValue:[[Student alloc]initStudentWithstudentkey:studentkey studentid:studentid firstname:firstname lastname:lastname othername:othername gender:gender dateofbirth:[dateofbirth isEqualToString:@""]?@"":[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:dateofbirth] age:age grade:grade preferredlanguage:preferredlanguage school:school parentname:parentname phonearray:[[NSMutableArray alloc]init] parentemail:parentemail parentaddress:parentaddress remarks:remarks flag:flag status:status promotion:promotion image:image leadkey:leadkey studentmedia:studentmedia studentsource:studentsource siblingarray:[[NSMutableArray alloc]init] photoalbumrecord:nil centerkey:centerkey due:due avatar:avatar sendmessage:sendmessage displayfullname:displayfullname fcmemberid:fcmemberid ddaenabled:ddaenabled ddaaccountno:ddaaccountno ddaaccountname:ddaaccountname ddadebtorreference:ddadebtorreference ddalimit:ddalimit extrafield1:extrafield1 parentname2:parentname2 validcouponcount:validcouponcount extrafield2:extrafield2 creditamount:creditamount] forKey:studentkey];
                        
                    }
                }
            }
            
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"student", @"studentkey",@"centerkey",@"studentid",@"firstname",@"lastname",@"gender",@"dateofbirth",@"age",@"grade",@"preferredlanguage",@"school",@"parentname",@"parentemail",@"parentaddress",@"remarks",@"image",@"status",@"flag",@"promotion",@"leadkey",@"studentmedia",@"studentsource",@"othername",@"due",@"avatar",@"sendmessage",@"displayfullname",@"fcmemberid",@"ddaenabled",@"ddaaccountno",@"ddaaccountname",@"ddadebtorreference",@"ddalimit",@"extrafield1",@"parentname2",@"validcouponcount",@"extrafield2",@"creditamount"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
        
        
        
    }
    
    //check and add phone contact table
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"contact"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if (![MyClass checkColumnExistswithTableName:@"contact" columnname:@"enablewechat"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS contact;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"contact", @"contactkey",@"centerkey",@"studentkey",@"type",@"relationship",@"contact",@"enableparentapp",@"primarycontact",@"enablesms",@"iso_code",@"enablewechat"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    //sqlite3_close(isdb);
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }
                
                [MyClass updatedevicelastupdatetimewithparameter:@"student" centerkeyarray:nil systemcurrenttime:@""];
            }else{
                //load value from local db to globalvariables
                
                
                sql =[NSString stringWithFormat:@"SELECT * FROM contact"];
                ContactRecord *contactobject;

            
            
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    
                    
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        //NSString *contactkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
                        //NSString *centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        NSString *studentkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        NSString *type=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        NSString *relationship=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)];
                        NSString *contact=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)];
                        NSString *enableparentapp=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 6)];
                        NSString *primarycontact=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 7)];
                        NSString *enablesms=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 8)];
                        NSString *iso_code=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 9)];
                        NSString *enablewechat=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 10)];
                        
                        contactobject=[[ContactRecord alloc]initContactRecordwithtype:type relationship:relationship contact:contact enableparentapp:[enableparentapp isEqualToString:@"Yes"] primarycontact:[primarycontact isEqualToString:@"Yes"]?YES:NO parentapplastlogin:@"" enablesms:[enablesms isEqualToString:@"Yes"] iso_code:iso_code enablewechat:[enablewechat isEqualToString:@"Yes"]];
                        
                        [((Student *)[MyClass returnstudentwithstudentkey:studentkey]).phonearray addObject:contactobject];
                    }
                }
            }
            
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEX, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"contact", @"contactkey",@"centerkey",@"studentkey",@"type",@"relationship",@"contact",@"enableparentapp",@"primarycontact",@"enablesms",@"iso_code",@"enablewechat"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
    }
    
    
    //check and add sibling table
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"sibling"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            /*if (![MyClass checkColumnExistswithTableName:@"student" columnname:@"math_hq"]) {
             //delete table
             sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS contact;"];
             sqlite3_exec(isdb, [sql UTF8String],NULL,NULL,&err);
             
             //create table
             sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"contact", @"contactkey",@"centerkey",@"studentkey",@"type",@"relationship",@"contact",@"enableparentapp",@"parentapplastlogin"];
             if (sqlite3_exec(isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
             sqlite3_close(isdb);
             NSAssert(0, @"Could not create table");
             }else{
             NSLog(@"table created");
             }
             
             //[MyClass updatedevicelastupdatetimewithparameter:@"" centerkey:@"All"];
             }else{*/
            //load value from local db to globalvariables
            
            
            sql =[NSString stringWithFormat:@"SELECT * FROM sibling"];
            SiblingRecord *siblingobject;
            
            
            
            if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                
                
                while (sqlite3_step(statement)==SQLITE_ROW) {
                    
                    NSString *studentkey1=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                    NSString *studentkey2=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                    NSString *relationship=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)];
                    siblingobject=[[SiblingRecord alloc]initSiblingRecordwithStudentname:nil Studentkey:studentkey1 Relationship:relationship];
                    [((Student *)[MyClass returnstudentwithstudentkey:studentkey2]).siblingarray addObject:siblingobject];
                    
                    siblingobject=[[SiblingRecord alloc]initSiblingRecordwithStudentname:nil Studentkey:studentkey2 Relationship:relationship];
                    [((Student *)[MyClass returnstudentwithstudentkey:studentkey1]).siblingarray addObject:siblingobject];
                }
            }
            //}
            
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT);",@"sibling", @"siblingkey",@"centerkey",@"studentkey1",@"studentkey2",@"relationship"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
    }
    
    //check and add lead table
    globalvariables.leadlistarray=[[NSMutableDictionary alloc]init];
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"lead"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if (![MyClass checkColumnExistswithTableName:@"lead" columnname:@"avatar"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS lead;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"lead", @"leadkey",@"centerkey",@"leadid",@"firstname",@"lastname",@"gender",@"dateofbirth",@"age",@"grade",@"preferredlanguage",@"school",@"parentname",@"parentemail",@"parentaddress",@"parentcontact",@"remarks",@"image",@"status",@"flag",@"promotion",@"leadmedia",@"leadsource",@"studentkey",@"othername",@"iso_code",@"avatar"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    //sqlite3_close(isdb);
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }
                
                [MyClass updatedevicelastupdatetimewithparameter:@"lead" centerkeyarray:nil systemcurrenttime:@""];
            }else{
                //load value from local db to globalvariables
                
                
                sql =[NSString stringWithFormat:@"SELECT * FROM lead"];
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        NSString *leadkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
                        NSString *centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        NSString *leadid=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        NSString *firstname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        NSString *lastname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)];
                        NSString *gender=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)];
                        NSString *dateofbirth=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 6)];
                        NSString *age=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 7)];
                        NSString *grade=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 8)];
                        NSString *preferredlanguage=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 9)];
                        NSString *school=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 10)];
                        NSString *parentname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 11)];
                        NSString *parentemail=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 12)];
                        NSString *parentaddress=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 13)];
                        NSString *parentcontact=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 14)];
                        NSString *remarks=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 15)];
                        NSString *image=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 16)];
                        NSString *status=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 17)];
                        NSString *flag=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 18)];
                        NSString *promotion=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 19)];
                        NSString *leadmedia=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 20)];
                        NSString *leadsource=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 21)];
                        NSString *studentkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 22)];
                        NSString *othername=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 23)];
                        NSString *iso_code=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 24)];
                        NSString *avatar=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 25)];
                        
                        
                        [globalvariables.leadlistarray setValue:[[Lead alloc]initLeadWithleadkey:leadkey firstname:firstname lastname:lastname othername:othername gender:gender dateofbirth:[dateofbirth isEqualToString:@""]?@"":[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:dateofbirth] age:age grade:grade preferredlanguage:preferredlanguage school:school parentname:parentname parentcontact:parentcontact parentemail:parentemail parentaddress:parentaddress remarks:remarks flag:flag promotion:promotion status:status image:image leadid:leadid leadmedia:leadmedia leadsource:leadsource studentkey:studentkey photoalbumrecord:nil centerkey:centerkey iso_code:iso_code avatar:avatar] forKey:leadkey];
                    }
                }
            }
            
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"lead", @"leadkey",@"centerkey",@"leadid",@"firstname",@"lastname",@"gender",@"dateofbirth",@"age",@"grade",@"preferredlanguage",@"school",@"parentname",@"parentemail",@"parentaddress",@"parentcontact",@"remarks",@"image",@"status",@"flag",@"promotion",@"leadmedia",@"leadsource",@"studentkey",@"othername",@"iso_code",@"avatar"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
        
        
        
    }

    //check and add attendance nature table
    sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS attendancenature;"];
    sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
    
    
    //check and add leave nature list table
    globalvariables.leavenaturearray=[[NSMutableDictionary alloc]init];
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"leave_nature_list"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            /*if (![MyClass checkColumnExistswithTableName:@"languagetitle" columnname:@"centerkey"]) {
             //delete table
             sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS languagetitle;"];
             sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
             
             //create table
             sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT);",@"languagetitle",@"titlekey",@"centerkey",@"title",@"english",@"chinese"];
             if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
             //sqlite3_close(isdb);
             NSAssert(0, @"Could not create table");
             }else{
             NSLog(@"table created");
             }
             
             //[MyClass updatedevicelastupdatetimewithparameter:@"" centerkey:@"All"];
             }else{*/
            //load value from local db to globalvariables
            
            
            sql =[NSString stringWithFormat:@"SELECT * FROM leave_nature_list order by centerkey,listorder"];
            
            if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                while (sqlite3_step(statement)==SQLITE_ROW) {
                    
                    NSString * leavenaturelistkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
                    NSString * centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                    NSString *nature_desc_english=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                    NSString *nature_desc_chinese=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                    BOOL is_student_request=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)] isEqualToString:@"Y"];
                    NSString *remarks=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)];
                    NSString *listorder=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 6)];
                    [globalvariables.leavenaturearray setValue:[[LeaveNatureRecord alloc]initLeaveNatureRecordWithLeaveNatureListKey:leavenaturelistkey centerKey:centerkey nature_desc_english:nature_desc_english nature_desc_chinese:nature_desc_chinese is_student_request:is_student_request remarks:remarks listOrder:listorder configDict:[[NSMutableDictionary alloc]init]] forKey:leavenaturelistkey];
                }
            }
            //}
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT);",@"leave_nature_list", @"leavenaturelistkey",@"centerkey",@"nature_desc_english",@"nature_desc_chinese",@"is_student_request",@"remarks",@"listorder"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
        
        
        
    }
    
    //check and add leave nature config table
    //globalvariables.leavenaturearray=[[NSMutableDictionary alloc]init];
    
    
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"leave_nature_config"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            /*if (![MyClass checkColumnExistswithTableName:@"languagetitle" columnname:@"centerkey"]) {
             //delete table
             sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS languagetitle;"];
             sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
             
             //create table
             sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT);",@"languagetitle",@"titlekey",@"centerkey",@"title",@"english",@"chinese"];
             if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
             //sqlite3_close(isdb);
             NSAssert(0, @"Could not create table");
             }else{
             NSLog(@"table created");
             }
             
             //[MyClass updatedevicelastupdatetimewithparameter:@"" centerkey:@"All"];
             }else{*/
            //load value from local db to globalvariables
            
            
            sql =[NSString stringWithFormat:@"SELECT * FROM leave_nature_config order by leavenaturelistkey"];
            
            if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                while (sqlite3_step(statement)==SQLITE_ROW) {
                    
                    NSString * leavenatureconfigkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
                    NSString * leavenaturelistkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                    NSString * attendance=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                    BOOL count_quota=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)] isEqualToString:@"Y"];
                    BOOL default_nature_for_student=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)] isEqualToString:@"Y"];
                    BOOL default_nature_for_staff=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 6)] isEqualToString:@"Y"];
                    BOOL require_approval=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 7)] isEqualToString:@"Y"];
                    
                    LeaveNatureRecord *record=[globalvariables.leavenaturearray objectForKey:leavenaturelistkey];
                    [record.configdict setValue:[[LeaveNatureConfig alloc]initLeaveNatureConfigWithLeaveNatureConfigKey:leavenatureconfigkey leaveNatureLeaveKey:leavenaturelistkey attendance:attendance count_quota:count_quota default_nature_for_student:default_nature_for_student default_nature_for_staff:default_nature_for_staff require_approval:require_approval] forKey:attendance];
                }
            }
            //}
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT);",@"leave_nature_config", @"leavenatureconfigkey",@"centerkey",@"leavenaturelistkey",@"attendance",@"count_quota",@"default_nature_for_student",@"default_nature_for_staff",@"require_approval"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
        
        
        
    }
    
    //check and add calendar table
    globalvariables.centerdaydictionary=[[NSMutableDictionary alloc]init];
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"schoolcalendar"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if ([MyClass checkColumnExistswithTableName:@"schoolcalendar" columnname:@"schoolmonth"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS schoolcalendar;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"schoolcalendar",@"schoolcalendarkey",@"centerkey",@"date",@"centerday"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }
            }else{
                sql =[NSString stringWithFormat:@"SELECT * FROM schoolcalendar"];
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        NSString *ccenterkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        NSString *cdate=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        NSString *ccenterday=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        [globalvariables.centerdaydictionary setValue:ccenterday forKey:[NSString stringWithFormat:@"%@#%@",cdate,ccenterkey]];
                    }
                }
            }
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"schoolcalendar",@"schoolcalendarkey",@"centerkey",@"date",@"centerday"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
        
        
    }
    
    //check and add studenthistory table
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"viewhistory"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            
            //load value from local db to globalvariables

        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT);",@"viewhistory",@"viewhistorykey",@"centerkey",@"type",@"typekey",@"name",@"id",@"gender"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
    }

    //check and add subject_information table
    globalvariables.subjectlistarray=[[NSMutableDictionary alloc]init];
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"subject_information"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if (![MyClass checkColumnExistswithTableName:@"subject_information" columnname:@"autolevelupgrade"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS subject_information;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"subject_information", @"subjectkey",@"centerkey",@"subject_chinesename",@"subject_englishname",@"subject_shortname",@"subject_category",@"enrollmentmode",@"tuition_method",@"tuition_mode",@"studentcapacity",@"standardnoofclassormonth",@"classduration",@"classduration_assessment",@"classduration_trial",@"status",@"remarks",@"weeklyautorenewdefault",@"validity",@"makeup_quota_unit",@"makeup_quota_value",@"leaveday_by_makeupschedule",@"leaveday_by_classdate",@"leaveday_follow_teacher",@"leaveday_by_enrolledschedule",@"leaveday_by_staffschedule",@"leaveday_follow_level",@"leaveday_follow_lesson",@"colorcode",@"fcsubject",@"leaveday_follow_category",@"allowsameschedule",@"subject_fulldescription",@"subject_image",@"publishinchatbot",@"chatbot_category",@"chatbot_tag1",@"trial_by_existinglesson",@"trial_by_definedschedule",@"trialcapacity",@"chatbot_enabletrial",@"showmakeupbuttonifnotimeslot",@"btspromotioncode831",@"btspromotioncode1031",@"showabsentbuttononarrangeleave",@"pregenperiodcount",@"autolevelupgrade"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    //sqlite3_close(isdb);
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }
                
                [MyClass updatedevicelastupdatetimewithparameter:@"subject" centerkeyarray:nil systemcurrenttime:@""];
                //[MyClass updatedevicelastupdatetimewithparameter:@"" centerkey:@"All"];
            }else{
                //load value from local db to globalvariables
                
                
                sql =[NSString stringWithFormat:@"SELECT * FROM subject_information"];
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        NSString *subjectkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
                        NSString *centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        NSString *subject_chinesename=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        NSString *subject_englishname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        NSString *subject_shortname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)];
                        NSString *subject_category=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)];
                        NSString *enrollmentmode=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 6)];
                        NSString *tuition_method=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 7)];
                        NSString *tuition_mode=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 8)];
                        NSString *studentcapacity=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 9)];
                        NSString *standardnoofclassormonth=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 10)];
                        NSString *classduration=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 11)];
                        NSString *classduration_assessment=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 12)];
                        NSString *classduration_trial=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 13)];
                        NSString *status=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 14)];
                        NSString *remarks=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 15)];
                        NSString *weeklyautorenewdefault=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 16)];
                        NSString *validity=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 17)];
                        NSString *makeup_quota_unit=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 18)];
                        NSString * makeup_quota_value=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 19)];
                        BOOL leaveday_by_makeupschedule=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 20)] isEqualToString:@"Yes"];
                        BOOL leaveday_by_classdate=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 21)] isEqualToString:@"Yes"];
                        BOOL leaveday_follow_teacher=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 22)] isEqualToString:@"Yes"];
                        BOOL leaveday_by_enrolledschedule=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 23)] isEqualToString:@"Yes"];
                        BOOL leaveday_by_staffschedule=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 24)] isEqualToString:@"Yes"];
                        BOOL leaveday_follow_level=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 25)] isEqualToString:@"Yes"];
                        BOOL leaveday_follow_lesson=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 26)] isEqualToString:@"Yes"];
                        NSInteger colorcode=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 27)] integerValue];
                        NSString *fcsubject=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 28)];
                        BOOL leaveday_follow_category=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 29)] isEqualToString:@"Yes"];
                        BOOL allowsameschedule=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 30)] isEqualToString:@"Yes"];
                        NSString *subject_fulldescription=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 31)];
                        NSString *subject_image=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 32)];
                        BOOL publishinchatbot=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 33)] isEqualToString:@"Yes"];
                        NSString *chatbot_category=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 34)];
                        NSString *chatbot_tag1=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 35)];
                        BOOL trial_by_existinglesson=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 36)] isEqualToString:@"Yes"];
                        BOOL trial_by_definedschedule=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 37)] isEqualToString:@"Yes"];
                        NSString *trialcapacity=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 38)];
                        BOOL chatbot_enabletrial=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 39)] isEqualToString:@"Yes"];
                        BOOL showmakeupbuttonifnotimeslot=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 40)] isEqualToString:@"Yes"];
                        NSString * btspromotioncode831=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 41)];
                        NSString * btspromotioncode1031=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 42)];
                        BOOL showabsentbuttononarrangeleave=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 43)] isEqualToString:@"Yes"];
                        NSInteger pregenperiodcount=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 44)] integerValue];
                        NSString *autolevelupgrade=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 45)];
                        
                        //add system default schedule if not user default
                        NSMutableArray *tmpscheduleArray=[[NSMutableArray alloc]init];
                        if ([tuition_mode isEqualToString:@"Month"]) {
                            [tmpscheduleArray addObject:[[ScheduleRecord alloc]initScheduleRecordwithScheduleKey:@"-1" Name:@"Weekly" AutoRenew:weeklyautorenewdefault?@"Yes":@"No" DayTimeArray:nil Action:@"" StartDate:@"" EndDate:@"" makeupschedule:NO active:YES type:@"Recursive" showintimetableifnoenrollment:NO onlinetrialschedule:NO levelarray:[[NSMutableArray alloc]init]]];
                        }else{
                            [tmpscheduleArray addObject:[[ScheduleRecord alloc]initScheduleRecordwithScheduleKey:@"-1" Name:@"Weekly" AutoRenew:weeklyautorenewdefault?@"Yes":@"No" DayTimeArray:nil Action:@"" StartDate:@"" EndDate:@"" makeupschedule:NO active:YES type:@"Recursive" showintimetableifnoenrollment:NO onlinetrialschedule:NO levelarray:[[NSMutableArray alloc]init]]];
                            [tmpscheduleArray addObject:[[ScheduleRecord alloc]initScheduleRecordwithScheduleKey:@"-2" Name:@"Free" AutoRenew:@"No" DayTimeArray:nil Action:@"" StartDate:@"" EndDate:@"" makeupschedule:NO active:YES type:@"" showintimetableifnoenrollment:NO onlinetrialschedule:NO levelarray:[[NSMutableArray alloc]init]]];
                        }
                        
                        
                        [globalvariables.subjectlistarray setValue:[[SubjectRecord alloc]initSubjectRecordwithCenterkey:centerkey Subjectkey:subjectkey Subject_Englishname:subject_englishname Subject_Chinesename:subject_chinesename Subject_shortname:subject_shortname Enrollmentmode:enrollmentmode Tuition_method:tuition_method Tuition_mode:tuition_mode Studentcapacity:studentcapacity StandardNoOfClassOrMonth:standardnoofclassormonth ClassDuration:classduration ClassDurationAssessment:classduration_assessment ClassDurationTrial:classduration_trial Status:status LevelArray:nil TuitionArray:nil Remarks:remarks ScheduleArray:tmpscheduleArray Subject_Category:subject_category WeeklyAutoRenewDefault:[weeklyautorenewdefault isEqualToString:@"Yes"] validity:validity makeup_quota_unit:makeup_quota_unit makeup_quota_value:makeup_quota_value leaveday_by_makeupschedule:leaveday_by_makeupschedule leaveday_by_classdate:leaveday_by_classdate leaveday_follow_teacher:leaveday_follow_teacher leaveday_by_enrolledschedule:leaveday_by_enrolledschedule leaveday_by_staffschedule:leaveday_by_staffschedule leaveday_follow_level:leaveday_follow_level leaveday_follow_lesson:leaveday_follow_lesson colorcode:colorcode fcsubject:fcsubject lessonnumberDict:[[NSMutableDictionary alloc]init] leaveday_follow_category:leaveday_follow_category allowsameschedule:allowsameschedule subject_fulldescription:subject_fulldescription subject_image:subject_image publishinchatbot:publishinchatbot chatbot_category:chatbot_category chatbot_tag1:chatbot_tag1 trial_by_existinglesson:trial_by_existinglesson trial_by_definedschedule:trial_by_definedschedule trialcapacity:trialcapacity chatbot_enabletrial:chatbot_enabletrial showmakeupbuttonifnotimeslot:showmakeupbuttonifnotimeslot btspromotioncode831:btspromotioncode831 btspromotioncode1031:btspromotioncode1031 showabsentbuttononarrangeleave:showabsentbuttononarrangeleave pregenperiodcount:pregenperiodcount autolevelupgrade:autolevelupgrade] forKey:[NSString stringWithFormat:@"%@#%@",centerkey,subject_shortname]];
                    }
                }
            }
            
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"subject_information", @"subjectkey",@"centerkey",@"subject_chinesename",@"subject_englishname",@"subject_shortname",@"subject_category",@"enrollmentmode",@"tuition_method",@"tuition_mode",@"studentcapacity",@"standardnoofclassormonth",@"classduration",@"classduration_assessment",@"classduration_trial",@"status",@"remarks",@"weeklyautorenewdefault",@"validity",@"makeup_quota_unit",@"makeup_quota_value",@"leaveday_by_makeupschedule",@"leaveday_by_classdate",@"leaveday_follow_teacher",@"leaveday_by_enrolledschedule",@"leaveday_by_staffschedule",@"leaveday_follow_level",@"leaveday_follow_lesson",@"colorcode",@"fcsubject",@"leaveday_follow_category",@"allowsameschedule",@"subject_fulldescription",@"subject_image",@"publishinchatbot",@"chatbot_category",@"chatbot_tag1",@"trial_by_existinglesson",@"trial_by_definedschedule",@"trialcapacity",@"chatbot_enabletrial",@"showmakeupbuttonifnotimeslot",@"btspromotioncode831",@"btspromotioncode1031",@"showabsentbuttononarrangeleave",@"pregenperiodcount",@"autolevelupgrade"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
        
        
        
    }
    
    //check and add subject_level table

    
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"subject_levelset"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if (![MyClass checkColumnExistswithTableName:@"subject_levelset" columnname:@"earlieststartdate"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS subject_levelset;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                 
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT);",@"subject_levelset", @"levelsetkey",@"centerkey",@"subject_shortname",@"level",@"earlieststartdate"];
                 if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                     //sqlite3_close(isdb);
                     NSAssert(0, @"Could not create table");
                 }else{
                     NSLog(@"table created");
                 }
             
                [MyClass updatedevicelastupdatetimewithparameter:@"subject" centerkeyarray:nil systemcurrenttime:@""];
            }else{
                //load value from local db to globalvariables
                sql =[NSString stringWithFormat:@"SELECT * FROM subject_levelset order by centerkey, subject_shortname, CAST(level AS UNSIGNED INTEGER), level"];
                NSMutableArray *tmplevelArray=[[NSMutableArray alloc]init];
                
                NSString *levelsetkey;
                NSString *centerkey;
                NSString *subject_shortname=@"";
                NSString *level;
                NSString *earlieststartdate;
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        levelsetkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
                        //centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        level=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        //NSString *test=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        earlieststartdate=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)];
                        
                        if (([subject_shortname isEqualToString:[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)]] && [centerkey isEqualToString:[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)]]) || [subject_shortname isEqualToString:@""]) {
                            
                            [tmplevelArray addObject:[[LevelRecord alloc]initLevelRecordwithLevel:level earlieststartdate:earlieststartdate]];
                        }else{
                            //add tmplevelarray to subjectarray
                            ((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:subject_shortname centerkey:centerkey]).levelArray=tmplevelArray;
                            
                            tmplevelArray=[[NSMutableArray alloc]init];
                            //subject_shortname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                            [tmplevelArray addObject:[[LevelRecord alloc]initLevelRecordwithLevel:level earlieststartdate:earlieststartdate]];
                        }
                        centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        subject_shortname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                    }
                    
                    if(![subject_shortname isEqualToString:@""]){
                        ((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:subject_shortname centerkey:centerkey]).levelArray=tmplevelArray;
                    }
                }
            }
            
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT);",@"subject_levelset", @"levelsetkey",@"centerkey",@"subject_shortname",@"level",@"earlieststartdate"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
    }
    
    //check and add subject_tuition table
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"subject_tuitionset"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if (![MyClass checkColumnExistswithTableName:@"subject_tuitionset" columnname:@"newtuitionfee"]) {
             //delete table
                 sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS subject_tuitionset;"];
                 sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                 
                 //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT);",@"subject_tuitionset", @"tuitionsetkey",@"centerkey",@"subject_shortname",@"method",@"scale",@"tuitionfee",@"newtuitionfee",@"effectivedate"];
                 if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                 //sqlite3_close(isdb);
                 NSAssert(0, @"Could not create table");
                 }else{
                 NSLog(@"table created");
                 }
                 
                [MyClass updatedevicelastupdatetimewithparameter:@"subject" centerkeyarray:nil systemcurrenttime:@""];
             }else{
                //load value from local db to globalvariables
                
                
                sql =[NSString stringWithFormat:@"SELECT * FROM subject_tuitionset order by centerkey, subject_shortname, CAST(scale AS UNSIGNED INTEGER), scale"];
                NSMutableArray *tmptuitionArray=[[NSMutableArray alloc]init];
                
                NSString *tuitionsetkey;
                NSString *centerkey;
                NSString *subject_shortname=@"";
                NSString *method;
                NSString *scale;
                NSString *tuitionfee;
                 NSString *newtuitionfee;
                 NSString *effectivedate;
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        tuitionsetkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
                        //centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        method=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        scale=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)];
                        tuitionfee=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)];
                        newtuitionfee=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 6)];
                        effectivedate=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 7)];
                        
                        
                        if (([subject_shortname isEqualToString:[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)]] && [centerkey isEqualToString:[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)]]  )|| [subject_shortname isEqualToString:@""]) {
                            subject_shortname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                            [tmptuitionArray addObject:[[TuitionRecord alloc]initTuitionRecordwithSubject_Shortname:subject_shortname Method:method Scale:scale TuitionFee:tuitionfee newtuitionfee:newtuitionfee effectivedate:effectivedate]];
                        }else{
                            //add tmplevelarray to subjectarray
                            ((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:subject_shortname centerkey:centerkey]).tuitionArray=tmptuitionArray;
                            tmptuitionArray=[[NSMutableArray alloc]init];
                            subject_shortname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                            [tmptuitionArray addObject:[[TuitionRecord alloc]initTuitionRecordwithSubject_Shortname:subject_shortname Method:method Scale:scale TuitionFee:tuitionfee newtuitionfee:newtuitionfee effectivedate:effectivedate]];
                        }
                        
                        
                        centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                    }
                    
                    if(![subject_shortname isEqualToString:@""]){
                        ((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:subject_shortname centerkey:centerkey]).tuitionArray=tmptuitionArray;
                    }
                }
            }
            
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT);",@"subject_tuitionset", @"tuitionsetkey",@"centerkey",@"subject_shortname",@"method",@"scale",@"tuitionfee",@"newtuitionfee",@"effectivedate"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
        
        
        
    }
    
    //check and add course_schedule table
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"course_schedule"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if (![MyClass checkColumnExistswithTableName:@"course_schedule" columnname:@"level"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS course_schedule;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT);",@"course_schedule", @"schedulekey",@"centerkey",@"subject_shortname",@"schedulename",@"autorenew",@"makeupschedule",@"startdate",@"enddate",@"active",@"type",@"showintimetableifnoenrollment",@"onlinetrialschedule",@"level"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    //sqlite3_close(isdb);
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }
                
                [MyClass updatedevicelastupdatetimewithparameter:@"subject" centerkeyarray:nil systemcurrenttime:@""];
            }else{
                //load value from local db to globalvariables
                
                
                sql =[NSString stringWithFormat:@"SELECT * FROM course_schedule order by centerkey,subject_shortname,schedulename COLLATE NOCASE ASC,schedulekey"];
                NSMutableArray *tmpscheduleArray=[[NSMutableArray alloc]init];
                NSString *schedulekey;
                NSString *centerkey;
                NSString *subject_shortname=@"";
                NSString *schedulename;
                NSString *autorenew;
                NSString *makeupschedule;
                NSString *active;
                NSString *startdate;
                NSString *enddate;
                NSString *type;
                NSString *showintimetableifnoenrollment;
                NSString *onlinetrialschedule;
                NSString *level;
                
                SubjectRecord *subjectobject;
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        schedulekey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
                        schedulename=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        autorenew=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)];
                        makeupschedule=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)];
                        startdate=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 6)];
                        enddate=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 7)];
                        active=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 8)];
                        type=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 9)];
                        showintimetableifnoenrollment=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 10)];
                        onlinetrialschedule=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 11)];
                        level=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 12)];
                        
                        NSMutableArray *cstimearray=[[NSMutableArray alloc]init];
                        
                        if (([subject_shortname isEqualToString:[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)]] && [centerkey isEqualToString:[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)]]) || [subject_shortname isEqualToString:@""]) {
                            [tmpscheduleArray addObject:[[ScheduleRecord alloc]initScheduleRecordwithScheduleKey:schedulekey Name:schedulename AutoRenew:autorenew DayTimeArray:cstimearray Action:@"" StartDate:[MyClass convertDateFormatWithDate:startdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO] EndDate:[MyClass convertDateFormatWithDate:enddate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO] makeupschedule:[makeupschedule isEqualToString:@"Yes"] active:[active isEqualToString:@"Yes"] type:type showintimetableifnoenrollment:[showintimetableifnoenrollment isEqualToString:@"Yes"] onlinetrialschedule:[onlinetrialschedule isEqualToString:@"Yes"] levelarray:[level isEqualToString:@""]?[[NSMutableArray alloc]init]:[level isEqualToString:@"!!None!!"]?nil:[[NSMutableArray alloc]initWithArray:[level componentsSeparatedByString:@"#|#"]]]];
                        }else{
                            //add tmpschedulearray to subjectarray
                            subjectobject=[MyClass returnsubjectinformationwithsubject_shortname:subject_shortname centerkey:centerkey];
                            [subjectobject.scheduleArray addObjectsFromArray:tmpscheduleArray];
                            tmpscheduleArray=[[NSMutableArray alloc]init];
                            
                            [tmpscheduleArray addObject:[[ScheduleRecord alloc]initScheduleRecordwithScheduleKey:schedulekey Name:schedulename AutoRenew:autorenew DayTimeArray:cstimearray Action:@"" StartDate:[MyClass convertDateFormatWithDate:startdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO] EndDate:[MyClass convertDateFormatWithDate:enddate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO] makeupschedule:[makeupschedule isEqualToString:@"Yes"] active:[active isEqualToString:@"Yes"] type:type showintimetableifnoenrollment:[showintimetableifnoenrollment isEqualToString:@"Yes"] onlinetrialschedule:[onlinetrialschedule isEqualToString:@"Yes"] levelarray:[level isEqualToString:@""]?[[NSMutableArray alloc]init]:[level isEqualToString:@"!!None!!"]?nil:[[NSMutableArray alloc]initWithArray:[level componentsSeparatedByString:@"#|#"]]]];
                        }
                        subject_shortname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                    }
                    
                    if(![subject_shortname isEqualToString:@""]){
                        subjectobject=[MyClass returnsubjectinformationwithsubject_shortname:subject_shortname centerkey:centerkey];
                        [subjectobject.scheduleArray addObjectsFromArray:tmpscheduleArray];
                    }
                }
            }
            
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT);",@"course_schedule", @"schedulekey",@"centerkey",@"subject_shortname",@"schedulename",@"autorenew",@"makeupschedule",@"startdate",@"enddate",@"active",@"type",@"showintimetableifnoenrollment",@"onlinetrialschedule",@"level"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
        
        
        
    }

    //check and add course_schedule_details table
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"course_schedule_details"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if (![MyClass checkColumnExistswithTableName:@"course_schedule_details" columnname:@"sinstructor"]) {
                 //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS course_schedule_details;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                 
                 //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT);",@"course_schedule_details", @"scheduledetailskey",@"centerkey",@"subject_shortname",@"schedulekey",@"dayofweek",@"classtime",@"instructor",@"classroom",@"sinstructor"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    //sqlite3_close(isdb);
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }
                [MyClass updatedevicelastupdatetimewithparameter:@"subject" centerkeyarray:nil systemcurrenttime:@""];
            }else{
                //load value from local db to globalvariables
                
                
                //sql =[NSString stringWithFormat:@"SELECT * FROM course_schedule_details order by centerkey,subject_shortname,schedulekey,case dayofweek when 'Mon' then 0 when 'Tue' then 1 when  'Wed' then 2 when 'Thu' then 3 when  'Fri' then 4 when 'Sat' then 5 when 'Sun' then 6 end,classtime"];
                sql =[NSString stringWithFormat:@"SELECT * FROM course_schedule_details order by centerkey,subject_shortname,schedulekey,scheduledetailskey"];
                NSMutableArray *tmpDetailsArray=[[NSMutableArray alloc]init];
                NSString *scheduledetailskey;
                NSString *centerkey;
                NSString *subject_shortname;
                NSString *schedulekey=@"";
                NSString *dayofweek;
                NSString *classtime;
                NSString *instructor;
                NSString *classroom;
                NSString *sinstructor;
                ScheduleRecord *scheduleobject;
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        scheduledetailskey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
                        //centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        //subject_shortname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        dayofweek=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)];
                        classtime=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)];
                        instructor=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 6)];
                        classroom=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 7)];
                        sinstructor=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 8)];

                        if (![schedulekey isEqualToString:[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)]]  && ![schedulekey isEqualToString:@""]) {

                            //add tmpschedulearray to subjectarray
                            scheduleobject=[MyClass returnschedulerecordwithsubject_shortname:subject_shortname centerkey:centerkey schedulekey:schedulekey];
                            [scheduleobject.daytimearray addObjectsFromArray:tmpDetailsArray];
                            tmpDetailsArray=[[NSMutableArray alloc]init];
                            
                        }
                        [tmpDetailsArray addObject:[[ScheduleDetailsRecord alloc]initScheduleDetailsRecordwithdayofweek:dayofweek classtime:classtime instructor:instructor classroom:classroom sinstructor:sinstructor]];
                        
                        centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        subject_shortname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        schedulekey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                    }
                    
                    if(![schedulekey isEqualToString:@""]){
                        scheduleobject=[MyClass returnschedulerecordwithsubject_shortname:subject_shortname centerkey:centerkey schedulekey:schedulekey];
                        [scheduleobject.daytimearray addObjectsFromArray:tmpDetailsArray];
                    }
                }
            }
            
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT);",@"course_schedule_details", @"scheduledetailskey",@"centerkey",@"subject_shortname",@"schedulekey",@"dayofweek",@"classtime",@"instructor",@"classroom",@"sinstructor"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
        
        
        
    }
    
    
    
    //check and add subject_category table
    globalvariables.subjectcategoryarray=[[NSMutableArray alloc]init];
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"subject_category"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if (![MyClass checkColumnExistswithTableName:@"subject_category" columnname:@"bundleforapppayment"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS subject_category;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT);",@"subject_category",@"scategorykey",@"centerkey",@"englishname",@"chinesename",@"colorcode",@"bundleforapppayment"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    //sqlite3_close(isdb);
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }
                [MyClass updatedevicelastupdatetimewithparameter:@"subject" centerkeyarray:nil systemcurrenttime:@""];
            }else{
                //load value from local db to globalvariables
                sql =[NSString stringWithFormat:@"SELECT * FROM subject_category order by centerkey,scategorykey"];
                
                //NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                
                
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        NSString *scategorykey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
                        NSString *centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        NSString *englishname=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        NSString *chinesename=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        NSInteger colorcode=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)] integerValue];
                        BOOL bundleforapppayment=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)] isEqualToString:@"Yes"];
                        
                        [globalvariables.subjectcategoryarray addObject:[[SubjectCategoryRecord alloc]initSubjectCategoryRecordwithCenterkey:centerkey SCategoryKey:scategorykey Englishname:englishname Chinesename:chinesename colorcode:colorcode bundleforapppayment:bundleforapppayment]];
                        
                    }
                }
            
            }
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT);",@"subject_category",@"scategorykey",@"centerkey",@"englishname",@"chinesename",@"colorcode",@"bundleforapppayment"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
    }
    
    
    //check and add languagepack table
    globalvariables.languagepackdictionary=[[NSMutableDictionary alloc]init];
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"languagepack"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if (![MyClass checkColumnExistswithTableName:@"languagepack" columnname:@"centerkey"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS languagepack;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT);",@"languagepack",@"titlekey",@"centerkey",@"title",@"english",@"chinese",@"schinese"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    //sqlite3_close(isdb);
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }
                
                //[MyClass updatedevicelastupdatetimewithparameter:@"languagetitle" centerkeyarray:nil systemcurrenttime:@""];
            }else{
                //load value from local db to globalvariables
                
                
                sql =[NSString stringWithFormat:@"SELECT * FROM languagepack"];
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        NSString *ccenterkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        NSString *ctitle=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        NSString *cenglish=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        NSString *cchinese=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)];
                        NSString *cschinese=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)];
                        [globalvariables.languagepackdictionary setValue:[[LanguageTitleRecord alloc]initLanguageTitleRecordwithCenterkey:ccenterkey Title:ctitle Chinese:cchinese English:cenglish SChinese:cschinese] forKey:[NSString stringWithFormat:@"%@#%@",/*ccenterkey*/@"",ctitle]];
                    }
                }
            }
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT,'%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT);",@"languagepack",@"titlekey",@"centerkey",@"title",@"english",@"chinese",@"schinese"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
        
        

    }
    
    //check and add subject_lesson table
//    globalvariables.subjectcategoryarray=[[NSMutableArray alloc]init];
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"subject_lesson"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            /*if (![MyClass checkColumnExistswithTableName:@"languagetitle" columnname:@"centerkey"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS languagetitle;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT);",@"languagetitle",@"titlekey",@"centerkey",@"title",@"english",@"chinese"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    //sqlite3_close(isdb);
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }
            }else{*/
                //load value from local db to globalvariables
                sql =[NSString stringWithFormat:@"SELECT * FROM subject_lesson order by centerkey,subject,type,lessonnumber"];
                
                //NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                
                NSMutableDictionary *tmplessonnumberDict=[[NSMutableDictionary alloc]init];
                NSMutableArray *tmpnotesetArray=[[NSMutableArray alloc]init];
                
                NSString *prevcenterkey;
                NSString *prevsubject=@"";
                NSString *prevtype=@"";
                NSString *thiscenterkey;
                NSString *thissubject;
                NSString *thistype;
                NSString *thisdescription;
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        //type=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        thiscenterkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        thissubject=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        thistype=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        thisdescription=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)];
                        
                        NSString *thisstring=[NSString stringWithFormat:@"%@%@",thissubject,thistype];
                        NSString *prevstring=[NSString stringWithFormat:@"%@%@",prevsubject,prevtype];
                        
                        
                        if (![thisstring isEqualToString:prevstring] && ![prevsubject isEqualToString:@""]) {
                            //add array to dict
                            [tmplessonnumberDict setValue:tmpnotesetArray forKey:prevtype];
                            tmpnotesetArray=[[NSMutableArray alloc]init];
                            if(![prevsubject isEqualToString:thissubject]){
                                //add dict to subject
                                ((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:prevsubject centerkey:prevcenterkey]).lessonnumberDict=tmplessonnumberDict;
                                tmplessonnumberDict=[[NSMutableDictionary alloc]init];
                            }
                        }
                        [tmpnotesetArray addObject:thisdescription];
                        
                        prevcenterkey=thiscenterkey;
                        prevsubject=thissubject;
                        prevtype=thistype;
                        
                    }
                    
                    //conclude last record
                    if(![prevsubject isEqualToString:@""]){
                        [tmplessonnumberDict setValue:tmpnotesetArray forKey:prevtype];
                        ((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:prevsubject centerkey:prevcenterkey]).lessonnumberDict =tmplessonnumberDict;
                    }
                }
                
            //}
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' INTEGER,'%@' TEXT);",@"subject_lesson",@"lessonkey",@"centerkey",@"subject",@"type",@"lessonnumber",@"description"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
    }
    
    //check and add country code table
    globalvariables.countrycodearray=[[NSMutableDictionary alloc]init];
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"countrycode"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if (![MyClass checkColumnExistswithTableName:@"countrycode" columnname:@"countrycodekey"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS countrycode;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"countrycode",@"countrycodekey",@"country_code",@"country_name",@"iso_code"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }
            }else{
                sql =[NSString stringWithFormat:@"SELECT * FROM countrycode"];
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        NSString *countrycodekey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
                        NSString *country_code=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        NSString *country_name=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        NSString *iso_code=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        [globalvariables.countrycodearray setValue:[[CountryCodeRecord alloc]initCountryCodeRecordwithcountrycodekey:countrycodekey country_code:country_code country_name:country_name iso_code:iso_code] forKey:iso_code];
                    }
                }
            }
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"countrycode",@"countrycodekey",@"country_code",@"country_name",@"iso_code"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
    }
    
    //assessment form temp table
//    globalvariables.countrycodearray=[[NSMutableDictionary alloc]init];
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"assessmentresponse"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if (![MyClass checkColumnExistswithTableName:@"assessmentresponse" columnname:@"formresponsekey"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS assessmentresponse;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"assessmentresponse",@"formresponsekey",@"classkey",@"formkey",@"response",@"section",@"row"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }
            }else{
//                sql =[NSString stringWithFormat:@"SELECT * FROM assessmentresponse"];
//
//                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
//                    while (sqlite3_step(statement)==SQLITE_ROW) {
//
//                        NSString *countrycodekey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
//                        NSString *country_code=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
//                        NSString *country_name=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
//                        NSString *iso_code=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
//                        [globalvariables.countrycodearray setValue:[[CountryCodeRecord alloc]initCountryCodeRecordwithcountrycodekey:countrycodekey country_code:country_code country_name:country_name iso_code:iso_code] forKey:iso_code];
//                    }
//                }
            }
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"assessmentresponse",@"formresponsekey",@"classkey",@"formkey",@"response",@"section",@"row"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
    }
    
    //check and add messagecontact table
    globalvariables.messagecontactlist=[[NSMutableDictionary alloc]init];
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"messagecontact"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if (![MyClass checkColumnExistswithTableName:@"messagecontact" columnname:@"unreadcountsort"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS messagecontact;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"messagecontact", @"messagecontactkey",@"outboxmessagekey",@"centerkey",@"readstatus",@"channel",@"unreadcount",@"messagetype",@"messagecontacttype",@"messagestarttime",@"type",@"messagecontact",@"attachmenttypes",@"recipient",@"messageenglish",@"messagechinese",@"sender",@"unreadcountsort"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    //sqlite3_close(isdb);
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"messagecontact table created");
                }
                
                [MyClass updatedevicelastupdatetimewithparameter:@"messagecontact" centerkeyarray:nil systemcurrenttime:@""];
            }else{
                //load value from local db to globalvariables
                
                
                sql =[NSString stringWithFormat:@"SELECT * FROM messagecontact"];
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        NSString *outboxmessagekey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        NSString *centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        NSString *readstatus=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        NSString *channel=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)];
                        NSString *unreadcount=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)];
                        NSString *messagetype=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 6)];
                        NSString *messagecontacttype=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 7)];
                        NSString *messagestarttime=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 8)];
                        NSString *type=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 9)];
                        NSString *messagecontact=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 10)];
                        NSString *attachmenttypes=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 11)];
                        NSString *recipient=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 12)];
                        NSString *messageenglish=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 13)];
                        NSString *messagechinese=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 14)];
                        NSString *sender=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 15)];
                        NSString *unreadcountsort=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 16)];
                        NSArray * attachmenttypesarray=[attachmenttypes componentsSeparatedByString:@","];
                        
                        [globalvariables.messagecontactlist setValue:[[MessageContactRecord alloc]initMessageContactRecordwithcenterkey:centerkey messagecontact:messagecontact messagetype:messagetype messagestarttime:messagestarttime unreadcount:unreadcount attachmenttypes:attachmenttypesarray readstatus:readstatus type:type messagecontacttype:messagecontacttype sender:sender recipient:recipient channel:channel unreadcountsort:unreadcountsort messageenglish:messageenglish messagechinese:messagechinese outboxmessagekey:outboxmessagekey messagecontactdisplayname:nil] forKey:[NSString stringWithFormat:@"%@#%@",centerkey,messagecontact]];
                    }
                }
            }
            
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"messagecontact",@"messagecontactkey", @"outboxmessagekey",@"centerkey",@"readstatus",@"channel",@"unreadcount",@"messagetype",@"messagecontacttype",@"messagestarttime",@"type",@"messagecontact",@"attachmenttypes",@"recipient",@"messageenglish",@"messagechinese",@"sender",@"unreadcountsort"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"messagecontact table created");
            }
        }
    }
    
    //check and add marketing_information table
    globalvariables.marketinglistarray=[[NSMutableDictionary alloc]init];
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"marketing_information"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if (![MyClass checkColumnExistswithTableName:@"marketing_information" columnname:@"manualapply"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS marketing_information;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"marketing_information", @"marketingkey",@"code",@"centerkey",@"category",@"description",@"description_chinese",@"startdate",@"enddate",@"remarks",@"promotionfixeddiscount",@"promotionpercentagediscount",@"promotionquota",@"effectivefrom",@"effectiveto",@"subcategory",@"redeemable",@"redeempoint",@"perstudentquota",@"cannotuseconjunctionwithothercoupons",@"usedcount",@"couponallowcredit",@"perclassorquantity",@"earlybirdlastdate",@"buymorepayless",@"estartdate",@"eenddate",@"enablebuymorepayless",@"minnoofclass",@"bmsmacrossothersubjects",@"bmsmminsubjectno",@"bmsmminnoofclasspersubject",@"bmsmsamebillmonth",@"manualapply"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    //sqlite3_close(isdb);
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }
                [MyClass updatedevicelastupdatetimewithparameter:@"marketing" centerkeyarray:nil systemcurrenttime:@""];
                //[MyClass updatedevicelastupdatetimewithparameter:@"" centerkey:@"All"];
            }else{
                //load value from local db to globalvariables
                
                
                sql =[NSString stringWithFormat:@"SELECT * FROM marketing_information"];
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        
                        NSString *marketingkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 0)];
                        NSString *code=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        NSString *centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        NSString *category=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                        NSString *description=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)];
                        NSString *description_chinese=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 5)];
                        NSString *startdate=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 6)];
                        NSString *enddate=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 7)];
                        NSString *remarks=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 8)];
                        NSString *promotionfixeddiscount=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 9)];
                        NSString *promotionpercentagediscount=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 10)];
                        NSString *promotionquota=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 11)];
                        NSString *effectivefrom=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 12)];
                        NSString *effectiveto=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 13)];
                        NSString *subcategory=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 14)];
                        NSString *redeemable=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 15)];
                        NSString *redeempoint=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 16)];
                        NSString *perstudentquota=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 17)];
                        NSString *cannotuseconjunctionwithothercoupons=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 18)];
                        NSString *usedcount=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 19)];
                        NSString *couponallowcredit=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 20)];
                        BOOL perclassorquantity=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 21)] isEqualToString:@"Yes"];
                        NSString *earlybirdlastdate=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 22)];
                        BOOL buymorepayless=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 23)] isEqualToString:@"Yes"];
                        NSString *estartdate=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 24)];
                        NSString *eenddate=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 25)];
                        BOOL enablebuymorepayless=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 26)] isEqualToString:@"Yes"];
                        NSInteger minnoofclass=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 27)] integerValue];
                        BOOL bmsmacrossothersubjects=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 28)] isEqualToString:@"Yes"];
                        NSInteger bmsmminsubjectno=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 29)] integerValue];
                        NSInteger bmsmminnoofclasspersubject=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 30)] integerValue];
                        BOOL bmsmsamebillmonth=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 31)] isEqualToString:@"Yes"];
                        BOOL manualapply=[[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 32)] isEqualToString:@"Yes"];
                        
                        [globalvariables.marketinglistarray setValue:[[MarketingRecord alloc]initMarketingRecordWithcenterkey:centerkey marketingkey:marketingkey category:category description:description description_chinese:description_chinese startdate:startdate enddate:enddate remarks:remarks promotionfixeddiscount:promotionfixeddiscount promotionpercentagediscount:promotionpercentagediscount usedcount:usedcount promotionquota:promotionquota code:code recursive:@"No" effectivefrom:effectivefrom effectiveto:effectiveto subcategory:subcategory redeemable:[redeemable isEqualToString:@"Yes"] redeempoint:redeempoint perstudentquota:perstudentquota cannotuseconjunctionwithothercoupons:[cannotuseconjunctionwithothercoupons isEqualToString:@"Yes"] subjectarray:[[NSMutableArray alloc]init] productarray:[[NSMutableArray alloc]init] couponallowcredit:couponallowcredit perclassorquantity:perclassorquantity earlybirdlastdate:earlybirdlastdate buymorepayless:buymorepayless estartdate:estartdate eenddate:eenddate enablebuymorepayless:enablebuymorepayless minnoofclass:minnoofclass bmsmacrossothersubjects:bmsmacrossothersubjects bmsmminsubjectno:bmsmminsubjectno bmsmminnoofclasspersubject:bmsmminnoofclasspersubject bmsmsamebillmonth:bmsmsamebillmonth manualapply:manualapply] forKey:[NSString stringWithFormat:@"%@#%@",centerkey,marketingkey]];
                    }
                }
            }
            
        }else{
            //table does not exist
            [MyClass resetdevicelastupdatetimewithparameters:@"marketing"];
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT);",@"marketing_information", @"marketingkey",@"code",@"centerkey",@"category",@"description",@"description_chinese",@"startdate",@"enddate",@"remarks",@"promotionfixeddiscount",@"promotionpercentagediscount",@"promotionquota",@"effectivefrom",@"effectiveto",@"subcategory",@"redeemable",@"redeempoint",@"perstudentquota",@"cannotuseconjunctionwithothercoupons",@"usedcount",@"couponallowcredit",@"perclassorquantity",@"earlybirdlastdate",@"buymorepayless",@"estartdate",@"eenddate",@"enablebuymorepayless",@"minnoofclass",@"bmsmacrossothersubjects",@"bmsmminsubjectno",@"bmsmminnoofclasspersubject",@"bmsmsamebillmonth",@"manualapply"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
        
        
        
    }
    
    //check and add marketing_application table
    sql=[NSString stringWithFormat:@"select name from sqlite_master where type='table' and name='%@';",@"marketing_application"];
    
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        int rowcount = 0;
        while (sqlite3_step(statement)==SQLITE_ROW) {
            rowcount+=1;
        }
        if (rowcount==1) {
            //table exist
            if (![MyClass checkColumnExistswithTableName:@"marketing_application" columnname:@"centerkey"]) {
                //delete table
                sql=[NSString stringWithFormat:@"DROP TABLE IF EXISTS marketing_application;"];
                sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err);
                
                //create table
                sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT);",@"marketing_application", @"applicationkey",@"centerkey",@"marketingkey",@"type",@"typekey"];
                if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                    //sqlite3_close(isdb);
                    NSAssert(0, @"Could not create table");
                }else{
                    NSLog(@"table created");
                }

                //[MyClass updatedevicelastupdatetimewithparameter:@"" centerkey:@"All"];
            }else{
                //load value from local db to globalvariables
                sql =[NSString stringWithFormat:@"SELECT * FROM marketing_application order by centerkey, marketingkey,type"];
                NSMutableArray *tmpArray=[[NSMutableArray alloc]init];
                
                NSString *applicationkey;
                NSString *centerkey;
                NSString *marketingkey=@"";
                NSString *type;
                NSString *typekey;
                     
                
                if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
                    while (sqlite3_step(statement)==SQLITE_ROW) {
                        typekey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 4)];
                        
                        if (([marketingkey isEqualToString:[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)]] && [centerkey isEqualToString:[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)]] && [type isEqualToString:[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)]]) || [marketingkey isEqualToString:@""]) {
                            
                            [tmpArray addObject:typekey];
                        }else{
                            //add tmplevelarray to subjectarray
                            if(tmpArray.count!=1 || ![[tmpArray firstObject] isEqualToString:@"None"]){
                                if([type isEqualToString:@"subject"]){
                                    ((MarketingRecord *)[MyClass returnmarketinginformationwithmarketingkey:marketingkey centerkey:centerkey]).subjectarray=tmpArray;
                                }else{
                                    ((MarketingRecord *)[MyClass returnmarketinginformationwithmarketingkey:marketingkey centerkey:centerkey]).productarray=tmpArray;
                                }
                            }else{
                                if([type isEqualToString:@"subject"]){
                                    ((MarketingRecord *)[MyClass returnmarketinginformationwithmarketingkey:marketingkey centerkey:centerkey]).subjectarray=nil;
                                }else{
                                    ((MarketingRecord *)[MyClass returnmarketinginformationwithmarketingkey:marketingkey centerkey:centerkey]).productarray=nil;
                                }
                            }
                            
                            tmpArray=[[NSMutableArray alloc]init];
                            [tmpArray addObject:typekey];
                        }
                        centerkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 1)];
                        marketingkey=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 2)];
                        type=[MyClass returnSqlColumnTextWithChar:(char *)sqlite3_column_text(statement, 3)];
                    }
                    
                    if(![marketingkey isEqualToString:@""]){
                        if(tmpArray.count!=1 || ![[tmpArray firstObject] isEqualToString:@"None"]){
                            if([type isEqualToString:@"subject"]){
                                ((MarketingRecord *)[MyClass returnmarketinginformationwithmarketingkey:marketingkey centerkey:centerkey]).subjectarray=tmpArray;
                            }else{
                                ((MarketingRecord *)[MyClass returnmarketinginformationwithmarketingkey:marketingkey centerkey:centerkey]).productarray=tmpArray;
                            }
                        }else{
                            if([type isEqualToString:@"subject"]){
                                ((MarketingRecord *)[MyClass returnmarketinginformationwithmarketingkey:marketingkey centerkey:centerkey]).subjectarray=nil;
                            }else{
                                ((MarketingRecord *)[MyClass returnmarketinginformationwithmarketingkey:marketingkey centerkey:centerkey]).productarray=nil;
                            }
                        }
                    }
                }
            }
        }else{
            //table does not exist
            sql =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT);",@"marketing_application", @"applicationkey",@"centerkey",@"marketingkey",@"type",@"typekey"];
            if (sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,&err) !=SQLITE_OK){
                //sqlite3_close(isdb);
                NSAssert(0, @"Could not create table");
            }else{
                NSLog(@"table created");
            }
        }
    }
}



-(void) addEntriesToSettingsIfNotExist{
    
    char *err;
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('renewalremainingclassthreshold','1')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('dailyclassschedulemaxrow','45')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('username','')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('password','')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('centerkey','')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('centername','')",NULL,NULL,&err);
    
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('activeserver','')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('startupserver','')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('lastlogin','')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('lastlogout','')",NULL,NULL,&err);
    if ([[[[NSLocale preferredLanguages] objectAtIndex:0] substringToIndex:2] isEqualToString:@"zh"]) {
        sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('language','Chinese')",NULL,NULL,&err);
    }else{
        sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('language','English')",NULL,NULL,&err);
    }
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('dailyclassscheduleviewmode','class')",NULL,NULL,&err);
    
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('lastoncesystemmessagetime','2016-01-27 10:24:00')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('showgetnewpassword','Yes')",NULL,NULL,&err);
    
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('marketingpromotionlistsortingorder','a#code,a#description,a#startdate,a#enddate,a#promotionfixeddiscount,a#promotionpercentagediscount,a#promotionquota,a#usedcount')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('marketingcouponlistsortingorder','a#code,a#description,a#startdate,a#enddate,a#promotionfixeddiscount,a#promotionpercentagediscount,a#promotionquota,a#usedcount')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('marketingmedialistsortingorder','a#code,a#description,a#startdate,a#enddate')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('marketingsourcelistsortingorder','a#code,a#description,a#startdate,a#enddate')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('subjectlistsortingorder','a#subject_shortname,a#subject_name,a#subject_category,a#enrollmentmode,a#tuition_method,a#tuition_mode,a#studentcapacity,a#status')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('classroomlistsortingorder','a#classroom,a#status')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('stafflistsortingorder','a#firstname,a#lastname,a#role,a#username,a#privilege,a#phone,a#valid')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('productlistsortingorder','a#code,a#product_name,a#category,a#price,a#status')",NULL,NULL,&err);
    
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('classlistsortingorder','a#orderdatetime,a#subjectfullname,a#attendance')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('enrollmentlistsortingorder','d#enrollmentdate,d#startdate,a#enddate,a#classtime,a#subjectfullname,a#instructorfullname,a#classroom,a#classday')",NULL,NULL,&err);
    
    if ([MyClass isParameterExistsinSettingswithparametername:@"saleslistsortingorder" parametervalue:@"productdatetime"]) {
        sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='saleslistsortingorder'",NULL,NULL,&err);
    }
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('saleslistsortingorder','a#orderdate,a#productfullname,a#productcode,a#productcategory')",NULL,NULL,&err);
    
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('couponlistsortingorder','d#couponkey,a#coupon,a#coupon_type,a#issuedate,a#effectivefrom,a#effectiveto,a#dateused')",NULL,NULL,&err);
    
    if (![MyClass isParameterExistsinSettingswithparametername:@"messagelistsortingorder" parametervalue:@"messagetype"]) {
        sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='messagelistsortingorder'",NULL,NULL,&err);
    }
    
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('messagelistsortingorder','d#messagestarttime,a#sender,a#message,a#messagetype')",NULL,NULL,&err);
    
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('callloglistsortingorder','a#calledon,a#calledbyfullname,a#details')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('dtlistsortingorder','a#DTdate,a#DTtime,a#subjectfullname,a#instructorfullname,a#classroom,a#classtype')",NULL,NULL,&err);
    
    
    if (![MyClass isParameterExistsinSettingswithparametername:@"dailyclassschedulelistsortingorder" parametervalue:@"realclasstime"]) {
        sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='dailyclassschedulelistsortingorder'",NULL,NULL,&err);
    }
    
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('dailyclassschedulelistsortingorder','a#realclasstime,a#instructorfullname,a#subjectfullname,a#realclassroom,a#studentdisplayname')",NULL,NULL,&err);
    
    if (![MyClass isParameterExistsinSettingswithparametername:@"financialclasslistsortingorder" parametervalue:@"studentfullname"]) {
        sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='financialclasslistsortingorder'",NULL,NULL,&err);
    }
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('financialclasslistsortingorder','a#studentfullname,a#subjectfullname,a#enrollmentdate,a#startdate,a#enddate,a#totalfee')",NULL,NULL,&err);
    
    if (![MyClass isParameterExistsinSettingswithparametername:@"financialsaleslistsortingorder" parametervalue:@"studentfullname"]) {
        sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='financialsaleslistsortingorder'",NULL,NULL,&err);
    }
    
    
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('financialsaleslistsortingorder','a#studentfullname,a#productfullname,a#orderdate,a#totalfee')",NULL,NULL,&err);
    
    
    
    //sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('scannerpoweroffcode','')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('messageviewlistsortingorder','d#messagestarttime,a#recipienttype,a#messagetype,d#messagecreatetime')",NULL,NULL,&err);
    /*if (![MyClass isParameterExistsinSettingswithparametername:@"studentnamedisplayorder" parametervalue:@"studentid"]) {
        sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='studentnamedisplayorder'",NULL,NULL,&err);
    }
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('studentnamedisplayorder','e#firstname,e#lastname,e#othername,d#studentid')",NULL,NULL,&err);
    
    if (![MyClass isParameterExistsinSettingswithparametername:@"leadnamedisplayorder" parametervalue:@"leadid"]) {
        sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='leadnamedisplayorder'",NULL,NULL,&err);
    }
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('leadnamedisplayorder','e#firstname,e#lastname,e#othername,d#leadid')",NULL,NULL,&err);*/
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('dtviewlistsortingorder','d#DTdate,a#DTtime,a#studentfullname,a#instructorfullname,a#subjectfullname')",NULL,NULL,&err);
    /*sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('classtimetabledaystodisplay','Sun,Mon,Tue,Wed,Thu,Fri,Sat')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('showvalidityininvoicereceipt','Yes')",NULL,NULL,&err);*/
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('sound','Yes')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('classtimetableheadertype','All')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('classtimetablecontentmode','Subject')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('classtimetableviewmode','Weekly')",NULL,NULL,&err);
    //sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('classtimetableshowlevel','No')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('classtimetablecombine3rddimension','No')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('recalculatetuitionfeeupongradepromotion','No')",NULL,NULL,&err);
    /*sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('showlevelinreceipt','Yes')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('showlevelininvoice','Yes')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('showstaffnameinreceipt','Yes')",NULL,NULL,&err);*/
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('defaultprintcolor','1')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('defaultprintcolor_invoice','1')",NULL,NULL,&err);
    /*sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('receiptfontsize','0')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('invoicefontsize','0')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('defaultstudentmessagechannel','1')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('defaultleadmessagechannel','0')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('defaultreceiptremarksasinvoiceremarksforcourseenrollment','No')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('defaultreceiptremarksasinvoiceremarksforproductsales','No')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('defaultarckey','')",NULL,NULL,&err);*/
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('globallastupdate','')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('showsystemmessage','Y')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('chartperiod','Week')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('lastwhatsnewbuild','')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('groupsubjectcategory','No')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('hideemptycolumns','Yes')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('timetablefiltervalues','')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('timetableshowallstudentcount','N')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('timetableshowattendingcount','Y')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('timetableshowoutstandingpaymentstudentcount','N')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('timetableshowlessonnumber','N')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('dailyscheduleshowsubjectcolor','Yes')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('dailyscheduleshowinstructorcolor','Yes')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('showageintimetable','N')",NULL,NULL,&err);
    sqlite3_exec(globalvariables.isdb,"INSERT OR IGNORE INTO settings ('parametername','parametervalue') VALUES ('timetableoutstandingmode','perstudent')",NULL,NULL,&err);
    
}

-(void) uploadSettings
{
    char *err;
    if ([MyClass isParameterExistsinSettingswithparametername:@"showlastclass" parametervalue:@""]) {
        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
        [dictionary setValue:@"uploadsettings" forKey:@"postaction"];
        [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
        [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dictionary setValue:globalvariables.username forKey:@"lastupdatedby"];
        
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"showlastclass"] forKey:@"showlastclass"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"showfirstclass"] forKey:@"showfirstclass"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"showoutstanding"] forKey:@"showoutstandingclass"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"showpendingrenewal"] forKey:@"showpendingrenewalclass"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"showassessclass"] forKey:@"showassessclass"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"showtrialclass"] forKey:@"showtrialclass"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"showmakeupclass"] forKey:@"showmakeupclass"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"showabsentclass"] forKey:@"showabsentclass"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"showcontactindailyscheduleprintout"] forKey:@"showcontactindailyscheduleprintout"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"showduepaymentindailyscheduleprintout"] forKey:@"showduepaymentindailyscheduleprintout"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"a4trayfora5printing_receipt"] forKey:@"a4trayfora5printing_receipt"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"a4trayfora5printing_invoice"] forKey:@"a4trayfora5printing_invoice"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"tncfontsize_receipt"] forKey:@"tncfontsize_receipt"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"tncfontsize_invoice"] forKey:@"tncfontsize_invoice"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"scannerpoweroffcode"] forKey:@"scannerpoweroffcode"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"studentnamedisplayorder"] forKey:@"studentnamedisplayorder"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"leadnamedisplayorder"] forKey:@"leadnamedisplayorder"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"classtimetabledaystodisplay"] forKey:@"classtimetabledaystodisplay"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"showvalidityininvoicereceipt"] forKey:@"showvalidityininvoicereceipt"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"classtimetableshowlevel"] forKey:@"showtimetablelevel"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"showlevelinreceipt"] forKey:@"showlevelinreceipt"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"showlevelininvoice"] forKey:@"showlevelininvoice"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"showstaffnameinreceipt"] forKey:@"showstaffnameinreceipt"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"receiptfontsize"] forKey:@"receiptfontsize"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"invoicefontsize"] forKey:@"invoicefontsize"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"defaultstudentmessagechannel"] forKey:@"defaultstudentmessagechannel"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"defaultleadmessagechannel"] forKey:@"defaultleadmessagechannel"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"defaultreceiptremarksasinvoiceremarksforcourseenrollment"] forKey:@"defaultreceiptremarksasinvoiceremarksforcourseenrollment"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"defaultreceiptremarksasinvoiceremarksforproductsales"] forKey:@"defaultreceiptremarksasinvoiceremarksforproductsales"];
        [dictionary setValue:[MyClass getlocaldbwithparameter:@"defaultarckey"] forKey:@"defaultarckey"];
        
        __block BOOL result=FALSE;
        [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                result =TRUE;
            }
        }];
        
        if (result) {
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showlastclass'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showfirstclass'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showoutstanding'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showpendingrenewal'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showassessclass'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showtrialclass'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showmakeupclass'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showabsentclass'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showmytask'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showtasktoother'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showallothertask'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showcontactindailyscheduleprintout'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showduepaymentindailyscheduleprintout'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='a4trayfora5printing'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='a4trayfora5printing_invoice'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='tncfontsize'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='tncfontsize_invoice'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='scannerpoweroffcode'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='studentnamedisplayorder'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='leadnamedisplayorder'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='classtimetabledaystodisplay'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showvalidityininvoicereceipt'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='classtimetableshowlevel'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showlevelinreceipt'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showlevelininvoice'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='showstaffnameinreceipt'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='receiptfontsize'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='invoicefontsize'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='defaultstudentmessagechannel'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='defaultleadmessagechannel'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='defaultreceiptremarksasinvoiceremarksforcourseenrollment'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='defaultreceiptremarksasinvoiceremarksforproductsales'",NULL,NULL,&err);
            sqlite3_exec(globalvariables.isdb,"delete from settings where parametername='defaultarckey'",NULL,NULL,&err);
        }
    }
}


- (BOOL)shouldAutorotate {
    return  YES;
}



-(BOOL) CheckDatabaseAvailability
{
    int retrycount=3;
    
    __block BOOL result=FALSE;
    __block NSDictionary *jsondictionary=[[NSDictionary alloc]init];

    jsonarray_globalsettings=[[NSMutableArray alloc]init];
    jsonarray_userauthentication=[[NSMutableArray alloc]init];
    jsonarray_countrycode=[[NSDictionary alloc]init];
    centerrecorddictionary=[[NSDictionary alloc]init];

    
    NSMutableURLRequest *postRequest;
    
    globalvariables.deviceidentifier = [[[UIDevice currentDevice] identifierForVendor].UUIDString stringByReplacingOccurrencesOfString:@"-"withString:@""];
    if (!globalvariables.deviceToken) {
        globalvariables.deviceToken=@"";
    }
    
    NSDictionary *dictionary=[[NSDictionary alloc]init];

    dictionary = @{@"postaction" : @"userauthenticationandauthorizationv3",
                                 @"appname" : @"icenter",
                                 @"osplatform" : @"ios",
                                 @"username" : [MyClass removeDevFromUsername:tmpusername],
                                 @"password" : tmppassword,
                                 @"appid" : [[NSBundle mainBundle] bundleIdentifier],
                                 @"language" : globalvariables.language,
                                 @"lastupdatetime" : [MyClass getlocaldbwithparameter:@"globallastupdate"],
                                 @"appversion" : [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
                   };
    
    
    NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    if ([globalvariables.activeserver isEqualToString:@"primary"] || [globalvariables.activeserver isEqualToString:@""]) {
        //first check if production server is up
        
        for (int i=0; i<retrycount && !result; i++) {
            postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalvariables.primaryserverpath,globalvariables.generalphpfilename]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
            [postRequest setHTTPMethod:@"POST"];
            [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
            [postRequest setHTTPBody:finalData];
            
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (!error) {
                    NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                    jsondictionary = jsonreturned[@"content"];
                    
                    if (jsondictionary) {
                        jsonarray_globalsettings = jsondictionary[@"globalsettings"];
                        jsonarray_userauthentication=jsondictionary[@"userauthentication"];
                        centerrecorddictionary=jsondictionary[@"centerrecord"];
                        jsonarray_countrycode=jsondictionary[@"countrycoderecord"];
                        jsonarray_languagepack=jsondictionary[@"languagepackrecord"];
                        
                        globalvariables.generalphpfullpath=[NSString stringWithFormat:@"%@%@",globalvariables.primaryserverpath,globalvariables.generalphpfilename];
                        globalvariables.serverpath=globalvariables.primaryserverpath;
                        globalvariables.activeserver=@"primary";
                        
                        [MyClass updatelocaldbwithparameter:@"activeserver" value:@"primary"];
                        result= TRUE;
                    }


                }
                dispatch_semaphore_signal(semaphore);
            }] resume];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
        }
        
        // try secondary
        if (!result) {
            for (int i=0; i<retrycount && !result; i++) {
                postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalvariables.secondaryserverpath,globalvariables.generalphpfilename]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
                [postRequest setHTTPMethod:@"POST"];
                [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
                [postRequest setHTTPBody:finalData];
                
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    if (!error) {
                        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                        jsondictionary = jsonreturned[@"content"];
                        
                        if (jsondictionary) {
                            jsonarray_globalsettings = jsondictionary[@"globalsettings"];
                            jsonarray_userauthentication=jsondictionary[@"userauthentication"];
                            centerrecorddictionary=jsondictionary[@"centerrecord"];
                            jsonarray_countrycode=jsondictionary[@"countrycoderecord"];
                            jsonarray_languagepack=jsondictionary[@"languagepackrecord"];
                            globalvariables.generalphpfullpath=[NSString stringWithFormat:@"%@%@",globalvariables.secondaryserverpath,globalvariables.generalphpfilename];
                            globalvariables.serverpath=globalvariables.secondaryserverpath;
                            globalvariables.activeserver=@"secondary";
                            
                            [MyClass updatelocaldbwithparameter:@"activeserver" value:@"secondary"];
                            result= TRUE;
                        }

                    }
                    dispatch_semaphore_signal(semaphore);
                }] resume];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }
        }
        
        return result;
        
    }else{
        
        for (int i=0; i<retrycount && !result; i++) {
            postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalvariables.secondaryserverpath,globalvariables.generalphpfilename]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
            [postRequest setHTTPMethod:@"POST"];
            [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
            [postRequest setHTTPBody:finalData];
            
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (!error) {
                    NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                    jsondictionary = jsonreturned[@"content"];
                    
                    if (jsondictionary) {
                        jsonarray_globalsettings = jsondictionary[@"globalsettings"];
                        jsonarray_userauthentication=jsondictionary[@"userauthentication"];
                        centerrecorddictionary=jsondictionary[@"centerrecord"];
                        jsonarray_countrycode=jsondictionary[@"countrycoderecord"];
                        jsonarray_languagepack=jsondictionary[@"languagepackrecord"];
                        globalvariables.generalphpfullpath=[NSString stringWithFormat:@"%@%@",globalvariables.secondaryserverpath,globalvariables.generalphpfilename];
                        globalvariables.serverpath=globalvariables.secondaryserverpath;
                        globalvariables.activeserver=@"secondary";
                        
                        [MyClass updatelocaldbwithparameter:@"activeserver" value:@"secondary"];
                        
                        result= TRUE;
                    }

                }
                dispatch_semaphore_signal(semaphore);
            }] resume];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        // try primary
        if (!result) {
            
            for (int i=0; i<retrycount && !result; i++) {
                postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalvariables.primaryserverpath,globalvariables.generalphpfilename]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
                [postRequest setHTTPMethod:@"POST"];
                [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
                [postRequest setHTTPBody:finalData];
                
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    if (!error) {
                        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                        jsondictionary = jsonreturned[@"content"];
                        
                        if (jsondictionary) {
                            jsonarray_globalsettings = jsondictionary[@"globalsettings"];
                            jsonarray_userauthentication=jsondictionary[@"userauthentication"];
                            centerrecorddictionary=jsondictionary[@"centerrecord"];
                            jsonarray_countrycode=jsondictionary[@"countrycoderecord"];
                            jsonarray_languagepack=jsondictionary[@"languagepackrecord"];
                            globalvariables.generalphpfullpath=[NSString stringWithFormat:@"%@%@",globalvariables.primaryserverpath,globalvariables.generalphpfilename];
                            globalvariables.serverpath=globalvariables.primaryserverpath;
                            globalvariables.activeserver=@"primary";
                            
                            [MyClass updatelocaldbwithparameter:@"activeserver" value:@"primary"];
                            
                            result= TRUE;
                        }

                    }
                    dispatch_semaphore_signal(semaphore);
                }] resume];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }
        }
        return result;
    }
}


- (void) retrievelastconnectedserver
{
    NSString *startupserver;
    startupserver=[MyClass getlocaldbwithparameter:@"startupserver"];
    
    if ([startupserver isEqualToString:@"primary"]) {
        globalvariables.activeserver=@"primary";
    }else if ([startupserver isEqualToString:@"secondary"]){
        globalvariables.activeserver=@"secondary";
    }else{
        globalvariables.activeserver=[MyClass getlocaldbwithparameter:@"activeserver"];
    }
}

- (void)loginbuttonpressed:(id)sender {
    
    [self.view endEditing:YES];

    loadinglabel.text=[MyClass returnlogintitlewithtitle:@"Loading Information"];
    usernametext.text=[MyClass allspacestrimmed:usernametext.text];
    if ([usernametext.text isEqualToString:@""] || [passwordtext.text isEqualToString:@""]) {
        loginmessage.text=[MyClass returnlogintitlewithtitle:@"Username or password was not entered"];
        //usernametext.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:188.0/255.0 blue:227.0/255.0 alpha:1.0];
    }else{
        //[self adjustwindowsposition];
        ///loginview.hidden=YES;
        //newnew
        
        tmpusername=usernametext.text;
        tmppassword=passwordtext.text;
        
        
        [self enableloginbutton:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loginapp];
        });
    }
}


- (IBAction)languagebuttonpressed:(UIButton *)sender {
    if(sender.tag==0){
        globalvariables.language=@"English";
        [englishlanguagebutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [chineselanguagebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [schineselanguagebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if(sender.tag==1){
        globalvariables.language=@"Chinese";
        [englishlanguagebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [chineselanguagebutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [schineselanguagebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        globalvariables.language=@"SChinese";
        [englishlanguagebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [chineselanguagebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [schineselanguagebutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    [MyClass updatelocaldbwithparameter:@"language" value:globalvariables.language];
    loginmessage.text=[MyClass returnlogintitlewithtitle:@"Please enter your username and password"];
    usernametext.placeholder=[MyClass returnlogintitlewithtitle:@"Username"];
    passwordtext.placeholder=[MyClass returnlogintitlewithtitle:@"Password"];
    
    ///loginmessage.textColor=[UIColor darkGrayColor];
    
    [loginbutton setTitle:[MyClass returnlogintitlewithtitle:@"Login"] forState:UIControlStateNormal];
    [trialbutton setTitle:[MyClass returnlogintitlewithtitle:@"Apply Trial Account"] forState:UIControlStateNormal];
    
    
    [resetpassword setTitle:[MyClass returnlogintitlewithtitle:@"Get One Time Password"] forState:UIControlStateNormal];
    [applyTrialAccountButton setTitle:[MyClass returnlogintitlewithtitle:@"Apply Trial Account"] forState:UIControlStateNormal];
    /*if ([showgetnewpassword isEqualToString:@"Yes"]) {
        [resetpassword setTitle:[MyClass returnlogintitlewithtitle:@"Get New Password"] forState:UIControlStateNormal];
    }else{
        [resetpassword setTitle:[MyClass returnlogintitlewithtitle:@"Reset Password"] forState:UIControlStateNormal];
    }*/
    
}



-(void) retrievelocalinformation
{

    tmpusername=[MyClass getlocaldbwithparameter:@"username"];
    globalvariables.username=[[MyClass removeDevFromUsername:tmpusername] lowercaseString];
    globalvariables.rawusername=tmpusername;
    tmppassword=[MyClass getlocaldbwithparameter:@"password"];
    globalvariables.password=tmppassword;
    globalvariables.language=[MyClass getlocaldbwithparameter:@"language"];
    globalvariables.lastlogin=[MyClass getlocaldbwithparameter:@"lastlogin"];
    globalvariables.lastlogout=[MyClass getlocaldbwithparameter:@"lastlogout"];
    devicelastoncesystemmessagetime=[MyClass getlocaldbwithparameter:@"lastoncesystemmessagetime"];
    showgetnewpassword=[MyClass getlocaldbwithparameter:@"showgetnewpassword"];
}

-(void) retrievecenterkey
{
    globalvariables.centerrecord.centerkey=[MyClass getlocaldbwithparameter:@"centerkey"];
    globalvariables.centerrecord.centername=[MyClass getlocaldbwithparameter:@"centername"];
    
}

-(void) updateusernamepasswordtosqlitewithusername:(NSString *)username password:(NSString *)password
{

    [MyClass updatelocaldbwithparameter:@"username" value:username];
    globalvariables.rawusername=tmpusername;
    globalvariables.username=[[MyClass removeDevFromUsername:username] lowercaseString];
    globalvariables.password=password;
    
}



-(void) adjustwindowsposition
{
    
    /*

    [UIView beginAnimations:nil context:nil];
    if (keyboardheight>0) {
        if (!loginview.hidden && loginview) {
            loginview.frame=CGRectMake(loginview.frame.origin.x, self.view.frame.size.height-keyboardheight-loginview.frame.size.height, loginview.frame.size.width, loginview.frame.size.height);
        }else if (passwordresetview && !passwordresetview.hidden) {
            passwordresetview.frame=CGRectMake(passwordresetview.frame.origin.x, self.view.frame.size.height-keyboardheight-passwordresetview.frame.size.height, passwordresetview.frame.size.width, passwordresetview.frame.size.height);
        }
    }else{
        if (!loginview.hidden && loginview) {
            loginview.frame=CGRectMake(loginview.frame.origin.x, (self.view.frame.size.height-loginview.frame.size.height)/2, loginview.frame.size.width, loginview.frame.size.height);
        }else if (passwordresetview && !passwordresetview.hidden) {
            passwordresetview.frame=CGRectMake(passwordresetview.frame.origin.x, (self.view.frame.size.height-passwordresetview.frame.size.height)/2, passwordresetview.frame.size.width, passwordresetview.frame.size.height);
        }
    }
    [UIView commitAnimations];*/

    
}

- (void)donebuttonpressed:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([newpasswordtext.text isEqualToString:@""]) {
        resetpasswordmessage.text=[MyClass returnlogintitlewithtitle:@"Please enter passwords"];
        resetpasswordmessage.textColor=[UIColor redColor];
    }else if ([newpasswordtext.text isEqualToString:confirmpasswordtext.text]) {
        tmppassword=newpasswordtext.text;
        //newnew
        //globalvariables.password=newpasswordtext.text;
        tmppassword=newpasswordtext.text;
        globalvariables.username=[MyClass removeDevFromUsername:tmpusername];
//        NSString *strURL=[NSString stringWithFormat:@"%@?action=updatepassword&username=%@&newpassword=%@",globalvariables.generalphpfullpath,[MyClass removeDevFromUsername:tmpusername], tmppassword];
//        
//        __block BOOL result=FALSE;
//        [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
//            if (succeeded) {
//                result=TRUE;
//            }
//        }];
        
        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
        [dictionary setValue:@"updatepassword" forKey:@"postaction"];
//        [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
        [dictionary setValue:globalvariables.username forKey:@"username"];
        [dictionary setValue:tmppassword forKey:@"newpassword"];
        
        __block BOOL result=FALSE;
        [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                result=TRUE;
            }
        }];
        
        /*
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
            }
            dispatch_semaphore_signal(semaphore);
        }] resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
        
        if(result){
            globalvariables.password=tmppassword;
            passwordresetview.hidden=YES;
            UIAlertController *successalert = [UIAlertController alertControllerWithTitle:[MyClass returnlogintitlewithtitle:@"Change Password"] message:[MyClass returnlogintitlewithtitle:@"Password successfully changed"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                loginview.hidden=YES;
                [self showLoadingIndicator:YES initialscreen:NO];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loginapp];
                });
                
            }];
            
            [successalert addAction:OKAction];
            [self presentViewController:successalert animated:YES completion:nil];
        }

        
        
    }else{
        resetpasswordmessage.text=[MyClass returnlogintitlewithtitle:@"Passwords do not match"];
        resetpasswordmessage.textColor=[UIColor redColor];
        
    }
    
}

-(BOOL) retrievecenterlist
{
    NSString *sql=@"";
    char *err;

//    NSMutableArray *lastupdatecenterkeyarray=[[NSMutableArray alloc]init];
//    for (int i=0; i<globalvariables.lastupdatearray.count; i++) {
//        [lastupdatecenterkeyarray addObject:((LastUpdateRecord *)[globalvariables.lastupdatearray objectAtIndex:i]).centerkey];
//    }
    
    globalvariables.CenterDict=[[NSMutableDictionary alloc]init];

    
    jsonArray=centerrecorddictionary[@"centerrecords"];
    NSString *centerlistlastupdatetime=centerrecorddictionary[@"lastupdatetime"];
    
    if (jsonArray) {
        for (int i=0; i<jsonArray.count; i++) {
            
            NSString * ccenterkey=[[jsonArray objectAtIndex:i] objectForKey:@"centerkey"];
            NSString * centitykey=[[jsonArray objectAtIndex:i] objectForKey:@"entitykey"];
            NSString * ccentername=[[jsonArray objectAtIndex:i] objectForKey:@"centername"];
            NSString * ccentershortname_english=[[jsonArray objectAtIndex:i] objectForKey:@"centershortname_english"];
            NSString * ccentershortname_chinese=[[jsonArray objectAtIndex:i] objectForKey:@"centershortname_chinese"];
            NSString * cclassstarttime=[[jsonArray objectAtIndex:i] objectForKey:@"classstarttime"];
            NSString * cclassendtime=[[jsonArray objectAtIndex:i] objectForKey:@"classendtime"];
            NSString * cclasstimeinterval=[[jsonArray objectAtIndex:i] objectForKey:@"classtimeinterval"];
            NSString * ccenteraddress=[[jsonArray objectAtIndex:i] objectForKey:@"centeraddress"];
            NSString * ccenteraddress_chinese=[[jsonArray objectAtIndex:i] objectForKey:@"centeraddress_chinese"];
            NSString * ccentercontact=[[jsonArray objectAtIndex:i] objectForKey:@"centercontact"];
            NSString * ccenterfax=[[jsonArray objectAtIndex:i] objectForKey:@"centerfax"];
            NSString * ccenterwhatsapp=[[jsonArray objectAtIndex:i] objectForKey:@"centerwhatsapp"];
            NSString * ccenteremail=[[jsonArray objectAtIndex:i] objectForKey:@"centeremail"];
            NSString * ccenterwebsite=[[jsonArray objectAtIndex:i] objectForKey:@"centerwebsite"];
            NSString * ccenterothers=[[jsonArray objectAtIndex:i] objectForKey:@"centerothers"];
            NSString * ccenterdb=[[jsonArray objectAtIndex:i] objectForKey:@"centerdb"];
            NSString * ccenterhour_line1left=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line1left"];
            NSString * ccenterhour_line1right=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line1right"];
            NSString * ccenterhour_line2left=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line2left"];
            NSString * ccenterhour_line2right=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line2right"];
            NSString * ccenterhour_line3left=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line3left"];
            NSString * ccenterhour_line3right=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line3right"];
            NSString * ccenterhour_line4left=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line4left"];
            NSString * ccenterhour_line4right=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line4right"];
            NSString * ccenterhour_line5left=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line5left"];
            NSString * ccenterhour_line5right=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line5right"];
            NSString * claunchimage_landscape=[[jsonArray objectAtIndex:i] objectForKey:@"launchimage_landscape"];
            NSString * claunchimage_portrait=[[jsonArray objectAtIndex:i] objectForKey:@"launchimage_portrait_5"];
            NSString * ccenterhour_line1left_chinese=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line1left_chinese"];
            NSString * ccenterhour_line1right_chinese=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line1right_chinese"];
            NSString * ccenterhour_line2left_chinese=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line2left_chinese"];
            NSString * ccenterhour_line2right_chinese=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line2right_chinese"];
            NSString * ccenterhour_line3left_chinese=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line3left_chinese"];
            NSString * ccenterhour_line3right_chinese=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line3right_chinese"];
            NSString * ccenterhour_line4left_chinese=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line4left_chinese"];
            NSString * ccenterhour_line4right_chinese=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line4right_chinese"];
            NSString * ccenterhour_line5left_chinese=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line5left_chinese"];
            NSString * ccenterhour_line5right_chinese=[[jsonArray objectAtIndex:i] objectForKey:@"centerhour_line5right_chinese"];
            NSString * cshopfrontimage=[[jsonArray objectAtIndex:i] objectForKey:@"shopfrontimage"];
            NSString * cmapimage=[[jsonArray objectAtIndex:i] objectForKey:@"mapimage"];
            NSString * cprintlogoimage=[[jsonArray objectAtIndex:i] objectForKey:@"printlogoimage"];
            NSString * cchequepayable=[[jsonArray objectAtIndex:i] objectForKey:@"chequepayable"];
            NSString * cenrollmentfee=[[jsonArray objectAtIndex:i] objectForKey:@"enrollmentfee"];
            NSString * clatefee_enable=[[jsonArray objectAtIndex:i] objectForKey:@"latefee_enable"];
            NSString * creceipttnc=[[jsonArray objectAtIndex:i] objectForKey:@"centerreceipttnc"];
            NSString * cinvoicetnc=[[jsonArray objectAtIndex:i] objectForKey:@"centerinvoicetnc"];
            NSString * cdefaulteditablepaymentamount=[[jsonArray objectAtIndex:i] objectForKey:@"defaulteditablepaymentamount"];
            NSString * cdefaultattendancestatus=[[jsonArray objectAtIndex:i] objectForKey:@"defaultattendancestatus"];
            NSString * claunchmessagemode=@"";
            BOOL cenableattendanceextend=[[[jsonArray objectAtIndex:i] objectForKey:@"enableattendanceextend"] isEqualToString:@"Yes"]?YES:NO;
            BOOL crenewmonthlyroundup=[[[jsonArray objectAtIndex:i] objectForKey:@"renewmonthlyroundup"] isEqualToString:@"Yes"]?YES:NO;
            BOOL cenableautobatchrenew=[[[jsonArray objectAtIndex:i] objectForKey:@"enableautobatchrenew"] isEqualToString:@"Yes"]?YES:NO;
            NSString * cautobatchrenewdaystoinclude=[[jsonArray objectAtIndex:i] objectForKey:@"autobatchrenewdaystoinclude"];
            NSString * cautorenewal_date_for_monthlycourse=[[jsonArray objectAtIndex:i] objectForKey:@"autorenewal_date_for_monthlycourse"];
            NSString * cdefaultstudentgrade=[[jsonArray objectAtIndex:i] objectForKey:@"defaultstudentgrade"];
            int cmonthlymodeweeklyscheduletuitiondenominator=[[[jsonArray objectAtIndex:i] objectForKey:@"monthlymodeweeklyscheduletuitiondenominator"] intValue];
            int cnoofroundoffdigit=[[[jsonArray objectAtIndex:i] objectForKey:@"noofroundoffdigit"] intValue];
            BOOL cenablestaffsalaryrate=YES;//[[[jsonArray objectAtIndex:i] objectForKey:@"enablestaffsalaryrate"] isEqualToString:@"Yes"]?YES:NO;
            BOOL cenablescantotakeattendance=[[[jsonArray objectAtIndex:i] objectForKey:@"enablescantotakeattendance"] isEqualToString:@"Yes"]?YES:NO;
            int cscantottakeattendancebeforethreshold=[[[jsonArray objectAtIndex:i] objectForKey:@"scantottakeattendancebeforethreshold"] intValue];
            int cscantottakeattendanceafterthreshold=[[[jsonArray objectAtIndex:i] objectForKey:@"scantottakeattendanceafterthreshold"] intValue];
            NSString * cscantype=[[jsonArray objectAtIndex:i] objectForKey:@"scantype"];
            BOOL cautofillstudentid=[[[jsonArray objectAtIndex:i] objectForKey:@"autofillstudentid"] isEqualToString:@"Yes"]?YES:NO;
            BOOL cenableistafftakingattendance=[[[jsonArray objectAtIndex:i] objectForKey:@"enableistafftakingattendance"] isEqualToString:@"Yes"]?YES:NO;
            NSString * clatefee=[[jsonArray objectAtIndex:i] objectForKey:@"latefee"];
            NSString * clatefeegraceperiod=[[jsonArray objectAtIndex:i] objectForKey:@"latefeegraceperiod"];
            BOOL ciparentusercanupdatepersonalinformation=[[[jsonArray objectAtIndex:i] objectForKey:@"iparentusercanupdatepersonalinformation"] isEqualToString:@"Yes"]?YES:NO;
            BOOL creservedcalendardate=[[[jsonArray objectAtIndex:i] objectForKey:@"reservedcalendardate"] isEqualToString:@"Yes"]?YES:NO;
            BOOL cautofillleadid=[[[jsonArray objectAtIndex:i] objectForKey:@"autofillleadid"] isEqualToString:@"Yes"]?YES:NO;
            BOOL cparentappdefault=[[[jsonArray objectAtIndex:i] objectForKey:@"parentappdefault"] isEqualToString:@"Yes"]?YES:NO;
            BOOL cstudentpromotiondefault=[[[jsonArray objectAtIndex:i] objectForKey:@"studentpromotiondefault"] isEqualToString:@"Yes"]?YES:NO;
            BOOL cleadpromotiondefault=[[[jsonArray objectAtIndex:i] objectForKey:@"leadpromotiondefault"] isEqualToString:@"Yes"]?YES:NO;
            BOOL cstudentassessmentform=[[[jsonArray objectAtIndex:i] objectForKey:@"studentassessmentform"] isEqualToString:@"Yes"]?YES:NO;
            BOOL cenrollmentvalidity=[[[jsonArray objectAtIndex:i] objectForKey:@"enrollmentvalidity"] isEqualToString:@"Yes"]?YES:NO;
            BOOL ciparentshowenrollmenttuitionfee=[[[jsonArray objectAtIndex:i] objectForKey:@"iparentshowenrollmenttuitionfee"] isEqualToString:@"Yes"]?YES:NO;
            BOOL cenrollmultiplesubjectsatsametimeslot=[[[jsonArray objectAtIndex:i] objectForKey:@"enrollmultiplesubjectsatsametimeslot"] isEqualToString:@"Yes"]?YES:NO;
            BOOL cenablemakeup=[[[jsonArray objectAtIndex:i] objectForKey:@"enablemakeup"] isEqualToString:@"Yes"]?YES:NO;
            BOOL ceditmonthlycourseclassdate=[[[jsonArray objectAtIndex:i] objectForKey:@"editmonthlycourseclassdate"] isEqualToString:@"Yes"]?YES:NO;
            BOOL ciparentclassalert=[[[jsonArray objectAtIndex:i] objectForKey:@"iparentclassalert"] isEqualToString:@"Yes"]?YES:NO;
            NSString *ciparentleavemode=[[jsonArray objectAtIndex:i] objectForKey:@"iparentleavemode"];
            BOOL cenablemakeupquota=[[[jsonArray objectAtIndex:i] objectForKey:@"enablemakeupquota"] isEqualToString:@"Yes"];
            NSInteger cmindaytoapplyleave=[[[jsonArray objectAtIndex:i] objectForKey:@"mindaytoapplyleave"] integerValue];
            NSInteger cmaxdayformakeup=[[[jsonArray objectAtIndex:i] objectForKey:@"maxdayformakeup"] integerValue];
            NSString *cnoofdayafteroriginalclassformakeup=[[jsonArray objectAtIndex:i] objectForKey:@"noofdayafteroriginalclassformakeup"];
            NSInteger cnoofpastdayincludediniparentclassschedule=[[[jsonArray objectAtIndex:i] objectForKey:@"noofpastdayincludediniparentclassschedule"] integerValue];
            BOOL csmsdefault=[[[jsonArray objectAtIndex:i] objectForKey:@"smsdefault"] isEqualToString:@"Yes"];
            BOOL ciparentshowclassroom=[[[jsonArray objectAtIndex:i] objectForKey:@"iparentshowclassroom"] isEqualToString:@"Yes"];
            NSString * cstandaloneparentappid=[[jsonArray objectAtIndex:i] objectForKey:@"standaloneparentappid"];
            NSString * cstandalonestaffappid=[[jsonArray objectAtIndex:i] objectForKey:@"standalonestaffappid"];
            BOOL cautosendereceipt=[[[jsonArray objectAtIndex:i] objectForKey:@"autosendereceipt"] isEqualToString:@"Yes"];
            BOOL cautosendeinvoice=[[[jsonArray objectAtIndex:i] objectForKey:@"autosendeinvoice"] isEqualToString:@"Yes"];
            BOOL cenableaccountreceivablecodes=[[[jsonArray objectAtIndex:i] objectForKey:@"enableaccountreceivablecodes"] isEqualToString:@"Yes"];
            BOOL ciparentshowclassschedule=[[[jsonArray objectAtIndex:i] objectForKey:@"iparentshowclassschedule"] isEqualToString:@"Yes"];
            BOOL ciparentshowmessages=[[[jsonArray objectAtIndex:i] objectForKey:@"iparentshowmessages"] isEqualToString:@"Yes"];
            BOOL ciparentshowphotocorner=[[[jsonArray objectAtIndex:i] objectForKey:@"iparentshowphotocorner"] isEqualToString:@"Yes"];
            BOOL ciparentshowenrollmentrecords=[[[jsonArray objectAtIndex:i] objectForKey:@"iparentshowenrollmentrecords"] isEqualToString:@"Yes"];
            BOOL ciparentshowsalesrecords=[[[jsonArray objectAtIndex:i] objectForKey:@"iparentshowsalesrecords"] isEqualToString:@"Yes"];
            NSString * cduepayment=[[jsonArray objectAtIndex:i] objectForKey:@"duepayment"];
            BOOL cshowdiscountdetailsinreceipt=[[[jsonArray objectAtIndex:i] objectForKey:@"showdiscountdetailsinreceipt"] isEqualToString:@"Yes"];
            BOOL cshowdiscountdetailsininvoice=[[[jsonArray objectAtIndex:i] objectForKey:@"showdiscountdetailsininvoice"] isEqualToString:@"Yes"];
            NSString * cleaveapprovalmode=[[jsonArray objectAtIndex:i] objectForKey:@"leaveapprovalmode"];
            NSInteger cfirstreminderbeforeexpiry=[[[jsonArray objectAtIndex:i] objectForKey:@"firstreminderbeforeexpiry"] integerValue];
            BOOL cexpiringclassreminder=[[[jsonArray objectAtIndex:i] objectForKey:@"expiringclassreminder"] isEqualToString:@"Yes"];
            NSInteger cexpiringclassreminderrecursiveday=[[[jsonArray objectAtIndex:i] objectForKey:@"expiringclassreminderrecursiveday"] integerValue];
            
            BOOL cenableparentsendmessage=[[[jsonArray objectAtIndex:i] objectForKey:@"enableparentsendmessage"] isEqualToString:@"Yes"];
            if ([ccentershortname_english isEqualToString:@""]) {
                ccentershortname_english=ccentername;
            }
            
            if ([ccentershortname_chinese isEqualToString:@""]) {
                ccentershortname_chinese=ccentername;
            }
            
            NSMutableArray * cstudentnamedisplayorder=[[NSMutableArray alloc]initWithArray:[[[jsonArray objectAtIndex:i] objectForKey:@"studentnamedisplayorder"] componentsSeparatedByString:@","]];
            BOOL cshowcontactindailyscheduleprintout=[[[jsonArray objectAtIndex:i] objectForKey:@"showcontactindailyscheduleprintout"] isEqualToString:@"Yes"];
            BOOL cshowduepaymentindailyscheduleprintout=[[[jsonArray objectAtIndex:i] objectForKey:@"showduepaymentindailyscheduleprintout"] isEqualToString:@"Yes"];
            NSString * cdefaultstudentmessagechannel=[[jsonArray objectAtIndex:i] objectForKey:@"defaultstudentmessagechannel"];
            NSString * cdefaultleadmessagechannel=[[jsonArray objectAtIndex:i] objectForKey:@"defaultleadmessagechannel"];
            NSMutableArray * cleadnamedisplayorder=[[NSMutableArray alloc]initWithArray:[[[jsonArray objectAtIndex:i] objectForKey:@"leadnamedisplayorder"] componentsSeparatedByString:@","]];
            NSString * cscannerpoweroffcode=[[jsonArray objectAtIndex:i] objectForKey:@"scannerpoweroffcode"];
            BOOL cdefaultreceiptremarksasinvoiceremarksforcourseenrollment=[[[jsonArray objectAtIndex:i] objectForKey:@"defaultreceiptremarksasinvoiceremarksforcourseenrollment"] isEqualToString:@"Yes"];
            BOOL cdefaultreceiptremarksasinvoiceremarksforproductsales=[[[jsonArray objectAtIndex:i] objectForKey:@"defaultreceiptremarksasinvoiceremarksforproductsales"] isEqualToString:@"Yes"];
            NSInteger cinvoicefontsize=[[[jsonArray objectAtIndex:i] objectForKey:@"invoicefontsize"] integerValue];
            NSInteger ctncfontsize_invoice=[[[jsonArray objectAtIndex:i] objectForKey:@"tncfontsize_invoice"] integerValue];
            BOOL cshowlevelininvoice=[[[jsonArray objectAtIndex:i] objectForKey:@"showlevelininvoice"] isEqualToString:@"Yes"];
            NSInteger creceiptfontsize=[[[jsonArray objectAtIndex:i] objectForKey:@"receiptfontsize"] integerValue];
            NSInteger ctncfontsize_receipt=[[[jsonArray objectAtIndex:i] objectForKey:@"tncfontsize_receipt"] integerValue];
            BOOL cshowlevelinreceipt=[[[jsonArray objectAtIndex:i] objectForKey:@"showlevelinreceipt"] isEqualToString:@"Yes"];
            BOOL cshowstaffnameinreceipt=[[[jsonArray objectAtIndex:i] objectForKey:@"showstaffnameinreceipt"] isEqualToString:@"Yes"];
            BOOL cshowvalidityininvoicereceipt=[[[jsonArray objectAtIndex:i] objectForKey:@"showvalidityininvoicereceipt"] isEqualToString:@"Yes"];
            BOOL cenablevideomessage=[[[jsonArray objectAtIndex:i] objectForKey:@"enablevideomessage"] isEqualToString:@"Yes"];
            BOOL cenableparentsendvideomessage=[[[jsonArray objectAtIndex:i] objectForKey:@"enableparentsendvideomessage"] isEqualToString:@"Yes"];
            BOOL cenablevoicemessage=[[[jsonArray objectAtIndex:i] objectForKey:@"enablevoicemessage"] isEqualToString:@"Yes"];
            BOOL cenableparentsendvoicemessage=[[[jsonArray objectAtIndex:i] objectForKey:@"enableparentsendvoicemessage"] isEqualToString:@"Yes"];
            BOOL csendparentappinvitesms=[[[jsonArray objectAtIndex:i] objectForKey:@"sendparentappinvitesms"] isEqualToString:@"Yes"];
            BOOL cddaenabled=[[[jsonArray objectAtIndex:i] objectForKey:@"ddaenabled"] isEqualToString:@"Yes"];
            BOOL cstudentsendmessagedefault=[[[jsonArray objectAtIndex:i] objectForKey:@"studentsendmessagedefault"] isEqualToString:@"Yes"];
            NSString * cprintclassdatemode=[[jsonArray objectAtIndex:i] objectForKey:@"printclassdatemode"];
            BOOL cenablelessonnumber=[[[jsonArray objectAtIndex:i] objectForKey:@"enablelessonnumber"] isEqualToString:@"Yes"];
            NSString * cschoolregnumber=[[jsonArray objectAtIndex:i] objectForKey:@"schoolregnumber"];
            NSInteger cshowclassdatesinreceipt=[[[jsonArray objectAtIndex:i] objectForKey:@"showclassdatesinreceipt"] integerValue];
            NSInteger cshowclassdatesininvoice=[[[jsonArray objectAtIndex:i] objectForKey:@"showclassdatesininvoice"] integerValue];
            BOOL cshowlastpaymentonlyinreceipt=[[[jsonArray objectAtIndex:i] objectForKey:@"showlastpaymentonlyinreceipt"] isEqualToString:@"Yes"];
            BOOL csecondaryinstructor=[[[jsonArray objectAtIndex:i] objectForKey:@"secondaryinstructor"] isEqualToString:@"Yes"];
            BOOL ciparentshowonlynondroppedenrollment=[[[jsonArray objectAtIndex:i] objectForKey:@"iparentshowonlynondroppedenrollment"] isEqualToString:@"Yes"];
            BOOL cstudentextrafield1=[[[jsonArray objectAtIndex:i] objectForKey:@"studentextrafield1"] isEqualToString:@"Yes"];
            BOOL cfullday=[[[jsonArray objectAtIndex:i] objectForKey:@"fullday"] isEqualToString:@"Yes"];
            NSInteger clessonnumbermode=[[[jsonArray objectAtIndex:i] objectForKey:@"lessonnumbermode"] integerValue];
            BOOL cmarkexpiredclassabsent=[[[jsonArray objectAtIndex:i] objectForKey:@"markexpiredclassabsent"] isEqualToString:@"Yes"];
            NSString * cpaymentmethods_string=[[jsonArray objectAtIndex:i] objectForKey:@"paymentmethods"];
            NSArray *cpaymentmethods=[[NSArray alloc]initWithArray:[cpaymentmethods_string componentsSeparatedByString:@","]];
            BOOL cupdateclassafterschedulechange=[[[jsonArray objectAtIndex:i] objectForKey:@"updateclassafterschedulechange"] isEqualToString:@"Yes"];
            BOOL crenewevenifthereistbdclass=[[[jsonArray objectAtIndex:i] objectForKey:@"renewevenifthereistbdclass"] isEqualToString:@"Yes"];
            BOOL cecoupon=[[[jsonArray objectAtIndex:i] objectForKey:@"ecoupon"] isEqualToString:@"Yes"];
            BOOL cconsolidatestockcountformultipleaccountcodes=[[[jsonArray objectAtIndex:i] objectForKey:@"consolidatestockcountformultipleaccountcodes"] isEqualToString:@"Yes"];
            BOOL cenablechatbot=[[[jsonArray objectAtIndex:i] objectForKey:@"enablechatbot"] isEqualToString:@"Yes"];
            BOOL cenablemembershippoint=[[[jsonArray objectAtIndex:i] objectForKey:@"enablemembershippoint"] isEqualToString:@"Yes"];
            BOOL caddpointwithactiveparentapp=[[[jsonArray objectAtIndex:i] objectForKey:@"addpointwithactiveparentapp"] isEqualToString:@"Yes"];
            NSString * cspendingtopointratio=[[jsonArray objectAtIndex:i] objectForKey:@"spendingtopointratio"];
            NSString * cspendingtopointratio_sales=[[jsonArray objectAtIndex:i] objectForKey:@"spendingtopointratio_sales"];
            NSString * cdefaultpointexpirydays=[[jsonArray objectAtIndex:i] objectForKey:@"defaultpointexpirydays"];
            NSInteger cmaxdayrangefortrialclass=[[[jsonArray objectAtIndex:i] objectForKey:@"maxdayrangefortrialclass"] integerValue];
            BOOL cautoenrollmentfeeforfirstenrollment=[[[jsonArray objectAtIndex:i] objectForKey:@"autoenrollmentfeeforfirstenrollment"] isEqualToString:@"Yes"];
            NSInteger ccouponexpiryfirstreminder=[[[jsonArray objectAtIndex:i] objectForKey:@"couponexpiryfirstreminder"] integerValue];
            NSInteger ccouponexpiryrecursivereminder=[[[jsonArray objectAtIndex:i] objectForKey:@"couponexpiryrecursivereminder"] integerValue];
            NSInteger cpointexpiryfirstreminder=[[[jsonArray objectAtIndex:i] objectForKey:@"pointexpiryfirstreminder"] integerValue];
            NSInteger cpointexpiryrecursivereminder=[[[jsonArray objectAtIndex:i] objectForKey:@"pointexpiryrecursivereminder"] integerValue];
            BOOL caddpointforonlinepaymentonly=[[[jsonArray objectAtIndex:i] objectForKey:@"addpointforonlinepaymentonly"] isEqualToString:@"Yes"];
            BOOL caddpointforontimepaymentonly=[[[jsonArray objectAtIndex:i] objectForKey:@"addpointforontimepaymentonly"] isEqualToString:@"Yes"];
            NSMutableArray * ctimetablefielddisplayorder=[[NSMutableArray alloc]initWithArray:[[[jsonArray objectAtIndex:i] objectForKey:@"ctimetablefielddisplayorder"] componentsSeparatedByString:@","]];
            BOOL cprintclassdateendtime=[[[jsonArray objectAtIndex:i] objectForKey:@"printclassdateendtime"] isEqualToString:@"Yes"];
            BOOL cskipmakeupforrenewal_prepare=[[[jsonArray objectAtIndex:i] objectForKey:@"skipmakeupforrenewal_prepare"] isEqualToString:@"Yes"];
            BOOL ctransferpointforinternaltransferpayment=[[[jsonArray objectAtIndex:i] objectForKey:@"transferpointforinternaltransferpayment"] isEqualToString:@"Yes"];
            BOOL ccloneenrollmentcopydiscountdefault=[[[jsonArray objectAtIndex:i] objectForKey:@"cloneenrollmentcopydiscountdefault"] isEqualToString:@"Yes"];
            NSString * cinvoiceprefix=[[jsonArray objectAtIndex:i] objectForKey:@"invoiceprefix"];
            NSString * creceiptprefix=[[jsonArray objectAtIndex:i] objectForKey:@"receiptprefix"];
            BOOL ciparentshowuserdefinedschedulename=[[[jsonArray objectAtIndex:i] objectForKey:@"iparentshowuserdefinedschedulename"] isEqualToString:@"Yes"];
            NSString * cpointearn_qrcodecheckin=[[jsonArray objectAtIndex:i] objectForKey:@"pointearn_qrcodecheckin"];
            NSString * cpointearn_selfmakeup=[[jsonArray objectAtIndex:i] objectForKey:@"pointearn_selfmakeup"];
            BOOL cicenterversioncheck=[[[jsonArray objectAtIndex:i] objectForKey:@"icenterversioncheck"] isEqualToString:@"Yes"];
            BOOL cjumptonextlevelduringrenewal=[[[jsonArray objectAtIndex:i] objectForKey:@"jumptonextlevelduringrenewal"] isEqualToString:@"Yes"];
            BOOL ciparentreturnrenewalremindernotifications=[[[jsonArray objectAtIndex:i] objectForKey:@"iparentreturnrenewalremindernotifications"] isEqualToString:@"Yes"];
            NSInteger cmakeupdelayhour=[[[jsonArray objectAtIndex:i] objectForKey:@"makeupdelayhour"] integerValue];
            NSInteger ctrialdelayhour=[[[jsonArray objectAtIndex:i] objectForKey:@"trialdelayhour"] integerValue];
            NSInteger cparentappcolorschemekey=[[[jsonArray objectAtIndex:i] objectForKey:@"parentappcolorschemekey"] integerValue];
            BOOL ciparentshowclassendtime=[[[jsonArray objectAtIndex:i] objectForKey:@"iparentshowclassendtime"] isEqualToString:@"Yes"];
            BOOL cshowcenteraveragescore=[[[jsonArray objectAtIndex:i] objectForKey:@"showcenteraveragescore"] isEqualToString:@"Yes"];
            NSString * csidprefix=[[jsonArray objectAtIndex:i] objectForKey:@"sidprefix"];
            BOOL cenablestaffcompetency=[[[jsonArray objectAtIndex:i] objectForKey:@"enablestaffcompetency"] isEqualToString:@"Yes"];
            NSString * cstaffcompetencyvalues=[[jsonArray objectAtIndex:i] objectForKey:@"staffcompetencyvalues"];
            NSInteger cwaiveenrollmentfeeminmonth=[[[jsonArray objectAtIndex:i] objectForKey:@"waiveenrollmentfeeminmonth"] integerValue];
            BOOL cdefaultcsshowintimetableifnoenrollment=[[[jsonArray objectAtIndex:i] objectForKey:@"defaultcsshowintimetableifnoenrollment"] isEqualToString:@"Yes"];
            BOOL cdefaultcsmakeupschedule=[[[jsonArray objectAtIndex:i] objectForKey:@"defaultcsmakeupschedule"] isEqualToString:@"Yes"];
            NSString * clockclassperiod=[[jsonArray objectAtIndex:i] objectForKey:@"lockclassperiod"];
            BOOL cusereserveddayduringrenewal=[[[jsonArray objectAtIndex:i] objectForKey:@"usereserveddayduringrenewal"] isEqualToString:@"Yes"];
            BOOL cusereserveddayduringenrollment=[[[jsonArray objectAtIndex:i] objectForKey:@"usereserveddayduringenrollment"] isEqualToString:@"Yes"];
            NSString * cmaplat=[[jsonArray objectAtIndex:i] objectForKey:@"maplat"];
            NSString * cmaplong=[[jsonArray objectAtIndex:i] objectForKey:@"maplong"];
            NSInteger cminstudentcontact=[[[jsonArray objectAtIndex:i] objectForKey:@"minstudentcontact"] integerValue];
            BOOL cremovecouponifnotpaidbeforeexpiry=[[[jsonArray objectAtIndex:i] objectForKey:@"removecouponifnotpaidbeforeexpiry"] isEqualToString:@"Yes"];
            BOOL cmarkrenewalreserveddaytomakeup=[[[jsonArray objectAtIndex:i] objectForKey:@"markrenewalreserveddaytomakeup"] isEqualToString:@"Yes"];
            BOOL cmarkenrollmentreserveddaytomakeup=[[[jsonArray objectAtIndex:i] objectForKey:@"markenrollmentreserveddaytomakeup"] isEqualToString:@"Yes"];
            NSString * cfcgroup=[[jsonArray objectAtIndex:i] objectForKey:@"fcgroup"];
            BOOL cremoveunpaidandexpiredpromotion=[[[jsonArray objectAtIndex:i] objectForKey:@"removeunpaidandexpiredpromotion"] isEqualToString:@"Yes"];
            BOOL cenablemembershiptier=[[[jsonArray objectAtIndex:i] objectForKey:@"enablemembershiptier"] isEqualToString:@"Yes"];
            NSInteger ctierspendinginterval=[[[jsonArray objectAtIndex:i] objectForKey:@"tierspendinginterval"] integerValue];
            NSInteger cmaxuploadfilesize=[[[jsonArray objectAtIndex:i] objectForKey:@"maxuploadfilesize"] integerValue];
            NSString * cstudentextrafield2=[[jsonArray objectAtIndex:i] objectForKey:@"studentextrafield2"];
            NSInteger ctimetabletbdinstructorcolorcode=[[[jsonArray objectAtIndex:i] objectForKey:@"timetabletbdinstructorcolorcode"] integerValue];
            NSInteger ctimetabletbdclassroomcolorcode=[[[jsonArray objectAtIndex:i] objectForKey:@"timetabletbdclassroomcolorcode"] integerValue];
            NSInteger cnoofpastdayincludedinistaffmystudentclass=[[[jsonArray objectAtIndex:i] objectForKey:@"noofpastdayincludedinistaffmystudentclass"] integerValue];
            NSString * cstaffpasswordexpirationday=[[jsonArray objectAtIndex:i] objectForKey:@"staffpasswordexpirationday"];
            BOOL ccaneditmonthlycoursestartdate=[[[jsonArray objectAtIndex:i] objectForKey:@"caneditmonthlycoursestartdate"] isEqualToString:@"Yes"];
            NSString * cattendance_qrcode_refresh_minute=[[jsonArray objectAtIndex:i] objectForKey:@"attendance_qrcode_refresh_minute"];
            NSString * ccenter_qrcode_refresh_minute=[[jsonArray objectAtIndex:i] objectForKey:@"center_qrcode_refresh_minute"];
            NSString * cautodropenrollmentday=[[jsonArray objectAtIndex:i] objectForKey:@"autodropenrollmentday"];
            NSString * clicensetype=[[jsonArray objectAtIndex:i] objectForKey:@"licensetype"];
            NSString * cmark_noattendancetaking_to=[[jsonArray objectAtIndex:i] objectForKey:@"mark_noattendancetaking_to"];
            NSString * ceenrollmentformdest=[[jsonArray objectAtIndex:i] objectForKey:@"eenrollmentformdest"];
            
            [globalvariables.CenterDict setValue:[[CenterRecord alloc]initCenterRecordwithCenterKey:ccenterkey EntityKey:centitykey CenterName:ccentername CenterShortNameEnglish:ccentershortname_english CenterShortNameChinese:ccentershortname_chinese ClassStartTime:cclassstarttime ClassEndTime:cclassendtime ClassTimeInterval:cclasstimeinterval CenterAddress:ccenteraddress CenterAddress_chinese:ccenteraddress_chinese CenterContact:ccentercontact CenterFax:ccenterfax CenterWhatsapp:ccenterwhatsapp CenterEmail:ccenteremail CenterWebsite:ccenterwebsite CenterOthers:ccenterothers CenterDB:ccenterdb Centerhour_line1left:ccenterhour_line1left Centerhour_line1right:ccenterhour_line1right Centerhour_line2left:ccenterhour_line2left Centerhour_line2right:ccenterhour_line2right Centerhour_line3left:ccenterhour_line3left Centerhour_line3right:ccenterhour_line3right Centerhour_line1left_chinese:ccenterhour_line1left_chinese Centerhour_line1right_chinese:ccenterhour_line1right_chinese Centerhour_line2left_chinese:ccenterhour_line2left_chinese Centerhour_line2right_chinese:ccenterhour_line2right_chinese Centerhour_line3left_chinese:ccenterhour_line3left_chinese Centerhour_line3right_chinese:ccenterhour_line3right_chinese launchimage_landscape:claunchimage_landscape launchimage_portrait:claunchimage_portrait shopfrontimage:cshopfrontimage mapimage:cmapimage printlogoimage:cprintlogoimage chequepayable:cchequepayable Enrollmentfee:cenrollmentfee LateFee_Enable:clatefee_enable receipttnc:creceipttnc invoicetnc:cinvoicetnc defaulteditablepaymentamount:cdefaulteditablepaymentamount defaultattendancestatus:cdefaultattendancestatus launchmessagemode:claunchmessagemode enableattendanceextend:cenableattendanceextend renewmonthlyroundup:crenewmonthlyroundup enableautobatchrenew:cenableautobatchrenew autobatchrenewdaystoinclude:cautobatchrenewdaystoinclude monthlymodeweeklyscheduletuitiondenominator:cmonthlymodeweeklyscheduletuitiondenominator defaultstudentgrade:cdefaultstudentgrade noofroundoffdigit:cnoofroundoffdigit enablestaffsalaryrate:cenablestaffsalaryrate enablescantotakeattendance:cenablescantotakeattendance scantottakeattendancebeforethreshold:cscantottakeattendancebeforethreshold scantottakeattendanceafterthreshold:cscantottakeattendanceafterthreshold scantype:cscantype autofillstudentid:cautofillstudentid enableistafftakingattendance:cenableistafftakingattendance latefee:clatefee latefeegraceperiod:clatefeegraceperiod iparentusercanupdatepersonalinformation:ciparentusercanupdatepersonalinformation reservedcalendardate:creservedcalendardate autofillleadid:cautofillleadid parentappdefault:cparentappdefault studentpromotiondefault:cstudentpromotiondefault leadpromotiondefault:cleadpromotiondefault studentassessmentform:cstudentassessmentform enrollmentvalidity:cenrollmentvalidity iparentshowenrollmenttuitionfee:ciparentshowenrollmenttuitionfee enrollmultiplesubjectsatsametimeslot:cenrollmultiplesubjectsatsametimeslot enablemakeup:cenablemakeup autorenewal_date_for_monthlycourse:cautorenewal_date_for_monthlycourse editmonthlycourseclassdate:ceditmonthlycourseclassdate iparentclassalert:ciparentclassalert iparentleavemode:ciparentleavemode enablemakeupquota:cenablemakeupquota mindaytoapplyleave:cmindaytoapplyleave maxdayformakeup:cmaxdayformakeup noofdayafteroriginalclassformakeup:cnoofdayafteroriginalclassformakeup noofpastdayincludediniparentclassschedule:cnoofpastdayincludediniparentclassschedule smsdefault:csmsdefault iparentshowclassroom:ciparentshowclassroom standaloneparentappid:cstandaloneparentappid autosendereceipt:cautosendereceipt enableaccountreceivablecodes:cenableaccountreceivablecodes iparentshowclassschedule:ciparentshowclassschedule iparentshowmessages:ciparentshowmessages iparentshowphotocorner:ciparentshowphotocorner iparentshowenrollmentrecords:ciparentshowenrollmentrecords iparentshowsalesrecords:ciparentshowsalesrecords duepayment:cduepayment showdiscountdetailsinreceipt:cshowdiscountdetailsinreceipt showdiscountdetailsininvoice:cshowdiscountdetailsininvoice leaveapprovalmode:cleaveapprovalmode enableparentsendmessage:cenableparentsendmessage expiringclassreminder:cexpiringclassreminder firstreminderbeforeexpiry:cfirstreminderbeforeexpiry expiringclassreminderrecursiveday:cexpiringclassreminderrecursiveday studentnamedisplayorder:cstudentnamedisplayorder showcontactindailyscheduleprintout:cshowcontactindailyscheduleprintout showduepaymentindailyscheduleprintout:cshowduepaymentindailyscheduleprintout defaultstudentmessagechannel:cdefaultstudentmessagechannel defaultleadmessagechannel:cdefaultleadmessagechannel leadnamedisplayorder:cleadnamedisplayorder scannerpoweroffcode:cscannerpoweroffcode defaultreceiptremarksasinvoiceremarksforcourseenrollment:cdefaultreceiptremarksasinvoiceremarksforcourseenrollment defaultreceiptremarksasinvoiceremarksforproductsales:cdefaultreceiptremarksasinvoiceremarksforproductsales invoicefontsize:cinvoicefontsize tncfontsize_invoice:ctncfontsize_invoice showlevelininvoice:cshowlevelininvoice receiptfontsize:creceiptfontsize tncfontsize_receipt:ctncfontsize_receipt showlevelinreceipt:cshowlevelinreceipt showstaffnameinreceipt:cshowstaffnameinreceipt showvalidityininvoicereceipt:cshowvalidityininvoicereceipt enablevideomessage:cenablevideomessage enableparentsendvideomessage:cenableparentsendvideomessage enablevoicemessage:cenablevoicemessage enableparentsendvoicemessage:cenableparentsendvoicemessage sendparentappinvitesms:csendparentappinvitesms ddaenabled:cddaenabled studentsendmessagedefault:cstudentsendmessagedefault printclassdatemode:cprintclassdatemode enablelessonnumber:cenablelessonnumber schoolregnumber:cschoolregnumber autosendeinvoice:cautosendeinvoice showclassdatesinreceipt:cshowclassdatesinreceipt showclassdatesininvoice:cshowclassdatesininvoice showlastpaymentonlyinreceipt:cshowlastpaymentonlyinreceipt secondaryinstructor:csecondaryinstructor iparentshowonlynondroppedenrollment:ciparentshowonlynondroppedenrollment studentextrafield1:cstudentextrafield1 fullday:cfullday lessonnumbermode:clessonnumbermode markexpiredclassabsent:cmarkexpiredclassabsent paymentmethods:cpaymentmethods updateclassafterschedulechange:cupdateclassafterschedulechange standalonestaffappid:cstandalonestaffappid renewevenifthereistbdclass:crenewevenifthereistbdclass ecoupon:cecoupon consolidatestockcountformultipleaccountcodes:cconsolidatestockcountformultipleaccountcodes enablechatbot:cenablechatbot enablemembershippoint:cenablemembershippoint addpointwithactiveparentapp:caddpointwithactiveparentapp spendingtopointratio:cspendingtopointratio spendingtopointratio_sales:cspendingtopointratio_sales defaultpointexpirydays:cdefaultpointexpirydays maxdayrangefortrialclass:cmaxdayrangefortrialclass autoenrollmentfeeforfirstenrollment:cautoenrollmentfeeforfirstenrollment couponexpiryfirstreminder:ccouponexpiryfirstreminder couponexpiryrecursivereminder:ccouponexpiryrecursivereminder pointexpiryfirstreminder:cpointexpiryfirstreminder pointexpiryrecursivereminder:cpointexpiryrecursivereminder addpointforonlinepaymentonly:caddpointforonlinepaymentonly addpointforontimepaymentonly:caddpointforontimepaymentonly timetablefielddisplayorder:ctimetablefielddisplayorder printclassdateendtime:cprintclassdateendtime skipmakeupforrenewal_prepare:cskipmakeupforrenewal_prepare transferpointforinternaltransferpayment:ctransferpointforinternaltransferpayment cloneenrollmentcopydiscountdefault:ccloneenrollmentcopydiscountdefault invoiceprefix:cinvoiceprefix receiptprefix:creceiptprefix iparentshowuserdefinedschedulename:ciparentshowuserdefinedschedulename pointearn_qrcodecheckin:cpointearn_qrcodecheckin icenterversioncheck:cicenterversioncheck jumptonextlevelduringrenewal:cjumptonextlevelduringrenewal iparentreturnrenewalremindernotifications:ciparentreturnrenewalremindernotifications makeupdelayhour:cmakeupdelayhour parentappcolorschemekey:cparentappcolorschemekey iparentshowclassendtime:ciparentshowclassendtime showcenteraveragescore:cshowcenteraveragescore sidprefix:csidprefix staffcompetencyvalues:cstaffcompetencyvalues enablestaffcompetency:cenablestaffcompetency waiveenrollmentfeeminmonth:cwaiveenrollmentfeeminmonth defaultcsshowintimetableifnoenrollment:cdefaultcsshowintimetableifnoenrollment defaultcsmakeupschedule:cdefaultcsmakeupschedule lockclassperiod:clockclassperiod usereserveddayduringrenewal:cusereserveddayduringrenewal usereserveddayduringenrollment:cusereserveddayduringenrollment maplat:cmaplat maplong:cmaplong minstudentcontact:cminstudentcontact removecouponifnotpaidbeforeexpiry:cremovecouponifnotpaidbeforeexpiry markrenewalreserveddaytomakeup:cmarkrenewalreserveddaytomakeup Centerhour_line4left:ccenterhour_line4left Centerhour_line4right:ccenterhour_line4right Centerhour_line5left:ccenterhour_line5left Centerhour_line5right:ccenterhour_line5right Centerhour_line4left_chinese:ccenterhour_line4left_chinese Centerhour_line4right_chinese:ccenterhour_line4right_chinese Centerhour_line5left_chinese:ccenterhour_line5left_chinese Centerhour_line5right_chinese:ccenterhour_line5right_chinese markenrollmentreserveddaytomakeup:cmarkenrollmentreserveddaytomakeup fcgroup:cfcgroup removeunpaidandexpiredpromotion:cremoveunpaidandexpiredpromotion enablemembershiptier:cenablemembershiptier tierspendinginterval:ctierspendinginterval maxuploadfilesize:cmaxuploadfilesize studentextrafield2:cstudentextrafield2 trialdelayhour:ctrialdelayhour timetabletbdinstructorcolorcode:ctimetabletbdinstructorcolorcode timetabletbdclassroomcolorcode:ctimetabletbdclassroomcolorcode noofpastdayincludedinistaffmystudentclass:cnoofpastdayincludedinistaffmystudentclass staffpasswordexpirationday:cstaffpasswordexpirationday caneditmonthlycoursestartdate:ccaneditmonthlycoursestartdate attendance_qrcode_refresh_minute:cattendance_qrcode_refresh_minute center_qrcode_refresh_minute:ccenter_qrcode_refresh_minute autodropenrollmentday:cautodropenrollmentday licensetype:clicensetype pointearn_selfmakeup:cpointearn_selfmakeup mark_noattendancetaking_to:cmark_noattendancetaking_to eenrollmentformdest:ceenrollmentformdest] forKey:ccenterkey];
            
            //add new lastupdate
//            if (![lastupdatecenterkeyarray containsObject:ccenterkey]) {
//                [lastupdatecenterkeyarray addObject:ccenterkey];
            if(![globalvariables.lastupdatedict valueForKey:ccenterkey]){
                [globalvariables.lastupdatedict setValue:[[LastUpdateRecord alloc]initLastUpdateRecordwithCenterkey:ccenterkey Calendar:@"" Staff:@"" Classroom:@"" LanguageTitle:@"" Subject:@"" Product:@"" Marketing:@"" Centerimage:@"" StudentImage:@"" LeadImage:@"" ClassImage:@"" Centerrecord:centerlistlastupdatetime Centersettings:@"" Userroleandprivilege:@"" Student:@"" Lead:@"" LeaveNature:@"" ARCode:@"" MessageContact:@""] forKey:ccenterkey];
                
                if ([sql isEqualToString:@""]) {
                    sql=[NSString stringWithFormat:@"('%@','','','','','','','','','','','','%@','','','','','','','')",ccenterkey,centerlistlastupdatetime];
                }else{
                    sql=[NSString stringWithFormat:@"%@ , ('%@','','','','','','','','','','','','%@','','','','','','','')",sql,ccenterkey,centerlistlastupdatetime];
                }
            }
        }
        
        if (![sql isEqualToString:@""]) {
            sql=[NSString stringWithFormat:@"INSERT INTO lastupdate ('centerkey','calendar','staff','classroom','languagetitle','subject','product','marketing','studentimage','leadimage','centerimage','classimage','centerrecord','centersettings','userroleandprivilege','student','lead','leavenature','arcode','messagecontact') VALUES %@",sql];
            sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,&err);
        }
        
//        globalvariables.CenterArray=[[NSMutableArray alloc]initWithArray:CenterArray];
        [MyClass sortCenterArraybyCenterName];
        return YES;
    }else{
        //[MyClass showconnectionlostdialogbox];
        return NO;
    }
    
}


-(void) retrieveglobalsettings
{
    globalvariables.globalsettings = [[GlobalSettings alloc]init];
    
    NSString * cstartupserver=[[jsonarray_globalsettings objectAtIndex:0] objectForKey:@"startupserver"];
    NSString * clatestappversion=[[jsonarray_globalsettings objectAtIndex:0] objectForKey:@"latestappversion"];
    NSString * clatestappurl=[[jsonarray_globalsettings objectAtIndex:0] objectForKey:@"latestappurl"];
    NSString * cbroadcastmessagemode=[[jsonarray_globalsettings objectAtIndex:0] objectForKey:@"broadcastmessagemode"];
    NSString * cbroadcastmessageenglish=[[jsonarray_globalsettings objectAtIndex:0] objectForKey:@"broadcastmessageenglish"];
    NSString * cbroadcastmessagechinese=[[jsonarray_globalsettings objectAtIndex:0] objectForKey:@"broadcastmessagechinese"];
    
    
    globalvariables.globalsettings=[[GlobalSettings alloc]initGlobalSettingswithStartupServer:cstartupserver LatestAppVersion:clatestappversion LatestAppUrl:clatestappurl BroadcastMessageMode:cbroadcastmessagemode BroadcastMessageEnglish:cbroadcastmessageenglish BroadcastMessageChinese:cbroadcastmessagechinese];
    
    [MyClass updatelocaldbwithparameter:@"startupserver" value:cstartupserver];

}

-(NSString *) UserAuthentication
{
    if ([tmpusername isEqualToString:@""] || jsonarray_userauthentication.count<1) {
        return @"Failed";
    }else{
        NSString *result=[[jsonarray_userauthentication objectAtIndex:0] objectForKey:@"result"];
        NSString *entitykey=[[jsonarray_userauthentication objectAtIndex:0] objectForKey:@"entitykey"];
        returnmessage=[[jsonarray_userauthentication objectAtIndex:0] objectForKey:@"returnmessage"];
        
        if ([result isEqualToString:@"failed"]) {
            if (!loginview.hidden) {
                if (![tmppassword isEqualToString:@""]) {
                    loginmessage.text=[MyClass returnlogintitlewithtitle:returnmessage];
                }
            }else if([returnmessage isEqualToString:@"Password Expired"]){
                loginmessage.text=[MyClass returnlogintitlewithtitle:returnmessage];
            }
            return @"Failed";
        }else if ([result isEqualToString:@"resetpassword"]){
            globalvariables.password=tmppassword;
            return @"ResetPassword";
        }else if (![entitykey isEqualToString:@""]){
            //if change user login
            if (![globalvariables.rawusername isEqualToString:tmpusername]) {
                globalvariables.centerrecord=[[CenterRecord alloc]init];
            }
            
            if (![globalvariables.rawusername isEqualToString:tmpusername] || ![globalvariables.password isEqualToString:tmppassword]) {
                [self updateusernamepasswordtosqlitewithusername:tmpusername password:tmppassword];
                globalvariables.newlogin=@"Yes";
            }
            
            globalvariables.centerrecord.entitykey=entitykey;
            return @"Passed";
        }else{
            if (!loginview.hidden) {
                loginmessage.text=[MyClass returnlogintitlewithtitle:@"Your username or password is incorrect"];
            }
            return @"Failed";
        }
    }
}

-(void) retrievelanguagepackrecord
{
    if (jsonarray_languagepack) {
        NSArray *jsonlanguagepack=jsonarray_languagepack[@"languagepackrecords"];
        [MyClass updatelocaldbwithparameter:@"globallastupdate" value:jsonarray_languagepack[@"lastupdatetime"]];
        char *err;
        sqlite3_stmt *stmt;
        char *csql;
        
        globalvariables.languagepackdictionary=[[NSMutableDictionary alloc]init];
        //remove old data from db
        NSString *sql=[NSString stringWithFormat:@"delete from languagepack"];
        sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,&err);
        
        //add new data
        NSString *title;
        NSString *english;
        NSString *chinese;
        NSString *schinese;
        NSString *centerkey;
        
        NSLog(@"Updating language pack");
        
        csql="INSERT INTO languagepack ('centerkey','title','english','chinese','schinese') VALUES (?,?,?,?,?)";
        if (sqlite3_prepare_v2(globalvariables.isdb, csql, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_exec(globalvariables.isdb, "BEGIN TRANSACTION", NULL, NULL, NULL);
            for (long i=0; i<jsonlanguagepack.count; i++) {
                
                centerkey=[[jsonlanguagepack objectAtIndex:i] objectForKey:@"centerkey"];
                title=[[jsonlanguagepack objectAtIndex:i] objectForKey:@"title"];
                english=[[jsonlanguagepack objectAtIndex:i] objectForKey:@"english"];
                chinese=[[jsonlanguagepack objectAtIndex:i] objectForKey:@"chinese"];
                schinese=[[jsonlanguagepack objectAtIndex:i] objectForKey:@"schinese"];
                
                [globalvariables.languagepackdictionary setValue:[[LanguageTitleRecord alloc]initLanguageTitleRecordwithCenterkey:centerkey Title:title Chinese:chinese English:english SChinese:schinese] forKey:[NSString stringWithFormat:@"%@#%@",/*globalvariables.centerrecord.centerkey*/@"",title]];
                
                sqlite3_bind_text(stmt, 1, [centerkey UTF8String], -1, NULL);
                sqlite3_bind_text(stmt, 2, [title UTF8String], -1, NULL);
                sqlite3_bind_text(stmt, 3, [english UTF8String], -1, NULL);
                sqlite3_bind_text(stmt, 4, [chinese UTF8String], -1, NULL);
                sqlite3_bind_text(stmt, 5, [schinese UTF8String], -1, NULL);
                
                sqlite3_step(stmt);
                sqlite3_reset(stmt);
            }
            sqlite3_exec(globalvariables.isdb, "END TRANSACTION", NULL, NULL, NULL);
            sqlite3_finalize(stmt);
            //[self updatedevicelastupdatetimewithparameter:@"languagetitle" centerkeyarray:languagetitlecenterkeyarray systemcurrenttime:languagetitlelastupdatetime];
        }
    }
}

-(void) retrievecountrycode
{
    if (jsonarray_countrycode) {
        NSArray *jsoncountrycode=jsonarray_countrycode[@"countrycoderecords"];
        [MyClass updatelocaldbwithparameter:@"globallastupdate" value:jsonarray_countrycode[@"lastupdatetime"]];
        
        NSLog(@"Updating country code");
        char *err;
        sqlite3_stmt *stmt;
        char *csql;
        
        globalvariables.countrycodearray=[[NSMutableDictionary alloc]init];
        //remove old data from db
        NSString *sql=[NSString stringWithFormat:@"delete from countrycode"];
        sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,&err);
        
        //add new data
        NSString *countrycodekey;
        NSString *country_code;
        NSString *country_name;
        NSString *iso_code;
        
        csql="INSERT INTO countrycode ('countrycodekey','country_code','country_name','iso_code') VALUES (?,?,?,?)";
        if (sqlite3_prepare_v2(globalvariables.isdb, csql, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_exec(globalvariables.isdb, "BEGIN TRANSACTION", NULL, NULL, NULL);
            for (long i=0; i<jsoncountrycode.count; i++) {
                
                countrycodekey=[[jsoncountrycode objectAtIndex:i] objectForKey:@"countrycodekey"];
                country_name=[[jsoncountrycode objectAtIndex:i] objectForKey:@"country_name"];
                iso_code=[[jsoncountrycode objectAtIndex:i] objectForKey:@"iso_code"];
                country_code=[[jsoncountrycode objectAtIndex:i] objectForKey:@"country_code"];
                
                [globalvariables.countrycodearray setValue:[[CountryCodeRecord alloc]initCountryCodeRecordwithcountrycodekey:countrycodekey country_code:country_code country_name:country_name iso_code:iso_code] forKey:iso_code];
                
                
                sqlite3_bind_text(stmt, 1, [countrycodekey UTF8String], -1, NULL);
                sqlite3_bind_text(stmt, 2, [country_code UTF8String], -1, NULL);
                sqlite3_bind_text(stmt, 3, [country_name UTF8String], -1, NULL);
                sqlite3_bind_text(stmt, 4, [iso_code UTF8String], -1, NULL);
                
                sqlite3_step(stmt);
                sqlite3_reset(stmt);
            }
            sqlite3_exec(globalvariables.isdb, "END TRANSACTION", NULL, NULL, NULL);
            sqlite3_finalize(stmt);
            //[self updatedevicelastupdatetimewithparameter:@"languagetitle" centerkeyarray:languagetitlecenterkeyarray systemcurrenttime:languagetitlelastupdatetime];
        }
    }
}

- (void)resetpasswordbuttonpressed:(id)sender
{
    [self.view endEditing:YES];
    
    if ([usernametext.text isEqualToString:@""]) {
        UIAlertController *missingusernamealert = [UIAlertController alertControllerWithTitle:[MyClass returnlogintitlewithtitle:@"Reset Password"] message:[MyClass returnlogintitlewithtitle:@"Please enter your username"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missingusernamealert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missingusernamealert addAction:OKAction];
        [self presentViewController:missingusernamealert animated:YES completion:nil];
    }else{
        tmpusername=usernametext.text;
        [self setServer];
        if ([self CheckDatabaseAvailability]) {

            
                    UIAlertController *initializedpasswordalert = [UIAlertController alertControllerWithTitle:[MyClass returnlogintitlewithtitle:@"Reset Password"] message:[MyClass returnlogintitlewithtitle:@"Are you sure to reset the password?"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [self initializedpassword:YES];
                    }];
                    
                    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [initializedpasswordalert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [initializedpasswordalert addAction:OKAction];
                    [initializedpasswordalert addAction:CancelAction];
                    
                    [self presentViewController:initializedpasswordalert animated:YES completion:nil];

        }else{
            [self showLoadingIndicator:NO initialscreen:NO];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"iSchool" message:[MyClass returnlogintitlewithtitle:@"Server connection is not available. Please check your internet connection and try again"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //[self loginapp];
            }];

            [alert addAction:OKAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        

    }
}

-(void) initializedpassword:(BOOL)loginscreen
{
    NSString *userName;
    if (loginscreen) {
        globalvariables.username=[MyClass removeDevFromUsername:usernametext.text];
    }
    userName=globalvariables.username;
    globalvariables.password=@"";
    NSString *strURL=[NSString stringWithFormat:@"%@?action=resetuserpassword&username=%@&usertype=staff&apptype=iCenter",globalvariables.generalphpfullpath,userName];
    
    __block NSString *result;
    __block BOOL success=FALSE;
    __block NSString *sentto;
    __block NSString *senttimestamp;
    __block NSDate *date;
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            success=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            jsonArray = jsonreturned[@"content"];
            result=[[jsonArray objectAtIndex:0] objectForKey:@"result"];
            sentto=[[jsonArray objectAtIndex:0] objectForKey:@"sentto"];
            senttimestamp=[[jsonArray objectAtIndex:0] objectForKey:@"senttimestamp"];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            date=[df dateFromString:senttimestamp];
            [df setDateFormat:@"HH:mm"];
        }
    }];
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            success=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            jsonArray = jsonreturned[@"content"];
            result=[[jsonArray objectAtIndex:0] objectForKey:@"result"];
            sentto=[[jsonArray objectAtIndex:0] objectForKey:@"sentto"];
            senttimestamp=[[jsonArray objectAtIndex:0] objectForKey:@"senttimestamp"];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            date=[df dateFromString:senttimestamp];
            [df setDateFormat:@"HH:mm"];
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    
    if (success) {

        NSRange range=[sentto rangeOfString:@"@"];
        NSString *message;
        if ([result isEqualToString:@"invaliduser"]) {
            message=[MyClass returnlogintitlewithtitle:@"Username is invalid. Please check with your centre's administrator."];
        }else if ([result isEqualToString:@"sentok"]) {
            if (range.location==NSNotFound) {
                message=[MyClass returnreplacedtitlewithtitle2:@"A new password will be sent within next few minutes via SMS to your mobile %@1" replacementarray:@[sentto]];
            }else{
                message=[MyClass returnreplacedtitlewithtitle2:@"A new password will be sent within next few minutes to your email %@1" replacementarray:@[sentto]];
            }
            [MyClass updatelocaldbwithparameter:@"showgetnewpassword" value:@"No"];
        }else if ([result isEqualToString:@"sentalready"]) {
            if (range.location==NSNotFound) {
                message=[MyClass returnreplacedtitlewithtitle2:@"Password has already been sent to your mobile %@1 via SMS at %@2. Please try again later if you do not receive it in the next few minutes." replacementarray:[[NSArray alloc]initWithObjects:sentto,[df stringFromDate:date], nil]];
            }else{
                message=[MyClass returnreplacedtitlewithtitle2:@"Password has already been sent to your email %@1 at %@2. Please try again later if you do not receive it in the next few minutes." replacementarray:[[NSArray alloc]initWithObjects:sentto,[df stringFromDate:date], nil]];
            }
        }else if ([result isEqualToString:@"invalidphoneno"]) {
            message=[MyClass returnlogintitlewithtitle:@"User's phone number is invalid. Please check with your centre's administrator."];
        }else{
            message=result;
        }
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returnlogintitlewithtitle:@"Reset Password"] message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alert addAction:OKAction];
        [self presentViewController:alert animated:YES completion:nil];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
}

-(void) loadlaunchimage
{

    [MyClass downloadImageWithImageview:launchimage gender:nil type:@"launchimage" typekey:globalvariables.centerrecord.launchimage_landscape image:@"Yes" async:YES];
}



-(void) doneswitchcenterwithreload:(BOOL)reload centerkey:(NSString *)centerkey centerimage:(UIImage *)centerimage
{
    loginview.hidden=YES;
    [self showLoadingIndicator:YES initialscreen:NO];
    
    if (reload) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loginapp];
        });
    }
}

-(void) createloadingindicator
{
    [self.view layoutIfNeeded];
    
    
    CGFloat width = appBackgroundView.frame.size.width;//[UIScreen mainScreen].bounds.size.width;
    CGFloat height = appBackgroundView.frame.size.height;//[UIScreen mainScreen].bounds.size.height;
    
//    UIWindow *mainWindow= [[[UIApplication sharedApplication] delegate] window];
    SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.anyObject.delegate;
    UIWindow *mainWindow = sceneDelegate.window;
    [mainWindow.rootViewController.view layoutIfNeeded];
    
    UIView * loadingindicatorview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    loadingindicatorview.backgroundColor=[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:0.2];
    [mainWindow addSubview:loadingindicatorview];
    
    
    UIView *centerview=[[UIView alloc]initWithFrame:CGRectMake((width-200)/2, (height-150)/2, 180, 140)];
    centerview.layer.cornerRadius=10;
    centerview.layer.masksToBounds=YES;
    [loadingindicatorview addSubview:centerview];
    
    
    
    UIImageView *activityImageView=[[UIImageView alloc]init];
    activityImageView.alpha=1.0;
    activityImageView.tag=808;
    activityImageView.frame=CGRectMake(-10,-10,60,60);
    
    UIActivityIndicatorView *ailoadindicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    ailoadindicator.alpha = 1.0;
    ailoadindicator.color=[UIColor clearColor];
    ailoadindicator.transform=CGAffineTransformMakeScale(1, 1);
    ailoadindicator.center = CGPointMake(centerview.frame.size.width/2,centerview.frame.size.height/2);
    ailoadindicator.hidesWhenStopped = YES;
    ailoadindicator.tag=1024;
    [ailoadindicator addSubview:activityImageView];
    [centerview addSubview:ailoadindicator];
    
    globalvariables.loadingindicatorview=loadingindicatorview;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == usernametext) {
        [textField resignFirstResponder];
        [passwordtext becomeFirstResponder];
    }else if (textField == newpasswordtext) {
        [textField resignFirstResponder];
        [confirmpasswordtext becomeFirstResponder];
    }else if (textField == passwordtext){
        [self loginbuttonpressed:nil];
    }else if (textField == confirmpasswordtext){
        [self donebuttonpressed:nil];
    }
    return YES;
}

-(void) logoutapp
{
    [MyClass clearLocalDataUponLogout];
    alreadyshowedsystemmessage=@"Yes";
    [launchimage setImage:nil];
    [self showLoadingIndicator:YES initialscreen:YES];
    runviewdidappear=TRUE;
    
    tmppassword=@"";
    passwordtext.text=@"";
 
    if (@available(iOS 13.0, *)) {
        mainContainerView.hidden=YES;
        //remove container child view
        if (@available(iOS 13.0, *)) {
            [mainmenunavcontroller willMoveToParentViewController:nil];
            [mainmenunavcontroller.view removeFromSuperview];
            [mainmenunavcontroller removeFromParentViewController];
        }
    }else{
        [mainmenunavcontroller dismissViewControllerAnimated:YES completion:nil];
    }
    
    [self viewDidAppear:YES];
}

-(void) reloadapp
{
    alreadyshowedsystemmessage=@"Yes";
    [launchimage setImage:nil];
    [self showLoadingIndicator:YES initialscreen:YES];
    runviewdidappear=TRUE;
    
    if (@available(iOS 13.0, *)) {
        mainContainerView.hidden=YES;
        //remove container child view
        if (@available(iOS 13.0, *)) {
            [mainmenunavcontroller willMoveToParentViewController:nil];
            [mainmenunavcontroller.view removeFromSuperview];
            [mainmenunavcontroller removeFromParentViewController];
        }
    }else{
        [mainmenunavcontroller dismissViewControllerAnimated:YES completion:nil];
    }

    
    [self viewDidAppear:YES];
    
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }
    [topRootViewController dismissViewControllerAnimated:NO completion:nil];
}

-(void) gotoscreenindex:(NSInteger)screenindex pageindex:(NSInteger)pageindex keyindex:(NSInteger)keyindex
{
    globalvariables.leftmenuindex=[@(screenindex) stringValue];
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    globalvariables.firstredirectscreen=[NSString stringWithFormat:@"%ld",(long)screenindex];
    if(![globalvariables.appbecomeactiveaction isEqualToString:@"reloading"]){
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            NSIndexPath *menuindexPath = [NSIndexPath indexPathForRow:screenindex inSection:0];
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:menuindexPath];
        });
    }
}

-(void) refreshscreenindex:(NSInteger)screenindex
{
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    UIViewController *currentvc=[mainVC.currentActiveNVC.viewControllers lastObject];
    //if ([currentvc isKindOfClass:[MessageViewController class]]) {
        [((MessageViewController *)currentvc) reloadMessageScreenWithCenterkey:nil];
    /*}if ([currentvc isKindOfClass:[SubMessageViewController class]]) {
        [((SubMessageViewController *)currentvc) reloadMessageScreen];
    }*/
    
}

- (IBAction)applyTrialAccountButtonPressed:(id)sender {
    
    RegistrationViewController *viewcontroller = (RegistrationViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"RegistrationViewController"];
    viewcontroller.delegate=self;
    viewcontroller.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:viewcontroller animated:YES completion: nil];
}

-(void) appliedTrialAccountWithUsername:(NSString *)username statusmessage:(NSString *)statusmessage
{
    usernametext.text=username;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returnlogintitlewithtitle: @"Apply Trial Account"] message:[MyClass returnlogintitlewithtitle:statusmessage] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returnlogintitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:OKAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) sendOutboxDocument
{
    MessagePopoverViewController *viewController = [[MessagePopoverViewController alloc]init];
    [viewController sendOutboxDocument];
}

-(void) sendAssessmentReport
{
    MessagePopoverViewController *viewController = [[MessagePopoverViewController alloc]init];
    [viewController sendAssessmentReport];
}

-(void) backgroundretrievemessagecontactlistwithcenterkey:(NSString *)centerkey
{
    MessageViewController *viewController = [[MessageViewController alloc]init];
    [viewController reloadMessageScreenWithCenterkey:centerkey];
}



@end
