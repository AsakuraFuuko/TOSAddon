CHAT_SYSTEM("MARKET SHOW LEVEL SC v1.0.4 loaded!");

local itemColor = {
	[0] = "FFFFFF",    -- Normal
	[1] = "108CFF",    -- 0.75 over
	[2] = "9F30FF",    -- 0.85 over
	[3] = "FF4F00",    -- 0.95 over
};

local propList = {};
propList.MHP           = {name = "ＨＰ";max = 2283;};
propList.RHP           = {name = "HP回";max = 56;};
propList.MSP           = {name = "ＳＰ";max = 450;};
propList.RSP           = {name = "SP回";max = 56;};
propList.PATK          = {name = "物攻";max = 126;};
propList.ADD_MATK      = {name = "魔攻";max = 126;};
propList.ADD_DEF       = {name = "物防";max = 110;};
propList.ADD_MDEF      = {name = "魔防";max = 110;};
propList.ADD_MHR       = {name = "増幅";max = 126;};
propList.CRTATK        = {name = "爆攻";max = 189;};
propList.CRTHR         = {name = "爆发";max = 14;};
propList.CRTDR         = {name = "爆抵";max = 14;};
propList.BLK           = {name = "格挡";max = 14;};
propList.ADD_HR        = {name = "命中";max = 14;};
propList.ADD_DR        = {name = "回避";max = 14;};
propList.ADD_FIRE      = {name = "火攻";max = 99;};
propList.ADD_ICE       = {name = "冰攻";max = 99;};
propList.ADD_POISON    = {name = "毒攻";max = 99;};
propList.ADD_LIGHTNING = {name = "雷攻";max = 99;};
propList.ADD_EARTH     = {name = "地攻";max = 99;};
propList.ADD_SOUL      = {name = "念攻";max = 99;};
propList.ADD_HOLY      = {name = "圣攻";max = 99;};
propList.ADD_DARK      = {name = "暗攻";max = 99;};
propList.RES_FIRE      = {name = "火防";max = 84;};
propList.RES_ICE       = {name = "冰防";max = 84;};
propList.RES_POISON    = {name = "毒防";max = 84;};
propList.RES_LIGHTNING = {name = "雷防";max = 84;};
propList.RES_EARTH     = {name = "地防";max = 84;};
propList.RES_SOUL      = {name = "念防";max = 84;};
propList.RES_HOLY      = {name = "圣防";max = 84;};
propList.RES_DARK      = {name = "暗防";max = 84;};
propList.MSPD          = {name = "移动";max = 1;};
propList.SR            = {name = "AOE攻";max = 1;};
propList.SDR           = {name = "AOE防";max = 4;};

local function SetupHook(newFunction, hookedFunctionName)
	local storeOldFunc = hookedFunctionName .. "_OLD_MARKET";
	if _G[storeOldFunc] == nil then
		_G[storeOldFunc] = _G[hookedFunctionName];
		_G[hookedFunctionName] = newFunction;
	else
		_G[hookedFunctionName] = newFunction;
	end
end

local isLoaded = false;

function MARKETSHOWLEVEL_ON_INIT(addon, frame)
	if not isLoaded then
		SetupHook(ON_MARKET_ITEM_LIST_HOOKED, "ON_MARKET_ITEM_LIST");
		isLoaded = true;
	end
end

function GetGemInfo(itemObj)
	local gemInfo = "";
	local fn = GET_FULL_NAME_OLD or GET_FULL_NAME;

	local socketId;
	local rstLevel;
	local gemName;
	local exp;
	local color="";

	for i = 0, 4 do

		socketId = itemObj["Socket_Equip_" .. i];
		rstLevel = itemObj["Socket_JamLv_" .. i];
		exp = itemObj["SocketItemExp_" .. i];

		if socketId > 0 then
			if #gemInfo > 0 then
				gemInfo = gemInfo..",";
			end

			local obj = GetClassByType("Item", socketId);
			gemName = fn(obj);
			local gemLevel = 0;

			if exp >= 27014700 then
				gemLevel = 10;
			elseif exp >= 5414700 then
				gemLevel = 9;
			elseif exp >= 1094700 then
				gemLevel = 8;
			elseif exp >= 230700 then
				gemLevel = 7;
			elseif exp >= 57900 then
				gemLevel = 6;
			elseif exp >= 14700 then
				gemLevel = 5;
			elseif exp >= 3900 then
				gemLevel = 4;
			elseif exp >= 1200 then
				gemLevel = 3;
			elseif exp >= 300 then
				gemLevel = 2;
			else
				gemLevel = 1;
			end

			if gemLevel <= rstLevel then
				gemInfo = gemInfo .. "{#FF7F50}{ol}Lv" .. gemLevel .. ":" .. GET_ITEM_IMG_BY_CLS(obj, 22) .. "{/}{/}";
			else
				gemInfo = gemInfo .. "{#FFFFFF}{ol}Lv" .. gemLevel .. ":" .. GET_ITEM_IMG_BY_CLS(obj, 22) .. "{/}{/}";
			end

		end
	end

	if #gemInfo > 0 then
		gemInfo = "{nl}" .. gemInfo;
	end

	return gemInfo;

