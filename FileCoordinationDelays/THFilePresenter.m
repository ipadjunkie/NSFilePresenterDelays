//
//  THFilePresenter.m
//  FileCoordinationDelays
//
//  Created by Tom Hamming on 5/13/15.
//  Copyright (c) 2015 Olive Tree Bible Software. All rights reserved.
//

#import "THFilePresenter.h"

@interface THFilePresenter ()
@property (retain) NSURL *url;
@end

@implementation THFilePresenter

-(id)initForFileAtPath:(NSString *)path
{
    if (self = [super init])
    {
        self.url = [NSURL fileURLWithPath:path];
        [NSFileCoordinator addFilePresenter:self];
    }
    
    return self;
}

-(void)dealloc
{
    [NSFileCoordinator removeFilePresenter:self];
    self.url = nil;
    [super dealloc];
}

-(NSURL *)presentedItemURL
{
    return self.url;
}

-(NSOperationQueue *)presentedItemOperationQueue
{
    return [NSOperationQueue mainQueue];
}

-(void)write:(dispatch_block_t)writeBlock
{
    NSError *myErr = nil;
    
    NSFileCoordinator *coord = [[NSFileCoordinator alloc]initWithFilePresenter:self];
    NSDate *start = [NSDate date];
    [coord coordinateWritingItemAtURL:self.presentedItemURL options:0 error:&myErr byAccessor:^(NSURL *newUrl)
     {
         NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:start];
         //if (elapsed > 0.1)
             NSLog(@"%@ took %.4f seconds to start writing", self.presentedItemURL, elapsed);
         writeBlock();
     }];
    
    [coord release];
    
    if (myErr)
    {
        NSLog(@"File presenter write error for %@: %@", self.presentedItemURL, myErr);
    }
}

-(void)relinquishPresentedItemToReader:(void (^)(void (^)(void)))reader
{
    NSLog(@"Relinquishing %@ to reader", self.presentedItemURL);
    reader(^{});
}

-(void)relinquishPresentedItemToWriter:(void (^)(void (^)(void)))writer
{
    NSLog(@"Relinquishing %@ to writer", self.presentedItemURL);
    writer(^{});
}

@end
