TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = R8RJ_Splash_Tweak

R8RJ_Splash_Tweak_FILES = Tweak.x
R8RJ_Splash_Tweak_CFLAGS = -fobjc-arc
R8RJ_Splash_Tweak_FRAMEWORKS = UIKit CoreGraphics QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk 
