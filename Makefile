LOVE_FILE=release/tyrsky.love
ZIP_TO_UPLOAD=ggj_upload.zip
BUILD_DIR=.build
BUILD_ZIP_DIR=$(BUILD_DIR)/tyrsky

all: $(ZIP_TO_UPLOAD)

$(LOVE_FILE): clean
	cd ./source; zip -9 -r ../$(LOVE_FILE) * -x "*.kra" -x "*.git"

$(ZIP_TO_UPLOAD): $(LOVE_FILE)
	mkdir -p $(BUILD_ZIP_DIR)
	cd $(BUILD_ZIP_DIR); ln -s ../../LICENSE ../../LICENSES ../../other ../../press ../../README.md ../../release ../../source .
	cd $(BUILD_DIR); zip -r ../$(ZIP_TO_UPLOAD) tyrsky -x "*.git"

.phony: clean
clean:
	rm -f $(LOVE_FILE) $(ZIP_TO_UPLOAD)
	rm -rf $(BUILD_DIR)

.phony: love
love:
	cd ./source; love .
