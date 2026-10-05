# OpenTRIM - build from source on macOS

The core library, the `opentrim` CLI, the tests and the Python bindings build with the native Apple Clang compiler (Xcode or Command Line Tools). No GCC is needed.

Tested with Apple clang 21 on macOS 27 (Apple silicon), Homebrew `cmake` 4.4, `eigen` 5.0 and `hdf5` 2.2.

The GUI has not been tested on macOS.

## Dependencies

Install the Xcode Command Line Tools (`xcode-select --install`) and, with [Homebrew](https://brew.sh):

```bash
brew install cmake eigen hdf5
```

[libdedx](https://github.com/ir2-lab/libdedx) is not in Homebrew. Build and install it first:

```bash
git clone https://github.com/ir2-lab/libdedx.git
cmake -S libdedx -B libdedx/build -DCMAKE_BUILD_TYPE=Release
cmake --build libdedx/build
cmake --install libdedx/build
```

It installs in `$HOME/.local` by default. If you set another `-DCMAKE_INSTALL_PREFIX`, pass the same path to OpenTRIM below as `-DCMAKE_PREFIX_PATH=...`.

## Build OpenTRIM

```bash
git clone https://github.com/ir2-lab/OpenTRIM.git
cd OpenTRIM
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DOPENTRIM_BUILD_GUI=OFF
cmake --build build -j
cmake --install build
```

To build the Python bindings with a specific interpreter, add `-DPython_EXECUTABLE=/path/to/python3`. That interpreter needs `numpy` and `pytest` to run the Python tests.

## Testing the build

```bash
cd build && ctest
```

## Notes

Two of the fetched header-only dependencies, [screened_coulomb](https://github.com/ir2-lab/screened_coulomb) and [ieee754_seq](https://github.com/ir2-lab/ieee754_seq), use C++ features that Apple Clang and its standard library, libc++, do not provide:

- `std::cyl_bessel_k`, a C++17 special math function.
- `constexpr` evaluation of `std::log2` and `std::cos`.

The build applies the patches in `cmake/patches/` to these projects when it fetches them. They replace the missing functions with portable code, and on GCC/libstdc++ the generated scattering tables are bit-identical to the unpatched ones. The patches are not applied when `PACKAGE_BUILD=ON`, which takes the dependency sources from the local `external/` folder.
