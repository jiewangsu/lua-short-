local _M = {}
local pgdb = require "tools.dbtools"
local validity = require "tools.checkdata"
local redis = require "tools.redis_client"
local http = require "resty.http"
local logger = require "tools.logger"

function _M.deal_command (self)
    --数据库操作
    if ret == true then
        local data = cjson.decode(result)
        if #data > 0 then
            local url_long = 'https://m.lianzumall.com/ware?goodId='
            local teabein = ''
            for i, v in pairs(data) do
                teabein = teabein ..'url_long=' .. url_long .. v['recid']
                if i < #data then
                    teabein = teabein .. '&'
                end
            end
            local curlUrls = SHORT_URL .. 'source=' .. SINA_APPKEY .. '&' ..teabein
            local httpc = http.new()
            local res, err = httpc:request_uri(curlUrls, {
                ssl_verify = false,
                method = 'GET',
                headers = {
                    ["Content-Type"] = "application/json"
                }
            })
            httpc:close()
            if res.status == 200 then
                local data_urls = cjson.decode(res.body)
                for ii, vv in pairs(data_urls['urls']) do
                    if vv['result'] == true then
                        local goods = string.find(vv['url_long'], '=')
                        local goods_id = string.sub(vv['url_long'], goods + 1)
                        if goods_id and tonumber(goods_id) then
                            --数据操作
                        end
                    end
                end
            end
        end
        return 1
    end
    return 1
end

return _M
