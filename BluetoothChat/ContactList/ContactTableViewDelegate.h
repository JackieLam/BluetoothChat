//
//  ContactTableViewDelegate.h
//  BluetoothChat
//
//  Created by Cho-Yeung Lam on 23/3/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactTableViewDelegate : NSObject<UITableViewDataSource, UITableViewDelegate>

- (id)initWithContacts:(NSArray *)anItems
        cellIdentifier:(NSString *)aCellIdentifier;

@end
