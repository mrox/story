//
//  main.m
//  storySW
//
//  Created by Tran Trung Tuyen on 10/03/2016.
//  Copyright © 2016 Tran Trung Tuyen. All rights reserved.
//

#import <Foundation/Foundation.h>

// From here to end of file added by Injection Plugin //

#ifdef DEBUG
static char _inMainFilePath[] = __FILE__;
static const char *_inIPAddresses[] = {"192.168.1.133", "127.0.0.1", 0};

#define INJECTION_ENABLED
#import "/tmp/injectionforxcode/BundleInjection.h"
#endif
