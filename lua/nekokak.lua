local uv = vim.loop
local api = setmetatable({ _cache = {} }, {
  __index = function(self, name)
    if not self._cache[name] then
      local func = vim.api["nvim_" .. name]
      if func then
        self._cache[name] = func
      else
        error("Unknown api func: " .. name, 2)
      end
    end
    return self._cache[name]
  end,
})
local Nekokak = {}

Nekokak.new = function()
  local self = setmetatable({}, { __index = Nekokak })
  self.images = {}
  self.default_options = {
    wait_ms = 100,
    direction = "expand",
    count = 3,
  }
  return self
end

function Nekokak:setup()
  api.create_user_command("Nekokak", function(options)
    local opts = options.args == "" and {} or assert(loadstring("return " .. options.args)())
    self:start(opts)
  end, { nargs = "?" })
end

function Nekokak:start(opts)
  opts = vim.tbl_extend("force", self.default_options, opts or {})
  vim.validate {
    wait_ms = {
      opts.wait_ms,
      function(v)
        return type(v) == "number" and v >= 0
      end,
      "should be a positive number or zero",
    },
    direction = {
      opts.direction,
      function(v)
        local available = { expand = true, reduct = true, loop = true }
        return available[v] or false
      end,
      "should be either `expand`, `reduct` or `loop`",
    },
    count = {
      opts.count,
      function(v)
        return type(v) == 'number' and v > 0
      end,
      'should be a positive number',
    },
  }
  self:load_data()

  api.buf_set_name(0, "==nekokak==")
  vim.opt.buftype = "nowrite"
  vim.opt.swapfile = false
  vim.opt.bufhidden = "wipe"
  vim.opt.buftype = "nofile"
  vim.opt.number = false
  vim.opt.relativenumber = false
  vim.opt.list = false
  vim.opt.wrap = false
  vim.opt.cursorline = false
  vim.opt.cursorcolumn = false
  vim.cmd [[redraw]]

  local namespace = api.create_namespace "nekokak"
  local images = self:create_animation(opts.direction, opts.count)
  for _, image in ipairs(images) do
    self:draw(namespace, image)
    vim.cmd [[redraw]]
    uv.sleep(opts.wait_ms)
  end
  -- api.buf_clear_namespace(0, namespace, 0, -1)
end

