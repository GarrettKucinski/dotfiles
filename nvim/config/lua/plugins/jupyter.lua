return {
  -- 1. Automatically convert .ipynb to python text on open, and back on save.
  -- NOTE: repo is GCBallesteros/jupytext.nvim, not goerz/jupytext.nvim — that's a different
  -- plugin with an incompatible opts schema (style/output_extension/force_ft are this one's).
  -- lazy = false because this has to be loaded before the first .ipynb BufReadCmd fires.
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = {
      style = "light",
      output_extension = "auto",
      force_ft = "python",
    },
  },

  -- 2. Interactive Jupyter Notebook execution environment.
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use latest stable version
    build = ":UpdateRemotePlugins",
    init = function()
      -- These must be set before the plugin loads
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      -- Default behavior is a floating window that only shows while the cursor sits on
      -- that exact cell, and closes the moment you move away (see molten-nvim's README,
      -- "Usage" section). virt_text_output pins the output as virtual text under the
      -- cell instead, so it stays visible like a real notebook.
      vim.g.molten_virt_text_output = true
      vim.g.molten_wrap_output = true
    end,
    config = function()
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
      end

      -- :MoltenInit with no args *always* shows the kernel picker, even if this buffer
      -- already has one attached — it doesn't check first. Guard it so re-pressing this
      -- doesn't re-prompt; just use the evaluate keymaps once a kernel is attached.
      map("n", "<leader>ri", function()
        if #vim.fn.MoltenRunningKernels({ true }) > 0 then
          vim.notify("Molten kernel already attached to this buffer", vim.log.levels.INFO)
          return
        end
        vim.cmd("MoltenInit")
      end, "[R]un: [I]nit kernel")
      map("n", "<leader>rl", ":MoltenEvaluateLine<CR>", "[R]un: evaluate [L]ine")
      map("n", "<leader>re", ":MoltenEvaluateOperator<CR>", "[R]un: [E]valuate operator")
      map("n", "<leader>rr", ":MoltenReevaluateCell<CR>", "[R]un: [R]e-evaluate cell")
      map("v", "<leader>r", ":<C-u>MoltenEvaluateVisual<CR>gv", "[R]un: evaluate visual selection")
      map("n", "<leader>rd", ":MoltenDelete<CR>", "[R]un: [D]elete cell")
      map("n", "<leader>ro", ":MoltenShowOutput<CR>", "[R]un: show [O]utput")
      -- MoltenEnterOutput moves focus INTO the output float so it can be scrolled with normal
      -- motions (j/k, <C-d>/<C-u>, gg/G). Per molten-nvim's README this must be called with
      -- `noautocmd`, otherwise entering the float immediately triggers autocmds that close it.
      map("n", "<leader>rv", ":noautocmd MoltenEnterOutput<CR>", "[R]un: enter/scroll output")
      map("n", "<leader>rh", ":MoltenHideOutput<CR>", "[R]un: [H]ide output")
      map("n", "<leader>rx", ":MoltenInterrupt<CR>", "[R]un: interrupt kernel")
      map("n", "<leader>rn", ":MoltenNext<CR>", "[R]un: [N]ext cell")
      map("n", "<leader>rp", ":MoltenPrev<CR>", "[R]un: [P]revious cell")
    end,
  },

  -- 3. Render images and plots inside the Neovim buffer.
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty", -- Ghostty implements the kitty graphics protocol
      max_width = 100,
      max_height = 12,
      magick_compile_by_hand = false,
    },
  },
}
