# android-v8
Contains the Google's V8 build used in android runtime.

### How to build (linux)

* get depot tools [more](https://www.chromium.org/developers/how-tos/install-depot-tools) :
```
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

export PATH=`pwd`/depot_tools:"$PATH"
```

* Make sure you have these packages installed (Linux only)
```
sudo apt-get install curl libc6-dev-i386 g++-multilib
```
- on fedora `sudo dnf install curl glibc-2*.i686`


* Download and extract Android NDK r22b

Linux:
```
curl -O https://dl.google.com/android/repository/android-ndk-r22b-linux-x86_64.zip
unzip android-ndk-r22b-linux-x86_64.zip -d ndkr22b
```

(install it with android studio??)

* Export ANDROID_NDK_HOME environment variable
```
export ANDROID_NDK_HOME=`pwd`/ndkr22b/android-ndk-r22b
```

* `fetch v8` (this will create a `v8` repo folder and add a `.gclient` file)

* Add `target_os` to the `.gclient` file:

This will ensure that the required build dependencies are fetched by depot_tools

```
solutions = [
  {
    "name": "v8",
    "url": "https://chromium.googlesource.com/v8/v8.git",
    "deps_file": "DEPS",
    "managed": False,
    "custom_deps": {},
  },
]
target_os = ['android']
```

* checkout tag 11.0.226.9
```
cd v8
git checkout 11.0.226.9
```

* Run sync
```
gclient sync
```

* Create symlinks
```
cp third_party/android_ndk/BUILD.gn $ANDROID_NDK_HOME
rm -rf third_party/android_ndk
ln -s $ANDROID_NDK_HOME third_party/android_ndk
```

* Apply patch running the following command
```
cd ..
./scripts/apply_patch.sh
```

* run the following command in the root folder
```
./scripts/build.android.sh
```
> you can run: `../build.android.sh debug` if you want to build v8 in debug, by default it's built in release.

### Outputs

The output folder is called `dist` and it's created at the repository root level.

### HOW TO CREATE A NEW PATCH file

git diff --cached > patch.diff

### What to do next

* Copy the files from the **dist** folder in the corresponding folder in [android-runtime](https://github.com/NativeScript/android-runtime/tree/master/test-app/runtime/src/main/libs)
  * The folders have to be renamed to the corresponding [architecture tags](https://developer.android.com/ndk/guides/abis#sa) used by the Android NDK
  * Copy the include and generated files to arch-independent locations
* Update the **v8-versions.json** file in the [android-runtime root folder](https://github.com/NativeScript/android-runtime/blob/master/v8-versions.json)
* Update the **settings.json** file in [android-runtime/build-artifacts/project-template-gradle](https://github.com/NativeScript/android-runtime/tree/master/build-artifacts/project-template-gradle/settings.json)
* Replace all the needed header and inspector files in the repo. The following [article](https://github.com/NativeScript/android-runtime/blob/master/docs/extending-inspector.md) might be helpful


- don't delete libzip.a, zip.h, zipconf.h, they are not build products of V8
- copy `src/V8NativeScriptExtension.h` to `test-app/runtime/src/main/cpp/include/`
- don't copy to src/main/libs/$arch/{include,generated}
- how to update to the latest libzip? https://github.com/NativeScript/android/pull/1724/files
- check what LIBCPP build flags V8 builds with
