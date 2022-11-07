# eshell-visual-vterm

Configures eshell to use [vterm] for visual commands.

Applies advices to eshell functions to replace `term-mode` functions, and use
[inheritenv] for [envrc] compatibility.

This package is based off of [eshell-vterm]. I had switched off that package to
my own implementation using more surgical advices a while ago, and ended up
fixing some bugs along the way so I figured I'd package it for others.

[vterm]: https://github.com/akermu/emacs-libvterm
[inheritenv]: https://github.com/purcell/inheritenv
[envrc]: https://github.com/purcell/envrc
[eshell-vterm]: https://github.com/purcell/envrc
