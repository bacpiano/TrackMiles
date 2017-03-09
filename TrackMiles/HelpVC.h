//
//  HelpVC.h
//  TrackMiles
//
//  Created by Adrian Borcea Saeed on 22/06/2016.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpVC : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrolView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
