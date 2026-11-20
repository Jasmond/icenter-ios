//
//  PhotoCornerViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 31/3/2016.
//  Copyright © 2016 DreamHigh Company Limited. All rights reserved.
//

#import "ClassPhotoViewController.h"
#import "MainMenuViewController.h"
#import "MyClass.h"
#import "UIViewController+AMSlideMenu.h"
#import "MainViewController.h"
#import "MyTableViewCell.h"
#import "SceneDelegate.h"

@import Photos;

@import BSImagePicker;

#define maxphotoheight 3+(ClassPhotoTable.frame.size.width-20-6)*5/6

@interface ClassPhotoViewController ()
{
    BOOL sideWindowAdjusting;
    CGFloat laidOutPhotoWidth;
    UILabel *photoHeaderLabel;
    NSLayoutConstraint *classPhotoWidthConstraint;
    NSLayoutConstraint *classPhotoCenterConstraint;
    NSLayoutConstraint *classPhotoBottomConstraint;
}
@end

@implementation ClassPhotoViewController
@synthesize imagepicker,mypopovercontroller;

-(void)deleteImageWithIndex:(NSInteger)index{}
-(void)returnRotatedImage:(UIImage *)image Index:(NSInteger)index{}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    globalvariables=[GlobalVariables singleObj];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];

    
    photoHeaderLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 68)];
    photoHeaderLabel.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0];
    [self.view addSubview:photoHeaderLabel];
    
    headertitleview=[[UIView alloc]initWithFrame:CGRectMake(70, 0, self.view.bounds.size.width-140, 68)];
    headertitlename=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, headertitleview.frame.size.width, 20)];
    headertitlename.font=[UIFont boldSystemFontOfSize:17];
    headertitlename.textColor=[UIColor whiteColor];
    headertitlename.textAlignment=NSTextAlignmentCenter;
    [headertitleview addSubview:headertitlename];
    [self.view addSubview:headertitleview];
    
    headercentername=[[UILabel alloc]init];
    headercentername.font=[UIFont systemFontOfSize:12];
    headercentername.textAlignment=NSTextAlignmentCenter;
    headercentername.minimumScaleFactor=0.8;
    headercentername.adjustsFontSizeToFitWidth=YES;
    headercentername.textColor=[UIColor whiteColor];
    //headercentername.text=[MyClass returncentershortnamewithcenterkey:nil];
    [headertitleview addSubview:headercentername];
    
    headercenternamearrow=[[UIImageView alloc]init];
    [headercenternamearrow setImage:[UIImage imageNamed:@"openbutton_white.png"]];
    headercenternamearrow.hidden=[MyClass isMultiCenterUser]?NO:YES;
    [headertitleview addSubview:headercenternamearrow];
    //[self updateheadercentertitle];
    
    switchcenterbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, headertitleview.frame.size.width,68)];
    //[switchcenterbutton setImage:[UIImage imageWithData:globalvariables.menuimagedata] forState:UIControlStateNormal];
    switchcenterbutton.layer.cornerRadius=5;
    switchcenterbutton.layer.masksToBounds=YES;
    if ([MyClass isMultiCenterUser]) {
        [switchcenterbutton addTarget:self action:@selector(switchcenterbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    }
    [headertitleview addSubview:switchcenterbutton];
    
    switchcenterviewcontroller = (SwitchCenterViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"SwitchCenterViewController"];
    //switchcenterviewcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
    switchcenterviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    switchcenterviewcontroller.delegate=self;
    
    menubutton=[[UIButton alloc]initWithFrame:CGRectMake(15, 35, 33, 22)];
    [menubutton setImage:[UIImage imageNamed:@"menu-button.png"] forState:UIControlStateNormal];
    [menubutton setContentMode:UIViewContentModeScaleToFill];
    [menubutton addTarget:self action:@selector(menubuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menubutton];
    
    
    addclassphotobutton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-30, 31, 21, 21)];
    [addclassphotobutton setImage:[UIImage imageNamed:@"addbuttonwhite_icon.png"] forState:UIControlStateNormal];
    [addclassphotobutton addTarget:self action:@selector(addclassphotobuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addclassphotobutton];
    
    searchphotobutton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-70, 32, 21, 21)];
    [searchphotobutton setImage:[UIImage imageNamed:@"searchbutton.png"] forState:UIControlStateNormal];
    [searchphotobutton addTarget:self action:@selector(searchbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchphotobutton];
    
    //add table
    /*ClassPhotoTable=[[UITableView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-classphototablewidth)/2, 68, classphototablewidth, self.view.bounds.size.height-68) style:UITableViewStylePlain];
    ClassPhotoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    ClassPhotoTable.delegate=self;
    ClassPhotoTable.dataSource=self;
    [self.view addSubview:ClassPhotoTable];*/
    
    //norecordtitle=[[UILabel alloc]initWithFrame:CGRectMake(ClassPhotoTable.frame.origin.x, 0, classphototablewidth, self.view.bounds.size.height)];
    norecordtitle.text=[MyClass returntitlewithtitle:@"No Record"];
    //norecordtitle.textColor=[UIColor lightGrayColor];
    //norecordtitle.textAlignment=NSTextAlignmentCenter;
    //norecordtitle.font=[UIFont systemFontOfSize:20];
    //norecordtitle.hidden=YES;
    //[self.view addSubview:norecordtitle];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(retrievePhotoRecord) forControlEvents:UIControlEventValueChanged];
    [ClassPhotoTable addSubview:tablerefresh];
    
    [self intializesearchbar];
    
    classphotoobject=[[ClassPhotoRecord alloc]init];
    
    [self refreshlanguage];
    runviewdidappear=TRUE;
    
    


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checktoreloadapp) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    fullscreenphotoviewcontroller = (FullScreenPhotoViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"FullScreenPhotoViewController"];
    fullscreenphotoviewcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
    fullscreenphotoviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    fullscreenphotoviewcontroller.delegate=self;
    fullscreenphotoviewcontroller.mode=@"View";
    
//    mainWindow= [[[UIApplication sharedApplication] delegate] window];
    SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.anyObject.delegate;
    mainWindow = sceneDelegate.window;
    
    mainviewcontroller = (MainViewController*) [mainWindow rootViewController];
    
    sidewindowviewclosebutton=[[UIButton alloc]initWithFrame:mainWindow.bounds];
    sidewindowviewclosebutton.backgroundColor=[UIColor blackColor];
    sidewindowviewclosebutton.layer.opacity=0.3;
    sidewindowviewclosebutton.tag=-200;
    sidewindowviewclosebutton.hidden=YES;
    [sidewindowviewclosebutton addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [mainWindow addSubview:sidewindowviewclosebutton];
    
    sidewindowview=[[UIView alloc]initWithFrame:CGRectMake(mainWindow.bounds.size.width, 0, 0, mainWindow.bounds.size.height)];
    sidewindowview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    sidewindowview.hidden=YES;
    sidewindowview.clipsToBounds=YES;
    sidewindowview.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    sidewindowview.tag=-200;
    [mainWindow addSubview:sidewindowview];
    
    UIImageView *activityImageView=[[UIImageView alloc]init];
    activityImageView.animationImages=[MyClass returnLoadingIndicatorAnimatedImageWithBaseColor:@"lightgray"];
    activityImageView.alpha=1.0;
    activityImageView.animationDuration=1.5;
    activityImageView.frame=CGRectMake(0,0,45,45);
    [activityImageView startAnimating];
    
    ailoadindicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    ailoadindicator.alpha = 1.0;
    ailoadindicator.color=[UIColor clearColor];
    ailoadindicator.transform=CGAffineTransformMakeScale(1, 1);
    ailoadindicator.center = CGPointMake(152.5,mainWindow.frame.size.height/2-7.5);
    ailoadindicator.hidesWhenStopped = YES;
    [ailoadindicator addSubview:activityImageView];
    [self->sidewindowview addSubview:ailoadindicator];
    
    
    
}

-(void) checktoreloadapp
{
    
    if ([globalvariables.appbecomeactiveaction isEqualToString:@"reload"]) {
        if ([mypopovercontroller presentingViewController].isBeingPresented) {
            [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==switchcenterviewcontroller) {
            [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==fullscreenphotoviewcontroller) {
            [fullscreenphotoviewcontroller dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.mainSlideMenu closeLeftMenu];
        }
        globalvariables.appbecomeactiveaction=@"";
        globalvariables.leftmenuindex=@"0";
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        
        [MyClass reloadApp];
    }else if ([globalvariables.appbecomeactiveaction isEqualToString:@"refresh"]){
        
        globalvariables.appbecomeactiveaction=@"";
        if ([mypopovercontroller presentingViewController].isBeingPresented) {
            [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==switchcenterviewcontroller) {
            [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.mainSlideMenu closeLeftMenu];
        }

        [self reloadPageWithFirstLoad:NO];

    }
}

-(void) refreshlanguage
{
    
    headercentername.text=[MyClass returnWindowTitle];
    headertitlename.text=[MyClass returntitlewithtitle:@"Photo Corner"];
    [self updateheadercentertitle];
    
}

-(void) updateheadercentertitle
{
    
    [headercentername sizeToFit];
    CGRect myframe=headercentername.frame;
    if (myframe.size.width>headertitleview.frame.size.width) {
        headercentername.frame=CGRectMake([MyClass isMultiCenterUser]?-4:0, 43, headertitleview.frame.size.width, 22);
    }else{
        headercentername.frame=CGRectMake((headertitleview.frame.size.width-myframe.size.width)/2+([MyClass isMultiCenterUser]?-4:0), 43, myframe.size.width, 22);
    }
    headercenternamearrow.frame=CGRectMake(headercentername.frame.size.width+headercentername.frame.origin.x, 50.5, 8, 8);
}


- (CGFloat)visibleClassPhotoWidth
{
    CGFloat width = self.view.bounds.size.width;
    UIWindow *window = self.view.window;
    if (!window || width < 1) {
        return width;
    }
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGFloat leftShift = MAX(CGRectGetMinX(frameInWindow) - CGRectGetMinX(window.bounds), 0);
    CGFloat rightOverflow = MAX(CGRectGetMaxX(frameInWindow) - CGRectGetMaxX(window.bounds), 0);
    CGFloat menuSlide = MIN(leftShift, rightOverflow);
    return MAX(width - (rightOverflow - menuSlide), 0);
}

- (CGFloat)visibleClassPhotoHeight
{
    CGFloat height = self.view.bounds.size.height;
    UIWindow *window = self.view.window;
    if (!window || height < 1) {
        return height;
    }
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGFloat visibleMaxY = MIN(CGRectGetMaxY(frameInWindow), CGRectGetMaxY(window.bounds));
    return MAX(MIN(visibleMaxY - CGRectGetMinY(frameInWindow), height), 0);
}

- (CGRect)visibleWindowFrame
{
    UIWindow *window = self.view.window ? self.view.window : mainWindow;
    if (!window) {
        return CGRectZero;
    }
    if (!self.isViewLoaded || !self.view.window) {
        return window.bounds;
    }
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGRect visible = CGRectIntersection(frameInWindow, window.bounds);
    if (CGRectIsNull(visible) || visible.size.width < 1 || visible.size.height < 1) {
        return window.bounds;
    }
    return visible;
}

- (void)layoutClassPhotoForCurrentSize
{
    CGFloat width = [self visibleClassPhotoWidth];
    CGFloat height = [self visibleClassPhotoHeight];
    if (width < 1 || height < 1) {
        return;
    }
    photoHeaderLabel.frame = CGRectMake(0, 0, width, 68);
    CGFloat titleWidth = MAX(width - 140.0, 0);
    headertitleview.frame = CGRectMake(70, 0, titleWidth, 68);
    headertitlename.frame = CGRectMake(0, 25, titleWidth, 20);
    switchcenterbutton.frame = CGRectMake(0, 0, titleWidth, 68);
    [self updateheadercentertitle];
    addclassphotobutton.frame = CGRectMake(width - 30, 31, 21, 21);
    searchphotobutton.frame = CGRectMake(width - 70, 32, 21, 21);
    if (searchbarview) {
        CGRect searchFrame = searchbarview.frame;
        searchFrame.size.width = width;
        searchbarview.frame = searchFrame;
        CGFloat fieldWidth = MIN(400.0, MAX(width - 180.0, 0));
        search_text.frame = CGRectMake(MAX((width - fieldWidth) / 2.0 - 40.0, 15.0), 32, fieldWidth, 25);
        search_favouritebutton.frame = CGRectMake(CGRectGetMaxX(search_text.frame) + 20, 32, 23, 23);
        UIButton *cancelButton = (UIButton *)[searchbarview viewWithTag:881];
        cancelButton.frame = CGRectMake(width - 15 - 85, 33, 85, 21);
    }
    if (!classPhotoWidthConstraint) {
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            if (constraint.firstItem == ClassPhotoTable && constraint.firstAttribute == NSLayoutAttributeWidth && constraint.secondItem == self.view) {
                classPhotoWidthConstraint = constraint;
            } else if (constraint.firstItem == ClassPhotoTable && constraint.firstAttribute == NSLayoutAttributeCenterX && constraint.secondItem == self.view) {
                classPhotoCenterConstraint = constraint;
            } else if (constraint.firstItem == self.view && constraint.firstAttribute == NSLayoutAttributeBottom && constraint.secondItem == ClassPhotoTable) {
                classPhotoBottomConstraint = constraint;
            }
        }
    }
    CGFloat fullWidth = self.view.bounds.size.width;
    CGFloat tableWidth = MIN(fullWidth * 0.5, width);
    if (classPhotoWidthConstraint) {
        classPhotoWidthConstraint.constant = tableWidth - fullWidth * 0.5;
    }
    if (classPhotoCenterConstraint) {
        classPhotoCenterConstraint.constant = width / 2.0 - fullWidth / 2.0;
    }
    if (classPhotoBottomConstraint) {
        classPhotoBottomConstraint.constant = MAX(self.view.bounds.size.height - height, 0);
    }
    if (fabs(laidOutPhotoWidth - width) > 0.5) {
        laidOutPhotoWidth = width;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->ClassPhotoTable reloadData];
        });
    }
}

