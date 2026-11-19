//
//  MessagePhotoCollectionViewCell.m
//  ischoolicenter
//
//  Created by Jasmond Luk on 22/12/2016.
//  Copyright © 2016 DreamHigh Company Limited. All rights reserved.
//

#import "MessagePhotoCollectionViewCell.h"

@implementation MessagePhotoCollectionViewCell

@synthesize photoimageView,addimagebutton,deleteimagebutton,videoplayicon;

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    {
        float photosize=80;
        photoimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, photosize, photosize)];
        photoimageView.contentMode=UIViewContentModeScaleAspectFill;
        photoimageView.clipsToBounds=YES;
        addimagebutton= [[UIButton alloc] initWithFrame:CGRectMake(30, 30, 20, 20)];
        [addimagebutton setImage:[UIImage imageNamed:@"addbuttonblue_icon.png"] forState:UIControlStateNormal];
        deleteimagebutton=[[UIButton alloc] initWithFrame:CGRectMake(55, 55, 20, 20)];
        [deleteimagebutton setImage:[UIImage imageNamed:@"deletebutton2.png"] forState:UIControlStateNormal];
        videoplayicon = [[UIImageView alloc] initWithFrame:CGRectMake((photosize-80/4)/2, (photosize-photosize/4)/2, photosize/4, photosize/4)];
        [videoplayicon setImage:[UIImage imageNamed:@"play_icon.png"]];
        
        [self addSubview:photoimageView];
        [self addSubview:addimagebutton];
        [self addSubview:deleteimagebutton];
        [self addSubview:videoplayicon];
        
    }
    return self;
}

@end
