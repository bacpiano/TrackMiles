//
//  HelpVC.m
//  TrackMiles
//
//  Created by Adrian Borcea Saeed on 22/06/2016.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import "HelpVC.h"

@interface HelpVC ()

@end

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    float width=[UIScreen mainScreen].bounds.size.width;
    _contentWidth.constant=width*5.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float width=[UIScreen mainScreen].bounds.size.width;
    float x=scrollView.contentOffset.x;
    _pageControl.currentPage=x/width;
}

@end
