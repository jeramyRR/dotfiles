# Nix Darwin

This README will provide helpful snippets and descriptions for working with `nix` and `nix-darwin`.

## Resources

[mynixos.com](https://www.mynixos.com)
> Build and share reproducible software environments with Nix and NixOS

## Commands

```sh
# rebuild and reload nix environment
darwin-rebuild switch --flake ~/dev/dotfiles/nix/darwin#mbpm4
```

```sh
# bring up nix-darwin configuration options homepage
darwin-help
```