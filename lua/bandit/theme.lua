vim.pack.add({
        { src = "https://github.com/stevedylandev/darkmatter-nvim" },
        { src = "https://github.com/drewxs/ash.nvim" },
        { src = "https://github.com/slugbyte/lackluster.nvim" },
})

require "lackluster".setup({
  tweak_background = {
    normal = "none",
    popup = "none",
  }
})

require "ash".setup({
  transparent = true,
  term_colors = true,
})
vim.cmd('colorscheme ash')
