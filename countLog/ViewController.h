//
//  ViewController.h
//  countLog
//
//  Created by Wataru Nishimoto on 12/03/03.
//  Copyright (c) 2012年 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView* listTableView;
    IBOutlet UIButton* createItemButton;    
    IBOutlet UIButton* deleteItemButton;    
    IBOutlet UIView* createView;
    IBOutlet UIButton* backgroundView;
}
@property (strong,nonatomic) IBOutlet UITableView* listTableView;
@property (strong,nonatomic) IBOutlet UIButton* createItemButton;    
@property (strong,nonatomic) IBOutlet IBOutlet UIView* createView;
@property (strong,nonatomic) IBOutlet IBOutlet UIButton* backgroundView;
@property (strong,nonatomic) IBOutlet IBOutlet UIButton* deleteItemButton;



-(IBAction)createNewItem:(id)sender;
-(IBAction)cancelBtn:(id)sender;
-(IBAction)addBtn:(id)sender;
-(IBAction)UpBtn:(UIButton*)sender;

@end
