//
//  ViewController.m
//  FileCoordinationDelays
//
//  Created by Tom Hamming on 5/13/15.
//  Copyright (c) 2015 Olive Tree Bible Software. All rights reserved.
//

#import "ViewController.h"
#import "THFilePresenter.h"

@interface ViewController ()

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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSArray* docDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if ([docDirectories count] > 0)
    {
        NSString* docDir = [docDirectories objectAtIndex:0];
        NSString *dataPath = [docDir stringByAppendingPathComponent:@"test.dat"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath])
            [[NSFileManager defaultManager] removeItemAtPath:dataPath error:nil];
        [[NSFileManager defaultManager] createFileAtPath:dataPath contents:nil attributes:nil];
        THFilePresenter *presenter = [[THFilePresenter alloc]initForFileAtPath:dataPath];
        NSOutputStream *stream = [[NSOutputStream alloc]initToFileAtPath:dataPath append:YES];
        [stream open];
        
        for (int i = 0; i < 25; i++)
        {
            NSData *testData = [@"foobar" dataUsingEncoding:NSUTF8StringEncoding];
            uint8_t* rawData = (uint8_t *)[testData bytes];
            [presenter write:^
             {
                 [stream write:rawData maxLength:testData.length];
             }];
        }
        
        [stream close];
        [presenter release];
        [stream release];
    }
}

@end
