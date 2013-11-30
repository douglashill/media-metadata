//
//  main.m
//  MediaMetadataReader
//
//  Created by Douglas Hill on 18/08/2012.
//

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#import <stdlib.h>
#import <stdio.h>

int main(int argc, const char * argv[])
{
	@autoreleasepool {
		
		NSString *path = nil;
		if (argc == 2) {
			path = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding]; // Don’t know if this encoding is correct
		}
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
			NSString *error = [NSString stringWithFormat:@"File at %@ not found.\n", path];
			fwrite([error cStringUsingEncoding:NSUTF8StringEncoding], 1,
				   [error lengthOfBytesUsingEncoding:NSUTF8StringEncoding], stdout);
			return 1;
		}
		
	    MDItemRef fileMetadata = MDItemCreate(NULL,(CFStringRef)path);
		CFArrayRef attritubeNames = (CFArrayRef)[NSArray arrayWithObjects:(id)kMDItemDurationSeconds, nil];
		NSDictionary *metadataDictionary = (NSDictionary*)MDItemCopyAttributes(fileMetadata, attritubeNames);
		float duration = [(NSNumber *)[metadataDictionary objectForKey:(id)kMDItemDurationSeconds] floatValue];
		NSString *durationString = [NSString stringWithFormat:@"%.3f\n", duration];
		
		fwrite([durationString cStringUsingEncoding:NSUTF8StringEncoding], 1,
			   [durationString lengthOfBytesUsingEncoding:NSUTF8StringEncoding], stdout);
	}
    return 0;
}

