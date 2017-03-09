//
//  SettingsVC.h
//  TrackMiles
//
//  Created by Jahangir on 6/5/16.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end
