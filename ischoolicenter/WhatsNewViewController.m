//
//  WhatsNewViewController.m
//  iCenter
//
//  Created by Jasmond Luk on 23/5/2020.
//  Copyright © 2020 DreamHigh Company Limited. All rights reserved.
//

#import "WhatsNewViewController.h"
#import "MyTableViewCell.h"
#import "SceneDelegate.h"

@interface WhatsNewViewController ()

@end

#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]

@implementation WhatsNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    globalvariables=[GlobalVariables singleObj];
    
//    mainWindow= [[[UIApplication sharedApplication] delegate] window];
    SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.anyObject.delegate;
    mainWindow = sceneDelegate.window;
    viewwidth=mainWindow.bounds.size.width*2.0/3.0;
    viewheight=viewwidth*3.0/4.0;
    
    self.preferredContentSize=CGSizeMake(viewwidth, viewheight);
    
    [closeButton setTitle:[MyClass returntitlewithtitle:@"Close"] forState:UIControlStateNormal];
    closeButton.layer.borderColor=themecolor.CGColor;
    closeButton.tintColor=themecolor;
    closeButton.backgroundColor=[UIColor whiteColor];
    closeButton.layer.borderWidth=1;
    closeButton.layer.cornerRadius=4;
    closeButton.layer.masksToBounds=YES;
    
    norecordlabel.text=[MyClass returntitlewithtitle:@"No Record"];
    
    UIImageView *activityImageView=[[UIImageView alloc]init];
    activityImageView.animationImages=[MyClass returnLoadingIndicatorAnimatedImageWithBaseColor:@"lightgray"];
    activityImageView.alpha=1.0;
    activityImageView.animationDuration=1.5;
    activityImageView.frame=CGRectMake(0,0,45,45);
    [activityImageView startAnimating];
    
    ailoadingindicator.alpha = 1.0;
    ailoadingindicator.color=[UIColor clearColor];
    ailoadingindicator.transform=CGAffineTransformMakeScale(1, 1);
    ailoadingindicator.hidesWhenStopped = YES;
    [ailoadingindicator addSubview:activityImageView];

    [ailoadingindicator startAnimating];
    
    fullscreenphotoviewcontroller = (FullScreenPhotoViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"FullScreenPhotoViewController"];
    fullscreenphotoviewcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
    fullscreenphotoviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    fullscreenphotoviewcontroller.delegate=self;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        [self getWhatsNew];
        [ailoadingindicator stopAnimating];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return whatsnewarray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell;
    static NSString *CellIdentifier= @"whatsnewcell";
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    WhatsNewRecord *object=[whatsnewarray objectAtIndex:indexPath.row];
    
    cell.label1.text=object.title;
    cell.label2.text=object.description;
    
    CGFloat imageheight=[object.imageheight floatValue]/[object.imagewidth floatValue]*(viewwidth-60);
    cell.layoutconstraint1.constant=imageheight;
    
    [MyClass downloadImageWithImageview:cell.imageview1 gender:nil type:@"whatsnew" typekey:object.imagefile image:@"Yes" async:YES];
    
    [cell.button1 addTarget:self action:@selector(photopressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.button1.tag=indexPath.row;
    
    if (indexPath.row%2==1) {
        cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
    }else{
        cell.backgroundColor=[UIColor whiteColor];
    }
    
    return cell;
}

-(void) photopressed:(UIButton *)button
{
    WhatsNewRecord *object=[whatsnewarray objectAtIndex:button.tag];
    if (![object.videourl isEqualToString:@""]) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            fullscreenphotoviewcontroller.index=0;
            fullscreenphotoviewcontroller.mode=@"View";
            SlidePhotoRecord *spobj=[[SlidePhotoRecord alloc]initSlidePhotoRecordwithcenterkey:@"" type:@"videomanual" typekey:@"" filename:object.videourl title:[MyClass returnlogintitlewithtitle:object.title] postdate:@"" width:@"" height:@"" hn_expiry_date:@"" editable:NO filetype:@"video" thumbnailurl:@"" fileurl:object.videourl];
            NSMutableArray *fullscreenslidearray=[[NSMutableArray alloc]initWithObjects:spobj, nil];

            fullscreenphotoviewcontroller.fileArray=fullscreenslidearray;
            [self presentViewController:fullscreenphotoviewcontroller animated:YES completion: nil];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }
}

-(void) closeFullScreenPhotoViewWithIndex:(NSInteger)index
{
//    runviewdidappear=FALSE;
    [fullscreenphotoviewcontroller dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closebuttonpressed:(id)sender {
    [self.delegate closewhatsnewwindowwithviewcontroller:self];
}

-(void) getWhatsNew
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getwhatsnew&platform=%@&os=%@&language=%@&build=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,@"iCenter",@"ios",[MyClass returnlanguagecode],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];

    __block BOOL result=FALSE;
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *JSONArray = jsonreturned[@"content"];
            whatsnewarray=[[NSMutableArray alloc]init];
            
            for (int i=0; i<JSONArray.count; i++) {
                NSString * cversion=[[JSONArray objectAtIndex:i] objectForKey:@"version"];
                NSString * ctitle=[[JSONArray objectAtIndex:i] objectForKey:@"title"];
                NSString * cdescription=[[JSONArray objectAtIndex:i] objectForKey:@"description"];
                NSString * cimagefile=[[JSONArray objectAtIndex:i] objectForKey:@"imagefile"];
                NSString * cimagewidth=[[JSONArray objectAtIndex:i] objectForKey:@"imagewidth"];
                NSString * cimageheight=[[JSONArray objectAtIndex:i] objectForKey:@"imageheight"];
                NSString * cvideourl=[[JSONArray objectAtIndex:i] objectForKey:@"videourl"];
                                         
                [whatsnewarray addObject:[[WhatsNewRecord alloc]initWhatsnewRecordwithversion:cversion title:ctitle description:cdescription imagefile:cimagefile imagewidth:cimagewidth imageheight:cimageheight videourl:cvideourl]];
            }
        }
    }];
    
    if (result) {
        if (whatsnewarray.count>0) {
            WhatsNewRecord *object=[whatsnewarray firstObject];
            titlelabel.text=[MyClass returnreplacedtitlewithtitle:@"What's new in %@1" replacementarray:@[object.version]];
        }else{
            titlelabel.text=[MyClass returntitlewithtitle:@"What's new"];
        }
        [whatsnewtable reloadData];
        
        norecordlabel.hidden=whatsnewarray.count>0;
    }

}
@end
