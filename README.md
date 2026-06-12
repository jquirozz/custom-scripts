Add sources at the bottom of **~/.zshrc**:

```sh
if [ -d "$HOME/.custom_scripts" ]; then
    for script in "$HOME/.custom_scripts"/*.sh; do
        [ -f "$script" ] && source "$script"
    done
fi

[ -f "$HOME/.custom_env" ] && source "$HOME/.custom_env"
```

Clone repository:

```sh
git clone https://github.com/jquirozz/custom-scripts "$HOME/.custom_scripts"
```

Apply changes:

```sh
source ~/.zshrc
```
