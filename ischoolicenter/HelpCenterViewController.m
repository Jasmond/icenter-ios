//
//  HelpCenterViewController.m
//  iCenter
//
//  Created by Jasmond Luk on 14/3/2022.
//  Copyright © 2022 DreamHigh Company Limited. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "MyTableViewCell.h"
#import "MainMenuViewController.h"
#import "UIViewController+AMSlideMenu.h"

@interface HelpCenterViewController ()

@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    globalvariables=[GlobalVariables singleObj];
    
    headertitleview=[[UIView alloc]initWithFrame:CGRectMake(70, 0, self.view.bounds.size.width-140, 68)];
    headertitlename=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, headertitleview.frame.size.width, 20)];
    headertitlename.font=[UIFont boldSystemFontOfSize:17];
    headertitlename.textColor=[UIColor whiteColor];
    headertitlename.textAlignment=NSTextAlignmentCenter;
    [headertitleview addSubview:headertitlename];
    [self.view addSubview:headertitleview];
    
    fullscreenphotoviewcontroller = (FullScreenPhotoViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"FullScreenPhotoViewController"];
    fullscreenphotoviewcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
    fullscreenphotoviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    fullscreenphotoviewcontroller.delegate=self;

    [self refreshlanguage];
    selectedCategoryRow=0;
    alphabetArray=[[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    runviewdidappear=TRUE;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    globalvariables.lastviewcontroller=(NSString *)self;
    
    if(runviewdidappear){
        [self getTrainingMaterial];
        [categoryTable reloadData];
        [self tableView:categoryTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [categoryTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else{
        runviewdidappear=TRUE;
    }
}

-(void) refreshlanguage
{
    headertitlename.text=[MyClass returntitlewithtitle:@"Help Center"];
}

- (IBAction)menubutton:(id)sender {
    [self.mainSlideMenu openLeftMenu];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==categoryTable) {
        return categoryArray.count;
    }else{
        return categoryArray.count==0?0:((TrainingCategory *)[categoryArray objectAtIndex:selectedCategoryRow]).itemrecords.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==categoryTable) {
        return [MyClass returnlogintitlewithtitle:@"Category"];
    }else{
        return [MyClass returnlogintitlewithtitle:@"Video Manual"];;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==categoryTable) {
        selectedCategoryRow=indexPath.row;
//        [categoryTable reloadData];
        [itemTable reloadData];
    }else{
        TrainingCategory *obj=[categoryArray objectAtIndex:selectedCategoryRow];
        TrainingItem *itemobj=[obj.itemrecords objectAtIndex:indexPath.row];
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            fullscreenphotoviewcontroller.index=0;
            fullscreenphotoviewcontroller.mode=@"View";
            SlidePhotoRecord *spobj=[[SlidePhotoRecord alloc]initSlidePhotoRecordwithcenterkey:@"" type:@"videomanual" typekey:@"" filename:itemobj.fileurl title:[MyClass returnlogintitlewithtitle:itemobj.title] postdate:@"" width:@"" height:@"" hn_expiry_date:@"" editable:NO filetype:itemobj.filetype thumbnailurl:@"" fileurl:itemobj.fileurl];
            NSMutableArray *fullscreenslidearray=[[NSMutableArray alloc]initWithObjects:spobj, nil];

            fullscreenphotoviewcontroller.fileArray=fullscreenslidearray;
            [self presentViewController:fullscreenphotoviewcontroller animated:YES completion: nil];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }
}

-(void) closeFullScreenPhotoViewWithIndex:(NSInteger)index
{
    runviewdidappear=FALSE;
    [fullscreenphotoviewcontroller dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cellView;
    if (tableView==categoryTable){
        
        static NSString *CellIdentifier = @"categoryCell";
        cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cellView == nil) {
            cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        TrainingCategory *obj=[categoryArray objectAtIndex:indexPath.row];
        cellView.label1.text=[NSString stringWithFormat:@"%@. %@",alphabetArray[indexPath.row],[MyClass returnlogintitlewithtitle:obj.category]];
        
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:cellView.frame];
        bgView.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
        cellView.selectedBackgroundView = bgView;
    }else{
        static NSString *CellIdentifier = @"itemCell";
        cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cellView == nil) {
            cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        TrainingCategory *obj=[categoryArray objectAtIndex:selectedCategoryRow];
        TrainingItem *itemobj=[obj.itemrecords objectAtIndex:indexPath.row];
        cellView.label1.text=[NSString stringWithFormat:@"%ld. %@",(long)indexPath.row+1,[MyClass returnlogintitlewithtitle:itemobj.title]];
    }
    return cellView;
}



-(void) getTrainingMaterial
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=gettrainingmaterial",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey];
    
    __block BOOL result=FALSE;
    __block NSMutableArray *JSONArray;

    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
        }
    }];
    
    if(result){
        categoryArray=[[NSMutableArray alloc]init];
        for (int i=0; i<JSONArray.count; i++) {
            NSString * category=[[JSONArray objectAtIndex:i] objectForKey:@"category"];
            NSArray * itemrecords=[[JSONArray objectAtIndex:i] objectForKey:@"itemrecords"];
            NSMutableArray *itemarray=[[NSMutableArray alloc]init];
            for (int j=0; j<itemrecords.count; j++) {
                NSString *title=[[itemrecords objectAtIndex:j] objectForKey:@"title"];
                NSString *fileurl=[[itemrecords objectAtIndex:j] objectForKey:@"fileurl"];
                NSString *filetype=[[itemrecords objectAtIndex:j] objectForKey:@"filetype"];
                [itemarray addObject:[[TrainingItem alloc]initTrainingItemwithTitle:title fileurl:fileurl filetype:filetype]];
            }
            [categoryArray addObject:[[TrainingCategory alloc]initTrainingCategorywithCategory:category itemrecords:itemarray]];
        }
    }
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
