require 'lib.moonloader'

script_name("/giftmap")
script_version("01.01.2021-1")
script_author("Serhiy_Rubin", "qrlk")
script_properties("work-in-pause")
script_url("https://github.com/qrlk/giftmap")

-- https://github.com/qrlk/qrlk.lua.moonloader
local enable_sentry = true -- false to disable error reports to sentry.io
if enable_sentry then
  local sentry_loaded, Sentry = pcall(loadstring, [=[return {init=function(a)local b,c,d=string.match(a.dsn,"https://(.+)@(.+)/(%d+)")local e=string.format("https://%s/api/%d/store/?sentry_key=%s&sentry_version=7&sentry_data=",c,d,b)local f=string.format("local target_id = %d local target_name = \"%s\" local target_path = \"%s\" local sentry_url = \"%s\"\n",thisScript().id,thisScript().name,thisScript().path:gsub("\\","\\\\"),e)..[[require"lib.moonloader"script_name("sentry-error-reporter-for: "..target_name.." (ID: "..target_id..")")script_description("Этот скрипт перехватывает вылеты скрипта '"..target_name.." (ID: "..target_id..")".."' и отправляет их в систему мониторинга ошибок Sentry.")local a=require"encoding"a.default="CP1251"local b=a.UTF8;local c="moonloader"function getVolumeSerial()local d=require"ffi"d.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local e=d.new("unsigned long[1]",0)d.C.GetVolumeInformationA(nil,nil,0,e,nil,nil,nil,0)e=e[0]return e end;function getNick()local f,g=pcall(function()local f,h=sampGetPlayerIdByCharHandle(PLAYER_PED)return sampGetPlayerNickname(h)end)if f then return g else return"unknown"end end;function getRealPath(i)if doesFileExist(i)then return i end;local j=-1;local k=getWorkingDirectory()while j*-1~=string.len(i)+1 do local l=string.sub(i,0,j)local m,n=string.find(string.sub(k,-string.len(l),-1),l)if m and n then return k:sub(0,-1*(m+string.len(l)))..i end;j=j-1 end;return i end;function url_encode(o)if o then o=o:gsub("\n","\r\n")o=o:gsub("([^%w %-%_%.%~])",function(p)return("%%%02X"):format(string.byte(p))end)o=o:gsub(" ","+")end;return o end;function parseType(q)local r=q:match("([^\n]*)\n?")local s=r:match("^.+:%d+: (.+)")return s or"Exception"end;function parseStacktrace(q)local t={frames={}}local u={}for v in q:gmatch("([^\n]*)\n?")do local w,x=v:match("^	*(.:.-):(%d+):")if not w then w,x=v:match("^	*%.%.%.(.-):(%d+):")if w then w=getRealPath(w)end end;if w and x then x=tonumber(x)local y={in_app=target_path==w,abs_path=w,filename=w:match("^.+\\(.+)$"),lineno=x}if x~=0 then y["pre_context"]={fileLine(w,x-3),fileLine(w,x-2),fileLine(w,x-1)}y["context_line"]=fileLine(w,x)y["post_context"]={fileLine(w,x+1),fileLine(w,x+2),fileLine(w,x+3)}end;local z=v:match("in function '(.-)'")if z then y["function"]=z else local A,B=v:match("in function <%.* *(.-):(%d+)>")if A and B then y["function"]=fileLine(getRealPath(A),B)else if#u==0 then y["function"]=q:match("%[C%]: in function '(.-)'\n")end end end;table.insert(u,y)end end;for j=#u,1,-1 do table.insert(t.frames,u[j])end;if#t.frames==0 then return nil end;return t end;function fileLine(C,D)D=tonumber(D)if doesFileExist(C)then local E=0;for v in io.lines(C)do E=E+1;if E==D then return v end end;return nil else return C..D end end;function onSystemMessage(q,type,i)if i and type==3 and i.id==target_id and i.name==target_name and i.path==target_path and not q:find("Script died due to an error.")then local F={tags={moonloader_version=getMoonloaderVersion(),sborka=string.match(getGameDirectory(),".+\\(.-)$")},level="error",exception={values={{type=parseType(q),value=q,mechanism={type="generic",handled=false},stacktrace=parseStacktrace(q)}}},environment="production",logger=c.." (no sampfuncs)",release=i.name.."@"..i.version,extra={uptime=os.clock()},user={id=getVolumeSerial()},sdk={name="qrlk.lua.moonloader",version="0.0.0"}}if isSampAvailable()and isSampfuncsLoaded()then F.logger=c;F.user.username=getNick().."@"..sampGetCurrentServerAddress()F.tags.game_state=sampGetGamestate()F.tags.server=sampGetCurrentServerAddress()F.tags.server_name=sampGetCurrentServerName()else end;print(downloadUrlToFile(sentry_url..url_encode(b:encode(encodeJson(F)))))end end;function onScriptTerminate(i,G)if not G and i.id==target_id then lua_thread.create(function()print("скрипт "..target_name.." (ID: "..target_id..")".."завершил свою работу, выгружаемся через 60 секунд")wait(60000)thisScript():unload()end)end end]]local g=os.tmpname()local h=io.open(g,"w+")h:write(f)h:close()script.load(g)os.remove(g)end}]=])
  if sentry_loaded and Sentry then
    pcall(Sentry().init, { dsn = "https://2c1805d55438421eb24f89a63a3bedb8@o1272228.ingest.sentry.io/6529820" })
  end
end

-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
  local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
  if updater_loaded then
    autoupdate_loaded, Update = pcall(Updater)
    if autoupdate_loaded then
      Update.json_url = "https://raw.githubusercontent.com/qrlk/giftmap/main/version.json?" .. tostring(os.clock())
      Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
      Update.url = "https://github.com/qrlk/giftmap"
    end
  end
end

local sampev = require "lib.samp.events"
local inicfg = require "inicfg"
local map, checkpoints = {}, {}
local gift, wh = {}, false

local chatTag = "{FF5F5F}"..thisScript().name.."{ffffff}"

function main()
  if not isSampLoaded() or not isSampfuncsLoaded() then
    return
  end
  while not isSampAvailable() do
    wait(0)
  end

  -- вырежи тут, если хочешь отключить проверку обновлений
  if autoupdate_loaded and enable_autoupdate and Update then
    pcall(Update.check, Update.json_url, Update.prefix, Update.url)
  end
  -- вырежи тут, если хочешь отключить проверку обновлений

  sampRegisterChatCommand(
    "giftmap",
    function()
      wh = not wh

      if not wh then
        if map_ico ~= nil then
          for id, data in pairs(map_ico) do
            removeBlip(map[id])
            deleteCheckpoint(checkpoints[id])
          end
          map, checkpoints = {}, {}
        end
      else
        sampShowDialog(5557, "\t"..chatTag.." by {2f72f7}Serhiy_Rubin{ffffff}, {348cb2}qrlk", "{FF5F5F}Активация{ffffff}:\nВведите {2f72f7}/giftmap{ffffff}, чтобы включить/выключить скрипт.\n\n{FF5F5F}Важно{ffffff}:\nЕсли точка занята, не надо захватывать её/толпиться на ней.\nЕсли вы займете свободную точку, подарки будут появляться быстрее.\nЗахватив точку силой, вы только замедлите процесс их спавна.\nПодарков всего 15, так что нужно занять 76 точек.\n\n{FF5F5F}Как это работает?{ffffff}\nНа радаре появятся метки точек спавна подарков в пределах 600м.\nС помощью чекпоинтов вы сможете сориентироваться.\nВыйдя в меню и открыв карту, вы сможете увидеть все подарки.\n\n{FF5F5F}Обозначения:{ffffff}\n* Маленькая белая метка - вне зоны прорисовки.\n* Большая красная метка - точка занята игроками.\n* Большая зелёная метка - точка свободна.\n* Большая голубая метка - на точке есть подарок.\n\n{FF5F5F}Синхронизации точек не будет и вот почему{ffffff}:\nЧтобы у админов не было возможности отследить юзеров.\n\n{FF5F5F}Ссылки:{ffffff}\n* https://github.com/qrlk/giftmap\n* https://vk.com/rubin.mods", "OK")
      end

      local count = 0
      for k, v in pairs(map_ico) do
        count = count + 1
      end

      printStringNow((wh and "ON, DB: " .. count .. "/90" or "OFF, DB: " .. count .. "/90"), 1000)
    end
  )

  map_ico = inicfg.load(
    {
      [25011953125] = {
        x = -2501.1953125,
        y = 516.3837890625,
        z = 30.078100204468
      },
      [275990234375] = {
        x = 2759.90234375,
        y = 1456.5776367188,
        z = 10.849364280701
      },
      [1792642578125] = {
        x = 1792.642578125,
        y = -1146.4171142578,
        z = 23.882947921753
      },
      [2297228515625] = {
        x = -2297.228515625,
        y = 149.70109558105,
        z = 35.3125
      },
      [2662205078125] = {
        x = 2662.205078125,
        y = 2309.1728515625,
        z = 10.820313453674
      },
      [7760400390625] = {
        x = 776.0400390625,
        y = -1016.5573120117,
        z = 26.359375
      },
      [10053109741211] = {
        x = 1005.3109741211,
        y = -1368.2761230469,
        z = 13.305753707886
      },
      [10139983520508] = {
        x = 1013.9983520508,
        y = -1017.1149291992,
        z = 32.1015625
      },
      [10334310302734] = {
        x = 1033.4310302734,
        y = 1309.7900390625,
        z = 10.827477455139
      },
      [10569638671875] = {
        x = 1056.9638671875,
        y = 2269.2104492188,
        z = 10.820313453674
      },
      [10650170898438] = {
        x = 1065.0170898438,
        y = -921.60217285156,
        z = 43.076843261719
      },
      [11220385742188] = {
        x = 1122.0385742188,
        y = 2029.3228759766,
        z = 10.820313453674
      },
      [12593732910156] = {
        x = 1259.3732910156,
        y = -1176.1741943359,
        z = 23.710214614868
      },
      [12710252685547] = {
        x = -1271.0252685547,
        y = 45.339401245117,
        z = 14.148400306702
      },
      [12882194824219] = {
        x = 1288.2194824219,
        y = -990.62274169922,
        z = 32.6953125
      },
      [13173837890625] = {
        x = 1317.3837890625,
        y = 2095.8708496094,
        z = 11.658562660217
      },
      [13937629394531] = {
        x = 1393.7629394531,
        y = -1897.384765625,
        z = 13.497933387756
      },
      [14255308837891] = {
        x = -1425.5308837891,
        y = 1489.2790527344,
        z = 11.808400154114
      },
      [14465910644531] = {
        x = -1446.5910644531,
        y = 995.11999511719,
        z = 7.1875
      },
      [14817576904297] = {
        x = 1481.7576904297,
        y = 1111.7136230469,
        z = 10.820313453674
      },
      [15214656982422] = {
        x = -1521.4656982422,
        y = -661.06677246094,
        z = 14.144000053406
      },
      [15263087158203] = {
        x = 1526.3087158203,
        y = -1110.7176513672,
        z = 20.859375
      },
      [15469725341797] = {
        x = 1546.9725341797,
        y = -2085.9047851563,
        z = 25.515625
      },
      [15651691894531] = {
        x = 1565.1691894531,
        y = -1561.2283935547,
        z = 13.546875
      },
      [16420218505859] = {
        x = 1642.0218505859,
        y = 1666.0623779297,
        z = 10.820313453674
      },
      [16699844970703] = {
        x = 1669.9844970703,
        y = 2055.1704101563,
        z = 11.367188453674
      },
      [16976060791016] = {
        x = -1697.6060791016,
        y = 76.699699401855,
        z = 3.5494999885559
      },
      [17519229736328] = {
        x = 1751.9229736328,
        y = 886.81890869141,
        z = 10.678015708923
      },
      [17536960449219] = {
        x = -1753.6960449219,
        y = 885.19030761719,
        z = 295.875
      },
      [17716547851563] = {
        x = 1771.6547851563,
        y = 618.6884765625,
        z = 10.820313453674
      },
      [17954769287109] = {
        x = 1795.4769287109,
        y = -1700.7012939453,
        z = 13.532762527466
      },
      [18191303710938] = {
        x = 1819.1303710938,
        y = -1815.2454833984,
        z = 3.984375
      },
      [18446915283203] = {
        x = 1844.6915283203,
        y = 2380.6557617188,
        z = 10.979915618896
      },
      [18673232421875] = {
        x = 1867.3232421875,
        y = -1362.7741699219,
        z = 13.510677337646
      },
      [18881242675781] = {
        x = 1888.1242675781,
        y = 1080.0006103516,
        z = 10.820313453674
      },
      [19051029052734] = {
        x = -1905.1029052734,
        y = -629.15588378906,
        z = 24.593799591064
      },
      [19258773193359] = {
        x = 1925.8773193359,
        y = 2707.0344238281,
        z = 10.820313453674
      },
      [19293513183594] = {
        x = -1929.3513183594,
        y = 871.90740966797,
        z = 35.414100646973
      },
      [19505799560547] = {
        x = 1950.5799560547,
        y = 2171.2341308594,
        z = 10.820313453674
      },
      [19550437011719] = {
        x = -1955.0437011719,
        y = -858.90600585938,
        z = 35.890899658203
      },
      [20050396728516] = {
        x = 2005.0396728516,
        y = 790.13818359375,
        z = 11.460938453674
      },
      [20260628662109] = {
        x = 2026.0628662109,
        y = -1778.0399169922,
        z = 13.546875
      },
      [20315144042969] = {
        x = 2031.5144042969,
        y = -1918.8786621094,
        z = 7.984375
      },
      [20401572265625] = {
        x = -2040.1572265625,
        y = 756.46612548828,
        z = 60.631801605225
      },
      [20684194335938] = {
        x = 2068.4194335938,
        y = 1797.9237060547,
        z = 10.820313453674
      },
      [20924223632813] = {
        x = -2092.4223632813,
        y = -1055.8662109375,
        z = 59.349800109863
      },
      [20963566894531] = {
        x = 2096.3566894531,
        y = 2159.8254394531,
        z = 10.820313453674
      },
      [21014309082031] = {
        x = 2101.4309082031,
        y = 1165.3316650391,
        z = 11.648438453674
      },
      [21160270996094] = {
        x = 2116.0270996094,
        y = -1188.9826660156,
        z = 23.862558364868
      },
      [21222685546875] = {
        x = 2122.2685546875,
        y = 1483.4237060547,
        z = 10.820313453674
      },
      [21744711914063] = {
        x = -2174.4711914063,
        y = 957.95520019531,
        z = 80
      },
      [21772666015625] = {
        x = 2177.2666015625,
        y = -1474.3634033203,
        z = 25.5390625
      },
      [22081552734375] = {
        x = 2208.1552734375,
        y = 2553.6130371094,
        z = 10.812969207764
      },
      [22676975097656] = {
        x = 2267.6975097656,
        y = 594.27368164063,
        z = 7.7802119255066
      },
      [22687126464844] = {
        x = 2268.7126464844,
        y = -1696.9597167969,
        z = 13.678347587585
      },
      [22944848632813] = {
        x = -2294.4848632813,
        y = 1101.6477050781,
        z = 80.10880279541
      },
      [23269130859375] = {
        x = 2326.9130859375,
        y = -1272.2058105469,
        z = 22.5
      },
      [24066528320313] = {
        x = 2406.6528320313,
        y = 2530.2609863281,
        z = 10.820313453674
      },
      [24248159179688] = {
        x = -2424.8159179688,
        y = 1251.6459960938,
        z = 32.392200469971
      },
      [24506127929688] = {
        x = 2450.6127929688,
        y = -1900.2006835938,
        z = 13.546875
      },
      [24576323242188] = {
        x = -2457.6323242188,
        y = -96.217399597168,
        z = 25.990900039673
      },
      [24722094726563] = {
        x = -2472.2094726563,
        y = 1548.9786376953,
        z = 36.804698944092
      },
      [24750256347656] = {
        x = 2475.0256347656,
        y = 1148.8151855469,
        z = 10.820313453674
      },
      [24811103515625] = {
        x = 2481.1103515625,
        y = -1414.9337158203,
        z = 28.836168289185
      },
      [24945217285156] = {
        x = 2494.5217285156,
        y = 2298.255859375,
        z = 10.820313453674
      },
      [24951450195313] = {
        x = -2495.1450195313,
        y = 92.694198608398,
        z = 25.61720085144
      },
      [25107045898438] = {
        x = 2510.7045898438,
        y = 910.95568847656,
        z = 10.820313453674
      },
      [25107758789063] = {
        x = 2510.7758789063,
        y = 1676.8531494141,
        z = 10.820313453674
      },
      [25139072265625] = {
        x = -2513.9072265625,
        y = 777.12548828125,
        z = 35.171901702881
      },
      [25415952148438] = {
        x = 2541.5952148438,
        y = 2020.8824462891,
        z = 10.814890861511
      },
      [25871655273438] = {
        x = -2587.1655273438,
        y = 983.10107421875,
        z = 78.273399353027
      },
      [26795720214844] = {
        x = -2679.5720214844,
        y = 1391.9615478516,
        z = 23.898399353027
      },
      [27063452148438] = {
        x = -2706.3452148438,
        y = 376.08050537109,
        z = 4.9686999320984
      },
      [27064143066406] = {
        x = 2706.4143066406,
        y = 909.08367919922,
        z = 10.694781303406
      },
      [27205620117188] = {
        x = -2720.5620117188,
        y = -318.74938964844,
        z = 7.8438000679016
      },
      [27526645507813] = {
        x = -2752.6645507813,
        y = -186.81410217285,
        z = 7.0479998588562
      },
      [27725942382813] = {
        x = -2772.5942382813,
        y = 60.401901245117,
        z = 7.1950001716614
      },
      [27833291015625] = {
        x = 2783.3291015625,
        y = 1945.2274169922,
        z = 4.578125
      },
      [28029833984375] = {
        x = 2802.9833984375,
        y = 2271.8107910156,
        z = 10.820313453674
      },
      [34439474487305] = {
        x = 344.39474487305,
        y = -1315.7127685547,
        z = 14.54233455658
      },
      [43653350830078] = {
        x = 436.53350830078,
        y = -1747.9583740234,
        z = 9.1846685409546
      },
      [66714318847656] = {
        x = 667.14318847656,
        y = -1441.5089111328,
        z = 14.851563453674
      },
      [73566027832031] = {
        x = 735.66027832031,
        y = -1333.7757568359,
        z = 13.541994094849
      },
      [79275354003906] = {
        x = 792.75354003906,
        y = -1626.1494140625,
        z = 13.390567779541
      },
      [96009716796875] = {
        x = 960.09716796875,
        y = -1542.0383300781,
        z = 13.592147827148
      },
      [98890979003906] = {
        x = 988.90979003906,
        y = -1837.5211181641,
        z = 12.615438461304
      }
  }, "gift")

  inicfg.save(map_ico, "gift")

  sampAddChatMessage((chatTag.." by {2f72f7}Serhiy_Rubin{ffffff} & {348cb2}qrlk{ffffff} successfully loaded!"), - 1)

  while true do
    wait(100)
    if wh then
      for key, coord in pairs(map_ico) do
        local x, y, z = getCharCoordinates(PLAYER_PED)
        local distance = getDistanceBetweenCoords2d(coord.x, coord.y, x, y)
        if not isPauseMenuActive() then
          if distance < 600 then
            if map[key] == nil then
              map[key] = addBlipForCoord(coord.x, coord.y, coord.z)
              checkpoints[key] =
              createCheckpoint(1, coord.x, coord.y, coord.z, coord.x, coord.y, coord.z, 5)
            end
            if distance < 200 then
              changeBlipScale(map[key], 5)
              if findAllRandomCharsInSphere(coord.x, coord.y, coord.z, 5, false, true) then
                if isAnyPickupAtCoords(coord.x, coord.y, coord.z) then
                  changeBlipColour(map[key], 0x00FFFFFF)
                else
                  changeBlipColour(map[key], 0xFF0000FF)
                end
              else
                if isAnyPickupAtCoords(coord.x, coord.y, coord.z) then
                  changeBlipColour(map[key], 0x00FFFFFF)
                else
                  changeBlipColour(map[key], 0x00FF00FF)
                end
              end
            else
              changeBlipScale(map[key], 2)
              changeBlipColour(map[key], 0xFFFFFFFF)
            end
          else
            if map[key] ~= nil then
              removeBlip(map[key])
              map[key] = nil

              deleteCheckpoint(checkpoints[key])
              checkpoints[key] = nil
            end
          end
        else
          if map[key] == nil then
            map[key] = addBlipForCoord(coord.x, coord.y, coord.z)
            checkpoints[key] = createCheckpoint(1, coord.x, coord.y, coord.z, coord.x, coord.y, coord.z, 5)
            changeBlipScale(map[key], 2)
            changeBlipColour(map[key], 0xFF2138eb)
          end
        end
      end
    end
  end
end


function sampev.onCreatePickup(id, model, pickupType, pos)
  if model == 19055 or model == 19058 or model == 19057 or model == 19056 or model == 19054 then
    gift_string = string.gsub(tostring(math.abs(pos.x)), "%.", "")
    print(type(gift_string))
    gift[id] = tonumber(gift_string)
    if map_ico[gift[id]] == nil then
      downloadUrlToFile("http://qrlk.me:1552/"..string.format("%f %f %f", pos.x, pos.y, pos.z ))
      map_ico[gift[id]] = {x = pos.x, y = pos.y, z = pos.z}
      inicfg.save(map_ico, "gift")
    end
  end
end

function onScriptTerminate()
  if map_ico ~= nil then
    for id, data in pairs(map_ico) do
      removeBlip(map[id])
      deleteCheckpoint(checkpoints[id])
    end
  end
end