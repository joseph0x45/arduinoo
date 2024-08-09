-- Simple Lua package to make working with Arduino in Neovim easier
local arduinoo = {}

-- check if arduino cli is installed
function arduinoo.check_dependencies(verbose)
  local arduino_cli_version = vim.fn.system("arduino-cli version")
  local exit_code = vim.v.shell_error
  if exit_code ~= 0 then
    print("arduino-cli not found in $PATH")
    return false
  end
  if verbose then
    print("Arduino CLI found in PATH")
    print(arduino_cli_version)
  end
  if exit_code ~= 0 then
    print("wc(word count) not found in $PATH")
    return false
  end
  if verbose then
    print("wc found in PATH")
  end
  vim.fn.system("test")
  if exit_code ~= 0 then
    print("test not found in $PATH")
    return false
  end
  if verbose then
    print("test found in PATH")
  end
  if verbose then
    print("All dependencies are installed!")
  end
  return true
end

-- Create a new sketch in the current directory
function arduinoo.create_sketch()
  if not arduinoo.check_dependencies(false) then
    return
  end
  local parts = vim.split(vim.fn.system("pwd"), "/")
  vim.fn.system(string.format("test -e %s", parts[#parts]:gsub("\n$", "")) .. ".ino")
  if vim.v.shell_error == 0 then
    print("The current directory already contains an Arduino sketch")
    return
  end
  local result = vim.fn.system("arduino-cli sketch new .")
  if vim.v.shell_error ~= 0 then
    print("Something went bad while creating new sketch")
    print(result)
  end
end

-- Generate a new sketch example in the current directory
function arduinoo.generate_sketch()
end

-- Compile current projet
function arduinoo.compile()
end

-- Upload current project
function arduinoo.upload()
end

vim.api.nvim_create_user_command(
  'ArduinooCheckDependencies', function ()
    arduinoo.check_dependencies(true)
  end,
  {
    nargs = '*',
    complete = nil,
  }
)
vim.api.nvim_create_user_command(
  'ArduinooCreateSketch', arduinoo.create_sketch,
  {
    nargs = '*',
    complete = nil,
  }
)

return arduinoo
