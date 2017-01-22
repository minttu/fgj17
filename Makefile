LOVE_FILE=release/tyrsky.love
ZIP_TO_UPLOAD=ggj_upload.zip
BUILD_DIR=.build

all: $(ZIP_TO_UPLOAD)

$(LOVE_FILE): clean
	cd ./source; zip -r ../$(LOVE_FILE) * -x "*.kra" -x "*.git"

$(ZIP_TO_UPLOAD): $(LOVE_FILE)
	zip -r $(ZIP_TO_UPLOAD) LICENSE LICENSES other press README.md release source -x "*.git"

.phony: clean
clean:
	rm -f $(LOVE_FILE) $(ZIP_TO_UPLOAD)
	rm -rf $(BUILD_DIR)