- (void)pinOpenSideWindowToVisibleEdge
{
    if (sideWindowAdjusting || !sidewindowview || sidewindowview.hidden || sidewindowview.frame.size.width < 1.0) {
        return;
    }
    CGRect visible = [self visibleWindowFrame];
    if (visible.size.width < 1.0 || visible.size.height < 1.0) {
        return;
    }
    CGFloat panelWidth = MIN(sidewindowview.frame.size.width, visible.size.width);
    sidewindowview.frame = CGRectMake(CGRectGetMaxX(visible) - panelWidth, visible.origin.y, panelWidth, visible.size.height);
    if (sidewindowviewclosebutton && !sidewindowviewclosebutton.hidden) {
        sidewindowviewclosebutton.frame = visible;
    }
    for (UIView *child in sidewindowview.subviews) {
        if ([child isKindOfClass:[UIActivityIndicatorView class]]) {
            continue;
        }
        child.frame = sidewindowview.bounds;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutClassPhotoForCurrentSize];
    [self pinOpenSideWindowToVisibleEdge];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.mainSlideMenu disableSlidePanGestureForRightMenu];
    if (runviewdidappear) {
        globalvariables.lastviewcontroller=(NSString *)self;
        [self reloadPageWithFirstLoad:YES];
    }else{
        runviewdidappear=TRUE;
    }
}



-(void)menubuttonpressed:(id)sender
{
    [self.mainSlideMenu openLeftMenu];
}

-(void) intializesearchbar
{
    searchbarview=[[UIView alloc]initWithFrame:CGRectMake(0, -68, self.view.bounds.size.width, 68)];
    searchbarview.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0];
    [self.view addSubview:searchbarview];
    
    UIButton *search_cancelbutton=[[UIButton alloc]initWithFrame:CGRectMake(searchbarview.frame.size.width-15-85, 33, 85, 21)];
    search_cancelbutton.tag=881;
    [search_cancelbutton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    search_cancelbutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    search_cancelbutton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [search_cancelbutton addTarget:self action:@selector(search_cancel) forControlEvents:UIControlEventTouchUpInside];
    [searchbarview addSubview:search_cancelbutton];
    

    
    search_text=[[UITextField alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-400)/2, 32, 400, 25)];
    search_text.backgroundColor=[UIColor colorWithRed:45.0/255.0 green:105.0/255.0 blue:180.0/255.0 alpha:1.0];//[UIColor lightGrayColor];
    search_text.font=[UIFont systemFontOfSize:12];
    search_text.textColor=[UIColor whiteColor];
    search_text.layer.cornerRadius=3;
    search_text.layer.masksToBounds=YES;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[MyClass returntitlewithtitle:@"Search"] attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    search_text.attributedPlaceholder = str;
    [search_text setTintColor:[UIColor whiteColor]];
    [search_text addTarget:self action:@selector(updatesearchtext)forControlEvents:UIControlEventEditingChanged];
    search_text.clearButtonMode = UITextFieldViewModeWhileEditing;
    search_text.layer.sublayerTransform = CATransform3DMakeTranslation(0, 1, 0);
    [search_text setLeftViewMode:UITextFieldViewModeAlways];
    
    search_favouritebutton=[[UIButton alloc]initWithFrame:CGRectMake(search_text.frame.origin.x+search_text.frame.size.width+20, 32, 23, 23)];
    [search_favouritebutton setImage:[UIImage imageNamed:@"photofavouritebutton_white.png"] forState:UIControlStateNormal];
    [search_favouritebutton addTarget:self action:@selector(search_favouritepressed) forControlEvents:UIControlEventTouchUpInside];
    search_favouritebutton.tag=0;
    [searchbarview addSubview:search_favouritebutton];
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 27, search_text.frame.size.height)];
    UIImageView *searchimage=[[UIImageView alloc]initWithFrame:CGRectMake(5,(search_text.frame.size.height-15)/2,15,15)];
    [searchimage setImage:[UIImage imageNamed:@"searchbutton.png"]];
    [spacerView addSubview:searchimage];
    
    [search_text setLeftView:spacerView];
    [searchbarview addSubview:search_text];
    
}

