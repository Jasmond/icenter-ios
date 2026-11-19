//
//  RightMenuViewController.m
//  ischoolistaff
//
//  Created by Jasmond Luk on 11/5/2016.
//  Copyright © 2016 Dreamware Limited. All rights reserved.
//

#import "RightMenuViewController.h"

@implementation RightMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    globalvariables=[GlobalVariables singleObj];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 128;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, -1, 170, 128)];
    menuimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 170, 128)];
    menuimage.contentMode=UIViewContentModeScaleAspectFit;
    //[menuimage setImage:[UIImage imageWithData:globalvariables.menuimagedata]];
    [view addSubview:menuimage];
    
    
    return view;
}


@end
