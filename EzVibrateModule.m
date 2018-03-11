#import "ezVibrateModule.h"

@interface UIImage ()
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;
@end

@implementation EzVibrateModule
- (UIImage *)iconGlyph {
	return [UIImage imageNamed:@"Icon" inBundle:[NSBundle bundleForClass:[self class]]];
}

- (UIColor *)selectedColor {
	return [UIColor colorWithRed:0.92 green:0.05 blue:0.23 alpha:1.0];
}

- (BOOL)isSelected {
	NSString *path = @"/var/mobile/Library/Preferences/com.apple.springboard.plist";
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	BOOL valueForSilent = [[dict valueForKey:@"silent-vibrate"] boolValue];
	if (valueForSilent) {
		self.ezVibrate = TRUE;
	} else {
		self.ezVibrate = FALSE;
	}
	return self.ezVibrate;
}

- (void)setSelected:(BOOL)selected {
	NSString *path = @"/var/mobile/Library/Preferences/com.apple.springboard.plist";
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	BOOL valueForSilent = [[dict valueForKey:@"silent-vibrate"] boolValue];
	if (valueForSilent) {
		NSString *sbPath = @"/var/mobile/Library/Preferences/com.apple.springboard.plist";
		NSMutableDictionary *sbDict = [[NSMutableDictionary alloc] initWithContentsOfFile:sbPath];
		[sbDict setValue:[NSNumber numberWithBool:NO] forKey:@"silent-vibrate"];
		[sbDict writeToFile:sbPath atomically: YES];
		notify_post("com.apple.SpringBoard/Prefs");
		notify_post("com.apple.springboard.silent-vibrate.changed");
		CFPreferencesAppSynchronize(CFSTR("com.apple.springboard"));
		CFRelease(CFSTR("com.apple.springboard"));
		selected = FALSE;
	} else {
		NSString *sbPath = @"/var/mobile/Library/Preferences/com.apple.springboard.plist";
		NSMutableDictionary *sbDict = [[NSMutableDictionary alloc] initWithContentsOfFile:sbPath];
		[sbDict setValue:[NSNumber numberWithBool:YES] forKey:@"silent-vibrate"];
		[sbDict writeToFile:sbPath atomically: YES];
		notify_post("com.apple.SpringBoard/Prefs");
		notify_post("com.apple.springboard.silent-vibrate.changed");
		CFPreferencesAppSynchronize(CFSTR("com.apple.springboard"));
		CFRelease(CFSTR("com.apple.springboard"));
		selected = TRUE;
	}
	self.ezVibrate = selected;
	[super refreshState];
}

@end
