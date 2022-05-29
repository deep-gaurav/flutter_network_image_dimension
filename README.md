# image_dimension_finder_flutter

A new flutter plugin project.


## Build Instruction

### Android

cd to rust folder
`cd rust`

#### Install targets

`rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android i686-linux-android`

#### Install cargo-ndk

`cargo install cargo-ndk`

#### Build Libs

`cargo ndk -t armeabi-v7a -t arm64-v8a -t x86 -t x86_64 -o ../android/src/main/jniLibs build --release`

### IOS

dd to rust folder
`cd rust`

#### Install cargo lipo

`cargo install cargo-lipo`

#### Install targets

`rustup target add aarch64-apple-ios x86_64-apple-ios`

We also need `i386-apple-ios` but it's not supported anymore, we'll build our own std.
We'll need rust-src for it

`rustup component add rust-src --toolchain nightly`

#### Build Simulator Archives

`cargo lipo --targets aarch64-apple-ios-sim,x86_64-apple-ios --release`

Copy lib to some folder

`mkdir target/ios-simulator`
`cp target/universal/release/libimage_dimension_fetcher_lib.a target/ios-simulator`

#### Build iPhone Archives

`cargo lipo --targets aarch64-apple-ios,armv7-apple-ios --release`

Copy lib to some folder

`mkdir target/ios-iphone`
`cp target/universal/release/libimage_dimension_fetcher_lib.a target/ios-iphone`

#### Create Framework from archives

Go to ios folder of plugin
`cd ../ios`

Create Framework
`xcodebuild -create-xcframework  -library ../rust/target/ios-iphone/libimage_dimension_fetcher_lib.a -library ../rust/target/ios-simulator/libimage_dimension_fetcher_lib.a  -output ImageDimensionFetcherLib.xcframework`