-- Simple Lua package to make working with Arduino in Neovim easier
local arduinoo = {}
local examples = require("examples")

local sketches = {}
for k, v in pairs(examples) do
  if type(v) == "string" then
    table.insert(sketches, k)
  end
end

local function is_valid_example(example)
  return sketches[example] ~= nil
end

local function sketch_completion(arg_lead)
  local completions = {}
  for _, sketch in ipairs(sketches) do
    if vim.startswith(sketch, arg_lead) then
      table.insert(completions, sketch)
    end
  end
  return completions
end


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
function arduinoo.create_sketch(opts)
  if not arduinoo.check_dependencies(false) then
    return
  end
  local parts = vim.split(vim.fn.system("pwd"), "/")
  local file_name = parts[#parts]:gsub("\n$", "") .. ".ino"
  vim.fn.system(string.format("test -e %s", file_name))
  if vim.v.shell_error == 0 then
    print("The current directory already contains an Arduino sketch")
    return
  end
  parts = vim.split(opts.args, " ")
  local arg1 = parts[#parts]
  if arg1 ~= "" then
    local content = examples[arg1]
    if not content then
      print("Invalid example '" .. arg1 .. "' provided")
      return
    end
    local result = vim.fn.system(string.format("touch %s", file_name))
    if vim.v.shell_error ~= 0 then
      print("Somethinw went wrong while creating new sketch")
      print(result)
      return
    end
    local success, err_msg, file
    file, err_msg = io.open(file_name, "w")
    if not file then
      print("Something went wrong while generating sketch content")
      print(err_msg)
      return
    end
    success, err_msg = file:write(content)
    file:close()
    if not success then
      print("Something went wrong while generating sketch content")
      print(err_msg)
    end
    return
  end
  local result = vim.fn.system("arduino-cli sketch new .")
  if vim.v.shell_error ~= 0 then
    print("Something went wrong while creating new sketch")
    print(result)
  end
end

-- Compile current projet
function arduinoo.compile()
  -- check if you have a sketch.yml
  -- if yes compile if not tell you to attach a board
  vim.fn.system(string.format("test %s/sketch.yml", vim.fn.system("pwd")))
  if vim.v.shell_error == 0 then
    print("sketch.yml file not found.")
    print("Please attach a board to your sketch")
    return
  end
  local result = vim.fn.system("arduino-cli compile")
  if vim.v.shell_error ~= 0 then
    print(result)
    return
  end
  print(result)
end

-- Upload current project
function arduinoo.upload()
end

vim.api.nvim_create_user_command(
  'ArduinooCheckDependencies', function()
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
    nargs = 1,
    complete = sketch_completion,
  }
)
vim.api.nvim_create_user_command(
  'ArduinooCompile', arduinoo.compile,
  {
    nargs = 0,
    complete = nil,
  }
)
vim.api.nvim_create_user_command(
  'ArduinooUpload', arduinoo.upload,
  {
    nargs = 0,
    complete = nil,
  }
)

return arduinoo
