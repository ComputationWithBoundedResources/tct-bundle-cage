##tct-bundle-inttrs
This package is part of the _Tyrolean Complexity Tool (TcT)_ and bundles
several TcT modules for the resource analysis of integer term rewrite systems.

The package provides three executables. For more information we refer to the
corresponding repositories.
  * [tct-its](https://github.com/ComputationWithBoundedResources/tct-its#readme)
  * [tct-trs](https://github.com/ComputationWithBoundedResources/tct-trs#readme)
  * [tct-inttrs](https://github.com/ComputationWithBoundedResources/tct-iinttrs#readme)


###Requirements

Executables:
  * [Glasgow Haskell Compiler, version 7.10](http://www.haskell.org/ghc/)
  * [minismt, version 0.6](http://cl-informatik.uibk.ac.at/software/minismt/)
  * [yices, version 2.3](http://yices.csl.sri.com/)

The commands `minismt` and `yices-smt` have to be in `$PATH`.

Other packages:
  * [slogic](https://github.com/ComputationWithBoundedResources/slogic/)
  * [tct-core](https://github.com/ComputationWithBoundedResources/tct-core/)
  * [tct-common](https://github.com/ComputationWithBoundedResources/tct-common/)
  * [tct-its](https://github.com/ComputationWithBoundedResources/tct-its/)
  * [tct-trs](https://github.com/ComputationWithBoundedResources/tct-trs/)
  * [tct-inttrs](https://github.com/ComputationWithBoundedResources/tct-inttrs/)

The tool is only tested under GNU/Linux.


###Installation

####Using Stack
We recommend using [stack](https://github.com/commercialhaskell/stack) with the
accompanied `stack.dev.yaml` file.

To build and install the executables first obtain the required packages.
```bash
mkdir tct-bundle-inttrs
cd tct-bundle-inttrs
git clone https://github.com/ComputationWithBoundedResources/slogic
git clone https://github.com/ComputationWithBoundedResources/tct-core
git clone https://github.com/ComputationWithBoundedResources/tct-common
git clone https://github.com/ComputationWithBoundedResources/tct-its
git clone https://github.com/ComputationWithBoundedResources/tct-trs
git clone https://github.com/ComputationWithBoundedResources/tct-inttrs
git clone https://github.com/ComputationWithBoundedResources/tct-bundle-inttrs
```

Then execute the following command:
```bash
cd tct-bundle-inttrs
STACK_YAML=stack.dev.yaml stack install tct-its tct-trs tct-inttrs
```

Per default `stack install` copies the executables in `$HOME/.local/bin`.


### USAGE

Further information and usage details can be found in the corresponding repositories.
  * [tct-its](https://github.com/ComputationWithBoundedResources/tct-its#readme)
  * [tct-trs](https://github.com/ComputationWithBoundedResources/tct-trs#readme)
  * [tct-inttrs](https://github.com/ComputationWithBoundedResources/tct-iinttrs#readme)

