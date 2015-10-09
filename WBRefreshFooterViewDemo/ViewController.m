//
//  ViewController.m
//  WBRefreshFooterViewDemo
//
//  Created by webox on 10/9/15.
//  Copyright © 2015 webox. All rights reserved.
//

#import "ViewController.h"
#import "WBRefreshFooterView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet WBRefreshFooterView *refreshFooter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadMore:(id)sender {
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2];
}

- (void)stopLoading
{
    [_refreshFooter stopLoading];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell" forIndexPath:indexPath];
    return cell;
}

@end
