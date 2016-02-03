mkdir modules &&
git clone https://github.com/ComputationWithBoundedResources/slogic modules/slogic &&
git clone https://github.com/ComputationWithBoundedResources/term-rewriting-xml modules/term-rewriting-xml &&
git clone https://github.com/ComputationWithBoundedResources/tct-core modules/tct-core && pushd tct-core && git checkout cage && popd &&
git clone https://github.com/ComputationWithBoundedResources/tct-common modules/tct-common &&
git clone https://github.com/ComputationWithBoundedResources/tct-its modules/tct-its && pushd tct-core && git checkout cage && popd &&
git clone https://github.com/ComputationWithBoundedResources/tct-trs modules/tct-trs &&
git clone https://github.com/ComputationWithBoundedResources/tct-inttrs modules/tct-inttrs
