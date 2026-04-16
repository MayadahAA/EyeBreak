APP_NAME = EyeBreak
BUILD_DIR = .build/release
BUNDLE = build/$(APP_NAME).app

.PHONY: all clean install run

all: $(BUNDLE)

$(BUNDLE): Sources/EyeBreak/*.swift Package.swift Resources/Info.plist
	swift build -c release
	rm -rf $(BUNDLE)
	mkdir -p $(BUNDLE)/Contents/MacOS
	mkdir -p $(BUNDLE)/Contents/Resources
	cp $(BUILD_DIR)/$(APP_NAME) $(BUNDLE)/Contents/MacOS/$(APP_NAME)
	cp Resources/Info.plist $(BUNDLE)/Contents/Info.plist
	codesign --force --sign - $(BUNDLE)
	@echo "✅ Built $(BUNDLE)"

clean:
	swift package clean
	rm -rf build/

install: $(BUNDLE)
	cp -R $(BUNDLE) /Applications/$(APP_NAME).app
	@echo "✅ Installed to /Applications/$(APP_NAME).app"

run: $(BUNDLE)
	open $(BUNDLE)
