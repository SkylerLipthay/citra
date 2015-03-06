if [ "$TRAVIS_BRANCH" = "master" ]; then
    mkdir output
    
    if [ "$TRAVIS_OS_NAME" = "linux" -o -z "$TRAVIS_OS_NAME" ]; then
        UPLOAD_DIR='/citra/nightly/linux'
        
        sudo apt-get -qq install lftp
        cp build/src/citra/citra output
        cp build/src/citra_qt/citra-qt output
    elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
        UPLOAD_DIR='/citra/nightly/osx'
        
        brew install lftp
        cp build/src/citra/Release/citra output
        cp build/src/citra_qt/Release/citra-qt output
    fi
    
    ARCHIVE_NAME="`git show -s --format='%h-%f' | cut -c1-111`.tar.gz"
    tar -czvf "$ARCHIVE_NAME" output/*
    lftp -c "open -u builds,$BUILD_PASSWORD sftp://builds.citra-emu.org; put -O '$UPLOAD_DIR' '$ARCHIVE_NAME'"
fi
