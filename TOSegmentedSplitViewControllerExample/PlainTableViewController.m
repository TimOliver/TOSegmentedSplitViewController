//
//  PlainTableViewController.m
//  TOSegmentedSplitViewControllerExample
//
//  Created by Tim Oliver on 30/12/18.
//  Copyright © 2018 Tim Oliver. All rights reserved.
//

#import "PlainTableViewController.h"

@interface PlainTableViewController ()

@end

@implementation PlainTableViewController

- (instancetype)init
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Lorem"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:nil
                                                                                action:nil];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Ipsum"
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:nil
                                                                                 action:nil];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %ld", (long)indexPath.row];
    return cell;
}

@end
