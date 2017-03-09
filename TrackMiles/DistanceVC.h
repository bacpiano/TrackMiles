//
//  DistanceVC.h
//  TrackMiles
//
//  Created by Jahangir on 6/4/16.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistanceVC : UIViewController<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTotalDistance;
@property (weak, nonatomic) IBOutlet UITableView *tblView;


@end
