//
//  TracksVC.h
//  TrackMiles
//
//  Created by Jahangir on 6/4/16.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TracksVC : UIViewController<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTotal;

@property (nonatomic,strong) Job *job;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
- (IBAction)addBtnPRessed:(id)sender;
- (IBAction)shareAllBtnPressed:(id)sender;


@end
