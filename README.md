# Recovery-Compiler 🤖

This GitHub Action Let's You Compile Recovery For Android Devices.

## Features 📜

 - Let's you Compile Without Any Hassle Of Setting Up Environment.
 - Just Setup Env Variables & Everything Is Automated.


## Notes ✋

There is Only Support For `ubuntu-20.04` also Known As `ubuntu-latest`

PATH for Compiled Recovery is `work/out/target/product/$VENDOR/$CODENAME/*.img , *.zip`

## Usage 👨‍💻

```yaml
- name: Recovery Compilation
  uses: Area69Lab/Recovery-Compiler@production
  env:
    MANIFEST: "Recovery Manifest URL with -b branch"
    DT_LINK: "Your Device Tree Link"
    VENDOR: "Your Device's Vendor name as in used inside DT. Example: xiaomi, samsung, asus, etc."
    CODENAME: "Your Device's Codename as in used inside DT. Example: nikel, phoenix, ginkgo, etc."
    KERNEL_LINK: "Kernel repo link with optional -b branch."
    KERNELISPREBUILT: "if your Kernel Is Prebuilt Set this To true else leave it emptly"
    TARGET: "Set as recoveryimage or bootimage if no recovery partition avaiable"
    FLAVOR: "eng or userdebug"
    EXTRA_CMD: "if you want to Execute any external Command Before Compilation Starts"
    TZ: "Asia/Kolkata" # Set Time-Zone According To Your Region
```

# Credits 🥰

[rokibhasansagar](https://github.com/rokibhasansagar) For His Cleanup Scripts And Great Help

## License 🔖

Licensed Under [GPLV3](https://github.com/Area69Lab/Recovery-Compiler/blob/production/LICENSE)
