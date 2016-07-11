function urldecode(s)
  s = s:gsub('+', ' ')
       :gsub('%%(%x%x)', function(h)
                           return string.char(tonumber(h, 16))
                         end)
  return s
end

function parseurl(s)
  local ans = {}
  for k,v in s:gmatch('([^&=?]-)=([^&=?]+)' ) do
    ans[ k ] = urldecode(v)
  end
  return ans
end

function isempty(s)
  return s == nil or s == ''
end

function resolveBackendForGET(txn)
  local server = "nodes-prim"
  local queryps = txn.sf:query()
  if not isempty(queryps) then
    local qparams = parseurl(queryps)
    if not isempty(qparams.server) then
      server = qparams.server
    end
  end
  return server
end

function choose_backend(txn)
  txn:Info("***********************************************")
  txn:Info("Request coming from: " .. txn.f:src())
  txn:Info("Request url: " .. txn.sf:url())
  txn:Info("Request method: " .. txn.sf:method())
  txn:Info("Request path: " .. txn.sf:path())
  txn:Info("Request query parameters: " .. txn.sf:query())
  txn:Info("***********************************************")
  
  local server = "nodes-prim"
  local method = txn.sf:method()
  if method == 'GET' then
    server = resolveBackendForGET(txn)    
  end
  return server
end

core.register_fetches("choose-backend", choose_backend)
