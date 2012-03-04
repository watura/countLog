//
//  ViewController.m
//  countLog
//
//  Created by Wataru Nishimoto on 12/03/03.
//  Copyright (c) 2012年 none. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize listTableView;
@synthesize createItemButton;
@synthesize deleteItemButton;
@synthesize createView;
@synthesize backgroundView;

#pragma mark - Table View


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSInteger count = [[ud arrayForKey:@"list"] count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *list = [ud arrayForKey:@"list"];
    NSDictionary* item = [list objectAtIndex:indexPath.row];
    UILabel *itemName = (UILabel*)[cell viewWithTag:1];
    itemName.text = [item objectForKey:@"name"];
    UILabel *countLabel = (UILabel*)[cell viewWithTag:2];
    countLabel.text = [NSString stringWithFormat:@"%@",[item objectForKey:@"count"]];

    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(284, 2, 37, 35);
    [btn setTitle:@"UP" forState:UIControlStateNormal];
    [btn setTag:indexPath.row];
    [btn addTarget:self action:@selector(UpBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [listTableView cellForRowAtIndexPath:indexPath];
    backgroundView.hidden = NO;
    createView.hidden = NO;
    deleteItemButton.hidden = NO;
    createItemButton.tag = indexPath.row;
    
    UITextField* itemName = (UITextField*)[createView viewWithTag:10];
    UILabel *itemNameCell = (UILabel*)[cell viewWithTag:1];
    itemName.text = itemNameCell.text;
    UIButton* addButton = (UIButton*)[createView viewWithTag:11];
    [addButton setTitle:@"Save" forState:UIControlStateNormal];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray* list =[NSMutableArray arrayWithArray:[ud arrayForKey:@"list"]];
    NSLog(@"%@",[list objectAtIndex:indexPath.row]);
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // For even
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    }
    // For odd
    else {
        cell.backgroundColor = [UIColor colorWithHue:0.61
                                          saturation:0.09
                                          brightness:0.99
                                               alpha:0.8];
    }
}

#pragma mark - View IBActions
-(IBAction)createNewItem:(id)sender{
    backgroundView.hidden = NO;
    createView.hidden = NO;
    UITextField* itemName = (UITextField*)[createView viewWithTag:10];
    UIButton* addButton = (UIButton*)[createView viewWithTag:11];
    [addButton setTitle:@"Add" forState:UIControlStateNormal];
    [itemName becomeFirstResponder];
}

-(IBAction)cancelBtn:(id)sender{
    backgroundView.hidden = YES;
    createView.hidden = YES;
    UITextField* itemName = (UITextField*)[createView viewWithTag:10];
    [itemName resignFirstResponder];
    itemName.text = @"";
    backgroundView.hidden = YES;
    createView.hidden = YES;
    deleteItemButton.hidden = YES;
    [itemName resignFirstResponder];
    [listTableView reloadData];

}

-(IBAction)deleteBtn:(id)sender{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray* list =[NSMutableArray arrayWithArray:[ud arrayForKey:@"list"]];
    [list removeObjectAtIndex:createItemButton.tag];
    [ud setObject:list forKey:@"list"];
    UITextField* itemName = (UITextField*)[createView viewWithTag:10];
    itemName.text = @"";
    backgroundView.hidden = YES;
    createView.hidden = YES;
    deleteItemButton.hidden = YES;
    [itemName resignFirstResponder];
    [listTableView reloadData];

}

-(IBAction)addBtn:(UIButton*)sender{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    UITextField* itemName = (UITextField*)[createView viewWithTag:10];
    NSMutableArray* list =[NSMutableArray arrayWithArray:[ud arrayForKey:@"list"]];
    UIButton* addButton = (UIButton*)[createView viewWithTag:11];
    NSInteger count = 0;
    NSArray* ary=[NSArray array];
    if ([addButton.titleLabel.text isEqualToString:@"Save"]) {
        count = [[[list objectAtIndex:createItemButton.tag] objectForKey:@"count"] intValue];
        ary = [NSArray arrayWithArray:[[list objectAtIndex:createItemButton.tag] objectForKey:@"logs"]];
        [list removeObjectAtIndex:createItemButton.tag];
    }
    NSMutableDictionary* newDictionary =[NSMutableDictionary dictionary];
    [newDictionary setObject:itemName.text forKey:@"name"];
    [newDictionary setObject:[NSNumber numberWithInt:count] forKey:@"count"];
    [newDictionary setObject:ary forKey:@"logs"];
    
    [list insertObject:newDictionary atIndex:0];
    [ud setObject:list forKey:@"list"];
    
    itemName.text = @"";
    backgroundView.hidden = YES;
    createView.hidden = YES;
    deleteItemButton.hidden = YES;
    [itemName resignFirstResponder];
    [listTableView reloadData];
}
- (IBAction)actionDidEndOnExit:(id)sender{
    [sender resignFirstResponder];
}


-(IBAction)UpBtn:(UIButton*)sender{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray* list =[NSMutableArray arrayWithArray:[ud arrayForKey:@"list"]];    
    // cellのrow番号を手にいれる
    UITableViewCell *cell = (UITableViewCell*)[sender superview];
    NSInteger row = [[listTableView indexPathForCell:cell] row];

    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[list objectAtIndex:row]];
    UITextField* tmpField = (UITextField*)[cell viewWithTag:3]; 
    [tmpField resignFirstResponder];
    NSDate* date =  [NSDate date];
    NSMutableDictionary* newCount =[NSMutableDictionary dictionary];
    [newCount setObject:date forKey:@"date"];
    [newCount setObject:[NSNumber numberWithInt:[tmpField.text intValue]] forKey:@"count"];
    
    NSMutableArray *logs = [NSMutableArray arrayWithArray:[dict objectForKey:@"logs"]];
    [logs addObject:newCount];
    [dict setObject:logs forKey:@"logs"];
    NSInteger count = [tmpField.text intValue];
    count += [[dict objectForKey:@"count"] intValue];
    [dict setObject:[NSNumber numberWithInt:count] forKey:@"count"];
    
    [list replaceObjectAtIndex:row withObject:dict];

    [ud setObject:list forKey:@"list"];
    [listTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ||
            interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
