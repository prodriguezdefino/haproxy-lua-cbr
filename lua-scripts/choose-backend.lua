-- initialize server maping
servers = {
  prim = 'nodes-prim',
  sec = 'nodes-sec',
  default = 'default'
}

-- helps to decode query parameters presents in the url
function urldecode(s)
  s = s:gsub('+', ' ')
       :gsub('%%(%x%x)', function(h)
                           return string.char(tonumber(h, 16))
                         end)
  return s
end

-- parses the query parameters and produces a table with keys and values
function parseQueryParams(s)
  local ans = {}
  for k,v in s:gmatch('([^&=?]-)=([^&=?]+)' ) do
    ans[ k ] = urldecode(v)
  end
  return ans
end

-- checks for empty strings
function isempty(s)
  return s == nil or s == ''
end

-- selects the backend server farms to use base on a GET request content
function resolveBackendForGET(txn)
  local server = servers.default
  local queryps = txn.sf:query()
  if not isempty(queryps) then
    local qparams = parseQueryParams(queryps)
    if not isempty(qparams.server) then
      if servers[qparams.server] ~= nil then 
        server = servers[qparams.server]
      end
    end
  end
  return server
end

-- to be register fetch function 
function choose_backend(txn)
  txn:Info("***********************************************")
  txn:Info("Request coming from: " .. txn.f:src())
  txn:Info("Request url: " .. txn.sf:url())
  txn:Info("Request method: " .. txn.sf:method())
  txn:Info("Request path: " .. txn.sf:path())
  txn:Info("Request query parameters: " .. txn.sf:query())
  txn:Info("***********************************************")
  
  local server = servers.default
  local method = txn.sf:method()
  if method == 'GET' then
    server = resolveBackendForGET(txn)    
  end
  return server
end

-- register the fetch function
core.register_fetches("choose-backend", choose_backend)
