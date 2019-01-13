//
//  main.m
//  KanaScroll
//
//  Created by tokai on 2019/01/13.
//  Copyright © 2019 tmytokai. All rights reserved.
//

#import <ApplicationServices/ApplicationServices.h>

const int64_t eisukey = 102; // Eisu Key on a Japanese keyboard
const CGKeyCode kanakey = 104; // Kana key on a Japanese keyboard
const int64_t scrollspeed = 3; // scroll speed (lines)

CGEventRef eventcallback( CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon )
{
    static bool kanamode = false;
    
    if( type == kCGEventKeyDown || type == kCGEventKeyUp ){
        CGKeyCode key = CGEventGetIntegerValueField( event, kCGKeyboardEventKeycode );
        if( key == kanakey ){
            if( kanamode ){
                CGEventSetIntegerValueField( event, kCGKeyboardEventKeycode, eisukey );
            }
            if( type == kCGEventKeyUp ){
                kanamode = !kanamode;
            }
        }
    }
    else if( type == kCGEventScrollWheel ){
        if( CGEventGetIntegerValueField( event, kCGScrollWheelEventIsContinuous ) == 0 ){
            int64_t d = CGEventGetIntegerValueField( event, kCGScrollWheelEventPointDeltaAxis1 );
            d = (scrollspeed^(d>>63))-(d>>63);
            CGEventSetIntegerValueField( event, kCGScrollWheelEventDeltaAxis1, d );
        }
    }
    
    return event;
}

int main()
{
    CFMachPortRef tap = CGEventTapCreate( kCGSessionEventTap, kCGHeadInsertEventTap, 0,
                                (1 << kCGEventKeyDown) | (1 << kCGEventKeyUp) | (1 << kCGEventScrollWheel),
                                eventcallback, NULL );
    CFRunLoopSourceRef loop = CFMachPortCreateRunLoopSource( kCFAllocatorDefault, tap, 0 );
    
    CFRunLoopAddSource( CFRunLoopGetCurrent(), loop, kCFRunLoopCommonModes );
    CGEventTapEnable( tap, true );
    CFRunLoopRun();
    
    return 0;
}

