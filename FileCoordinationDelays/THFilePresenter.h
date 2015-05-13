//
//  THFilePresenter.h
//  FileCoordinationDelays
//
//  Created by Tom Hamming on 5/13/15.
//  Copyright (c) 2015 Olive Tree Bible Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THFilePresenter : NSObject <NSFilePresenter>

-(id)initForFileAtPath:(NSString *)path;
-(void)write:(dispatch_block_t)writeBlock;

@property(readonly, copy) NSURL *presentedItemURL;

@end