function Nekokak:create_animation(direction, count)
  local images = {}
  if direction == "expand" then
    images = vim.deepcopy(self.images)
    table.sort(images, function(a, b)
      return a.name < b.name
    end)
  elseif direction == "reduct" then
    images = vim.deepcopy(self.images)
    table.sort(images, function(a, b)
      return a.name > b.name
    end)
  elseif direction == "loop" then
    local expansion = vim.deepcopy(self.images)
    table.sort(expansion, function(a, b)
      return a.name < b.name
    end)
    local reduction = vim.deepcopy(self.images)
    table.sort(reduction, function(a, b)
      return a.name > b.name
    end)
    for _ = 1, count do
      for i = 1, #expansion do
        images[#images + 1] = expansion[i]
      end
      for i = 1, #reduction do
        images[#images + 1] = reduction[i]
      end
    end
  end
  return images
end

function Nekokak:draw(namespace, image)
  api.buf_set_lines(0, 0, #image.map, false, image.map)
  for row, line in ipairs(image.map) do
    local col = 0
    for chars in line:gmatch ".." do
      local color = image.colors[chars]
      if not color then
        error("cannot find the color: " .. image.name .. ", " .. chars)
      end
      local hl_group = ("Nekokak%02d%02d"):format(row, col)
      -- TODO: nvim_set_hl cannot have namespace on arg 1 ???
      -- api.set_hl(namespace, hl_group, { fg = color, bg = color })
      api.set_hl(0, hl_group, { fg = color, bg = color })
      api.buf_add_highlight(0, namespace, hl_group, row - 1, col, col + #chars)
      col = col + #chars
    end
  end
end

function Nekokak:load_data()
  local data_dir = self:plugin_dir() .. "/data"
  local dir = uv.fs_opendir(data_dir)
  while true do
    local entry = dir:readdir()
    if entry and #entry == 1 then
      local file = entry[1]
      if file.name:match [[%.xpm$]] then
        local image = {
          name = file.name,
          colors = {},
          map = {},
        }
        local fd = assert(uv.fs_open(data_dir .. "/" .. file.name, "r", 438))
        local stat = assert(uv.fs_fstat(fd))
        local data = assert(uv.fs_read(fd, stat.size, 0))
        assert(uv.fs_close(fd))
        local start_pixels = false
        for line in data:gmatch "[^\n]+" do
          local chars, color = line:match [[^"(..) c (.*)",$]]
          if chars then
            if color:match [[^#]] then
              image.colors[chars] = color
            elseif color == "black" then
              image.colors[chars] = "black"
            elseif color == "gainsboro" then
              image.colors[chars] = "#DCDCDC"
            elseif color == "gray" then
              image.colors[chars] = "#BEBEBE"
            elseif color == "gray1" then
              image.colors[chars] = "#030303"
            elseif color == "gray58" then
              image.colors[chars] = "#949494"
            elseif color == "gray59" then
              image.colors[chars] = "#969696"
            elseif color == "gray60" then
              image.colors[chars] = "#999999"
            elseif color == "gray61" then
              image.colors[chars] = "#9C9C9C"
            elseif color == "gray62" then
              image.colors[chars] = "#9E9E9E"
            elseif color == "gray63" then
              image.colors[chars] = "#A1A1A1"
            elseif color == "gray64" then
              image.colors[chars] = "#A3A3A3"
            elseif color == "gray65" then
              image.colors[chars] = "#A6A6A6"
            elseif color == "gray66" then
              image.colors[chars] = "#A8A8A8"
            elseif color == "gray67" then
              image.colors[chars] = "#ABABAB"
            elseif color == "gray68" then
              image.colors[chars] = "#ADADAD"
            elseif color == "gray69" then
              image.colors[chars] = "#B0B0B0"
            elseif color == "gray70" then
              image.colors[chars] = "#B3B3B3"
            elseif color == "gray71" then
              image.colors[chars] = "#B5B5B5"
            elseif color == "gray72" then
              image.colors[chars] = "#B8B8B8"
            elseif color == "gray73" then
              image.colors[chars] = "#BABABA"
            elseif color == "gray74" then
              image.colors[chars] = "#BDBDBD"
            elseif color == "gray75" then
              image.colors[chars] = "#BFBFBF"
            elseif color == "gray76" then
              image.colors[chars] = "#C2C2C2"
            elseif color == "gray77" then
              image.colors[chars] = "#C4C4C4"
            elseif color == "gray78" then
              image.colors[chars] = "#C7C7C7"
            elseif color == "gray79" then
              image.colors[chars] = "#C9C9C9"
            elseif color == "gray80" then
              image.colors[chars] = "#CCCCCC"
            elseif color == "gray81" then
              image.colors[chars] = "#CFCFCF"
            elseif color == "gray82" then
              image.colors[chars] = "#D1D1D1"
            elseif color == "gray83" then
              image.colors[chars] = "#D4D4D4"
            elseif color == "gray84" then
              image.colors[chars] = "#D6D6D6"
            elseif color == "gray85" then
              image.colors[chars] = "#D9D9D9"
            elseif color == "gray86" then
              image.colors[chars] = "#DBDBDB"
            elseif color == "gray87" then
              image.colors[chars] = "#DEDEDE"
            elseif color == "gray88" then
              image.colors[chars] = "#E0E0E0"
            elseif color == "gray89" then
              image.colors[chars] = "#E3E3E3"
            elseif color == "gray90" then
              image.colors[chars] = "#E5E5E5"
            elseif color == "gray91" then
              image.colors[chars] = "#E8E8E8"
            elseif color == "gray92" then
              image.colors[chars] = "#EBEBEB"
            elseif color == "gray93" then
              image.colors[chars] = "#EDEDED"
            elseif color == "gray94" then
              image.colors[chars] = "#F0F0F0"
            elseif color == "gray95" then
              image.colors[chars] = "#F2F2F2"
            elseif color == "gray96" then
              image.colors[chars] = "#F5F5F5"
            elseif color == "gray97" then
              image.colors[chars] = "#F7F7F7"
            elseif color == "gray98" then
              image.colors[chars] = "#FAFAFA"
            elseif color == "gray99" then
              image.colors[chars] = "#FCFCFC"
            elseif color == "LightGray" then
              image.colors[chars] = "#D3D3D3"
            elseif color == "None" then
              image.colors[chars] = "#FFFFFF"
            elseif color == "white" then
              image.colors[chars] = "white"
            else
              error("unknown color: " .. color)
            end
          end
          if not start_pixels and line:match [[pixels]] then
            start_pixels = true
          end
          if start_pixels then
            local image_map = line:match [["([^"]+)"]]
            if image_map then
              table.insert(image.map, image_map)
            end
          end
        end
        table.insert(self.images, image)
      end
    else
      break
    end
  end
  dir:closedir()
end

function Nekokak:plugin_dir()
  local str = debug.getinfo(2, "S").source:sub(2)
  local dir = str:match [[^(.*)/lua/]]
  return dir
end

local n = Nekokak.new()

return {
  nekokak = n,
  setup = function()
    n:setup()
  end,
}
