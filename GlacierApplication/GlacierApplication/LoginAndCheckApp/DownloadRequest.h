//
//  DownloadRequest.h
//  SKLMAgent
//
//  Created by bqzhu on 12-10-9.
//  Copyright (c) 2012年 bqzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "DownLoadDelegate.h"

@interface DownloadRequest : NSObject <ASIHTTPRequestDelegate, ASIProgressDelegate> {
    
}
@property(nonatomic,retain) ASIHTTPRequest *_request;

@property(nonatomic,retain) NSString *_symbol;//该次下载的唯一标示

@property(nonatomic,retain) NSString *_url;
@property(nonatomic,retain) NSString *_name;
@property(nonatomic,retain) NSString *_fileType;
@property(nonatomic,retain) NSString *_savePath;
@property(nonatomic,retain)UIView *_progress;
@property(nonatomic,retain)id<DownLoadDelegate> _downLoadDelegate;

-(id)initWithURL:(NSString*)url Name:(NSString*)name FileType:(NSString*)fileType SavePath:(NSString*)savePath Progress:(UIView*)progress DownloadDelegate:(id)delegate;

- (void)start;

@end
