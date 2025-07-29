return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      
      -- Helper function to install a package via Homebrew
      local function brew_install(package_name, executable_name)
        -- Allow executable name to differ from package name (if provided)
        executable_name = executable_name or package_name
        
        -- Check if tool is already installed by checking if it's in PATH
        local exists = vim.fn.executable(executable_name) == 1
        
        if exists then
          -- Already installed, silently return
          return true
        end
        
        -- Check if brew is available
        local brew_exists = vim.fn.executable("brew") == 1
        
        if not brew_exists then
          vim.notify("Homebrew not found. Please install Homebrew for automatic tool installation.", vim.log.levels.ERROR)
          return false
        end
        
        -- Install via Homebrew using a job for better user experience
        local install_msg = "Installing " .. package_name .. " via Homebrew..."
        vim.notify(install_msg, vim.log.levels.INFO)
        
        -- Create a temporary buffer to show installation progress
        local bufnr = vim.api.nvim_create_buf(false, true)
        local width = math.floor(vim.o.columns * 0.8)
        local height = math.floor(vim.o.lines * 0.6)
        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)
        
        local opts = {
          relative = 'editor',
          width = width,
          height = height,
          row = row,
          col = col,
          style = 'minimal',
          border = 'rounded',
          title = " Installing " .. package_name .. " ",
          title_pos = 'center',
        }
        
        local win_id = vim.api.nvim_open_win(bufnr, true, opts)
        vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')
        vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')
        
        local function append_line(text)
          vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
          local lines = vim.split(text, "\n")
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, lines)
          vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
          vim.cmd("normal! G")
        end
        
        append_line("Starting Homebrew installation for " .. package_name .. "...")
        append_line("This might take a minute. Please wait...")
        
        -- Use nvim's job API for non-blocking install
        local stdout_data = {}
        local stderr_data = {}
        local job_id = vim.fn.jobstart("brew install " .. package_name, {
          on_stdout = function(_, data, _)
            if data then
              for _, line in ipairs(data) do
                if line and line ~= "" then
                  table.insert(stdout_data, line)
                  append_line(line)
                end
              end
            end
          end,
          on_stderr = function(_, data, _)
            if data then
              for _, line in ipairs(data) do
                if line and line ~= "" then
                  table.insert(stderr_data, line)
                  append_line(line)
                end
              end
            end
          end,
          on_exit = function(_, exit_code, _)
            if exit_code == 0 then
              append_line("\nInstallation completed successfully!")
              vim.defer_fn(function()
                if vim.api.nvim_win_is_valid(win_id) then
                  vim.api.nvim_win_close(win_id, true)
                end
                -- Re-check if executable is available
                if vim.fn.executable(executable_name) == 1 then
                  vim.notify(executable_name .. " installed successfully!", vim.log.levels.INFO)
                else
                  vim.notify("Homebrew reported successful installation, but " .. executable_name .. " not found in PATH. You may need to restart Neovim.", vim.log.levels.WARN)
                end
              end, 2000) -- Close after 2 seconds
            else
              append_line("\nInstallation failed with exit code: " .. exit_code)
              vim.defer_fn(function()
                if vim.api.nvim_win_is_valid(win_id) then
                  vim.api.nvim_win_close(win_id, true)
                end
                vim.notify("Failed to install " .. package_name .. " via Homebrew.", vim.log.levels.ERROR)
              end, 5000) -- Show error for longer (5 seconds)
            end
          end
        })
        
        -- Check if job started successfully
        if job_id <= 0 then
          append_line("Failed to start installation job.")
          vim.defer_fn(function()
            if vim.api.nvim_win_is_valid(win_id) then
              vim.api.nvim_win_close(win_id, true)
            end
            vim.notify("Failed to start installation job for " .. package_name, vim.log.levels.ERROR)
          end, 2000)
          return false
        end
        
        -- We're not using a timer anymore as it can cause issues
        -- The on_exit callback will handle everything we need
        
        -- We have to return something immediately, so assume success and let the job handle errors
        return true
      end
      
      -- Try to install tools via Homebrew
      brew_install("markdownlint-cli", "markdownlint") -- Package is markdownlint-cli, but executable is markdownlint
      brew_install("lazygit", "lazygit")               -- Package and executable have same name
      
      -- Configure markdownlint with Homebrew's markdownlint-cli
      -- Define the Homebrew version of markdownlint-cli as a custom linter
      lint.linters.markdownlint_brew = {
        cmd = "markdownlint", -- The actual executable name is markdownlint
        stdin = true,
        args = {},
        stream = "stderr",
        ignore_exitcode = false,
        env = nil,
        parser = lint.linters.markdownlint.parser
      }
      
      lint.linters_by_ft = {
        markdown = { 'markdownlint_brew' },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Ensure Homebrew's bin directories are in the PATH
      local old_path = vim.env.PATH
      local brew_paths = {
        "/opt/homebrew/bin",     -- Apple Silicon macs
        "/usr/local/bin"         -- Intel macs
      }
      
      for _, path in ipairs(brew_paths) do
        if vim.fn.isdirectory(path) == 1 and not string.find(old_path, path, 1, true) then
          vim.env.PATH = path .. ":" .. old_path
        end
      end

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
