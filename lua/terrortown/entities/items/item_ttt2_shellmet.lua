---
-- Shellmet  @{ITEM}

if SERVER then
	AddCSLuaFile()
end

ITEM.CanBuy = {ROLE_DETECTIVE}

if CLIENT then
	ITEM.EquipMenuData = {
		type = "item_active",
		name = "item_shellmet",
		desc = "item_shellmet_desc"
	}
	ITEM.material = "vgui/ttt/icon_shellmet"
	ITEM.hud = Material("vgui/ttt/perks/hud_shellmet.png")

	---
	-- @ignore
	-- function ITEM:AddToSettingsMenu(parent)
	-- 	local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")

	-- 	form:MakeHelp({
	-- 		label = "help_item_armor_value"
	-- 	})

	-- 	form:MakeSlider({
	-- 		serverConvar = "ttt_item_armor_value",
	-- 		label = "label_armor_value",
	-- 		min = 0,
	-- 		max = 100,
	-- 		decimal = 0
	-- 	})
	-- end
else -- SERVER
	---
	-- @ignore
	function ITEM:Equip(buyer)
		if not IsValid(buyer.shellmet) then
			local hat = ents.Create("ttt2_hat_shellmet")
			if not IsValid(hat) then return end
			hat:WearHat(buyer)
			hat:Spawn()
		end
	end

	---
	-- @ignore
	function ITEM:Reset(buyer)
		-- we should delete the hat too but, we don't know where it is
	end

	hook.Add("PlayerTraceAttack", "TTT2ShellmetHeadProtectPlayerTraceAttack", function(ply, dmginfo, dir, trace)
		if ply:HasEquipmentItem("item_ttt2_shellmet") and (dmginfo:IsDamageType(DMG_CRUSH + DMG_PHYSGUN) or trace.HitGroup == HITGROUP_HEAD) then
			ply.shellmet:Drop(dir)
			return true
		end
	end)
	hook.Add("PlayerTakeDamage", "TTT2ShellmetHeadProtectPlayerTakeDamage", function(ply, inflictor, att, dmg, dmginfo)
		if ply:HasEquipmentItem("item_ttt2_shellmet") and dmginfo:IsDamageType(DMG_CRUSH + DMG_PHYSGUN) then
			dmginfo:ScaleDamage(0)
			dmginfo:SetDamage(0)
			ply.shellmet:Drop(dmginfo:GetDamageForce())
			return true
		end
	end)
	hook.Add("DoPlayerDeath", "TTT2ShellmetRemoveOnDeath", function(ply, attacker, dmginfo)
		if IsValid(ply.shellmet) then
			ply.shellmet:Drop(dmginfo:GetDamageForce())
		end
	end)
end
