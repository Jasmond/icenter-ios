//
//  InstructorImageGridViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 28/10/2015.
//  Copyright © 2015 DreamHigh Company Limited. All rights reserved.
//

#import "InstructorImageGridViewController.h"
#import "InstructorGridCollectionViewCell.h"
#import "MyClass.h"

@implementation InstructorImageGridViewController
@synthesize instructorArray,mode,selectedinstructorarray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globalvariables=[GlobalVariables singleObj];
    
    filteredInstructorArray=[[NSMutableArray alloc]initWithArray:instructorArray];
    
    viewtitle.text=[MyClass returntitlewithtitle:@"Instructor"];
    [title_CancelButton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    [title_DoneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    
    df=[[NSDateFormatter alloc]init];df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    
    selectbutton=[[UIButton alloc]initWithFrame:CGRectMake(705, 31, 200, 33)];
    selectbutton.titleLabel.font = [UIFont systemFontOfSize: 17];
    selectbutton.contentHorizontalAlignment=NSTextAlignmentRight;
    [selectbutton setTitle:[MyClass returntitlewithtitle:@"Deselect all"] forState:UIControlStateNormal];
    selectbutton.tag=1;
    [selectbutton addTarget:self action:@selector(selectbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectbutton];
    
    if ([mode isEqualToString:@"multiple"]) {
        //checkimagearray=[[NSMutableArray alloc]init];
        for (int i=0; i<instructorArray.count; i++) {
            
            
            ((Instructor *)[instructorArray objectAtIndex:i]).photoalbumrecord=[[ClassValidateRecord alloc]initClassValidateRecordwithstatus:@"" classvalidatestatus:[[ClassValidateStatus alloc]init] classvalidmessage:[[ClassValidateMessage alloc]init] classkey:nil];
            
            
            if ([selectedinstructorarray containsObject:((Instructor *)[instructorArray objectAtIndex:i]).username] || [selectedinstructorarray containsObject:@"All"]) {
                ((ClassValidateRecord *)((Instructor *)[instructorArray objectAtIndex:i]).photoalbumrecord).status=@"Checked";
            }else{
                ((ClassValidateRecord *)((Instructor *)[instructorArray objectAtIndex:i]).photoalbumrecord).status=@"";
            }
        }
        selectbutton.hidden=NO;
    }else{
        title_DoneButton.hidden=YES;
        selectbutton.hidden=YES;
    }
    
    [instructorphotocollection reloadData];
    self.preferredContentSize=CGSizeMake(984, 738);
    
    
    instructorsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 68, self.preferredContentSize.width, 42)];
    instructorsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    instructorsearchbar.delegate=self;
    [self.view addSubview:instructorsearchbar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return filteredInstructorArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InstructorGridCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    instructorobject=[filteredInstructorArray objectAtIndex:indexPath.row];
    
    cell.instructornamelabel.text=[MyClass returninstructornamewithusername:instructorobject.username firstorfullname:@"full"];
    
    ////[MyClass downloadImageWithImageview:cell.instructorimage collectionview:collectionView indexpath:indexPath gender:@"Male" type:@"staff" typekey:instructorobject.staffkey image:@"No"];
    
    [MyClass downloadImageWithImageview:cell.instructorimage gender:@"Male" type:@"staff" typekey:instructorobject.staffkey image:@"Yes" async:YES];
    
    /*
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@staffimages/%@/staff_%@_%@.jpg",globalvariables.serverpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, instructorobject.staffkey]];
    
    if ([imageCache objectForKey:url]) {
        [cell.instructorimage setImage:[imageCache objectForKey:url]];
    }else{
        [cell.instructorimage setImage:boyimage];
    }
    
    [self checkifimagechangedwithURL:url studentimage:cell.instructorimage indexpath:indexPath completionBlock:^(BOOL imagechanged, NSURL *URL, UIImageView *stimage, NSIndexPath *stimageindexpath){
        if (imagechanged || ![imageCache objectForKey:URL]) {
            [self downloadImageWithURL:URL studentimage:stimage indexpath:stimageindexpath completionBlock:^(BOOL succeeded, NSData *data, UIImageView *simage, NSIndexPath *imageindexpath, NSURL *_url) {
                
                CGPoint point = [simage.superview convertPoint:CGPointZero toView:collectionView];
                NSIndexPath *indexpath =[collectionView indexPathForItemAtPoint:point];
                if ([collectionView.indexPathsForVisibleItems indexOfObject:imageindexpath] != NSNotFound && indexpath.row==imageindexpath.row)
                {
                    if (succeeded) {
                        if (imageindexpath) {
                            if ([[UIImage alloc] initWithData:data]) {
                                simage.image = [[UIImage alloc] initWithData:data];
                                [imageCache setObject:simage.image forKey:_url];
                            }
                        }
                    }
                }
            }];
        }
    }];*/
    
    cell.instructorimage.layer.cornerRadius=10;
    cell.instructorimage.layer.masksToBounds=YES;
    cell.informationbutton.userInteractionEnabled=NO;
    
    if ([mode isEqualToString:@"multiple"]) {
        
        photoalbumobject=((Instructor *)[filteredInstructorArray objectAtIndex:indexPath.row]).photoalbumrecord;
        if ([photoalbumobject.status isEqualToString:@"Checked"]) {
            [cell.informationbutton setImage:[UIImage imageNamed:@"checked_icon.png"] forState:UIControlStateNormal];
            cell.informationbutton.hidden=NO;
        }else{
            cell.informationbutton.hidden=YES;
        }
    }else{
        cell.informationbutton.hidden=YES;
    }
    return cell;
}





-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(154, 180+20+0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(46, 5, 20, 5);
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

/*
 - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
 {
 return UIInterfaceOrientationLandscapeRight;
 }*/

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([mode isEqualToString:@"multiple"]) {
        photoalbumobject=((Instructor *)[filteredInstructorArray objectAtIndex:indexPath.row]).photoalbumrecord;
        if (![photoalbumobject.status isEqualToString:@""]) {
            photoalbumobject.status=@"";
            //[selectedinstructorarray removeObject:((Instructor *)[instructorArray objectAtIndex:indexPath.row])];
        }else{
            photoalbumobject.status=@"Checked";
            //[selectedinstructorarray addObject:((Instructor *)[instructorArray objectAtIndex:indexPath.row])];
        }
        
        if ([self countcheckedimage]==instructorArray.count) {
            [selectbutton setTitle:[MyClass returntitlewithtitle:@"Deselect all"] forState:UIControlStateNormal];
            selectbutton.tag=1;
        }else{
            [selectbutton setTitle:[MyClass returntitlewithtitle:@"Select all"] forState:UIControlStateNormal];
            selectbutton.tag=0;
        }
        filteredInstructorArray= [self returnfilterinstructorarray];
        
        [instructorphotocollection reloadData];
    }else{
        instructorobject=[filteredInstructorArray objectAtIndex:indexPath.row];
        [self.delegate passinstructorfromgrid:instructorobject.username];
    }
}

-(long) countcheckedimage
{
    long result=0;
    for (int i=0; i<filteredInstructorArray.count; i++) {
        photoalbumobject=((Instructor *)[filteredInstructorArray objectAtIndex:i]).photoalbumrecord;
        if ([photoalbumobject.status isEqualToString:@"Checked"]) {
            result+=1;
        }
    }
    return result;
}

- (IBAction)cancelbuttonpressed:(id)sender {
    [self.delegate dismissinstructorgridview];
    
}


- (IBAction)savebuttonpressed:(id)sender {
    
    selectedinstructorarray=[[NSMutableArray alloc]init];
    for (int i=0; i<filteredInstructorArray.count; i++) {
        photoalbumobject=((Instructor *)[filteredInstructorArray objectAtIndex:i]).photoalbumrecord;
        if ([photoalbumobject.status isEqualToString:@"Checked"]) {
            [selectedinstructorarray addObject:((Instructor *)[filteredInstructorArray objectAtIndex:i]).username];
        }
    }
    
    if (selectedinstructorarray.count==0) {
        UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Instructor"] message:[MyClass returntitlewithtitle:@"Please select at least 1 instructor"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missinginput dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missinginput addAction:OKAction];
        //[self presentViewController:missinginput animated:YES completion:nil];
        [MyClass presentViewController:missinginput View:self];
    }else{
        if (selectedinstructorarray.count==instructorArray.count) {
            [self.delegate passinstructorlistfromgrid:@"All"];
        }else{
            [self.delegate passinstructorlistfromgrid:[selectedinstructorarray componentsJoinedByString:@","]];
        }
    }
}

-(void) selectbuttonpressed:(UIButton *)sender
{
    if (sender.tag==0) {
        //deselect all
        [selectbutton setTitle:[MyClass returntitlewithtitle:@"Deselect all"] forState:UIControlStateNormal];
        sender.tag=1;
        
        for (int i=0; i<filteredInstructorArray.count; i++) {
            photoalbumobject=((Instructor *)[filteredInstructorArray objectAtIndex:i]).photoalbumrecord;
            photoalbumobject.status=@"Checked";
        }
    }else{
        //select all
        [selectbutton setTitle:[MyClass returntitlewithtitle:@"Select all"] forState:UIControlStateNormal];
        sender.tag=0;
        
        for (int i=0; i<filteredInstructorArray.count; i++) {
            photoalbumobject=((Instructor *)[filteredInstructorArray objectAtIndex:i]).photoalbumrecord;
            photoalbumobject.status=@"";
        }
    }
    [instructorphotocollection reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==instructorsearchbar) {
        filteredInstructorArray=[self returnfilterinstructorarray];
        [instructorphotocollection reloadData];
        [instructorphotocollection setContentOffset:CGPointZero animated:YES];
    }
}

-(NSMutableArray *) returnfilterinstructorarray
{
    NSMutableArray *result;
    
    if ([instructorsearchbar.text isEqualToString:@""]) {
        result= [[NSMutableArray alloc]initWithArray:instructorArray];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstname contains[c] %@ or self.lastname contains[c] %@ or self.username contains[c] %@ or self.phone contains[c] %@ or  photoalbumrecord.status contains[c] %@",instructorsearchbar.text,instructorsearchbar.text,instructorsearchbar.text,instructorsearchbar.text,@"Checked"];
        result= [[NSMutableArray alloc]initWithArray:[instructorArray filteredArrayUsingPredicate:predicate]];
    }
    
    return result;
}
@end
