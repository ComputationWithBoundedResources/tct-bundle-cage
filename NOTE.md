####Note

#####tct-core/cage
Provides a complexity expression for multivariate polynomials. Note that only the certification function `identity` is
supported. This is usually enough to provide a proper output for `tct-its`. Though when branches in the proof trees are
combined via eg. `max` in `pathlength` `Unknown` is returned. Similar if comparison operations are used as for example
in `best`.

#####tct-its/cage
Adapt to tct-core to provide multivariate polynomial certificates as output.

