#if [ "$TRAVIS_BRANCH" = "master" ]; then
    REV_NAME="`git show -s --format='%h-%f' | cut -c1-111`"
    ARCHIVE_NAME="$REV_NAME".tar.gz
    mkdir "$REV_NAME"
    
    if [ "$TRAVIS_OS_NAME" = "linux" -o -z "$TRAVIS_OS_NAME" ]; then
        UPLOAD_DIR='/citra/nightly/linux'
        
        sudo apt-get -qq install lftp
        cp build/src/citra/citra "$REV_NAME"
        cp build/src/citra_qt/citra-qt "$REV_NAME"
    elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
        UPLOAD_DIR='/citra/nightly/osx'
        
        brew install lftp
        cp build/src/citra/Release/citra "$REV_NAME"
        cp -r build/src/citra_qt/Release/citra-qt.app "$REV_NAME"
    fi
    
    tar -czvf "$ARCHIVE_NAME" "$REV_NAME"
    lftp -c "open -u citra-builds,$BUILD_PASSWORD sftp://builds.citra-emu.org; put -O '$UPLOAD_DIR' '$ARCHIVE_NAME'"
#fi