-(BOOL) retrievePhotoRecord
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrieveclassphoto2",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewclassphoto"]];

    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSMutableArray *JSONArray=[[NSMutableArray alloc]init];
            
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            //Set up our class array
            ClassPhotoRecordArray=[[NSMutableArray alloc] init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                NSString * ccenterkey=[[JSONArray objectAtIndex:i] objectForKey:@"centerkey"];
                NSString * cclassphotokey=[[JSONArray objectAtIndex:i] objectForKey:@"classphotokey"];
                NSString * ctakenby=[[JSONArray objectAtIndex:i] objectForKey:@"takenby"];
                NSDate *ccreatedatetime=[MyClass convertToNSDateWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"createdatetime"] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                //NSString *ctitle = [[[JSONArray objectAtIndex:i] objectForKey:@"title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSString * ctitle=[[JSONArray objectAtIndex:i] objectForKey:@"title"];
                NSString * ctag=[[JSONArray objectAtIndex:i] objectForKey:@"tag"];

                
//                if ([cwidth isEqualToString:@""] || [cheight isEqualToString:@""]) {
//                    cwidth=[NSString stringWithFormat:@"%f",self.view.frame.size.width];
//                    cheight=[NSString stringWithFormat:@"%f",maxphotoheight];
//                }
                
                NSString * cfavourite=[[JSONArray objectAtIndex:i] objectForKey:@"favourite"];
                NSString * clike=[[JSONArray objectAtIndex:i] objectForKey:@"like"];
                BOOL chotnews=[[[JSONArray objectAtIndex:i] objectForKey:@"hotnews"] isEqualToString:@"Yes"];
                NSString * chn_expiry_date=[[JSONArray objectAtIndex:i] objectForKey:@"hn_expiry_date"];
                
                NSArray * filearray=[[JSONArray objectAtIndex:i] objectForKey:@"filearray"];
                NSMutableArray *cfilearray=[[NSMutableArray alloc]init];
                for (int j=0; j<filearray.count; j++) {
                    NSString * photocornerfilekey=[[filearray objectAtIndex:j] objectForKey:@"photocornerfilekey"];
                    NSString * fileurl=[[filearray objectAtIndex:j] objectForKey:@"fileurl"];
                    NSString * width=[[filearray objectAtIndex:j] objectForKey:@"width"];
                    NSString * height=[[filearray objectAtIndex:j] objectForKey:@"height"];
                    NSString * filetype=[[filearray objectAtIndex:j] objectForKey:@"filetype"];
                    NSString * thumbnailurl=[[filearray objectAtIndex:j] objectForKey:@"thumbnailurl"];
                    NSString * filename=[[filearray objectAtIndex:j] objectForKey:@"filename"];
                    /*if([filename isEqualToString:@""]){
                        filename=fileurl;
                    }*/
                    
                    if ([width isEqualToString:@""] || [height isEqualToString:@""]) {
                        width=[NSString stringWithFormat:@"%f",self.view.frame.size.width];
                        height=[NSString stringWithFormat:@"%f",maxphotoheight];
                    }
                    
                    [cfilearray addObject:[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:ccenterkey PhotoCornerFileKey:photocornerfilekey FileURL:fileurl ImageView:nil Width:[width floatValue] Height:[height floatValue] FileType:filetype InternalURL:nil FileName:filename ThumbnailURL:thumbnailurl Action:@"" DownloadFileType:@"class" title:ctitle]];
                }
                
                [ClassPhotoRecordArray addObject:[[ClassPhotoRecord alloc]initClassPhotoRecordwithcenterkey:ccenterkey classphotokey:cclassphotokey takenby:ctakenby createdatetime:ccreatedatetime title:ctitle tag:ctag favourite:cfavourite like:clike hotnews:chotnews hn_expiry_date:chn_expiry_date filearray:cfilearray]];
            }
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            result=TRUE;
        NSMutableArray *JSONArray=[[NSMutableArray alloc]init];
        NSMutableArray *filenamearray=[[NSMutableArray alloc]init];
        
        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
        JSONArray = jsonreturned[@"content"];
        
        //Set up our class array
        ClassPhotoRecordArray=[[NSMutableArray alloc] init];
        
        //loop through our jsonArray
        for (int i=0; i<JSONArray.count; i++) {
            NSString * ccenterkey=[[JSONArray objectAtIndex:i] objectForKey:@"centerkey"];
            NSString * cclassphotokey=[[JSONArray objectAtIndex:i] objectForKey:@"classphotokey"];
            NSString * ctakenby=[[JSONArray objectAtIndex:i] objectForKey:@"takenby"];
            NSString * cfilename=[[JSONArray objectAtIndex:i] objectForKey:@"filename"];
            
            //NSString *ctitle = [[[JSONArray objectAtIndex:i] objectForKey:@"title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString * ctitle=[[JSONArray objectAtIndex:i] objectForKey:@"title"];
            NSString * ctag=[[JSONArray objectAtIndex:i] objectForKey:@"tag"];
            NSString * cwidth=[[JSONArray objectAtIndex:i] objectForKey:@"width"];
            NSString * cheight=[[JSONArray objectAtIndex:i] objectForKey:@"height"];
            
            if ([cwidth isEqualToString:@""] || [cheight isEqualToString:@""]) {
                cwidth=[NSString stringWithFormat:@"%f",self.view.frame.size.width];
                cheight=[NSString stringWithFormat:@"%f",maxphotoheight];
            }
            
            NSString * cfavourite=[[JSONArray objectAtIndex:i] objectForKey:@"favourite"];
            NSString * clike=[[JSONArray objectAtIndex:i] objectForKey:@"like"];
            BOOL chotnews=[[[JSONArray objectAtIndex:i] objectForKey:@"hotnews"] isEqualToString:@"Yes"];
            NSString * chn_expiry_date=[[JSONArray objectAtIndex:i] objectForKey:@"hn_expiry_date"];
            
            [ClassPhotoRecordArray addObject:[[ClassPhotoRecord alloc]initClassPhotoRecordwithcenterkey:ccenterkey classphotokey:cclassphotokey takenby:ctakenby filename:cfilename title:ctitle tag:ctag width:cwidth height:cheight favourite:cfavourite like:clike hotnews:chotnews hn_expiry_date:chn_expiry_date]];
            [filenamearray addObject:cfilename];
        }
            
        }
                
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    
    if (result) {
        NSPredicate *predicate;
        if ([search_text.text isEqualToString:@""]) {
            if (search_favouritebutton.tag==1) {
                predicate = [NSPredicate predicateWithFormat:@"self.favourite contains [c] %@", globalvariables.username];
                ClassPhotoRecordArraySearchResult= [NSMutableArray arrayWithArray:[ClassPhotoRecordArray filteredArrayUsingPredicate:predicate]];
            }else{
                ClassPhotoRecordArraySearchResult=[[NSMutableArray alloc]initWithArray:ClassPhotoRecordArray];
            }
        }else{
            if (search_favouritebutton.tag==1) {
                predicate = [NSPredicate predicateWithFormat:@"(SELF.title contains[c] %@ or SELF.tag contains[c] %@) and self.favourite contains [c] %@",search_text.text,search_text.text,globalvariables.username];
            }else{
                predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@ or SELF.tag contains[c] %@",search_text.text,search_text.text];
            }
            ClassPhotoRecordArraySearchResult= [NSMutableArray arrayWithArray:[ClassPhotoRecordArray filteredArrayUsingPredicate:predicate]];
        }
        [ClassPhotoTable reloadData];
        [ClassPhotoTable setContentOffset:CGPointZero animated:YES];
        
        //[self clearupfavouritetablewithfilenamearray:filenamearray];
        
        if (ClassPhotoRecordArraySearchResult.count==0) {
            norecordtitle.hidden=NO;
            //ClassPhotoTable.hidden=YES;
        }else{
            norecordtitle.hidden=YES;
            //ClassPhotoTable.hidden=NO;
            [ClassPhotoTable reloadData];
        }
        
        [tablerefresh endRefreshing];
        //[ailoadclassphoto stopAnimating];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        return YES;
    }else{
        [tablerefresh endRefreshing];
        //[ailoadclassphoto stopAnimating];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        return NO;
        
    }
        
    /*
        NSPredicate *predicate;
        if ([search_text.text isEqualToString:@""]) {
            if (search_favouritebutton.tag==1) {
                predicate = [NSPredicate predicateWithFormat:@"self.favourite contains [c] %@", globalvariables.username];
                ClassPhotoRecordArraySearchResult= [NSMutableArray arrayWithArray:[ClassPhotoRecordArray filteredArrayUsingPredicate:predicate]];
            }else{
                ClassPhotoRecordArraySearchResult=[[NSMutableArray alloc]initWithArray:ClassPhotoRecordArray];
            }
        }else{
            if (search_favouritebutton.tag==1) {
                predicate = [NSPredicate predicateWithFormat:@"(SELF.title contains[c] %@ or SELF.tag contains[c] %@) and self.favourite contains [c] %@",search_text.text,search_text.text,globalvariables.username];
            }else{
                predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@ or SELF.tag contains[c] %@",search_text.text,search_text.text];
            }
            ClassPhotoRecordArraySearchResult= [NSMutableArray arrayWithArray:[ClassPhotoRecordArray filteredArrayUsingPredicate:predicate]];
        }
        [ClassPhotoTable reloadData];
        [ClassPhotoTable setContentOffset:CGPointZero animated:YES];
        
        //[self clearupfavouritetablewithfilenamearray:filenamearray];
        
        if (ClassPhotoRecordArraySearchResult.count==0) {
            norecordtitle.hidden=NO;
            //ClassPhotoTable.hidden=YES;
        }else{
            norecordtitle.hidden=YES;
            //ClassPhotoTable.hidden=NO;
            [ClassPhotoTable reloadData];
        }
        
        [tablerefresh endRefreshing];
        //[ailoadclassphoto stopAnimating];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        
        return YES;
    }else{
        [tablerefresh endRefreshing];
        //[ailoadclassphoto stopAnimating];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        return NO;
    }*/
}

-(NSString *) getfavouritevaluewithfilename:(NSString *)filename
{
    NSString *sql;
    sqlite3_stmt *statement;
    NSString *result=@"No";
    
    sql =[NSString stringWithFormat:@"SELECT * FROM classphoto where filename='%@' and centerkey='%@'",filename,globalvariables.centerrecord.centerkey];
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        while (sqlite3_step(statement)==SQLITE_ROW) {
            result= @"Yes";
        }
    }
    return result;
}

