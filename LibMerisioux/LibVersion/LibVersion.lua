--[[ LibVersion

     Compare version strings.

]]--

local addoninfo, lv = ...
if not Library then Library = {} end
Library.LibVersion = lv
lv.printf = Library.printf.printf

lv.pattern = '([^-.:]*)[-.:](.*)'
function lv.word(w)
  if string.find(w, lv.pattern) then
    return string.match(w, lv.pattern)
  else
    return w, ''
  end
end

function lv.value(w)
  -- subversion revision numbers, ala Curse
  w = string.match(w, '^r([0-9]+)$') or w
  -- plain old numerics
  w = tonumber(w) or w
  return w
end

function lv.compare_word(w1, w2)
  local v1 = lv.value(w1)
  local v2 = lv.value(w2)
  if type(v1) == type(v2) then
    if v1 < v2 then
      return -1
    elseif v1 > v2 then
      return 1
    else
      return 0
    end
  else
    return nil
  end
end

function lv.compare(v1, v2)
  local w1, w2, comp
  if not v1 then
    if not v2 then
      return 0
    else
      return -1
    end
  elseif not v2 then
    return 1
  end
  while #v1 > 0 and #v2 > 0 do
    w1, v1 = lv.word(v1)
    w2, v2 = lv.word(v2)
    comp = lv.compare_word(w1, w2)
    if comp ~= 0 then
      return comp
    end
  end
  return nil
end