end

function GetHatProp(itemObj)
	local prop = "";
	for i = 1 , 3 do
		local propName = "";
		local propValue = 0;
		local propNameStr = "HatPropName_"..i;
		local propValueStr = "HatPropValue_"..i;
		if itemObj[propValueStr] ~= 0 and itemObj[propNameStr] ~= "None" then
			if #prop > 0 then
				prop = prop..",";
			end

			propName = itemObj[propNameStr];
			propValue = itemObj[propValueStr];

			propValueColored = GetItemValueColor(propName, propValue, propList[propName].max);

			prop = prop .. string.format("%s:{#%s}{ol}%4d{/}{/}", propList[propName].name, propValueColored, propValue);
		end
	end

	if #prop > 0 then
		prop = "{nl}" .. prop;
	end

	return prop;

end

function GetItemValueColor(propname,value, max)
	local index = 0;

	if propname == "MSPD" or propname == "SR" or propname == "SDR" then
		index = 0
	else
		if value > (max * 0.95) then
			index = 3
		elseif value > (max * 0.85) then
			index = 2
		elseif value > (max * 0.75) then
			index = 1
		end
	end

	return itemColor[index]
end

function ON_MARKET_ITEM_LIST_HOOKED(frame, msg, argStr, argNum)
	_G["ON_MARKET_ITEM_LIST_OLD_MARKET"](frame, msg, argStr, argNum);

	if (marktioneer ~= nil and (marktioneer.fullscaning or marktioneer.refreshing)) then
		return;
	end

	local itemlist = GET_CHILD(frame, "itemlist", "ui::CDetailListBox");

	local mySession = session.GetMySession();
	local cid = mySession:GetCID();

	local count = session.market.GetItemCount();
	for i = 0 , count - 1 do
		local marketItem = session.market.GetItemByIndex(i);
		local itemObj = GetIES(marketItem:GetObject());

		local ctrlSet = itemlist:GetChild("DETAIL_ITEM_" .. i .. "_0");

		local name = ctrlSet:GetChild("name");

		local itemLevel = GET_ITEM_LEVEL(itemObj);
		local itemGroup = itemObj.GroupName;

		if itemGroup == "Weapon" or itemGroup == "SubWeapon" then
			local gemInfo = GetGemInfo(itemObj);
			name:SetTextByKey("value", GET_FULL_NAME(itemObj) .. gemInfo);
		elseif itemGroup == "Armor" then
			local gemInfo = GetGemInfo(itemObj);
			local prop = GetHatProp(itemObj);
			name:SetTextByKey("value", GET_FULL_NAME(itemObj) .. prop .. gemInfo);
		elseif itemGroup == "Gem" or itemGroup == "Card" then
			name:SetTextByKey("value", "Lv".. itemLevel .. ":" .. GET_FULL_NAME(itemObj));
		elseif (itemObj.ClassName == "Scroll_SkillItem") then
			local skillClass = GetClassByType("Skill", itemObj.SkillType);
			name:SetTextByKey("value", "Lv".. itemObj.SkillLevel .. " " .. skillClass.Name .. ":" .. GET_FULL_NAME(itemObj));
		else
			name:SetTextByKey("value", GET_FULL_NAME(itemObj));
		end
		name = tolua.cast(name, 'ui::CRichText');
		name:SetTextAlign("left", "top");
	end
end
