//
//  main.m
//  ant-tool
//
//  Created by 7 on 2018/11/14.
//  Copyright © 2018 alisports. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    NSApplication *app = [NSApplication sharedApplication];
    
    id delegate = [[AppDelegate alloc] init];;
    app.delegate = delegate;
    
    return NSApplicationMain(argc, argv);
}
