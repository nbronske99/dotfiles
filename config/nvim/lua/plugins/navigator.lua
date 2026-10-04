-- C-h/j/k/l move between nvim splits and tmux panes seamlessly
-- (the matching tmux side lives in ~/dotfiles/tmux.conf)
return {
    "christoomey/vim-tmux-navigator",
    cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight" },
    keys = {
        { "<C-h>", "<cmd>TmuxNavigateLeft<cr>" },
        { "<C-j>", "<cmd>TmuxNavigateDown<cr>" },
        { "<C-k>", "<cmd>TmuxNavigateUp<cr>" },
        { "<C-l>", "<cmd>TmuxNavigateRight<cr>" },
    },
}
