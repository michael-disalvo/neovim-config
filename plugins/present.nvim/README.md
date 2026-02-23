# `present.nvim`

Hey, this is a plugin for present markdown files as a presentation in Neovim.

# Features 

Can execute code in lua blocks when you have them in a slide

```lua
print("Hello world!")
```

# Usage 

```lua
require("present").start_presentation({})
```

Use `n` and `p` to navigate markdown slides
