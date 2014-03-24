//
//  ContactTableViewDelegate.m
//  BluetoothChat
//
//  Created by Cho-Yeung Lam on 23/3/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "ContactTableViewDelegate.h"

@interface ContactTableViewDelegate()

@property (nonatomic, strong) NSMutableArray *contactArray;
@property (nonatomic, copy) NSString *cellIdentifier;

@end

@implementation ContactTableViewDelegate

- (id)initWithContacts:(NSArray *)aContactArray
        cellIdentifier:(NSString *)aCellIdentifier
{
    self = [super init];
    if (self) {
        self.contactArray = [NSMutableArray arrayWithArray:aContactArray];
        self.cellIdentifier = [NSString stringWithString:aCellIdentifier];
    }
    return self;
}

#pragma mark - UITableView Datasource
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contactArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:self.cellIdentifier];
    }
    cell.textLabel.text = self.contactArray[indexPath.row];
    
    return cell;
}

@end