-(void) clearupfavouritetablewithfilenamearray:(NSMutableArray *)filenamearray
{
    NSString *filenamevalue=[filenamearray componentsJoinedByString:@"','"];
    
    NSString *sql;
    sql=[NSString stringWithFormat:@"delete from classphoto where centerkey='%@' and filename not in ('%@')",globalvariables.centerrecord.centerkey,filenamevalue];
    sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,NULL);
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return ClassPhotoRecordArraySearchResult.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
    /*
    classphotoobject=[ClassPhotoRecordArraySearchResult objectAtIndex:indexPath.row];
    if ([classphotoobject.height floatValue]/[classphotoobject.width floatValue]*classphototablewidth>maxphotoheight) {
        photoheight=maxphotoheight;
    }else{
        photoheight=[classphotoobject.height floatValue]/[classphotoobject.width floatValue]*classphototablewidth;
    }
    
    UILabel *titleheightlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 38, classphototablewidth-20, 200)];
    titleheightlabel.font=[UIFont systemFontOfSize:12];
    titleheightlabel.numberOfLines=0;
    titleheightlabel.text=classphotoobject.title;
    [titleheightlabel sizeToFit];
    
    
    UILabel *tagheightlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, classphototablewidth-20, 200)];
    tagheightlabel.font=[UIFont italicSystemFontOfSize:11];
    tagheightlabel.numberOfLines=0;
    tagheightlabel.text=classphotoobject.tag;
    [tagheightlabel sizeToFit];
    
    
    if ([classphotoobject.title isEqualToString:@""]) {
        if ([classphotoobject.tag isEqualToString:@""]) {
            return 60+photoheight+5+40+40+10;
        }else{
            return 60+tagheightlabel.frame.size.height+5+photoheight+5+40+40+10;
        }
    }else{
        if ([classphotoobject.tag isEqualToString:@""]) {
            return 60+titleheightlabel.frame.size.height+5+photoheight+5+40+40+10;
        }else{
            return 60+titleheightlabel.frame.size.height+5+tagheightlabel.frame.size.height+5+photoheight+5+40+40+10;
        }
    }*/
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"photocell";
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    classphotoobject=[ClassPhotoRecordArraySearchResult objectAtIndex:indexPath.row];
    
    cell.label1.text=[MyClass returncentershortnamewithcenterkey:classphotoobject.centerkey];
    cell.label2.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:[MyClass convertToNSStringWithNSDate:classphotoobject.createdatetime DateFormat:@"dd-MMM-YYYY HH:mm"]];
        
    //retrieve center image
    [MyClass downloadImageWithImageview:cell.imageview1 gender:nil type:@"centerimage" typekey:((CenterRecord *)[MyClass returncenterrecordwithcenterkey:classphotoobject.centerkey]).launchimage_landscape image:@"Yes" async:YES];

        
    if ([classphotoobject.title isEqualToString:@""]) {
        cell.label3.hidden=YES;
    }else{
        cell.label3.hidden=NO;
        cell.label3.text=classphotoobject.title;
    }
        
    if ([classphotoobject.tag isEqualToString:@""]) {
        cell.label4.hidden=YES;
    }else{
        cell.label4.hidden=NO;
        cell.label4.text=classphotoobject.tag;
    }

    cell.label5.text=[self returnliketitlewithlikestring:classphotoobject.like];
    cell.label5.hidden=[cell.label5.text isEqualToString:@""];
    
    if ([self favouritedphotowithfavouritestring:classphotoobject.favourite]) {
        [cell.imageview12 setImage:[UIImage imageNamed:@"photofavouritebutton_red.png"]];
        [cell.button2 setTitleColor:[UIColor colorWithRed:176.0/255.0 green:36.0/255.0 blue:34.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }else{
        [cell.imageview12 setImage:[UIImage imageNamed:@"photofavouritebutton_gray.png"]];
        [cell.button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    
    if ([self likedphotowithlikestring:classphotoobject.like]) {
        [cell.imageview13 setImage:[UIImage imageNamed:@"photolikebutton_blue.png"]];
        [cell.button1 setTitleColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }else{
        [cell.imageview13 setImage:[UIImage imageNamed:@"photolikebutton_gray.png"]];
        [cell.button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    [cell.button1 setTitle:[MyClass returntitlewithtitle:@"Like"] forState:UIControlStateNormal];
    [cell.button2 setTitle:[MyClass returntitlewithtitle:@"Favourite"] forState:UIControlStateNormal];
    [cell.button3 setTitle:[MyClass returntitlewithtitle:@"Share"] forState:UIControlStateNormal];
    
    [cell.button1 addTarget:self action:@selector(likebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.button2 addTarget:self action:@selector(favouritebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.button3 addTarget:self action:@selector(sharebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.button9 addTarget:self action:@selector(editclassphotopressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if([classphotoobject.takenby isEqualToString:globalvariables.username]){
        cell.button9.enabled=YES;
    }else{
        if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editothersphotocornerpost){
            cell.button9.enabled=YES;
        }else{
            cell.button9.enabled=NO;
        }
    }
    
    
    if (classphotoobject.hotnews) {
        cell.view4.hidden=NO;
        if ([classphotoobject.hn_expiry_date isEqualToString:@""]) {
            cell.label7.text=[MyClass returntitlewithtitle:@"Posted in Hot News"];
        }else{
            cell.label7.text=[MyClass returnreplacedtitlewithtitle:@"Posted in Hot News. Expiring on %@1" replacementarray:@[[MyClass convertDateFormatWithDate:classphotoobject.hn_expiry_date FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES]]];
        }
    }else{
        cell.view4.hidden=YES;
    }
    
    cell.view1.hidden=YES;
    cell.view2.hidden=YES;
    cell.stackview1.hidden=YES;
    cell.view3.hidden=YES;
    
    if (classphotoobject.filearray.count==1) {
        PhotoCornerFileRecord *obj=[classphotoobject.filearray firstObject];
        [MyClass downloadImageWithImageview:cell.imageview2 gender:nil type:@"class" typekey:obj.thumbnailurl image:@"Yes" async:YES];

        
        if ([obj.filetype isEqualToString:@"video"]) {
            cell.layoutconstraint1.constant=ClassPhotoTable.frame.size.width*5/8;
        }else if ([obj.filetype isEqualToString:@"pdf"]) {
            cell.layoutconstraint1.constant=ClassPhotoTable.frame.size.width*3/4;
        }else{
            if (obj.height/obj.width*ClassPhotoTable.frame.size.width>maxphotoheight) {
                cell.layoutconstraint1.constant=maxphotoheight;
            }else{
                cell.layoutconstraint1.constant=obj.height/obj.width*ClassPhotoTable.frame.size.width;
            }
        }
        
        cell.imageview7.hidden=![obj.filetype isEqualToString:@"video"];
        
        cell.button4.tag=0;
        [cell.button4 addTarget:self action:@selector(showfullscreen:) forControlEvents:UIControlEventTouchUpInside];

    }else if (classphotoobject.filearray.count==2){
        cell.view1.hidden=NO;
        cell.layoutconstraint1.constant=maxphotoheight*2/3;
        PhotoCornerFileRecord *obj1=[classphotoobject.filearray firstObject];
        PhotoCornerFileRecord *obj2=[classphotoobject.filearray lastObject];
        [MyClass downloadImageWithImageview:cell.imageview2 gender:nil type:@"class" typekey:obj1.thumbnailurl image:@"Yes" async:YES];
        [MyClass downloadImageWithImageview:cell.imageview3 gender:nil type:@"class" typekey:obj2.thumbnailurl image:@"Yes" async:YES];
        
        cell.imageview7.hidden=![obj1.filetype isEqualToString:@"video"];
        cell.imageview8.hidden=![obj2.filetype isEqualToString:@"video"];
        cell.button4.tag=0;
        [cell.button4 addTarget:self action:@selector(showfullscreen:) forControlEvents:UIControlEventTouchUpInside];
        cell.button5.tag=1;
        [cell.button5 addTarget:self action:@selector(showfullscreen:) forControlEvents:UIControlEventTouchUpInside];
        

    }else if (classphotoobject.filearray.count==3){
        cell.stackview1.hidden=NO;
        
        cell.layoutconstraint1.constant=maxphotoheight;
        cell.layoutconstraint2.constant=maxphotoheight/2;
        PhotoCornerFileRecord *obj1=[classphotoobject.filearray objectAtIndex:0];
        PhotoCornerFileRecord *obj2=[classphotoobject.filearray objectAtIndex:1];
        PhotoCornerFileRecord *obj3=[classphotoobject.filearray objectAtIndex:2];
        [MyClass downloadImageWithImageview:cell.imageview2 gender:nil type:@"class" typekey:obj1.thumbnailurl image:@"Yes" async:YES];
        [MyClass downloadImageWithImageview:cell.imageview4 gender:nil type:@"class" typekey:obj2.thumbnailurl image:@"Yes" async:YES];
        [MyClass downloadImageWithImageview:cell.imageview5 gender:nil type:@"class" typekey:obj3.thumbnailurl image:@"Yes" async:YES];
        
        cell.imageview7.hidden=![obj1.filetype isEqualToString:@"video"];
        cell.imageview9.hidden=![obj2.filetype isEqualToString:@"video"];
        cell.imageview10.hidden=![obj3.filetype isEqualToString:@"video"];
        
        cell.button4.tag=0;
        [cell.button4 addTarget:self action:@selector(showfullscreen:) forControlEvents:UIControlEventTouchUpInside];
        cell.button6.tag=1;
        [cell.button6 addTarget:self action:@selector(showfullscreen:) forControlEvents:UIControlEventTouchUpInside];
        cell.button7.tag=2;
        [cell.button7 addTarget:self action:@selector(showfullscreen:) forControlEvents:UIControlEventTouchUpInside];

    }else if (classphotoobject.filearray.count==4){
        cell.stackview1.hidden=NO;
        cell.view1.hidden=NO;

        cell.layoutconstraint1.constant=maxphotoheight;
        cell.layoutconstraint2.constant=maxphotoheight/2;
        PhotoCornerFileRecord *obj1=[classphotoobject.filearray objectAtIndex:0];
        PhotoCornerFileRecord *obj2=[classphotoobject.filearray objectAtIndex:1];
        PhotoCornerFileRecord *obj3=[classphotoobject.filearray objectAtIndex:2];
        PhotoCornerFileRecord *obj4=[classphotoobject.filearray objectAtIndex:3];
        [MyClass downloadImageWithImageview:cell.imageview2 gender:nil type:@"class" typekey:obj1.thumbnailurl image:@"Yes" async:YES];
        [MyClass downloadImageWithImageview:cell.imageview3 gender:nil type:@"class" typekey:obj2.thumbnailurl image:@"Yes" async:YES];
        [MyClass downloadImageWithImageview:cell.imageview4 gender:nil type:@"class" typekey:obj3.thumbnailurl image:@"Yes" async:YES];
        [MyClass downloadImageWithImageview:cell.imageview5 gender:nil type:@"class" typekey:obj4.thumbnailurl image:@"Yes" async:YES];
        
        cell.imageview7.hidden=![obj1.filetype isEqualToString:@"video"];
        cell.imageview8.hidden=![obj2.filetype isEqualToString:@"video"];
        cell.imageview9.hidden=![obj3.filetype isEqualToString:@"video"];
        cell.imageview10.hidden=![obj4.filetype isEqualToString:@"video"];
        
        cell.button4.tag=0;
        [cell.button4 addTarget:self action:@selector(showfullscreen:) forControlEvents:UIControlEventTouchUpInside];
        cell.button5.tag=1;
        [cell.button5 addTarget:self action:@selector(showfullscreen:) forControlEvents:UIControlEventTouchUpInside];
        cell.button6.tag=2;
        [cell.button6 addTarget:self action:@selector(showfullscreen:) forControlEvents:UIControlEventTouchUpInside];
        cell.button7.tag=3;
        [cell.button7 addTarget:self action:@selector(showfullscreen:) forControlEvents:UIControlEventTouchUpInside];

    }else if (classphotoobject.filearray.count>=5){
        cell.stackview1.hidden=NO;
        cell.view1.hidden=NO;
        cell.view2.hidden=NO;

        cell.layoutconstraint1.constant=maxphotoheight;
        cell.layoutconstraint2.constant=maxphotoheight*2/5;
        PhotoCornerFileRecord *obj1=[classphotoobject.filearray objectAtIndex:0];
        PhotoCornerFileRecord *obj2=[classphotoobject.filearray objectAtIndex:1];
        PhotoCornerFileRecord *obj3=[classphotoobject.filearray objectAtIndex:2];
        PhotoCornerFileRecord *obj4=[classphotoobject.filearray objectAtIndex:3];
        PhotoCornerFileRecord *obj5=[classphotoobject.filearray objectAtIndex:4];
        [MyClass downloadImageWithImageview:cell.imageview2 gender:nil type:@"class" typekey:obj1.thumbnailurl image:@"Yes" async:YES];
        [MyClass downloadImageWithImageview:cell.imageview3 gender:nil type:@"class" typekey:obj2.thumbnailurl image:@"Yes" async:YES];
        [MyClass downloadImageWithImageview:cell.imageview4 gender:nil type:@"class" typekey:obj3.thumbnailurl image:@"Yes" async:YES];
        [MyClass downloadImageWithImageview:cell.imageview5 gender:nil type:@"class" typekey:obj4.thumbnailurl image:@"Yes" async:YES];
        [MyClass downloadImageWithImageview:cell.imageview6 gender:nil type:@"class" typekey:obj5.thumbnailurl image:@"Yes" async:YES];
        
        cell.imageview7.hidden=![obj1.filetype isEqualToString:@"video"];
        cell.imageview8.hidden=![obj2.filetype isEqualToString:@"video"];
        cell.imageview9.hidden=![obj3.filetype isEqualToString:@"video"];
        cell.imageview10.hidden=![obj4.filetype isEqualToString:@"video"];
        cell.imageview11.hidden=![obj5.filetype isEqualToString:@"video"];
        
        if(classphotoobject.filearray.count>5){
            cell.view3.hidden=NO;
            cell.label6.text=[NSString stringWithFormat:@"+%lu",classphotoobject.filearray.count-4];
        }else{
            cell.view3.hidden=YES;
        }
        
        cell.button4.tag=0;
        [cell.button4 addTarget:self action:@selector(showfullscreen:) forControlEvents:UIControlEventTouchUpInside];
        cell.button5.tag=1;
        [cell.button5 addTarget:self action:@selector(showfullscreen:) forControlEvents:UIControlEventTouchUpInside];
        cell.button6.tag=2;
        [cell.button6 addTarget:self action:@selector(showfullscreen:) forControlEvents:UIControlEventTouchUpInside];
        cell.button7.tag=3;
        [cell.button7 addTarget:self action:@selector(showfullscreen:) forControlEvents:UIControlEventTouchUpInside];
        cell.button8.tag=4;
        [cell.button8 addTarget:self action:@selector(showfullscreen:) forControlEvents:UIControlEventTouchUpInside];
        

    }
        
        
        cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    /*}else if (tableView==ClassPhotoTable) {
        //add switch, label and button
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cellbackgroundview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, classphototablewidth, 300)];
            cellbackgroundview.backgroundColor=[UIColor whiteColor];
            cellbackgroundview.tag=107;
            [cell.contentView addSubview:cellbackgroundview];
            
            takenbyimage=[[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 46, 46)];
            takenbyimage.layer.cornerRadius=takenbyimage.frame.size.width/2;
            takenbyimage.layer.masksToBounds=YES;
            [MyClass downloadImageWithImageview:takenbyimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.launchimage_landscape image:@"Yes" async:YES];
            //[takenbyimage setImage:[UIImage imageWithData:globalvariables.menuimagedata]];
            takenbyimage.contentMode=UIViewContentModeScaleAspectFill;
            takenbyimage.backgroundColor=[UIColor lightGrayColor];
            takenbyimage.tag=105;
            [cell.contentView addSubview:takenbyimage];
            
            takenbylabel = [[UILabel alloc]initWithFrame:CGRectMake(takenbyimage.frame.origin.x+takenbyimage.frame.size.width+10, takenbyimage.frame.origin.y+5, classphototablewidth-35-45, takenbyimage.frame.size.height/2)];
            takenbylabel.font=[UIFont boldSystemFontOfSize:14];
            takenbylabel.minimumScaleFactor=0.7;
            takenbylabel.adjustsFontSizeToFitWidth=YES;
            takenbylabel.textColor=[UIColor darkGrayColor];
            takenbylabel.text=globalvariables.centerrecord.centershortname_english;
            takenbylabel.tag=106;
            [cell.contentView addSubview:takenbylabel];
            
            createdatetimelabel = [[UILabel alloc]initWithFrame:CGRectMake(takenbylabel.frame.origin.x, takenbylabel.frame.origin.y+takenbylabel.frame.size.height-5, takenbylabel.frame.size.width, takenbyimage.frame.size.height/2)];
            createdatetimelabel.font=[UIFont boldSystemFontOfSize:11];
            createdatetimelabel.textColor=[UIColor grayColor];
            createdatetimelabel.tag=100;
            [cell.contentView addSubview:createdatetimelabel];
            
            classphotoimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, classphototopmargin, ClassPhotoTable.frame.size.width, 45)];
            classphotoimage.contentMode=UIViewContentModeScaleAspectFill;
            classphotoimage.userInteractionEnabled=YES;
            classphotoimage.tag=101;
            
            UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhotoDetected:)];
            [tapped setNumberOfTapsRequired:1];
            [classphotoimage addGestureRecognizer:tapped];
            [cell.contentView addSubview:classphotoimage];
            
            titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 38, classphototablewidth-30, 200)];
            titlelabel.font=[UIFont systemFontOfSize:13];
            titlelabel.textColor=[UIColor blackColor];
            titlelabel.numberOfLines=0;
            titlelabel.tag=102;
            [cell.contentView addSubview:titlelabel];
            
            taglabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, classphototablewidth-30, 200)];
            taglabel.font=[UIFont italicSystemFontOfSize:12];
            taglabel.textColor=[UIColor lightGrayColor];
            taglabel.numberOfLines=0;
            taglabel.textAlignment=NSTextAlignmentLeft;
            taglabel.tag=103;
            [cell.contentView addSubview:taglabel];
            
            likelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, classphototablewidth-20, 200)];
            likelabel.font=[UIFont italicSystemFontOfSize:12];
            likelabel.textColor=[UIColor grayColor];
            likelabel.numberOfLines=0;
            likelabel.textAlignment=NSTextAlignmentLeft;
            likelabel.tag=115;
            [cell.contentView addSubview:likelabel];
            
            editclassphoto=[[UIButton alloc]initWithFrame:CGRectMake(classphototablewidth-30, 12.5, 20, 20)];
            editclassphoto.tag=104;
            [editclassphoto setImage:[UIImage imageNamed:@"edit_icon.png"] forState:UIControlStateNormal];
            [editclassphoto addTarget:self action:@selector(editclassphotopressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:editclassphoto];
            
            shareview=[[UIImageView alloc]init];
            [shareview setImage:[UIImage imageNamed:@"photosharebutton.png"]];
            shareview.tag=111;
            [cell.contentView addSubview:shareview];
            
            favouriteview=[[UIImageView alloc]init];
            favouriteview.tag=112;
            [cell.contentView addSubview:favouriteview];
            
            likeview=[[UIImageView alloc]init];
            likeview.tag=114;
            [cell.contentView addSubview:likeview];
            
            likebutton=[[UIButton alloc]init];
            likebutton.tag=113;
            [likebutton setTitle:[MyClass returntitlewithtitle:@"Like"] forState:UIControlStateNormal];
            likebutton.titleLabel.font=[UIFont systemFontOfSize:14];
            //[favouritebutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [likebutton addTarget:self action:@selector(likebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:likebutton];
            
            favouritebutton=[[UIButton alloc]init];
            favouritebutton.tag=109;
            [favouritebutton setTitle:[MyClass returntitlewithtitle:@"Favourite"] forState:UIControlStateNormal];
            favouritebutton.titleLabel.font=[UIFont systemFontOfSize:14];
            //[favouritebutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [favouritebutton addTarget:self action:@selector(favouritebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:favouritebutton];
            
            sharebutton=[[UIButton alloc]init];
            sharebutton.tag=110;
            [sharebutton setTitle:[MyClass returntitlewithtitle:@"Share"] forState:UIControlStateNormal];
            sharebutton.titleLabel.font=[UIFont systemFontOfSize:14];
            [sharebutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [sharebutton addTarget:self action:@selector(sharebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:sharebutton];
            
            separatorview=[[UIView alloc]init];
            separatorview.backgroundColor=[UIColor systemGroupedBackgroundColor];
            separatorview.tag=108;
            [cell.contentView addSubview:separatorview];
        }else{
            takenbyimage=(UIImageView *)[cell.contentView viewWithTag:105];
            takenbylabel=(UILabel *)[cell.contentView viewWithTag:106];
            cellbackgroundview=(UIView *)[cell.contentView viewWithTag:107];
            createdatetimelabel=(UILabel *)[cell.contentView viewWithTag:100];
            classphotoimage=(UIImageView *)[cell.contentView viewWithTag:101];
            titlelabel=(UILabel *)[cell.contentView viewWithTag:102];
            taglabel=(UILabel *)[cell.contentView viewWithTag:103];
            separatorview=(UIView *)[cell.contentView viewWithTag:108];
            favouritebutton=(UIButton *)[cell.contentView viewWithTag:109];
            sharebutton=(UIButton *)[cell.contentView viewWithTag:110];
            shareview=(UIImageView *)[cell.contentView viewWithTag:111];
            favouriteview=(UIImageView *)[cell.contentView viewWithTag:112];
            likebutton=(UIButton *)[cell.contentView viewWithTag:113];
            likeview=(UIImageView *)[cell.contentView viewWithTag:114];
            likelabel=(UILabel *)[cell.contentView viewWithTag:115];
        }
        
        // Configure the cell...
        
        classphotoobject=[ClassPhotoRecordArraySearchResult objectAtIndex:indexPath.row];
        
        takenbylabel.text=[MyClass returncentershortnamewithcenterkey:classphotoobject.centerkey];
        //createdatetimelabel.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:[MyClass convertYYYYMMDDHHMMtoDDMMMYYYYHHMMwithdate:[classphotoobject.filename substringToIndex:12]]];
        createdatetimelabel.text=[MyClass returnreplacedtitlewithtitle:@"Published by %@1 on %@2" replacementarray:@[[MyClass returnstaffnamewithusername:classphotoobject.takenby firstorfullname:@"full"],[MyClass returndateformatDDMMMYYYYHHMMwithdate:[MyClass convertYYYYMMDDHHMMtoDDMMMYYYYHHMMwithdate:[classphotoobject.filename substringToIndex:12]]]]];
        
        //retrieve center image
        
        [MyClass downloadImageWithImageview:takenbyimage gender:nil type:@"centerimage" typekey:((CenterRecord *)[MyClass returncenterrecordwithcenterkey:classphotoobject.centerkey]).launchimage_landscape image:@"Yes" async:YES];

        
        CGFloat lastposition=60;
        
        titlelabel.text=classphotoobject.title;
        if (![classphotoobject.title isEqualToString:@""]) {
            
            [titlelabel sizeToFit];
            titlelabel.frame=CGRectMake(10, lastposition, classphototablewidth-20, titlelabel.frame.size.height);
            lastposition=titlelabel.frame.origin.y+titlelabel.frame.size.height+5;
        }
        
        if (![classphotoobject.tag isEqualToString:@""]) {
            if ([[classphotoobject.tag substringToIndex:1] isEqualToString:@"#"]){
                taglabel.text=classphotoobject.tag;
            }else{
                taglabel.text=[NSString stringWithFormat:@"#%@",classphotoobject.tag];
            }
            [taglabel sizeToFit];
            taglabel.frame=CGRectMake(10, lastposition, classphototablewidth-20, taglabel.frame.size.height);
            lastposition=taglabel.frame.origin.y+taglabel.frame.size.height+5;
        }else{
            taglabel.text=@"";
        }
        
        
        if ([classphotoobject.height floatValue]/[classphotoobject.width floatValue]*classphototablewidth>maxphotoheight) {
            photoheight=maxphotoheight;
        }else{
            photoheight=[classphotoobject.height floatValue]/[classphotoobject.width floatValue]*classphototablewidth;
        }
        
        
        [MyClass downloadImageWithImageview:classphotoimage gender:nil type:@"classimage" typekey:classphotoobject.filename image:@"Yes" async:YES];
        
        //set photo height
        if ([classphotoobject.height floatValue]/[classphotoobject.width floatValue]*classphototablewidth>maxphotoheight) {
            classphotoimage.frame=CGRectMake((classphototablewidth-[classphotoobject.width floatValue]/[classphotoobject.height floatValue]*maxphotoheight)/2, lastposition+5, [classphotoobject.width floatValue]/[classphotoobject.height floatValue]*maxphotoheight, maxphotoheight);
        }else{
            classphotoimage.frame=CGRectMake(0, lastposition+5, classphototablewidth, [classphotoobject.height floatValue]/[classphotoobject.width floatValue]*classphototablewidth);
        }
        lastposition=classphotoimage.frame.origin.y+classphotoimage.frame.size.height+40;
        

        
        
        likelabel.frame=CGRectMake(10, lastposition-40, classphototablewidth-20, 40);
        likelabel.text=[self returnliketitlewithlikestring:classphotoobject.like];
        
        
        separatorview.frame=CGRectMake(5, lastposition, classphototablewidth-10, 1);
        
        
        if ([self favouritedphotowithfavouritestring:classphotoobject.favourite]) {
            [favouriteview setImage:[UIImage imageNamed:@"photofavouritebutton_red.png"]];
            [favouritebutton setTitleColor:[UIColor colorWithRed:176.0/255.0 green:36.0/255.0 blue:34.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        }else{
            [favouriteview setImage:[UIImage imageNamed:@"photofavouritebutton_gray.png"]];
            [favouritebutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        
        if ([self likedphotowithlikestring:classphotoobject.like]) {
            [likeview setImage:[UIImage imageNamed:@"photolikebutton_blue.png"]];
            [likebutton setTitleColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        }else{
            [likeview setImage:[UIImage imageNamed:@"photolikebutton_gray.png"]];
            [likebutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        
        [likebutton setFrame:CGRectMake(0, lastposition, classphototablewidth/3, 40)];
        [likebutton sizeToFit];
        likeview.frame=CGRectMake((classphototablewidth/3-likebutton.frame.size.width-30)/2, lastposition+10, 20, 20);
        [likebutton setFrame:CGRectMake(0, lastposition, classphototablewidth/3, 40)];
        likebutton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        
        
        [favouritebutton setFrame:CGRectMake(classphototablewidth/3, lastposition, classphototablewidth/3, 40)];
        [favouritebutton sizeToFit];
        favouriteview.frame=CGRectMake((classphototablewidth/3-favouritebutton.frame.size.width-30)/2+classphototablewidth/3, lastposition+10, 20, 20);
        [favouritebutton setFrame:CGRectMake(classphototablewidth/3, lastposition, classphototablewidth/3, 40)];
        favouritebutton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        
        
        [sharebutton setFrame:CGRectMake(classphototablewidth/3*2, lastposition, classphototablewidth/3, 40)];
        [sharebutton sizeToFit];
        shareview.frame=CGRectMake((classphototablewidth/3-sharebutton.frame.size.width-30)/2+classphototablewidth*2/3, lastposition+10, 20, 20);
        [sharebutton setFrame:CGRectMake(classphototablewidth/3*2, lastposition, classphototablewidth/3, 40)];
        sharebutton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        
        cellbackgroundview.frame=CGRectMake(0, 0, classphototablewidth, lastposition+40);
        
        if([classphotoobject.takenby isEqualToString:globalvariables.username]){
            editclassphoto.enabled=YES;
        }else{
            if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editothersphotocornerpost){
                editclassphoto.enabled=YES;
            }else{
                editclassphoto.enabled=NO;
            }
        }
    }
    cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;*/

}



-(void) likebuttonpressed:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:ClassPhotoTable];
    NSIndexPath *indexPath =[ClassPhotoTable indexPathForRowAtPoint:point];
    classphotoobject=[ClassPhotoRecordArraySearchResult objectAtIndex:indexPath.row];
    
    if ([self likedphotowithlikestring:classphotoobject.like]) {
        classphotoobject.like=[self likephotowithcenterkey:classphotoobject.centerkey classphotokey:classphotoobject.classphotokey action:@"unlike"];
    }else{
        classphotoobject.like=[self likephotowithcenterkey:classphotoobject.centerkey classphotokey:classphotoobject.classphotokey action:@"like"];
    }
    
    //[ClassPhotoTable reloadData];
    [ClassPhotoTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

-(void) favouritebuttonpressed:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:ClassPhotoTable];
    NSIndexPath *indexPath =[ClassPhotoTable indexPathForRowAtPoint:point];
    classphotoobject=[ClassPhotoRecordArraySearchResult objectAtIndex:indexPath.row];
    
    if ([self favouritedphotowithfavouritestring:classphotoobject.favourite]) {
        classphotoobject.favourite=[self favouritephotowithcenterkey:classphotoobject.centerkey classphotokey:classphotoobject.classphotokey action:@"unfavourite"];
    }else{
        classphotoobject.favourite=[self favouritephotowithcenterkey:classphotoobject.centerkey classphotokey:classphotoobject.classphotokey action:@"favourite"];
    }
    
    //[ClassPhotoTable reloadData];
    [ClassPhotoTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}


-(BOOL) likedphotowithlikestring:(NSString *)likestring
{
    NSArray *likearray=[[NSArray alloc]initWithArray:[likestring componentsSeparatedByString:@","]];
    if ([likearray containsObject:globalvariables.username]) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL) favouritedphotowithfavouritestring:(NSString *)favouritestring
{
    NSArray *favouritearray=[[NSArray alloc]initWithArray:[favouritestring componentsSeparatedByString:@","]];
    if ([favouritearray containsObject:globalvariables.username]) {
        return YES;
    }else{
        return NO;
    }
}


-(NSString *) returnliketitlewithlikestring:(NSString *)likestring
{
    if ([likestring isEqualToString:@""] || !likestring) {
        return @"";
    }else{
        NSArray *likearray=[[NSArray alloc]initWithArray:[likestring componentsSeparatedByString:@","]];
        if ([likearray containsObject:globalvariables.username]) {
            if (likearray.count==1) {
                return [MyClass returntitlewithtitle:@"You like it"];
            }else if (likearray.count==2){
                return [MyClass returntitlewithtitle:@"You and 1 other like it"];
            }else{
                return [NSString stringWithFormat:@"%@%lu%@",[MyClass returntitlewithtitle:@"You and"],(unsigned long)likearray.count-1,[MyClass returntitlewithtitle:@"others like it"]];
            }
        }else{
            if (likearray.count==1) {
                return [MyClass returntitlewithtitle:@"1 person likes it"];
            }else{
                return [NSString stringWithFormat:@"%lu%@",(unsigned long)likearray.count,[MyClass returntitlewithtitle:@"persons like it"]];
            }
        }
    }
}



-(NSString *) likephotowithcenterkey:(NSString *)centerkey classphotokey:(NSString *)classphotokey action:(NSString *)action
{
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *jsonlikeclassphotoarray=[[NSArray alloc]init];

    
    keys=[NSArray arrayWithObjects:@"centerdb",@"centerkey",@"classphotokey",@"username",@"action",nil];
    
    values=[NSArray arrayWithObjects:globalvariables.centerrecord.centerdb,centerkey,classphotokey,globalvariables.username,action,nil];
    
    dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    [arrayOfDicts addObject:dict];
    jsonlikeclassphotoarray = [NSArray arrayWithArray:arrayOfDicts];
    
    //combine arrays
    NSDictionary *dictionary = @{@"likeclassphotoinformation" : jsonlikeclassphotoarray,
                                 @"postaction" : @"likeclassphoto"};
    
    __block BOOL result=FALSE;
    __block NSMutableArray *likeusernamearray=[[NSMutableArray alloc]init];
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *jsonArray = jsonreturned[@"content"];
            
            for (int i=0; i<jsonArray.count; i++) {
                NSString * username=[[jsonArray objectAtIndex:i] objectForKey:@"username"];
                [likeusernamearray addObject:username];
            }
        }
    }];
    
    /*NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:finalData];
    
    __block BOOL result=FALSE;
    __block NSMutableArray *likeusernamearray=[[NSMutableArray alloc]init];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!error) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *jsonArray = jsonreturned[@"content"];
            
            for (int i=0; i<jsonArray.count; i++) {
                NSString * username=[[jsonArray objectAtIndex:i] objectForKey:@"username"];
                [likeusernamearray addObject:username];
            }
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        return [likeusernamearray componentsJoinedByString:@","];
    }else{
        return @"";
    }
}

-(NSString *) favouritephotowithcenterkey:(NSString *)centerkey classphotokey:(NSString *)classphotokey action:(NSString *)action
{
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *jsonfavouriteclassphotoarray=[[NSArray alloc]init];

    
    keys=[NSArray arrayWithObjects:@"centerdb",@"centerkey",@"classphotokey",@"username",@"action",nil];
    
    values=[NSArray arrayWithObjects:globalvariables.centerrecord.centerdb,centerkey,classphotokey,globalvariables.username,action,nil];
    
    dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    [arrayOfDicts addObject:dict];
    jsonfavouriteclassphotoarray = [NSArray arrayWithArray:arrayOfDicts];
    
    //combine arrays
    NSDictionary *dictionary = @{@"favouriteclassphotoinformation" : jsonfavouriteclassphotoarray,
                                 @"postaction" : @"favouriteclassphoto"};
    
    __block BOOL result=FALSE;
    __block NSMutableArray *favouriteusernamearray=[[NSMutableArray alloc]init];
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *jsonArray = jsonreturned[@"content"];
            
            for (int i=0; i<jsonArray.count; i++) {
                NSString * username=[[jsonArray objectAtIndex:i] objectForKey:@"username"];
                [favouriteusernamearray addObject:username];
            }
        }
    }];
    
    /*
    NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:finalData];
    
    __block BOOL result=FALSE;
    __block NSMutableArray *favouriteusernamearray=[[NSMutableArray alloc]init];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!error) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *jsonArray = jsonreturned[@"content"];
            
            for (int i=0; i<jsonArray.count; i++) {
                NSString * username=[[jsonArray objectAtIndex:i] objectForKey:@"username"];
                [favouriteusernamearray addObject:username];
            }
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        return [favouriteusernamearray componentsJoinedByString:@","];
    }else{
        return @"";
    }
}

-(void) sharebuttonpressed:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:ClassPhotoTable];
    NSIndexPath *indexPath =[ClassPhotoTable indexPathForRowAtPoint:point];
    classphotoobject=[ClassPhotoRecordArraySearchResult objectAtIndex:indexPath.row];
    
    NSMutableArray *activityItems=[[NSMutableArray alloc]init];
    for (int i=0; i<classphotoobject.filearray.count; i++) {
        PhotoCornerFileRecord *obj=[classphotoobject.filearray objectAtIndex:i];
        
        if (![obj.filetype isEqualToString:@"image"]) {
            NSURL *url = [MyClass returndownloadImageURLwithType:obj.downloadfiletype typekey:obj.fileurl];
            NSData *pdfdata=[[NSData alloc]initWithContentsOfURL:url];
            
            NSURL *fileUrl=[MyClass returnInternalURLforNSData:pdfdata Filename:obj.filename];
            [activityItems addObject:fileUrl];
        }else{
            NSURL *url = [MyClass returndownloadImageURLwithType:obj.downloadfiletype typekey:obj.fileurl];
            NSData *imagedata=[[NSData alloc]initWithContentsOfURL:url];
            NSURL *fileUrl=[MyClass returnInternalURLforNSData:imagedata Filename:obj.filename];
            //UIImage * image=[UIImage imageWithData:imagedata];
            [activityItems addObject:fileUrl];
        }
    }
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        activityVC.modalPresentationStyle=UIModalPresentationPopover;
        mypopovercontroller=activityVC.popoverPresentationController;
        //mypopovercontroller.delegate=self;
        mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
        mypopovercontroller.sourceView=sender;
        mypopovercontroller.sourceRect=sender.bounds;
        
        [self presentViewController:activityVC animated:TRUE completion:nil];
}



-(void) showfullscreen:(UIButton *)sender
{
    CGPoint point = [sender convertPoint:CGPointZero toView:ClassPhotoTable];
     NSIndexPath *indexPath = [ClassPhotoTable indexPathForRowAtPoint:point];
    
    classphotoobject=[ClassPhotoRecordArraySearchResult objectAtIndex:indexPath.row];

    fullscreenphotoviewcontroller.index=sender.tag;
    fullscreenphotoviewcontroller.mode=@"View";
    fullscreenphotoviewcontroller.fileArray=classphotoobject.filearray;
    [self presentViewController:fullscreenphotoviewcontroller animated:YES completion: nil];
}

-(void) searchbuttonpressed
{
    [UIView animateWithDuration:0.3 animations:^{
        searchbarview.frame=CGRectMake(0, 0, [self visibleClassPhotoWidth], 68);
    }];
    [search_text becomeFirstResponder];
}

-(void) search_cancel
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        searchbarview.frame=CGRectMake(0, -68, [self visibleClassPhotoWidth], 68);
    }];
    
    [search_favouritebutton setImage:[UIImage imageNamed:@"photofavouritebutton_white.png"] forState:UIControlStateNormal];
    ClassPhotoRecordArraySearchResult=[[NSMutableArray alloc]initWithArray:ClassPhotoRecordArray];
    [ClassPhotoTable reloadData];
    
    if (search_favouritebutton.tag==1 || ![search_text.text isEqualToString:@""]) {
        [ClassPhotoTable setContentOffset:CGPointZero animated:YES];
    }
    search_favouritebutton.tag=0;
    search_text.text=@"";
    
    
    if (ClassPhotoRecordArraySearchResult.count==0) {
        norecordtitle.hidden=NO;
    }else{
        norecordtitle.hidden=YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self search_cancel];
}

-(void) search_favouritepressed
{
    [self.view endEditing:YES];
    if (search_favouritebutton.tag==0) {
        search_favouritebutton.tag=1;
        [search_favouritebutton setImage:[UIImage imageNamed:@"photofavouritebutton_red.png"] forState:UIControlStateNormal];
    }else{
        search_favouritebutton.tag=0;
        [search_favouritebutton setImage:[UIImage imageNamed:@"photofavouritebutton_white.png"] forState:UIControlStateNormal];
    }
    
    NSPredicate *predicate;
    if (![search_text.text isEqualToString:@""]) {
        if (search_favouritebutton.tag==1) {
            predicate = [NSPredicate predicateWithFormat:@"(SELF.title contains[c] %@ or SELF.tag contains[c] %@) and self.favourite contains [c] %@",search_text.text,search_text.text,globalvariables.username];
        }else{
            predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@ or SELF.tag contains[c] %@",search_text.text,search_text.text];
        }
        ClassPhotoRecordArraySearchResult= [NSMutableArray arrayWithArray:[ClassPhotoRecordArray filteredArrayUsingPredicate:predicate]];
    }else{
        if (search_favouritebutton.tag==1) {
            predicate = [NSPredicate predicateWithFormat:@"self.favourite contains [c] %@", globalvariables.username];
            
            ClassPhotoRecordArraySearchResult= [NSMutableArray arrayWithArray:[ClassPhotoRecordArray filteredArrayUsingPredicate:predicate]];
        }else{
            ClassPhotoRecordArraySearchResult=[[NSMutableArray alloc]initWithArray:ClassPhotoRecordArray];
        }
    }
    
    [ClassPhotoTable reloadData];
    [ClassPhotoTable setContentOffset:CGPointZero animated:YES];
    
    if (ClassPhotoRecordArraySearchResult.count==0) {
        norecordtitle.hidden=NO;
    }else{
        norecordtitle.hidden=YES;
    }
}

-(void) updatesearchtext
{
    NSPredicate *predicate;
    if ([search_text.text isEqualToString:@""]) {
        if (search_favouritebutton.tag==1) {
            predicate = [NSPredicate predicateWithFormat:@"self.favourite contains [c] %@", globalvariables.username];
            ClassPhotoRecordArraySearchResult= [NSMutableArray arrayWithArray:[ClassPhotoRecordArray filteredArrayUsingPredicate:predicate]];
        }else{
            ClassPhotoRecordArraySearchResult=[[NSMutableArray alloc]initWithArray:ClassPhotoRecordArray];
        }
    }else{
        if (search_favouritebutton.tag==1) {
            predicate = [NSPredicate predicateWithFormat:@"(SELF.title contains[c] %@ or SELF.tag contains[c] %@) and self.favourite contains [c] %@",search_text.text,search_text.text,globalvariables.username];
        }else{
            predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@ or SELF.tag contains[c] %@",search_text.text,search_text.text];
        }
        ClassPhotoRecordArraySearchResult= [NSMutableArray arrayWithArray:[ClassPhotoRecordArray filteredArrayUsingPredicate:predicate]];
    }
    
    
    [ClassPhotoTable reloadData];
    [ClassPhotoTable setContentOffset:CGPointZero animated:YES];
    
    if (ClassPhotoRecordArraySearchResult.count==0) {
        norecordtitle.hidden=NO;
    }else{
        norecordtitle.hidden=YES;
    }
}

-(void) editclassphotopressed:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:ClassPhotoTable];
    NSIndexPath *indexPath =[ClassPhotoTable indexPathForRowAtPoint:point];
    
    classphotoobject=[ClassPhotoRecordArraySearchResult objectAtIndex:indexPath.row];
    
    [self showclassphotopopoverviewwithclassphotorecord:classphotoobject mode:@"edit"];

}



-(void) addclassphotofromsource:(NSString *)source
{
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([source isEqualToString:@"document"]) {
            //        UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"com.adobe.pdf"] inMode:UIDocumentPickerModeImport];
            UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initForOpeningContentTypes:@[UTTypePDF] asCopy:YES];
            documentPicker.delegate = self;
            documentPicker.modalPresentationStyle = UIModalPresentationPopover;
            mypopovercontroller=documentPicker.popoverPresentationController;
            mypopovercontroller.delegate=self;
            mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
            mypopovercontroller.sourceView=addclassphotobutton;
            mypopovercontroller.sourceRect=addclassphotobutton.bounds;
            
            [self presentViewController:documentPicker animated:YES completion:^{
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            }];
            
            
        }else{
            imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.delegate = self;
            imagepicker.allowsEditing=NO;
            
            if ([source isEqualToString:@"photocamera"]) {
                imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagepicker.modalPresentationStyle = UIModalPresentationFullScreen;
                imagepicker.view.tag=0;
                [MyClass presentViewController:imagepicker View:self];
            }else if ([source isEqualToString:@"photolibrary"]){
                //imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                if ([mypopovercontroller presentingViewController].isBeingPresented) {
                    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
                }
                
                BSImagePickerViewController *bspicker=[[BSImagePickerViewController alloc]init];
                bspicker.modalPresentationStyle=UIModalPresentationPopover;
                mypopovercontroller=bspicker.popoverPresentationController;
                mypopovercontroller.delegate=self;
                mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
                mypopovercontroller.sourceView=addclassphotobutton;
                mypopovercontroller.sourceRect=addclassphotobutton.bounds;
                
                [self bs_presentImagePickerController:bspicker animated:YES select:nil deselect:nil cancel:^(NSArray<PHAsset *> * array) {
                    [bspicker dismissViewControllerAnimated:YES completion:nil];
                } finish:^(NSArray<PHAsset *> * array) {
                    
                    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        __block BOOL fileexceedsize=FALSE;
                        for (int i=0;i<array.count;i++) {
                            PHAsset *asset=[array objectAtIndex:i];
                            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                            options.synchronous = YES;
                            options.networkAccessAllowed=YES;
                            [[PHImageManager defaultManager] requestImageDataAndOrientationForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
                                if (imageData) {
                                    if (![MyClass isPDFSizeNotExceedLimitWithData:imageData]) {
                                        fileexceedsize=TRUE;
                                    }else{
                                        UIImage *image=[[UIImage alloc]initWithData:imageData];
                                        imageData = UIImageJPEGRepresentation(image, 1.0);
                                        NSURL *imageURL=[MyClass returnInternalURLforNSData:imageData Filename:@"image"];
                                        [workingClassPhoto.filearray addObject:[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:workingClassPhoto.centerkey PhotoCornerFileKey:nil FileURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.height Height:image.size.height FileType:@"image" InternalURL:imageURL FileName:@"" ThumbnailURL:@"" Action:@"Add" DownloadFileType:@"class"  title:@""]];
                                    }
                                }
                            }];
                        }
                        
                        [MyClass loadingindicatorwithoption:@"stop" color:@""];
                        
                        [bspicker dismissViewControllerAnimated:YES completion:^{
                            if (fileexceedsize) {
                                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Image"] message:[MyClass returnreplacedtitlewithtitle:@"File cannot exceed %@1MB limit" replacementarray:@[[@(globalvariables.centerrecord.maxuploadfilesize) stringValue]]] preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                                }];
                                
                                [erroralert addAction:OKAction];
                                [self presentViewController:erroralert animated:YES completion:nil];
                            }else{
                                [self showclassphotopopoverviewwithclassphotorecord:workingClassPhoto mode:@"add"];
                            }
                        }];
                    });
                } completion:^{
                    [MyClass loadingindicatorwithoption:@"stop" color:@""];
                } selectLimitReached:nil];
                
            }else if ([source isEqualToString:@"videocamera"]) {
                imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagepicker.modalPresentationStyle = UIModalPresentationFullScreen;
                //            imagepicker.mediaTypes = @[(NSString *)kUTTypeMovie];
                imagepicker.mediaTypes = @[
                    @"public.movie"
                ];
                imagepicker.view.tag=1;
                [MyClass presentViewController:imagepicker View:self];
            }else if ([source isEqualToString:@"videolibrary"]){
                //            imagepicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
                imagepicker.mediaTypes = @[
                    @"public.movie",
                    @"public.video",
                    @"com.apple.quicktime-movie" // or @"public.mpeg" depending on your exact needs
                ];
                imagepicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
                
                if ([mypopovercontroller presentingViewController].isBeingPresented) {
                    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
                }
                
                imagepicker.modalPresentationStyle=UIModalPresentationPopover;
                imagepicker.view.tag=1;
                mypopovercontroller=imagepicker.popoverPresentationController;
                mypopovercontroller.delegate=self;
                mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
                mypopovercontroller.sourceView=addclassphotobutton;
                mypopovercontroller.sourceRect=addclassphotobutton.bounds;
                
                [self presentViewController:imagepicker animated:YES completion:nil];
            }
        }
    });
}

-(void) adjusttablesize
{

}

-(void) closesidewindow
{
    [self adjustpresentingviewwidthwithwidth:0];
    //[ClassPhotoTable deselectRowAtIndexPath:[ClassPhotoTable indexPathForSelectedRow] animated:YES];
    
    
}

-(void) startsidewindowanimationwithwidth:(float)width
{
    ailoadindicator.hidden=NO;
    ailoadindicator.center = CGPointMake(width/2-7.5,mainWindow.frame.size.height/2-7.5);
    [ailoadindicator startAnimating];
    [self adjustpresentingviewwidthwithwidth:width];
}

-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width
{
    CGRect visible = [self visibleWindowFrame];
    CGFloat edge = CGRectGetMaxX(visible);
    CGFloat panelY = visible.origin.y;
    CGFloat panelHeight = visible.size.height;
    if (edge < 1) {
        edge = mainWindow.bounds.size.width;
        panelY = 0;
        panelHeight = mainWindow.bounds.size.height;
    }
    CGFloat panelWidth = width > 0 ? MIN(width, visible.size.width > 1 ? visible.size.width : edge) : 0;
    BOOL alreadyClosed = ailoadindicator.hidden && sidewindowview.frame.size.width < 1 && fabs(sidewindowview.frame.origin.x - edge) < 1;
    if (alreadyClosed) {
        return;
    }
    if (fabs(sidewindowview.frame.origin.x - (edge - panelWidth)) < 1 && fabs(sidewindowview.frame.size.width - panelWidth) < 1 && fabs(sidewindowview.frame.size.height - panelHeight) < 1) {
        return;
    }
    if (width>0 && sidewindowview.frame.size.width < 1) {
        [MyClass playsoundwithoption:@"open"];
    }
    if (visible.size.width > 1) {
        sidewindowviewclosebutton.frame = visible;
    }
    sideWindowAdjusting = YES;
    [UIView animateWithDuration:0.25f animations:^{
        sidewindowview.hidden = width<=0;
        sidewindowview.frame=CGRectMake(edge-panelWidth, panelY, panelWidth, panelHeight);
        for (UIView *panelChild in sidewindowview.subviews) {
            if ([panelChild isKindOfClass:[UIActivityIndicatorView class]]) {
                continue;
            }
            panelChild.frame = sidewindowview.bounds;
        }
        if (width==0 && sidewindowview.frame.origin.x< edge) {
            [MyClass playsoundwithoption:@"close"];
        }
    } completion:^(BOOL finished){
        sideWindowAdjusting = NO;
        if (width > 0) {
            [self pinOpenSideWindowToVisibleEdge];
        }
        if (width==0) {
            sidewindowview.hidden=YES;
            NSArray *viewcontrollers=self.childViewControllers;
            for (int i=0; i<viewcontrollers.count; i++) {
                UIViewController *viewcontroller=viewcontrollers[i];
                [viewcontroller willMoveToParentViewController:nil];
                [viewcontroller.view removeFromSuperview];
                [viewcontroller removeFromParentViewController];
            }
            for (id object in [sidewindowview subviews]) {
                if (![object isKindOfClass:[UIActivityIndicatorView class]]) {
                    [object removeFromSuperview];
                }
            }
        }
    }];
    sidewindowviewclosebutton.hidden=width==0?YES:NO;
    
}

-(void) showclassphotopopoverviewwithclassphotorecord:(ClassPhotoRecord *)photoobject mode:(NSString *)mode
{
    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ClassPhotoPopoverViewController *classphotopopover = (ClassPhotoPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"ClassPhotoPopoverViewController"];
        classphotopopover.delegate=self;
        classphotopopover.classphotoobject=photoobject;
        classphotopopover.mode=mode;
        classphotopopover.view.frame=self->sidewindowview.bounds;
        [self->sidewindowview addSubview:classphotopopover.view];
        [self addChildViewController:classphotopopover];
        [classphotopopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
    
}

-(void) addclassphotobuttonpressed:(UIButton *)sender
{
    workingClassPhoto=[[ClassPhotoRecord alloc]init];
    workingClassPhoto.filearray=[[NSMutableArray alloc]init];
    [self addphotobuttonpressed:sender];
}

-(void) addphotobuttonpressed:(UIButton *)sender
{
    addclassphotobutton=sender;
    [self popupaddphotodialoguebox];
}

-(void) popupaddphotodialoguebox
{
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    NSMutableArray *ItemsArray=[[NSMutableArray alloc]init];
    if (hasCamera) {
//        if (globalvariables.centerrecord.enablevideomessage && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendvideomessage) {
            [ItemsArray addObject:@"Take Photo"];
            [ItemsArray addObject:@"Record Video"];
            [ItemsArray addObject:@"Photo Library"];
            [ItemsArray addObject:@"Video Library"];
            [ItemsArray addObject:@"Document"];
//        }else{
//            [ItemsArray addObject:@"Take Photo"];
//            [ItemsArray addObject:@"Photo Library"];
//            [ItemsArray addObject:@"Document"];
//        }
    }else{
//        if (globalvariables.centerrecord.enablevideomessage && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendvideomessage) {
            [ItemsArray addObject:@"Photo Library"];
            [ItemsArray addObject:@"Video Library"];
            [ItemsArray addObject:@"Document"];
//        }else{
//            [ItemsArray addObject:@"Photo Library"];
//            [ItemsArray addObject:@"Document"];
//        }
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"attachment" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 80) View:self Button:addclassphotobutton ItemsArray:ItemsArray Title:nil];

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    runviewdidappear=FALSE;
    //[imagepicker dismissViewControllerAnimated:YES completion:nil];
    
    
    if (picker.view.tag==1) {
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
//        NSData *videoData = [[NSData alloc]initWithContentsOfURL:videoURL];
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSData *videoData=[MyClass compressVideoSynchronouslyWithURL:videoURL error:nil];
        if (![MyClass isPDFSizeNotExceedLimitWithData:videoData]) {
            [picker dismissViewControllerAnimated:NO completion:^{
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Video"] message:[MyClass returnreplacedtitlewithtitle:@"File cannot exceed %@1MB limit" replacementarray:@[[@(globalvariables.centerrecord.maxuploadfilesize) stringValue]]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
            }];
        }else{
            
                UIImage *image=[MyClass getThumbnailImageFromVideo:videoURL];
                [workingClassPhoto.filearray addObject:[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:globalvariables.centerrecord.centerkey PhotoCornerFileKey:nil FileURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.height Height:image.size.height FileType:@"video" InternalURL:videoURL FileName:@"" ThumbnailURL:@"" Action:@"Add" DownloadFileType:@"class" title:@""]];

                
                [picker dismissViewControllerAnimated:YES completion:nil];
//                NSRange range = NSMakeRange(2,1);
//                NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
//                [editTable reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [self showclassphotopopoverviewwithclassphotorecord:workingClassPhoto mode:@"add"];
            
        }
            [MyClass loadingindicatorwithoption:@"stop" color:@""];
        });
    }else{
        UIImage *image=info[UIImagePickerControllerOriginalImage];
        NSData *imageData;
        if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
            imageData = UIImageJPEGRepresentation(image, 1.0);
        } else {
            if (@available(iOS 11.0, *)) {
                imageData = [NSData dataWithContentsOfURL:info[UIImagePickerControllerImageURL]];
            } else {
                imageData = UIImageJPEGRepresentation(image, 1.0);
            }
        }
        if (![MyClass isPDFSizeNotExceedLimitWithData:imageData]) {
            [picker dismissViewControllerAnimated:NO completion:^{
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Image"] message:[MyClass returnreplacedtitlewithtitle:@"File cannot exceed %@1MB limit" replacementarray:@[[@(globalvariables.centerrecord.maxuploadfilesize) stringValue]]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
            }];
        }else{
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //UIImage *image=info[UIImagePickerControllerOriginalImage];
                //image=[MyClass resizeImageWithImage:image ForSize:image.size];
                NSURL *imageURL=[MyClass returnInternalURLforNSData:imageData Filename:@"image"];
                [workingClassPhoto.filearray addObject:[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:globalvariables.centerrecord.centerkey PhotoCornerFileKey:nil FileURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.height Height:image.size.height FileType:@"image" InternalURL:imageURL FileName:@"" ThumbnailURL:@"" Action:@"Add" DownloadFileType:@"class" title:@""]];
                
                [picker dismissViewControllerAnimated:YES completion:nil];
//                NSRange range = NSMakeRange(2,1);
//                NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
//                [editTable reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
                [MyClass loadingindicatorwithoption:@"stop" color:@""];
                [self showclassphotopopoverviewwithclassphotorecord:workingClassPhoto mode:@"add"];
            });
        }
    }
}

//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    runviewdidappear=FALSE;
//    [imagepicker dismissViewControllerAnimated:YES completion:nil];
//    edit_ClassImage = info[UIImagePickerControllerOriginalImage];
//    edit_ClassImage=[MyClass resizeImageWithImage:edit_ClassImage ForSize:edit_ClassImage.size];
//
//    [self showclassphotopopoverviewwithclassphotorecord:nil mode:@"add"];
//}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //imagepicker.view.hidden=YES;
    runviewdidappear=FALSE;
    [[imagepicker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    //[[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    runviewdidappear=false;
    
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        if (controller.documentPickerMode == UIDocumentPickerModeImport) {
            NSData *chosendata=[[NSData alloc]initWithContentsOfURL:url];
            
            if (![MyClass isValidPDFWithData:chosendata]) {
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document"] message:[MyClass returntitlewithtitle:@"Invalid PDF file"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            }else if (![MyClass isPDFSizeNotExceedLimitWithData:chosendata]) {
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document"] message:[MyClass returnreplacedtitlewithtitle:@"File cannot exceed %@1MB limit" replacementarray:@[[@(globalvariables.centerrecord.maxuploadfilesize) stringValue]]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            }else{
                UIImage *chosenImage=[MyClass returnPDFFirstPageImageWithPDFData:chosendata];
                [workingClassPhoto.filearray addObject:[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:globalvariables.centerrecord.centerkey PhotoCornerFileKey:nil FileURL:nil ImageView:[[UIImageView alloc]initWithImage:chosenImage] Width:chosenImage.size.width Height:chosenImage.size.height FileType:@"pdf" InternalURL:url FileName:[url lastPathComponent] ThumbnailURL:@"" Action:@"Add" DownloadFileType:@"class" title:@""]];
                [self showclassphotopopoverviewwithclassphotorecord:workingClassPhoto mode:@"add"];
                
                
            }
        }
        
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}


-(void) donotrunviewdidappear
{
    runviewdidappear=FALSE;
}

//-(void) popupaddphotodialogueboxwithoption:(NSString *)option
//{
//    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"PhotoSource" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 80) View:self Button:addclassphotobutton ItemsArray:[[NSMutableArray alloc]initWithObjects:@"Take Photo",@"Photo Library", nil] Title:nil];
//}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"attachment"]){
        NSString *result=[selecteditems firstObject];

        if ([result isEqualToString:@"Take Photo"]) {
            [self addclassphotofromsource:@"photocamera"];
        }else if ([result isEqualToString:@"Photo Library"]){
            [self addclassphotofromsource:@"photolibrary"];
        }else if ([result isEqualToString:@"Document"]){
            [self addclassphotofromsource:@"document"];
        }else if ([result isEqualToString:@"Record Video"]) {
            [self addclassphotofromsource:@"videocamera"];
        }else if ([result isEqualToString:@"Video Library"]){
            [self addclassphotofromsource:@"videolibrary"];
        }
    }
}

//-(void) takephotobuttonpressed
//{
//    //[[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
//    [self addclassphotofromsource:@"camera"];
//}
//
//-(void) photolibrarybuttonpressed
//{
//    //[[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
//    [self addclassphotofromsource:@"library"];
//}

-(void) switchcenterbuttonpressed
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MyClass getLatestDataSetv2withParameters:@"" Centerkeys:@"" completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
            if (!nocenteravailable && !newupdateavailable) {
                dispatch_async(dispatch_get_main_queue(), ^{
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                switchcenterviewcontroller.modalPresentationStyle = UIModalPresentationFormSheet;
                switchcenterviewcontroller.singleselection=@"Yes";
                switchcenterviewcontroller.updatecenterkey=@"Yes";
                [self presentViewController:switchcenterviewcontroller animated:YES completion: nil];
                });
            }
        }];
    });
}

-(void) doneswitchcenterwithreload:(BOOL)reload centerkey:(NSString *)centerkey centerimage:(UIImage *)centerimage
{
    //[switchcenterviewcontroller dismissViewControllerAnimated:YES completion:nil];
    
    if (reload) {
        globalvariables.documentfolder.classreceiptarray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.salesreceiptarray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.classinvoicearray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.salesinvoicearray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.classpaymentarray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.salespaymentarray=[[NSMutableArray alloc]init];
        [MyClass retrievemenuimagewithasync:YES];
        [self reloadPageWithFirstLoad:NO];
        

        
    }
}
/*
-(void) refreshpage
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MyClass retrievemenuimagewithasync:YES];
        [MyClass retrievecenterimages];
        
        [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,subject,product,staff,classroom,marketing,centersettings,userroleandprivilege" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
        [MyClass LoadSchoolCalendarArray];
        
        [self refreshlanguage];
        [MyClass updatecenterkey];
        [self retrievePhotoRecord];
        
        
    });
}*/

-(void) closeFullScreenPhotoViewWithIndex:(NSInteger)index
{
    runviewdidappear=FALSE;
    //[ClassPhotoTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [fullscreenphotoviewcontroller dismissViewControllerAnimated:YES completion:nil];
}

-(void) reloadPageWithFirstLoad:(BOOL)firstload
{
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    if (!firstload) {
        /*if (!photofullscreenview.hidden) {
            [self closefullscreen];
        }else{*/
        //[self closeFullScreenPhotoViewWithIndex:0];
            //[self edit_cancel];
            [self search_cancel];
        //}
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        

        [MyClass getLatestDataSetv2withParameters:@"languagetitle,staff,centersettings,userroleandprivilege,arcode" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
            dispatch_async(dispatch_get_main_queue(), ^{
            if (newupdateavailable) {
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                return;
            }else if (nocenteravailable){
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                return;
            }else if (viewingcentersdeleted) {
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                [self switchcenterbuttonpressed];
            }else{
                    [MyClass updatecenterkey];
                    
                    addclassphotobutton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).publishinphotocorner;
                    
                    if ([MyClass enableviewwithsourceview:@"classphoto"]) {
                        addclassphotobutton.hidden=NO;
                    }else{
                        addclassphotobutton.hidden=YES;
                    }

                    [self refreshlanguage];
                    //if (!firstload) {
                        [self retrievePhotoRecord];
                        [ClassPhotoTable setContentOffset:CGPointZero animated:YES];
                    //}
                }
                });
                
            
        }];
        //});
    });
}

-(void) dismissClassPhotoPopoverVCWithReload:(BOOL)reload ScrollToTop:(BOOL)scrolltotop
{
    [self closesidewindow];
    if (reload) {
        [self retrievePhotoRecord];
    }
    
    if (scrolltotop) {
        [ClassPhotoTable setContentOffset:CGPointZero animated:YES];
    }
}


@end
