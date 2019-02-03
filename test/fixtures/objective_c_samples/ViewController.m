/*
//
//  ViewController.m
//  ProjectExample
//
//  Created by Gigel on 01/09/15.
//  Copyright (c) 2015 Stana. All rights reserved.
//
*/

#import "ViewController.h"
#import "Contact.h"
#import "ContactTableViewCell.h"
#import "EditTableViewController.h"
#import "Number.h"

@interface ViewController ()

@property(nonatomic, strong) NSArray *contacts;

@end

typedef void (^CallbackBlock)();

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tablecontacts.rowHeight = UITableViewAutomaticDimension;
    self.tablecontacts.estimatedRowHeight = 44;
    self.tablecontacts.allowsMultipleSelectionDuringEditing = NO;
    self.database = [Database new];
    [self.database connetti];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voiceChanged:) name:@"Menu" object:nil];
}

- (void)loadContacts:(CallbackBlock)callback {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        self.contacts = [self.database allContacts];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callback();
        });
        
    });
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"Executed once %@", @":)");
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Executed after 3 seconds");
    });
}

- (void)voceDiMenuCambiata:(NSNotification *)not {
    NSDictionary *parametro = not.object;
    NSInteger idx = [parametro[@"idx"] intValue];
    [[[UIAlertView alloc] initWithTitle:@"Menu" message:[NSString stringWithFormat:@"Menu voice changed: %d", idx] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.database disconnect];
    self.database = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadContacts:^{
        [self.tablecontacts reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    Contact *Contact = self.contacts[indexPath.row];
    cell.lblNome.text = Contact.nome;
    cell.lblNumber.text = [[Contact.numeri anyObject] Number];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editContact"]) {
        ((EditTableViewController *) segue.destinationViewController).database = self.database;
    }else if ([segue.identifier isEqualToString:@"editContactesistente"]) {
        ((EditTableViewController *) segue.destinationViewController).database = self.database;
        NSInteger index = [self.tablecontacts indexPathForSelectedRow].row;
        ((EditTableViewController *) segue.destinationViewController).Contact = self.contacts[index];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.database deleteContact: ((Contact *)self.contacts[indexPath.row]).contactId];
        [self loadContacts:^{
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationFade];
        }];
    }
}

- (IBAction)unwindSegue:(UIStoryboardSegue *) segue {
    
}

@end