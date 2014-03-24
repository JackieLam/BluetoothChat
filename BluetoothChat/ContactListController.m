//
//  ContactListController.m
//  BluetoothChat
//
//  Created by Cho-Yeung Lam on 23/3/14.
//  Copyright (c) 2014 Cho-Yeung Lam. All rights reserved.
//

#import "ContactListController.h"
#import "ContactTableViewDelegate.h"
#import "ContactPeripheralDelegate.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ContactListController ()

@property (strong, nonatomic) NSMutableArray *contactsList;

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;

@end

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation ContactListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Contacts";
    _contactsList = [[NSMutableArray alloc] initWithArray:@[@"A", @"B", @"C"]];
    
// TableView Delegate
    static NSString *cellIdentifier = @"CellIdentifier";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    ContactTableViewDelegate *tableViewDelegate = [[ContactTableViewDelegate alloc] initWithContacts:_contactsList cellIdentifier:cellIdentifier];
    self.tableView.delegate = tableViewDelegate;

// Central Manager
    
// Peripheral Manager
//    ContactPeripheralDelegate *peripheralDelegate = [ContactPeripheralDelegate alloc] initWithPeripheralManager:<#(CBPeripheralManager *)#>;
//    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate: queue:nil];
    
    //Server start advertising
//    [_peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID1]] }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
